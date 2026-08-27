-- Databricks notebook source
-- DBTITLE 1,Step 1: Pregnancy Cohort Base - Patients with pregnancy episode, age >= 18, within study window
-- =============================================================================
-- STEP 1: BASE PREGNANCY COHORT
-- Inclusion: Pregnancy episode (type 2) within 6/1/2016 - 7/1/2026, age >= 18
-- Index hospitalization = any inpatient encounter during pregnancy episode dates
-- (NOT restricted to encounters directly linked via EPISODE_LINK)
-- =============================================================================

-- Phase A: Identify patients with pregnancy episodes via any linked encounter
CREATE OR REPLACE TEMPORARY VIEW pregnancy_patients AS
SELECT DISTINCT
  e.pat_link_id as pat_id,
  e.EPISODE_ID,
  e.START_DATE AS episode_start,
  e.END_DATE AS episode_end
FROM data_mgmt.clarity.episode e
WHERE e.SUM_BLK_TYPE_ID = 2  -- Pregnancy episodes
  AND e.START_DATE >= '2016-06-01'
  AND e.START_DATE < '2026-07-01';

-- Phase B: Find any hospitalization during pregnancy window, apply age filter
CREATE OR REPLACE TEMPORARY VIEW pregnancy_cohort AS
SELECT DISTINCT
  pp.pat_id AS PAT_ID,
  pp.EPISODE_ID,
  pp.episode_start,
  pp.episode_end,
  ip.pat_enc_csn_id AS PAT_ENC_CSN_ID,
  ip.hosp_admsn_time,
  ip.hosp_disch_time,
  p.BIRTH_DATE,
  FLOOR(DATEDIFF(ip.hosp_admsn_time, p.BIRTH_DATE) / 365.25) AS age_at_admission
FROM pregnancy_patients pp
INNER JOIN data_mgmt.derived.inpatient_encounters ip
  ON pp.pat_id = ip.pat_id
  AND ip.hosp_admsn_time BETWEEN pp.episode_start AND pp.episode_end
INNER JOIN data_mgmt.clarity.patient p
  ON pp.pat_id = p.PAT_ID
WHERE ip.hosp_admsn_time >= '2016-06-01'
  AND ip.hosp_admsn_time < '2026-07-01'
  AND coalesce(ip.serv_area_id, 11) = 11
  AND FLOOR(DATEDIFF(ip.hosp_admsn_time, p.BIRTH_DATE) / 365.25) >= 18;

SELECT COUNT(DISTINCT PAT_ID) AS unique_patients,
       COUNT(DISTINCT EPISODE_ID) AS unique_episodes,
       COUNT(DISTINCT PAT_ENC_CSN_ID) AS unique_encounters
FROM pregnancy_cohort;

-- COMMAND ----------

-- DBTITLE 1,Step 2: Serum Creatinine Labs - Identify all creatinine measurements and classify inpatient vs outpatient
-- =============================================================================
-- STEP 2: SERUM CREATININE MEASUREMENTS
-- Classify labs as inpatient (during index hospitalization) vs outpatient
-- Filter: component_base_name = 'CREATININE' with valid numeric values
-- =============================================================================

CREATE OR REPLACE TEMPORARY VIEW creatinine_labs AS
SELECT DISTINCT
  pc.PAT_ID,
  pc.EPISODE_ID,
  pc.PAT_ENC_CSN_ID AS index_csn,
  pc.hosp_admsn_time,
  pc.hosp_disch_time,
  lr.order_proc_id,
  lr.specimen_taken_time,
  lr.ord_num_value AS creatinine_value,
  lr.pat_enc_csn_id AS lab_csn,
  CASE
    WHEN lr.specimen_taken_time BETWEEN pc.hosp_admsn_time AND pc.hosp_disch_time
    THEN 'INPATIENT'
    ELSE 'OUTPATIENT'
  END AS lab_setting
FROM pregnancy_cohort pc
INNER JOIN data_mgmt.derived.lab_results lr
  ON pc.PAT_ID = lr.pat_id
WHERE lr.component_base_name = 'CREATININE'
  AND lr.ord_num_value IS NOT NULL
  AND lr.ord_num_value > 0
  AND lr.ord_num_value <> 9999999  -- Exclude non-numeric flag
  AND lr.specimen_taken_time >= '2016-06-01'
  AND lr.specimen_taken_time < '2026-07-01'
  AND coalesce(lr.serv_area_id, 11) = 11
  AND lr.lab_status IN ('Final result', 'Edited Result - FINAL');

-- Count patients with at least 1 creatinine in study window
-- and at least 2 distinct inpatient creatinine values during index hospitalization
CREATE OR REPLACE TEMPORARY VIEW creatinine_eligible AS
SELECT
  PAT_ID,
  EPISODE_ID,
  index_csn,
  hosp_admsn_time,
  hosp_disch_time
FROM (
  SELECT
    PAT_ID, EPISODE_ID, index_csn, hosp_admsn_time, hosp_disch_time,
    COUNT(DISTINCT CASE WHEN lab_setting = 'INPATIENT' THEN specimen_taken_time END) AS inpatient_creat_count,
    COUNT(*) AS total_creat_count
  FROM creatinine_labs
  GROUP BY PAT_ID, EPISODE_ID, index_csn, hosp_admsn_time, hosp_disch_time
)
WHERE total_creat_count >= 2  -- must have more than 1 creatinine (applying exclusion early)
  AND inpatient_creat_count >= 2;  -- At least 2 during index hospitalization

SELECT COUNT(DISTINCT PAT_ID) AS patients_creatinine_eligible,
       COUNT(DISTINCT EPISODE_ID) AS episodes_eligible
FROM creatinine_eligible;

-- COMMAND ----------

-- DBTITLE 1,Step 3: Baseline Creatinine Calculation
-- =============================================================================
-- STEP 3: BASELINE SERUM CREATININE
-- Priority 1: Outpatient creatinine 365-7 days prior to index admission
--   >= 3 values → median of last 3
--   2 values → average
--   1 value → use that value
-- Priority 2: If no outpatient, use lowest inpatient value during index admission
-- =============================================================================

CREATE OR REPLACE TEMPORARY VIEW outpatient_baseline_labs AS
SELECT
  cl.PAT_ID,
  cl.EPISODE_ID,
  cl.index_csn,
  cl.creatinine_value,
  cl.specimen_taken_time,
  ROW_NUMBER() OVER (
    PARTITION BY cl.PAT_ID, cl.EPISODE_ID, cl.index_csn
    ORDER BY cl.specimen_taken_time DESC
  ) AS rn_desc,
  COUNT(*) OVER (
    PARTITION BY cl.PAT_ID, cl.EPISODE_ID, cl.index_csn
  ) AS total_outpatient_count
FROM creatinine_labs cl
INNER JOIN creatinine_eligible ce
  ON cl.PAT_ID = ce.PAT_ID
  AND cl.EPISODE_ID = ce.EPISODE_ID
  AND cl.index_csn = ce.index_csn
WHERE cl.lab_setting = 'OUTPATIENT'
  AND cl.specimen_taken_time BETWEEN DATE_ADD(cl.hosp_admsn_time, -365)
                                 AND DATE_ADD(cl.hosp_admsn_time, -7);

-- Calculate outpatient baseline
CREATE OR REPLACE TEMPORARY VIEW outpatient_baseline AS
SELECT
  PAT_ID, EPISODE_ID, index_csn,
  CASE
    WHEN total_outpatient_count >= 3 THEN
      -- Median of last 3: take the middle value (rn_desc = 2 when sorted by most recent 3)
      PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY creatinine_value)
    WHEN total_outpatient_count = 2 THEN
      AVG(creatinine_value)
    WHEN total_outpatient_count = 1 THEN
      MAX(creatinine_value)
  END AS baseline_creatinine,
  'OUTPATIENT' AS baseline_source
FROM outpatient_baseline_labs
WHERE (total_outpatient_count >= 3 AND rn_desc <= 3)
   OR (total_outpatient_count < 3)
GROUP BY PAT_ID, EPISODE_ID, index_csn, total_outpatient_count;

-- Inpatient fallback: lowest value during index admission
CREATE OR REPLACE TEMPORARY VIEW inpatient_baseline AS
SELECT
  cl.PAT_ID, cl.EPISODE_ID, cl.index_csn,
  MIN(cl.creatinine_value) AS baseline_creatinine,
  'INPATIENT_MIN' AS baseline_source
FROM creatinine_labs cl
INNER JOIN creatinine_eligible ce
  ON cl.PAT_ID = ce.PAT_ID
  AND cl.EPISODE_ID = ce.EPISODE_ID
  AND cl.index_csn = ce.index_csn
LEFT JOIN outpatient_baseline ob
  ON cl.PAT_ID = ob.PAT_ID
  AND cl.EPISODE_ID = ob.EPISODE_ID
  AND cl.index_csn = ob.index_csn
WHERE cl.lab_setting = 'INPATIENT'
  AND ob.PAT_ID IS NULL  -- Only when no outpatient baseline exists
GROUP BY cl.PAT_ID, cl.EPISODE_ID, cl.index_csn;

-- Combined baseline
CREATE OR REPLACE TEMPORARY VIEW baseline_creatinine AS
SELECT * FROM outpatient_baseline
UNION ALL
SELECT * FROM inpatient_baseline;

SELECT baseline_source, COUNT(*) AS n
FROM baseline_creatinine
GROUP BY baseline_source;

-- COMMAND ----------

-- DBTITLE 1,Step 4: AKI KDIGO Staging - Identify AKI during index hospitalization
-- =============================================================================
-- STEP 4: AKI CLASSIFICATION (KDIGO CRITERIA)
-- Stage 1: 1.5-1.9x baseline OR >= 0.3 mg/dL increase within 48 hours
-- Stage 2: 2.0-2.9x baseline
-- Stage 3: >= 3x baseline OR >= 4.0 mg/dL OR dialysis initiation
-- =============================================================================

-- Get all inpatient creatinine values during index hospitalization
CREATE OR REPLACE TEMPORARY VIEW inpatient_creatinine AS
SELECT
  cl.PAT_ID,
  cl.EPISODE_ID,
  cl.index_csn,
  cl.creatinine_value,
  cl.specimen_taken_time,
  bc.baseline_creatinine,
  cl.creatinine_value / bc.baseline_creatinine AS ratio_to_baseline
FROM creatinine_labs cl
INNER JOIN baseline_creatinine bc
  ON cl.PAT_ID = bc.PAT_ID
  AND cl.EPISODE_ID = bc.EPISODE_ID
  AND cl.index_csn = bc.index_csn
WHERE cl.lab_setting = 'INPATIENT';

-- Check for 0.3 mg/dL increase within 48 hours (any pair of labs)
CREATE OR REPLACE TEMPORARY VIEW aki_48hr_increase AS
SELECT DISTINCT
  a.PAT_ID, a.EPISODE_ID, a.index_csn
FROM inpatient_creatinine a
INNER JOIN inpatient_creatinine b
  ON a.PAT_ID = b.PAT_ID
  AND a.EPISODE_ID = b.EPISODE_ID
  AND a.index_csn = b.index_csn
  AND a.specimen_taken_time > b.specimen_taken_time
  AND TIMESTAMPDIFF(HOUR, b.specimen_taken_time, a.specimen_taken_time) <= 48
WHERE (a.creatinine_value - b.creatinine_value) >= 0.3;

-- Identify dialysis during index hospitalization (AKI Stage 3)
CREATE OR REPLACE TEMPORARY VIEW dialysis_during_admission AS
SELECT DISTINCT
  ce.PAT_ID, ce.EPISODE_ID, ce.index_csn
FROM creatinine_eligible ce
INNER JOIN data_mgmt.clarity.order_proc op
  ON ce.PAT_ID = op.PAT_ID
  AND op.PAT_ENC_CSN_ID = ce.index_csn
WHERE (
  lower(op.DESCRIPTION) LIKE '%hemodialysis inpatient%'
  OR lower(op.DESCRIPTION) LIKE '%continuous renal replacement%'
  OR lower(op.DESCRIPTION) LIKE '%peritoneal dialysis%'
)
AND op.ORDERING_DATE BETWEEN ce.hosp_admsn_time AND ce.hosp_disch_time;

-- Assign AKI Stage (highest stage per patient-episode)
CREATE OR REPLACE TEMPORARY VIEW aki_patients AS
SELECT
  PAT_ID, EPISODE_ID, index_csn,
  MAX(aki_stage) AS max_aki_stage
FROM (
  -- Stage 3: >= 3x baseline OR >= 4.0 OR dialysis
  SELECT PAT_ID, EPISODE_ID, index_csn, 3 AS aki_stage
  FROM inpatient_creatinine
  WHERE ratio_to_baseline >= 3.0 OR creatinine_value >= 4.0
  UNION ALL
  SELECT PAT_ID, EPISODE_ID, index_csn, 3 AS aki_stage
  FROM dialysis_during_admission
  UNION ALL
  -- Stage 2: 2.0-2.9x baseline
  SELECT PAT_ID, EPISODE_ID, index_csn, 2 AS aki_stage
  FROM inpatient_creatinine
  WHERE ratio_to_baseline >= 2.0 AND ratio_to_baseline < 3.0
  UNION ALL
  -- Stage 1: 1.5-1.9x baseline
  SELECT PAT_ID, EPISODE_ID, index_csn, 1 AS aki_stage
  FROM inpatient_creatinine
  WHERE ratio_to_baseline >= 1.5 AND ratio_to_baseline < 2.0
  UNION ALL
  -- Stage 1: >= 0.3 increase within 48 hours
  SELECT PAT_ID, EPISODE_ID, index_csn, 1 AS aki_stage
  FROM aki_48hr_increase
) all_aki
GROUP BY PAT_ID, EPISODE_ID, index_csn;

SELECT max_aki_stage, COUNT(DISTINCT PAT_ID) AS patients
FROM aki_patients
GROUP BY max_aki_stage
ORDER BY max_aki_stage;

-- COMMAND ----------

-- DBTITLE 1,Step 5: CKD Criteria - Lab triggers and ICD-10 problem list codes
-- =============================================================================
-- STEP 5: CKD CLASSIFICATION
-- Lab triggers:
--   eGFR < 90 (outpatient 365-7 days pre-admission OR first inpatient)
--   UACR > 300 mg/g (outpatient or inpatient during pregnancy)
--   Urine Protein/Creatinine Ratio > 300 mg/g
--   24-Hour Urine Protein > 300 mg
-- ICD-10 codes on problem list during pregnancy:
--   N18.1-N18.9, R80.0, R80.8, R80.9, O12.1
-- =============================================================================

-- CKD Lab Trigger: eGFR < 90
CREATE OR REPLACE TEMPORARY VIEW ckd_egfr AS
SELECT DISTINCT ce.PAT_ID, ce.EPISODE_ID, ce.index_csn, 'eGFR_LT_90' AS ckd_reason
FROM creatinine_eligible ce
INNER JOIN data_mgmt.derived.lab_results lr
  ON ce.PAT_ID = lr.pat_id
WHERE lr.component_base_name IN ('GFRCKDCR2021', 'GFRNA', 'GFRAA', 'EGFR', 'GFRCKDEPI')
  AND lr.ord_num_value IS NOT NULL
  AND lr.ord_num_value > 0
  AND lr.ord_num_value < 90
  AND lr.ord_num_value <> 9999999
  AND lr.lab_status IN ('Final result', 'Edited Result - FINAL')
  AND coalesce(lr.serv_area_id, 11) = 11
  AND (
    -- Outpatient: 365-7 days prior to admission
    (lr.specimen_taken_time BETWEEN DATE_ADD(ce.hosp_admsn_time, -365) AND DATE_ADD(ce.hosp_admsn_time, -7))
    OR
    -- First inpatient lab (during index admission)
    (lr.specimen_taken_time BETWEEN ce.hosp_admsn_time AND ce.hosp_disch_time)
  );

-- CKD Lab Trigger: UACR > 300 mg/g
CREATE OR REPLACE TEMPORARY VIEW ckd_uacr AS
SELECT DISTINCT ce.PAT_ID, ce.EPISODE_ID, ce.index_csn, 'UACR_GT_300' AS ckd_reason
FROM creatinine_eligible ce
INNER JOIN data_mgmt.derived.lab_results lr
  ON ce.PAT_ID = lr.pat_id
WHERE lr.component_base_name IN ('MICRALBCREAT', 'MICROALCREAT', 'POCURALCRERA')
  AND lr.ord_num_value IS NOT NULL
  AND lr.ord_num_value > 300
  AND lr.ord_num_value <> 9999999
  AND lr.lab_status IN ('Final result', 'Edited Result - FINAL')
  AND coalesce(lr.serv_area_id, 11) = 11
  AND lr.specimen_taken_time BETWEEN ce.hosp_admsn_time AND ce.hosp_disch_time;

-- CKD Lab Trigger: Urine Protein/Creatinine Ratio > 300 mg/g
CREATE OR REPLACE TEMPORARY VIEW ckd_upcr AS
SELECT DISTINCT ce.PAT_ID, ce.EPISODE_ID, ce.index_csn, 'UPCR_GT_300' AS ckd_reason
FROM creatinine_eligible ce
INNER JOIN data_mgmt.derived.lab_results lr
  ON ce.PAT_ID = lr.pat_id
WHERE lr.component_base_name = 'PROTCRRATIO'
  AND lr.ord_num_value IS NOT NULL
  AND lr.ord_num_value > 300
  AND lr.ord_num_value <> 9999999
  AND lr.lab_status IN ('Final result', 'Edited Result - FINAL')
  AND coalesce(lr.serv_area_id, 11) = 11
  AND lr.specimen_taken_time BETWEEN ce.hosp_admsn_time AND ce.hosp_disch_time;

-- CKD Lab Trigger: 24-Hour Urine Protein > 300 mg
CREATE OR REPLACE TEMPORARY VIEW ckd_24hr_protein AS
SELECT DISTINCT ce.PAT_ID, ce.EPISODE_ID, ce.index_csn, '24HR_PROTEIN_GT_300' AS ckd_reason
FROM creatinine_eligible ce
INNER JOIN data_mgmt.derived.lab_results lr
  ON ce.PAT_ID = lr.pat_id
WHERE lr.component_base_name IN ('PROTEIN24HR', 'PROTUPEP24')
  AND lr.ord_num_value IS NOT NULL
  AND lr.ord_num_value > 300
  AND lr.ord_num_value <> 9999999
  AND lr.lab_status IN ('Final result', 'Edited Result - FINAL')
  AND coalesce(lr.serv_area_id, 11) = 11
  AND lr.specimen_taken_time BETWEEN ce.hosp_admsn_time AND ce.hosp_disch_time;

-- CKD ICD-10 Codes on Problem List during pregnancy/index hospitalization
CREATE OR REPLACE TEMPORARY VIEW ckd_icd10 AS
SELECT DISTINCT ce.PAT_ID, ce.EPISODE_ID, ce.index_csn, 'ICD10_CKD_PROTEINURIA' AS ckd_reason
FROM creatinine_eligible ce
INNER JOIN data_mgmt.clarity.problem_list pl
  ON ce.PAT_ID = pl.PAT_ID
INNER JOIN data_mgmt.clarity.edg_current_icd10 icd
  ON pl.DX_ID = icd.DX_ID
WHERE (
  icd.CODE LIKE 'N18.1%' OR icd.CODE LIKE 'N18.2%' OR icd.CODE LIKE 'N18.3%'
  OR icd.CODE LIKE 'N18.4%' OR icd.CODE LIKE 'N18.5%' OR icd.CODE LIKE 'N18.6%'
  OR icd.CODE LIKE 'N18.9%'
  OR icd.CODE = 'R80.0' OR icd.CODE = 'R80.8' OR icd.CODE = 'R80.9'
  OR icd.CODE LIKE 'O12.1%'
)
AND (
  -- Problem noted during pregnancy episode window or index hospitalization
  (pl.NOTED_DATE BETWEEN ce.hosp_admsn_time AND ce.hosp_disch_time)
  OR pl.PROBLEM_STATUS_C = 1  -- Active problem
);

-- Combine all CKD criteria
CREATE OR REPLACE TEMPORARY VIEW ckd_patients AS
SELECT PAT_ID, EPISODE_ID, index_csn, ckd_reason FROM ckd_egfr
UNION
SELECT PAT_ID, EPISODE_ID, index_csn, ckd_reason FROM ckd_uacr
UNION
SELECT PAT_ID, EPISODE_ID, index_csn, ckd_reason FROM ckd_upcr
UNION
SELECT PAT_ID, EPISODE_ID, index_csn, ckd_reason FROM ckd_24hr_protein
UNION
SELECT PAT_ID, EPISODE_ID, index_csn, ckd_reason FROM ckd_icd10;

SELECT ckd_reason, COUNT(DISTINCT PAT_ID) AS patients
FROM ckd_patients
GROUP BY ckd_reason
ORDER BY patients DESC;

-- COMMAND ----------

-- DBTITLE 1,Step 6: Final Cohort - Combine AKI and CKD patients with kidney disease during pregnancy
-- =============================================================================
-- STEP 6: FINAL COHORT
-- Patients with pregnancy + (AKI OR CKD) + creatinine eligibility
-- Exclusion already applied: patients must have > 1 serum creatinine
-- =============================================================================

CREATE OR REPLACE TABLE ccda.ccda_9020_cohort AS
SELECT DISTINCT
  pc.PAT_ID,
  pc.EPISODE_ID,
  pc.PAT_ENC_CSN_ID AS index_csn,
  pc.episode_start,
  pc.episode_end,
  pc.hosp_admsn_time,
  pc.hosp_disch_time,
  pc.age_at_admission,
  bc.baseline_creatinine,
  bc.baseline_source,
  CASE
    WHEN aki.PAT_ID IS NOT NULL THEN 1 ELSE 0
  END AS has_aki,
  aki.max_aki_stage,
  CASE
    WHEN ckd.PAT_ID IS NOT NULL THEN 1 ELSE 0
  END AS has_ckd,
  CASE
    WHEN aki.PAT_ID IS NOT NULL AND ckd.PAT_ID IS NOT NULL THEN 'AKI + CKD'
    WHEN aki.PAT_ID IS NOT NULL THEN 'AKI Only'
    WHEN ckd.PAT_ID IS NOT NULL THEN 'CKD Only'
  END AS kidney_disease_category
FROM pregnancy_cohort pc
INNER JOIN creatinine_eligible ce
  ON pc.PAT_ID = ce.PAT_ID
  AND pc.EPISODE_ID = ce.EPISODE_ID
  AND pc.PAT_ENC_CSN_ID = ce.index_csn
INNER JOIN baseline_creatinine bc
  ON pc.PAT_ID = bc.PAT_ID
  AND pc.EPISODE_ID = bc.EPISODE_ID
  AND pc.PAT_ENC_CSN_ID = bc.index_csn
LEFT JOIN aki_patients aki
  ON pc.PAT_ID = aki.PAT_ID
  AND pc.EPISODE_ID = aki.EPISODE_ID
  AND pc.PAT_ENC_CSN_ID = aki.index_csn
LEFT JOIN (
  SELECT DISTINCT PAT_ID, EPISODE_ID, index_csn FROM ckd_patients
) ckd
  ON pc.PAT_ID = ckd.PAT_ID
  AND pc.EPISODE_ID = ckd.EPISODE_ID
  AND pc.PAT_ENC_CSN_ID = ckd.index_csn
WHERE aki.PAT_ID IS NOT NULL OR ckd.PAT_ID IS NOT NULL;

-- Summary statistics
SELECT
  kidney_disease_category,
  COUNT(DISTINCT PAT_ID) AS total_unique_patients,
  ROUND(100.0 * COUNT(DISTINCT PAT_ID) / SUM(COUNT(DISTINCT PAT_ID)) OVER (), 1) AS pct_of_cohort,
  COUNT(*) AS total_patient_episodes,
  SUM(has_aki) AS episodes_with_aki,
  SUM(has_ckd) AS episodes_with_ckd
FROM ccda.ccda_9020_cohort
GROUP BY kidney_disease_category
ORDER BY pct_of_cohort DESC;

-- COMMAND ----------

-- DBTITLE 1,Step 7: Detailed Final Cohort Output
-- =============================================================================
-- FINAL OUTPUT: Detailed patient-level cohort table
-- =============================================================================

SELECT
  PAT_ID,
  EPISODE_ID,
  index_csn,
  episode_start,
  episode_end,
  hosp_admsn_time,
  hosp_disch_time,
  age_at_admission,
  baseline_creatinine,
  baseline_source,
  has_aki,
  max_aki_stage,
  has_ckd,
  kidney_disease_category
FROM ccda.ccda_9020_cohort
ORDER BY PAT_ID, hosp_admsn_time;

-- COMMAND ----------

-- DBTITLE 1,Step 8: Demographics - Patient demographics for the cohort
-- =============================================================================
-- STEP 8: DEMOGRAPHICS TABLE
-- Pull patient demographics for the cohort from data_mgmt.derived.epic_patient
-- =============================================================================

CREATE OR REPLACE TABLE ccda.ccda_9020_demographics AS
SELECT DISTINCT
  c.PAT_ID,
  ep.emrn,
  ep.birth_date,
  ep.first_race AS race,
  ep.ethnic_group AS ethnicity,
  ep.language
FROM ccda.ccda_9020_cohort c
INNER JOIN data_mgmt.derived.epic_patient ep
  ON c.PAT_ID = ep.pat_id;

SELECT COUNT(*) AS total_patients,
       COUNT(DISTINCT race) AS distinct_races,
       COUNT(DISTINCT ethnicity) AS distinct_ethnicities,
       COUNT(DISTINCT language) AS distinct_languages
FROM ccda.ccda_9020_demographics;

-- COMMAND ----------

-- DBTITLE 1,Step 9: Geocode SDOH - Area Deprivation Index for the cohort
-- =============================================================================
-- STEP 9: GEOCODE & SDOH TABLE
-- Link cohort patients to their address at index hospitalization via geocode,
-- then join to 2020 Census SDOH data for Area Deprivation Index (ADI)
-- =============================================================================

CREATE OR REPLACE TABLE ccda.ccda_9020_sdoh AS
SELECT DISTINCT
  c.PAT_ID,
  g.pat_enc_csn_id,
  g.encounter_date,
  g.address,
  g.city,
  g.state_or_province,
  g.postal_code,
  g.geoid_2020,
  s.adi_nat_2020 AS adi_national,
  s.adi_state_2020 AS adi_state
FROM ccda.ccda_9020_cohort c
INNER JOIN data_mgmt.derived.geocode_patient_visit_changes g
  ON c.PAT_ID = g.pat_id
  AND coalesce(g.serv_area_id, 11) = 11
LEFT JOIN commons.dictionary.sdoh_dbgl_2020_census s
  ON g.geoid_2020 = s.GEOID;

SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT PAT_ID) AS unique_patients,
  COUNT(adi_national) AS has_adi_national
FROM ccda.ccda_9020_sdoh;

-- COMMAND ----------

-- DBTITLE 1,Step 10: Lab Results - Filtered labs for the cohort
-- =============================================================================
-- STEP 10: LAB RESULTS TABLE
-- Pull relevant labs for cohort patients from data_mgmt.derived.lab_results
-- Filtered to serv_area_id 11 and final/edited-final status
-- =============================================================================

CREATE OR REPLACE TABLE ccda.ccda_9020_labs AS
SELECT DISTINCT
  c.PAT_ID,
  lr.pat_enc_csn_id,
  lr.order_proc_id,
  lr.component_id,
  lr.component_base_name,
  lr.specimen_taken_time,
  lr.ord_num_value,
  lr.reference_unit,
  lr.lab_status,
  CASE
    WHEN lr.component_base_name IN ('CREATININE','CREATWB','POCCREA')
      THEN 'Serum Creatinine'
    WHEN lr.component_base_name IN ('ALBCREATRAT','MICRALBCREAT','MICRALBCREUR','MICROALCREAT')
      OR lr.component_id IN (3000000793,4000000917,5000002196,7100002936,9000000525)
      THEN 'Urine Albumin/Creatinine'
    WHEN lr.component_base_name IN ('ALBUPEP24','MICROALB24H')
      OR lr.component_id IN (8100000687,8100001457,8100004970,8100004971)
      THEN '24hr Urine Albumin'
    WHEN lr.component_base_name IN ('PROTCRRATIO')
      THEN 'Urine Protein/Creatinine'
    WHEN lr.component_base_name IN ('PROTEIN24HR','PROTUPEP24','PROTUR24HR','UTP24')
      THEN '24hr Urine Protein'
    WHEN lr.component_base_name IN ('PLT')
      THEN 'Platelet Count'
    WHEN lr.component_base_name IN ('EPOCK','K','KWB','KWBMEQ','POCPOTASSIUM')
      THEN 'Serum Potassium'
    WHEN lr.component_base_name IN ('HGB','HGBPOC','HGBWB','POCHGB')
      OR lr.component_id IN (7000002491,7100000936,9100006038)
      THEN 'Serum Hemoglobin'
    WHEN lr.component_base_name IN ('URICACID')
      THEN 'Serum Uric Acid'
    WHEN lr.component_base_name IN ('ALBUMIN','ALBUMINSPEP')
      THEN 'Serum Albumin'
    WHEN lr.component_base_name IN ('BUN')
      THEN 'Serum BUN'
    WHEN lr.component_base_name IN ('CO2')
      THEN 'Serum Bicarbonate'
    WHEN lr.component_base_name IN ('PHOS','PHOSPHORUS')
      THEN 'Serum Phosphorous'
    WHEN lr.component_base_name IN ('MG','MGRBC')
      THEN 'Serum Magnesium'
    WHEN lr.component_base_name IN ('AST')
      THEN 'Serum AST'
    WHEN lr.component_base_name IN ('ALT')
      THEN 'Serum ALT'
    WHEN lr.component_base_name IN ('NA','NAWB','NAWBMEQ','POCSODIUM','SODIUMPOC')
      THEN 'Serum Sodium'
  END AS lab_category
FROM ccda.ccda_9020_cohort c
INNER JOIN data_mgmt.derived.lab_results lr
  ON c.PAT_ID = lr.pat_id
WHERE coalesce(lr.serv_area_id, 11) = 11
  AND specimen_taken_time >= '2016-06-01'
  AND lr.lab_status IN ('Final result', 'Edited Result - FINAL')
  AND (
    -- Serum Creatinine
    lr.component_base_name IN ('CREATININE','CREATWB','POCCREA')
    -- Urine Albumin/Creatinine
    OR lr.component_base_name IN ('ALBCREATRAT','MICRALBCREAT','MICRALBCREUR','MICROALCREAT')
    OR lr.component_id IN (3000000793,4000000917,5000002196,7100002936,9000000525)
    -- 24hr Urine Albumin
    OR lr.component_base_name IN ('ALBUPEP24','MICROALB24H')
    OR lr.component_id IN (8100000687,8100001457,8100004970,8100004971)
    -- Urine Protein/Creatinine
    OR lr.component_base_name IN ('PROTCRRATIO')
    -- 24hr Urine Protein
    OR lr.component_base_name IN ('PROTEIN24HR','PROTUPEP24','PROTUR24HR','UTP24')
    -- Platelet Count
    OR lr.component_base_name IN ('PLT')
    -- Serum Potassium
    OR lr.component_base_name IN ('EPOCK','K','KWB','KWBMEQ','POCPOTASSIUM')
    -- Serum Hemoglobin
    OR lr.component_base_name IN ('HGB','HGBPOC','HGBWB','POCHGB')
    OR lr.component_id IN (7000002491,7100000936,9100006038)
    -- Serum Uric Acid
    OR lr.component_base_name IN ('URICACID')
    -- Serum Albumin
    OR lr.component_base_name IN ('ALBUMIN','ALBUMINSPEP')
    -- Serum BUN
    OR lr.component_base_name IN ('BUN')
    -- Serum Bicarbonate
    OR lr.component_base_name IN ('CO2')
    -- Serum Phosphorous
    OR lr.component_base_name IN ('PHOS','PHOSPHORUS')
    -- Serum Magnesium
    OR lr.component_base_name IN ('MG','MGRBC')
    -- Serum AST
    OR lr.component_base_name IN ('AST')
    -- Serum ALT
    OR lr.component_base_name IN ('ALT')
    -- Serum Sodium
    OR lr.component_base_name IN ('NA','NAWB','NAWBMEQ','POCSODIUM','SODIUMPOC')
  );

SELECT lab_category,
       COUNT(*) AS total_results,
       COUNT(DISTINCT PAT_ID) AS unique_patients
FROM ccda.ccda_9020_labs
GROUP BY lab_category
ORDER BY lab_category;

-- COMMAND ----------

-- DBTITLE 1,Step 11: Encounters - All encounters for the cohort with pregnancy fields
-- =============================================================================
-- STEP 11: ENCOUNTERS TABLE
-- All encounters for cohort patients from data_mgmt.derived.epic_all_encounters
-- with delivery/labor fields from data_mgmt.derived.inpatient_encounters
-- =============================================================================

CREATE OR REPLACE TABLE ccda.ccda_9020_encounters AS
SELECT DISTINCT
  c.PAT_ID,
  e.pat_enc_csn_id,
  e.contact_date,
  e.enc_type_c,
  e.enc_type,
  e.appt_visit_type,
  e.appointment_status,
  e.adt_pat_class,
  e.department_id,
  e.department_name,
  e.visit_prov_id,
  e.visit_provider,
  e.attending_prov_id,
  e.attending_provider,
  e.hosp_admission_time,
  e.hosp_discharge_time,
  e.effective_date_dttm,
  e.facility,
  e.ed_visit_yn,
  e.disch_disp,
  e.ip_episode_id,
  -- Pregnancy-related fields from inpatient_encounters
  ip.delivery_type_c,
  ip.delivery_type,
  ip.labor_status_c,
  ip.labor_status
FROM ccda.ccda_9020_cohort c
INNER JOIN data_mgmt.derived.epic_all_encounters e
  ON c.PAT_ID = e.pat_id
LEFT JOIN data_mgmt.derived.inpatient_encounters ip
  ON e.pat_enc_csn_id = ip.pat_enc_csn_id
WHERE (coalesce(e.appt_status_c,-1) NOT IN (3, 4, 5))
  AND coalesce(e.serv_area_id, 11) = 11
  AND coalesce(e.effective_date_dttm, e.contact_date) BETWEEN DATE('2016-06-01') AND current_timestamp();

SELECT
  COUNT(*) AS total_encounters,
  COUNT(DISTINCT PAT_ID) AS unique_patients,
  COUNT(delivery_type) AS has_delivery_type,
  COUNT(labor_status) AS has_labor_status
FROM ccda.ccda_9020_encounters;

-- COMMAND ----------

-- DBTITLE 1,Step 12: Social History - Smoking, alcohol, and substance use
-- =============================================================================
-- STEP 12: SOCIAL HISTORY TABLE
-- Pull smoking, alcohol, and substance use from
-- data_mgmt.derived.social_history_changes
-- =============================================================================

CREATE OR REPLACE TABLE ccda.ccda_9020_social_history AS
SELECT DISTINCT
  c.PAT_ID,
  sh.pat_enc_csn_id,
  sh.contact_date,
  -- Smoking
  sh.smoking_tobacco_use,
  sh.tobacco_pak_per_dy,
  sh.tob_pack_years,
  sh.smoking_quit_date,
  -- Alcohol
  sh.alcohol_use,
  sh.alcohol_oz_per_wk,
  sh.alcohol_drinks_per_day,
  sh.alcohol_binge,
  -- Substance use
  sh.ill_drug_user,
  sh.iv_drug_user_yn,
  sh.illicit_drug_freq
FROM ccda.ccda_9020_cohort c
INNER JOIN data_mgmt.derived.social_history_changes sh
  ON c.PAT_ID = sh.pat_id;

SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT PAT_ID) AS unique_patients,
  COUNT(smoking_tobacco_use) AS has_smoking_status,
  COUNT(alcohol_use) AS has_alcohol_use,
  COUNT(ill_drug_user) AS has_substance_use
FROM ccda.ccda_9020_social_history;

-- COMMAND ----------

-- DBTITLE 1,Step 13: Problem List - Diagnoses on the problem list
-- =============================================================================
-- STEP 13: PROBLEM LIST TABLE
-- All problem list entries for cohort patients from
-- data_mgmt.derived.problem_list (no serv_area_id on this table)
-- =============================================================================

CREATE OR REPLACE TABLE ccda.ccda_9020_problem_list AS
SELECT DISTINCT
  c.PAT_ID,
  pl.problem_list_id,
  pl.dx_id,
  pl.dx_name,
  pl.dx_group,
  pl.icd10_code,
  pl.icd9_code,
  pl.current_icd10_list,
  pl.problem_status,
  pl.problem_status_c,
  pl.class_of_problem,
  pl.chronic_yn,
  pl.noted_date,
  pl.resolved_date,
  pl.date_of_entry
FROM ccda.ccda_9020_cohort c
INNER JOIN data_mgmt.derived.problem_list pl
  ON c.PAT_ID = pl.pat_id
WHERE pl.noted_date >= '2016-06-01';

SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT PAT_ID) AS unique_patients,
  COUNT(DISTINCT dx_name) AS distinct_diagnoses
FROM ccda.ccda_9020_problem_list;

-- COMMAND ----------

-- DBTITLE 1,Step 14: Encounter Diagnoses - Diagnoses tied to encounters
-- =============================================================================
-- STEP 14: ENCOUNTER DIAGNOSES TABLE
-- Diagnoses associated with encounters for cohort patients
-- =============================================================================

CREATE OR REPLACE TABLE ccda.ccda_9020_encounter_dx AS
SELECT DISTINCT
  c.PAT_ID,
  edx.pat_enc_csn_id,
  edx.enc_contact_date,
  edx.line,
  edx.dx_id,
  edx.dx_name,
  edx.dx_group,
  edx.icd10_code,
  edx.icd9_code,
  edx.current_icd10_list,
  edx.dx_qualifier,
  edx.primary_dx_yn,
  edx.dx_chronic_yn,
  edx.facility
FROM ccda.ccda_9020_cohort c
INNER JOIN data_mgmt.derived.encounter_dx edx
  ON c.PAT_ID = edx.pat_id
WHERE coalesce(edx.serv_area_id, 11) = 11
  AND edx.enc_contact_date >= '2016-06-01';

SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT PAT_ID) AS unique_patients,
  COUNT(DISTINCT dx_name) AS distinct_diagnoses
FROM ccda.ccda_9020_encounter_dx;

-- COMMAND ----------

-- DBTITLE 1,Step 15: Medication Administrations - Inpatient med administrations
-- =============================================================================
-- STEP 15: MEDICATION ADMINISTRATIONS TABLE
-- Medication administrations for cohort patients
-- =============================================================================

CREATE OR REPLACE TABLE ccda.ccda_9020_med_admin AS
SELECT DISTINCT
  c.PAT_ID,
  ma.pat_enc_csn_id,
  ma.order_med_id,
  ma.medication_id,
  ma.medication_name,
  ma.generic_name,
  ma.thera_classname,
  ma.pharm_classname,
  ma.pharm_subclassname,
  ma.taken_time,
  ma.mar_action,
  ma.route,
  ma.sig,
  ma.dose_unit,
  ma.infusion_rate,
  ma.frequency
FROM ccda.ccda_9020_cohort c
INNER JOIN data_mgmt.derived.med_admin ma
  ON c.PAT_ID = ma.pat_id
WHERE coalesce(ma.serv_area_id, 11) = 11
  AND ma.taken_time >= '2016-06-01';

SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT PAT_ID) AS unique_patients,
  COUNT(DISTINCT medication_name) AS distinct_medications
FROM ccda.ccda_9020_med_admin;

-- COMMAND ----------

-- DBTITLE 1,Step 16: Medication Orders - All med orders for the cohort
-- =============================================================================
-- STEP 16: MEDICATION ORDERS TABLE
-- Medication orders for cohort patients
-- =============================================================================

CREATE OR REPLACE TABLE ccda.ccda_9020_med_orders AS
SELECT DISTINCT
  c.PAT_ID,
  mo.pat_enc_csn_id,
  mo.order_med_id,
  mo.medication_id,
  mo.med_name,
  mo.med_display_name,
  mo.order_mode,
  mo.order_class,
  mo.ord_status,
  mo.dose,
  mo.unit,
  mo.route,
  mo.frequency,
  mo.therapeutic_class,
  mo.pharmaceutical_class,
  mo.pharmaceutical_subclass,
  mo.start_date,
  mo.end_date,
  mo.ordering_dttm
FROM ccda.ccda_9020_cohort c
INNER JOIN data_mgmt.derived.med_orders mo
  ON c.PAT_ID = mo.pat_id
WHERE coalesce(mo.serv_area_id, 11) = 11
  AND mo.start_date >= '2016-06-01';

SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT PAT_ID) AS unique_patients,
  COUNT(DISTINCT med_name) AS distinct_medications
FROM ccda.ccda_9020_med_orders;

-- COMMAND ----------

-- DBTITLE 1,Step 17: Outpatient Dialysis - Profee billing for dialysis CPT codes
-- =============================================================================
-- STEP 17: OUTPATIENT DIALYSIS TABLE
-- Profee billing procedures filtered to outpatient dialysis CPT codes
-- =============================================================================

CREATE OR REPLACE TABLE ccda.ccda_9020_op_dialysis AS
SELECT DISTINCT
  c.PAT_ID,
  pb.pat_enc_csn_id,
  pb.proc_date,
  pb.proc_id,
  pb.proc_name,
  pb.code,
  pb.px_cpt_modifiers,
  pb.px_cpt_quantity,
  pb.proc_perf_prov_id,
  pb.proc_pref_prov_name,
  pb.department_id,
  pb.department,
  pb.location_name,
  pb.place_of_service
FROM ccda.ccda_9020_cohort c
INNER JOIN data_mgmt.derived.profee_billing_px pb
  ON c.PAT_ID = pb.pat_id
WHERE coalesce(pb.service_area_id, 11) = 11
  AND pb.code IN ('90935','90947','90960','90961','90962','90966')
  AND pb.proc_date >= '2016-06-01';

SELECT
  code,
  proc_name,
  COUNT(*) AS total_claims,
  COUNT(DISTINCT PAT_ID) AS unique_patients
FROM ccda.ccda_9020_op_dialysis
GROUP BY code, proc_name
ORDER BY code;

-- COMMAND ----------

-- DBTITLE 1,Step 18: Flowsheet Data - BMI, Blood Pressure, Inpatient Dialysis
-- =============================================================================
-- STEP 18: FLOWSHEET DATA TABLE
-- BMI, Blood Pressure, and Inpatient Dialysis flowsheet measures
-- =============================================================================

CREATE OR REPLACE TABLE ccda.ccda_9020_flowsheets AS
SELECT DISTINCT
  c.PAT_ID,
  fs.pat_enc_csn_id,
  fs.recorded_time,
  fs.meas_id,
  fs.meas_disp_name,
  fs.meas_value,
  fs.meas_comment,
  CASE
    WHEN fs.meas_disp_name IN ('BMI', 'BMI (Calculated)')
      THEN 'BMI'
    WHEN fs.meas_disp_name IN (
      '*OLD BP','*OLD* BP','2 Minute Blood Pressure','Arterial Line 1 BP',
      'Arterial Line 2 BP','Arterial Line 3 BP','Baseline Blood Pressure (mmHg)',
      'Baseline/Start Blood Pressure','Blood Pressure','BP','BP (Orthostatic)',
      'cNIBP','Diastolic','Diastolic Pressure','NIBP','Peak BP','Resting BP',
      'Seated Vital Signs BP','Sit To Stand Vital Signs BP',
      'Standing Vital Signs BP','Systolic','Systolic Pressure'
    ) THEN 'Blood Pressure'
    WHEN fs.meas_id IN (
      '3040100110','3040100116','3040100119','3040100135','3040100136',
      '3040100137','304401012832','304401012833','304401012834','304401012835',
      '30481005601','30481005701','304810060','8100260','8100270','15392',
      '3040107041','3040107081','304601000','304601001','304601002',
      '304601046','304601053','304601054','370040','370080','370090',
      '370110','370120','370150','370160','370170','370180','370190',
      '370200','370210','370220','370400','370401','370403','370404',
      '370405','370406','370407','370409','370412'
    ) THEN 'Inpatient Dialysis'
  END AS flowsheet_category
FROM ccda.ccda_9020_cohort c
INNER JOIN data_mgmt.derived.flowsheet_data fs
  ON c.PAT_ID = fs.pat_id
WHERE coalesce(fs.serv_area_id, 11) = 11
  AND fs.recorded_time >= '2016-06-01'
  AND (
    -- BMI
    fs.meas_disp_name IN ('BMI', 'BMI (Calculated)')
    -- Blood Pressure
    OR fs.meas_disp_name IN (
      '*OLD BP','*OLD* BP','2 Minute Blood Pressure','Arterial Line 1 BP',
      'Arterial Line 2 BP','Arterial Line 3 BP','Baseline Blood Pressure (mmHg)',
      'Baseline/Start Blood Pressure','Blood Pressure','BP','BP (Orthostatic)',
      'cNIBP','Diastolic','Diastolic Pressure','NIBP','Peak BP','Resting BP',
      'Seated Vital Signs BP','Sit To Stand Vital Signs BP',
      'Standing Vital Signs BP','Systolic','Systolic Pressure'
    )
    -- Inpatient Dialysis
    OR fs.meas_id IN (
      '3040100110','3040100116','3040100119','3040100135','3040100136',
      '3040100137','304401012832','304401012833','304401012834','304401012835',
      '30481005601','30481005701','304810060','8100260','8100270','15392',
      '3040107041','3040107081','304601000','304601001','304601002',
      '304601046','304601053','304601054','370040','370080','370090',
      '370110','370120','370150','370160','370170','370180','370190',
      '370200','370210','370220','370400','370401','370403','370404',
      '370405','370406','370407','370409','370412'
    )
  );

SELECT flowsheet_category,
       COUNT(*) AS total_readings,
       COUNT(DISTINCT PAT_ID) AS unique_patients
FROM ccda.ccda_9020_flowsheets
GROUP BY flowsheet_category
ORDER BY flowsheet_category;

-- COMMAND ----------

-- DBTITLE 1,Step 19: Kidney Transplant Data
-- =============================================================================
-- STEP 19: KIDNEY TRANSPLANT TABLE
-- Transplant episodes for cohort patients limited to Kidney
-- =============================================================================

CREATE OR REPLACE TABLE ccda.ccda_9020_transplant AS
SELECT DISTINCT
  c.PAT_ID,
  tx.episode_id,
  tx.episode_status,
  tx.episode_name,
  tx.transplant_class,
  tx.transplant_number,
  tx.current_stage,
  tx.current_status,
  tx.current_reason,
  tx.facility,
  tx.episode_start_date,
  tx.referral_date,
  tx.eval_begin_date,
  tx.eval_end_date,
  tx.waitlist_date,
  tx.admission_date,
  tx.surgery_date,
  tx.discharge_date,
  tx.recipient_admit_csn,
  tx.surgery_log_id,
  tx.organ_source,
  tx.type_of_organ,
  tx.organ_procedure_type,
  tx.organ_status,
  tx.donor_relationship,
  tx.donor_surgery_date,
  tx.org_fail_date,
  tx.unos_primary_fail,
  tx.transplant_protocols
FROM ccda.ccda_9020_cohort c
INNER JOIN data_mgmt.derived.transplant_data tx
  ON c.PAT_ID = tx.pat_id
WHERE tx.transplant_class = 'Kidney'
  AND coalesce(tx.serv_area_id, 11) = 11
  AND tx.episode_start_date >= '2016-06-01';

SELECT
  COUNT(*) AS total_episodes,
  COUNT(DISTINCT PAT_ID) AS unique_patients,
  COUNT(surgery_date) AS has_surgery_date,
  COUNT(org_fail_date) AS has_organ_failure
FROM ccda.ccda_9020_transplant;

-- COMMAND ----------

-- DBTITLE 1,Step 20: Obstetrics - Delivery and birth outcomes from birthfact
-- =============================================================================
-- STEP 20: OBSTETRICS TABLE
-- Delivery and birth outcomes from data_mgmt.edw.birthfact
-- Includes EDD, GA, delivery mode, labor, birth weight, Apgar, NICU, fetal demise
-- =============================================================================

CREATE OR REPLACE TABLE ccda.ccda_9020_obstetrics AS
WITH nicu_admissions AS (
  -- Baby CSNs admitted to NICU (ICU departments via clarity_dep_2)
  SELECT DISTINCT denom.PAT_ENC_CSN_ID
  FROM data_mgmt.clarity.ob_hsb_delivery del
  INNER JOIN data_mgmt.clarity.pat_enc_hsp denom
    ON del.BABY_BIRTH_CSN = denom.PAT_ENC_CSN_ID
  INNER JOIN data_mgmt.clarity.clarity_adt adt
    ON denom.PAT_ENC_CSN_ID = adt.PAT_ENC_CSN_ID
  INNER JOIN data_mgmt.clarity.clarity_dep_2 dep2
    ON adt.DEPARTMENT_ID = dep2.DEPARTMENT_ID
  WHERE adt.CANCEL_REASON_C IS NULL
    AND dep2.ICU_DEPT_YN = 'Y'
)
SELECT DISTINCT
  c.PAT_ID,
  bf.MotherEncounterEpicCsn AS mother_csn,
  bf.BabyEncounterEpicCsn AS baby_csn,
  bf.BirthInstant AS birth_datetime,
  -- Dating / EDD
  bf.GestationalAgeZeroDate AS lmp_date,
  DATE_ADD(bf.GestationalAgeZeroDate, 280) AS estimated_delivery_date,
  -- Gestational Age at Delivery
  bf.GestationalAgeDays AS gestational_age_days,
  FLOOR(bf.GestationalAgeDays / 7) AS gestational_age_weeks,
  MOD(bf.GestationalAgeDays, 7) AS gestational_age_remaining_days,
  -- Mode of Delivery
  bf.DeliveryMethod AS delivery_method,
  bf.CesareanDelivery AS cesarean_delivery,
  bf.SpontaneousVaginalDelivery AS spontaneous_vaginal_delivery,
  bf.ForcepsDelivery AS forceps_delivery,
  bf.VacuumDelivery AS vacuum_delivery,
  -- Labor characteristics
  bf.InductionUsed AS induction_used,
  bf.LaborAttempted AS labor_attempted,
  bf.AugmentationUsed AS augmentation_used,
  bf.LaborStartInstant AS labor_start_instant,
  bf.FirstStageLengthMinutes AS first_stage_minutes,
  bf.SecondStageLengthMinutes AS second_stage_minutes,
  bf.ThirdStageLengthMinutes AS third_stage_minutes,
  -- Birth Weight (grams)
  bf.BirthWeight AS birth_weight_grams,
  -- Apgar Scores
  bf.TotalApgarOneMinute AS apgar_1_min,
  bf.TotalApgarFiveMinute AS apgar_5_min,
  bf.TotalApgarTenMinute AS apgar_10_min,
  -- NICU Admission
  CASE WHEN nicu.PAT_ENC_CSN_ID IS NOT NULL THEN 1 ELSE 0 END AS nicu_admission,
  -- Fetal Demise (born alive = 0 and not a termination)
  CASE
    WHEN bf.BornAlive = 0 AND bf.DeliveryMethod NOT LIKE '%Termination%'
      THEN 1 ELSE 0
  END AS fetal_demise,
  bf.BornAlive AS born_alive,
  bf.LivingStatus AS living_status,
  bf.PresentationType AS presentation_type,
  bf.MultipleDeliveryCount AS multiple_delivery_count,
  bf.MultipleDeliveryOrder AS multiple_delivery_order,
  bf.IsHistorical AS is_historical
FROM ccda.ccda_9020_cohort c
INNER JOIN data_mgmt.edw.birthfact bf
  ON c.PAT_ID = bf.MotherPatientEpicId
LEFT JOIN nicu_admissions nicu
  ON bf.BabyEncounterEpicCsn = nicu.PAT_ENC_CSN_ID;

SELECT
  COUNT(*) AS total_deliveries,
  COUNT(DISTINCT PAT_ID) AS unique_mothers,
  ROUND(AVG(gestational_age_days), 1) AS avg_ga_days,
  SUM(cesarean_delivery) AS cesarean_count,
  SUM(spontaneous_vaginal_delivery) AS svd_count,
  SUM(induction_used) AS induction_count,
  SUM(nicu_admission) AS nicu_count,
  SUM(fetal_demise) AS fetal_demise_count
FROM ccda.ccda_9020_obstetrics;

-- COMMAND ----------

-- DBTITLE 1,Export All Tables to CSV
-- MAGIC %python
-- MAGIC import os
-- MAGIC
-- MAGIC # Create a volume (if it doesn't exist) and export all ccda_9020 tables as pipe-delimited .txt
-- MAGIC spark.sql("CREATE VOLUME IF NOT EXISTS data_mgmt_int.ccda.export_ccda9020")
-- MAGIC output_path = "/Volumes/data_mgmt_int/ccda/export_ccda9020"
-- MAGIC
-- MAGIC tables = [
-- MAGIC     "ccda.ccda_9020_cohort",
-- MAGIC     "ccda.ccda_9020_demographics",
-- MAGIC     "ccda.ccda_9020_sdoh",
-- MAGIC     "ccda.ccda_9020_labs",
-- MAGIC     "ccda.ccda_9020_encounters",
-- MAGIC     "ccda.ccda_9020_social_history",
-- MAGIC     "ccda.ccda_9020_problem_list",
-- MAGIC     "ccda.ccda_9020_encounter_dx",
-- MAGIC     "ccda.ccda_9020_med_admin",
-- MAGIC     "ccda.ccda_9020_med_orders",
-- MAGIC     "ccda.ccda_9020_op_dialysis",
-- MAGIC     "ccda.ccda_9020_flowsheets",
-- MAGIC     "ccda.ccda_9020_transplant",
-- MAGIC     "ccda.ccda_9020_obstetrics",
-- MAGIC ]
-- MAGIC
-- MAGIC for table in tables:
-- MAGIC     table_short = table.split(".")[-1]
-- MAGIC     file_path = f"{output_path}/{table_short}.txt"
-- MAGIC     print(f"Exporting {table} -> {file_path}")
-- MAGIC     pdf = spark.table(table).toPandas()
-- MAGIC     pdf.to_csv(file_path, sep="|", index=False)
-- MAGIC     print(f"  Done ({len(pdf):,} rows)")
-- MAGIC
-- MAGIC print(f"\nAll tables exported to: {output_path}")

-- COMMAND ----------

-- MAGIC %python
-- MAGIC #Testing
-- MAGIC import os
-- MAGIC
-- MAGIC # Create a volume (if it doesn't exist) and export all ccda_9020 tables as pipe-delimited .txt
-- MAGIC spark.sql("CREATE VOLUME IF NOT EXISTS data_mgmt_int.ccda.export_ccda9020")
-- MAGIC output_path = "/Volumes/data_mgmt_int/ccda/export_ccda9020"
-- MAGIC
-- MAGIC tables = [
-- MAGIC     "ccda.ccda_9020_cohort",
-- MAGIC     "ccda.ccda_9020_demographics"
-- MAGIC ]
-- MAGIC
-- MAGIC for table in tables:
-- MAGIC     table_short = table.split(".")[-1]
-- MAGIC     file_path = f"{output_path}/{table_short}.txt"
-- MAGIC     print(f"Exporting {table} -> {file_path}")
-- MAGIC     pdf = spark.table(table).toPandas()
-- MAGIC     pdf.to_csv(file_path, sep="|", index=False)
-- MAGIC     print(f"  Done ({len(pdf):,} rows)")
-- MAGIC
-- MAGIC print(f"\nAll tables exported to: {output_path}")