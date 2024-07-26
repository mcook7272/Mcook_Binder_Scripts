DROP TABLE IF EXISTS #crut_2441_case01;
DROP TABLE IF EXISTS #crut_2444_base_v2;
DROP TABLE IF EXISTS #temp;
DROP TABLE IF EXISTS #top4;
DROP TABLE IF EXISTS [Analytics].[dbo].[CCDA3796_Milstone_Control_Cohort];

WITH pat_race
AS (
   SELECT pat_race.pat_id
      ,STRING_AGG(pat_race.race, '; ') within
   GROUP (
         ORDER BY pat_race.race_rank
         ) "pat_race_list"
   FROM (
      SELECT DISTINCT patient_race.pat_id
         ,patient_race.patient_race_c
         ,zc_patient_race.name race
         ,patient_race.line race_recorded_order
         ,dense_rank() OVER (
            PARTITION BY patient_race.pat_id ORDER BY patient_race.line
            ) race_rank
      FROM clarity..patient_race patient_race
      INNER JOIN clarity..zc_patient_race zc_patient_race ON patient_race.patient_race_c = zc_patient_race.patient_race_c
      WHERE lower(zc_patient_race.name) NOT IN ('refused', 'do not use')
      ) pat_race
   GROUP BY pat_race.pat_id
   )
   ,COH AS (
   select PT.* 
   from clarity..patient PT
   INNER JOIN CLARITY..IDENTITY_ID II ON II.PAT_ID = PT.PAT_ID and II.IDENTITY_TYPE_ID = 38
   WHERE II.IDENTITY_ID in ('JH58151800', 'JH68164229')
   )
   ,ENC AS (
   Select * 
   from CLARITY..pat_enc
   where pat_enc_csn_id in (1343334738,1344132236)
   )
   ,pat_ethn
AS (
   SELECT DISTINCT pat_ethn.pat_id
      ,pat_ethn.ethnicity
   FROM (
      SELECT DISTINCT ethnic_background.pat_id
         ,pat.ethnic_group_c
         ,zc_ethnic_bkgrnd.[name] "ethnicity"
         ,ethnic_background.line "ethn_recorded_order"
         ,dense_rank() OVER (
            PARTITION BY ethnic_background.pat_id ORDER BY ethnic_background.line
            ) ethn_rank
      FROM clarity..ethnic_background ethnic_background
      LEFT JOIN COH pat ON ethnic_background.PAT_ID = pat.PAT_ID
      LEFT JOIN clarity..zc_ethnic_group zc_ethnic_bkgrnd ON pat.ethnic_group_c = zc_ethnic_bkgrnd.
         ethnic_group_c
      WHERE lower(zc_ethnic_bkgrnd.[name]) NOT IN ('refused', 'do not use')
      ) pat_ethn
   WHERE pat_ethn.ethn_rank = 1 --picking the first one (in the event that there are many listed).
   )
   ,pat_gender
AS (
   SELECT patient_4.pat_id
      ,zc_gender_identity.name gender_identity
   FROM clarity..patient_4
   LEFT JOIN clarity..zc_gender_identity ON patient_4.gender_identity_c = zc_gender_identity.
      gender_identity_c
   LEFT JOIN clarity..zc_sex ON patient_4.sex_asgn_at_birth_c = zc_sex.rcpt_mem_sex_c
   WHERE patient_4.gender_identity_c IS NOT NULL
   )
   ,pat_sex
AS (
   SELECT patient.pat_id
      ,zc_sex.name sex
   FROM COH patient
   LEFT JOIN clarity..zc_sex zc_sex ON patient.sex_c = zc_sex.rcpt_mem_sex_c
   )
   ,pat_sex_asgn_at_birth
AS (
   SELECT patient_4.pat_id
      ,zc_sex.name sex
   FROM clarity..patient_4 patient_4
   LEFT JOIN clarity..zc_gender_identity zc_gender_identity ON patient_4.gender_identity_c = 
      zc_gender_identity.gender_identity_c
   LEFT JOIN clarity..zc_sex zc_sex ON patient_4.sex_asgn_at_birth_c = zc_sex.rcpt_mem_sex_c
   WHERE patient_4.sex_asgn_at_birth_c IS NOT NULL
   )
   /*
   ,HT
AS (
   SELECT A.*
      ,ROW_NUMBER() OVER (
         PARTITION BY PAT_ID
         ,PAT_ENC_CSN_ID ORDER BY DD
         ) AS RN
   FROM (
      SELECT DISTINCT S.PAT_ID
         ,pe.PAT_ENC_CSN_ID
         ,IP_FLWSHT_MEAS.MEAS_VALUE
         ,flwgp.DISP_NAME
         ,IP_FLWSHT_MEAS.recorded_time
         ,flwgp.flo_MEAS_id
         ,ABS(DATEDIFF(MINUTE, IP_FLWSHT_MEAS.recorded_time, pe.EFFECTIVE_DATE_DTTM)) AS DD
      FROM COH S
      INNER JOIN CLARITY..PAT_ENC pe ON PE.PAT_ID = S.PAT_ID
      INNER JOIN CLARITY.dbo.IP_FLWSHT_REC IP_FLWSHT_REC ON PE.INPATIENT_DATA_ID = IP_FLWSHT_REC.
         INPATIENT_DATA_ID
      INNER JOIN CLARITY.dbo.IP_FLWSHT_MEAS IP_FLWSHT_MEAS ON IP_FLWSHT_REC.FSD_ID = IP_FLWSHT_MEAS.FSD_ID
      INNER JOIN clarity.dbo.IP_FLO_GP_DATA flwgp ON flwgp.FLO_MEAS_ID = IP_FLWSHT_MEAS.FLO_MEAS_ID
      INNER JOIN CLARITY.DBO.IP_FLT_DATA TMP ON TMP.TEMPLATE_ID = IP_FLWSHT_MEAS.FLT_ID
      WHERE IP_FLWSHT_MEAS.FLO_MEAS_ID IS NOT NULL
         AND flwgp.flo_MEAS_id IN ('11')
      ) A
   )
   ,WT
AS (
   SELECT A.*
      ,ROW_NUMBER() OVER (
         PARTITION BY PAT_ID
         ,PAT_ENC_CSN_ID ORDER BY DD
         ) AS RN
   FROM (
      SELECT DISTINCT S.PAT_ID
         ,pe.PAT_ENC_CSN_ID
         ,IP_FLWSHT_MEAS.MEAS_VALUE
         ,flwgp.DISP_NAME
         ,IP_FLWSHT_MEAS.recorded_time
         ,flwgp.flo_MEAS_id
         ,ABS(DATEDIFF(MINUTE, IP_FLWSHT_MEAS.recorded_time, pe.EFFECTIVE_DATE_DTTM)) AS DD
      FROM COH S
      INNER JOIN CLARITY..PAT_ENC pe ON PE.PAT_ID = S.PAT_ID
      INNER JOIN CLARITY.dbo.IP_FLWSHT_REC IP_FLWSHT_REC ON PE.INPATIENT_DATA_ID = IP_FLWSHT_REC.
         INPATIENT_DATA_ID
      INNER JOIN CLARITY.dbo.IP_FLWSHT_MEAS IP_FLWSHT_MEAS ON IP_FLWSHT_REC.FSD_ID = IP_FLWSHT_MEAS.FSD_ID
      INNER JOIN clarity.dbo.IP_FLO_GP_DATA flwgp ON flwgp.FLO_MEAS_ID = IP_FLWSHT_MEAS.FLO_MEAS_ID
      INNER JOIN CLARITY.DBO.IP_FLT_DATA TMP ON TMP.TEMPLATE_ID = IP_FLWSHT_MEAS.FLT_ID
      WHERE IP_FLWSHT_MEAS.FLO_MEAS_ID IS NOT NULL
         AND flwgp.flo_MEAS_id IN ('14')
      ) A
   )
   ,BMI
AS (
   SELECT A.*
      ,ROW_NUMBER() OVER (
         PARTITION BY PAT_ID
         ,PAT_ENC_CSN_ID ORDER BY DD
         ) AS RN
   FROM (
      SELECT DISTINCT S.PAT_ID
         ,pe.PAT_ENC_CSN_ID
         ,IP_FLWSHT_MEAS.MEAS_VALUE
         ,flwgp.DISP_NAME
         ,IP_FLWSHT_MEAS.recorded_time
         ,flwgp.flo_MEAS_id
         ,ABS(DATEDIFF(MINUTE, IP_FLWSHT_MEAS.recorded_time, pe.EFFECTIVE_DATE_DTTM)) AS DD
      FROM COH S
      INNER JOIN CLARITY..PAT_ENC pe ON PE.PAT_ID = S.PAT_ID
      INNER JOIN CLARITY.dbo.IP_FLWSHT_REC IP_FLWSHT_REC ON PE.INPATIENT_DATA_ID = IP_FLWSHT_REC.
         INPATIENT_DATA_ID
      INNER JOIN CLARITY.dbo.IP_FLWSHT_MEAS IP_FLWSHT_MEAS ON IP_FLWSHT_REC.FSD_ID = IP_FLWSHT_MEAS.FSD_ID
      INNER JOIN clarity.dbo.IP_FLO_GP_DATA flwgp ON flwgp.FLO_MEAS_ID = IP_FLWSHT_MEAS.FLO_MEAS_ID
      INNER JOIN CLARITY.DBO.IP_FLT_DATA TMP ON TMP.TEMPLATE_ID = IP_FLWSHT_MEAS.FLT_ID
      WHERE IP_FLWSHT_MEAS.FLO_MEAS_ID IS NOT NULL
         AND flwgp.flo_MEAS_id IN ('301070')
      ) A
   ) */
SELECT DISTINCT p.pat_id
   ,p.pat_mrn_id
   ,p.birth_date
   ,pr.pat_race_list
   ,pet.ethnicity
   ,pg.gender_identity
   ,ps.sex AS sex
   ,psaab.sex AS sex_asgn_at_birth
   ,round(DATEDIFF(day, p.birth_date, pe.hosp_admsn_time), 0) AS age_in_days_admission
   ,floor(round(DATEDIFF(day, p.birth_date, pe.hosp_admsn_time), 0) / 365) AS age_in_yr_admission
   ,round(DATEDIFF(day, p.birth_date, op2.specimn_taken_time), 0) AS age_in_days_collectiontime
   ,floor(round(DATEDIFF(day, p.birth_date, op2.specimn_taken_time), 0) / 365) AS age_in_yr_collectiontime
   ,round(DATEDIFF(day, p.birth_date, res.result_date), 0) AS age_in_days_resultdate
   ,floor(round(DATEDIFF(day, p.birth_date, res.result_date), 0) / 365) AS age_in_yr_resultdate
   ,pe.pat_enc_csn_id
   --,CAST(WT.MEAS_VALUE AS NUMERIC) "Weight_In_Ounces"
   --,CAST(HT.MEAS_VALUE AS NUMERIC) "Height_In_Inches"
   --,BMI.MEAS_VALUE "BMI"
   ,pe.contact_date
   ,pe.hosp_admsn_time
   ,pe.hosp_dischrg_time
   ,round(DATEDIFF(day, pe.hosp_admsn_time, pe.hosp_dischrg_time), 0) AS LOS_in_days
   ,ISNULL(op2.specimn_taken_time, op2.specimn_taken_date) AS specimn_taken_time -- collection time
   --,trunc(ISNULL(op2.specimn_taken_time, op2.specimn_taken_date)) AS specimn_taken_date
   ,cc.name
   ,cc.external_name
   ,cc.common_name
   ,op.abnormal_yn
   ,res.result_date
   ,pe.department_id
   ,dep.department_name
   ,dep.dept_abbreviation
INTO #crut_2441_case01
FROM COH p
INNER JOIN clarity.dbo.clarity_adt adt ON adt.pat_id = p.pat_id
INNER JOIN ENC pe ON pe.pat_enc_csn_id = adt.pat_enc_csn_id
LEFT JOIN clarity.dbo.pat_enc_hsp peh ON peh.pat_enc_csn_id = adt.pat_enc_csn_id
INNER JOIN clarity.dbo.order_proc op ON op.pat_enc_csn_id = pe.pat_enc_csn_id
INNER JOIN clarity.dbo.order_proc_2 op2 ON op.order_proc_id = op2.order_proc_id
--AND op2.pat_enc_csn_id=pe.pat_enc_csn_id
INNER JOIN clarity.dbo.order_results res ON op.order_proc_id = res.order_proc_id
--AND res.pat_enc_csn_id=op.pat_enc_csn_id
INNER JOIN clarity.dbo.clarity_eap eap ON op.proc_id = eap.proc_id
INNER JOIN clarity.dbo.clarity_component cc ON res.component_id = cc.component_id
/*
INNER JOIN HT ON pe.PAT_ENC_CSN_ID = HT.PAT_ENC_CSN_ID
   AND HT.RN = 1
INNER JOIN WT ON pe.PAT_ENC_CSN_ID = WT.PAT_ENC_CSN_ID
   AND WT.RN = 1
INNER JOIN BMI ON pe.PAT_ENC_CSN_ID = BMI.PAT_ENC_CSN_ID
   AND BMI.RN = 1
   */
LEFT JOIN clarity.dbo.clarity_dep dep ON dep.department_id = pe.department_id -- department name
LEFT JOIN pat_race pr ON p.pat_id = pr.pat_id -- race info
LEFT JOIN pat_ethn pet ON p.pat_id = pe.pat_id -- ethnicity info
LEFT JOIN pat_gender pg ON p.pat_id = pg.pat_id -- gender info 
LEFT JOIN pat_sex ps ON p.pat_id = ps.pat_id -- sex info
LEFT JOIN pat_sex_asgn_at_birth psaab ON p.pat_id = psaab.pat_id -- sex at birth info
--discharge  
LEFT JOIN clarity.dbo.zc_disch_disp zdd ON peh.disch_disp_c = zdd.disch_disp_c -- pull discharge name
LEFT JOIN clarity.dbo.zc_ed_disposition zed ON peh.ed_disposition_c = zed.ed_disposition_c 
   -- ed disposition
/*
WHERE (
		(
         lower(cc.name) LIKE '%rhinovirus%'
         OR lower(cc.name) LIKE '%norovirus%'
         OR lower(cc.name) LIKE '%adenovirus%'
         OR lower(cc.name) LIKE '%rotavirus%'
         OR lower(cc.name) LIKE '%astrovirus%'
         OR lower(cc.name) LIKE '%sapovirus%'
         OR lower(cc.name) LIKE '%coronavirus%'
         OR lower(cc.name) LIKE '%influenza%'
         OR lower(cc.name) LIKE '%flu%'
         OR lower(cc.name) LIKE '%rsv%'
         OR lower(cc.name) LIKE '%resp%sync%'
         OR lower(cc.name) LIKE '%hmpv%'
         OR lower(cc.name) LIKE '%human metapneum%'
         )
      OR (
         lower(eap.proc_name) LIKE '%rhinovirus%'
         OR lower(eap.proc_name) LIKE '%norovirus%'
         OR lower(eap.proc_name) LIKE '%adenovirus%'
         OR lower(eap.proc_name) LIKE '%rotavirus%'
         OR lower(eap.proc_name) LIKE '%astrovirus%'
         OR lower(eap.proc_name) LIKE '%sapovirus%'
         OR lower(eap.proc_name) LIKE '%coronavirus%'
         OR lower(eap.proc_name) LIKE '%influenza%'
         OR lower(eap.proc_name) LIKE '%flu%'
         OR lower(eap.proc_name) LIKE '%rsv%'
         OR lower(eap.proc_name) LIKE '%resp%sync%'
         OR lower(eap.proc_name) LIKE '%hmpv%'
         OR lower(eap.proc_name) LIKE '%human metapneum%'
         )
      )
   AND (
      lower(res.ord_value) LIKE '%pos%'
      OR (lower(res.ord_value) LIKE '%detected%' AND lower(res.ord_value) NOT LIKE '%no%')
      ) 
   AND lower(abnormal_yn) = 'y' 
*/
--INCLUDE MRN(s)
ORDER BY p.pat_id
   ,pe.hosp_admsn_time;

WITH case01
AS (
   SELECT DISTINCT pat_id
      ,pat_mrn_id
      ,birth_date
      ,pat_enc_csn_id
      ,age_in_days_admission
      ,age_in_yr_admission
      ,age_in_days_collectiontime
      ,age_in_yr_collectiontime
      ,age_in_days_resultdate
      ,age_in_yr_resultdate
      ,los_in_days
      ,specimn_taken_time
      --,specimn_taken_date
      ,result_date
   FROM #crut_2441_case01
   )
--include MRN(s) and result_date(s)
SELECT DISTINCT c01.pat_id
   ,c01.pat_mrn_id
   ,c01.result_date
   ,c01.los_in_days
   ,c01.age_in_days_resultdate
   ,c01.age_in_yr_resultdate
   ,'control_group--->' control_group
   --, peh.pat_id as p_id
   ,II.IDENTITY_ID AS control_mrn_id
   ,p.birth_date
   ,peh.hosp_admsn_time
   ,peh.hosp_disch_time
   ,round(DATEDIFF(day, peh.hosp_admsn_time, peh.hosp_disch_time), 0) AS los
   ,CONCAT (
      round((
            (round(DATEDIFF(day, peh.hosp_admsn_time, peh.hosp_disch_time), 0) / CAST(c01.los_in_days As float)
               ) * 100
            ), 2)
      ,' %'
      ) AS los_percentage
   ,round(DATEDIFF(day, p.birth_date, peh.hosp_admsn_time), 0) AS age_in_days
   ,CONCAT (
      round((
            (round(DATEDIFF(day, p.birth_date, peh.hosp_admsn_time), 0) / CAST(c01.age_in_days_resultdate AS float)
               ) * 100
            ), 2)
      ,' %'
      ) AS age_percentage
   --, floor(round(peh.hosp_admsn_time-p.birth_date)/365) as age_in_year
   ,'percentage_change--->' percentage_change
   ,100 - (
      round((
            (round(DATEDIFF(day, peh.hosp_admsn_time, peh.hosp_disch_time), 0) / CAST(c01.los_in_days AS float)
               ) * 100
            ), 2)
      ) AS los_percentage_change
   ,abs(100 - (
         round((
               (round(DATEDIFF(day, peh.hosp_admsn_time, peh.hosp_disch_time), 0) / CAST(c01.los_in_days AS float)
                  ) * 100
               ), 2)
         )) AS abs_los_percentage_change
   ,100 - (
      round((
            (round(DATEDIFF(day, p.birth_date, peh.hosp_admsn_time), 0) / CAST(c01.age_in_days_resultdate AS float)
               ) * 100
            ), 2)
      ) AS age_percentage_change
   ,abs(100 - (
         round((
               (round(DATEDIFF(day, p.birth_date, peh.hosp_admsn_time), 0) / CAST(c01.age_in_days_resultdate AS float)
                  ) * 100
               ), 2)
         )) AS abs_age_percentage_change
   ,(
      abs(100 - (
            round((
                  (round(DATEDIFF(day, peh.hosp_admsn_time, peh.hosp_disch_time), 0) / CAST(c01.los_in_days AS float)
                     ) * 100
                  ), 2)
            ))
      ) + (
      abs(100 - (
            round((
                  (
                     round(DATEDIFF(day, p.birth_date, peh.hosp_admsn_time), 0) / CAST(c01.age_in_days_resultdate AS float)
                     ) * 100
                  ), 2)
            ))
      ) AS combined_percentage_change
   ,'delta --->' delta
   ,(
      (round(DATEDIFF(day, peh.hosp_admsn_time, peh.hosp_disch_time), 0)) - (c01.los_in_days
         )
      ) / CAST(c01.los_in_days AS float) AS delta_los
   ,abs((
         (round(DATEDIFF(day, peh.hosp_admsn_time, peh.hosp_disch_time), 0)) - (c01.los_in_days
            )
         ) / CAST(c01.los_in_days AS float)) AS abs_delta_los
   ,(
      (round(DATEDIFF(day, p.birth_date, peh.hosp_admsn_time), 0)) - (c01.age_in_days_resultdate
         )
      ) / CAST(c01.age_in_days_resultdate AS float) AS delta_age
   ,abs((
         (round(DATEDIFF(day, p.birth_date, peh.hosp_admsn_time), 0)) - (c01.age_in_days_resultdate
            )
         ) / CAST(c01.age_in_days_resultdate AS float)) AS abs_delta_age
   ,round((
         (
            abs((
                  (
                     (round(DATEDIFF(day, p.birth_date, peh.hosp_admsn_time), 0)
                        ) - (c01.age_in_days_resultdate)
                     ) / CAST(c01.age_in_days_resultdate AS float)
                  ) * (- 1))
            ) + (
            abs((
                  (
                     (round(DATEDIFF(day, peh.hosp_admsn_time, peh.hosp_disch_time), 0)
                        ) - (c01.los_in_days)
                     ) / CAST(c01.los_in_days AS float)
                  ) * (- 1))
            )
         ), 3) AS delta_sum --Take top 3
INTO #crut_2444_base_v2
FROM CLARITY..pat_enc_hsp peh
INNER JOIN case01 c01 ON c01.result_date BETWEEN DATEADD(month, - 2, peh.hosp_admsn_time)
      AND DATEADD(month, 2, peh.hosp_admsn_time)--ask about this join
INNER JOIN CLARITY..patient p ON p.pat_id = peh.pat_id
INNER JOIN CLARITY..IDENTITY_ID II ON II.PAT_ID = p.PAT_ID and II.IDENTITY_TYPE_ID = 38
INNER JOIN CLARITY..Clarity_dep dep on peh.DEPARTMENT_ID = dep.DEPARTMENT_ID
WHERE (c01.los_in_days * 2) > = round(DATEDIFF(day, peh.hosp_admsn_time, peh.hosp_disch_time), 0)
   AND (c01.age_in_days_resultdate * 2) >= round(DATEDIFF(day, p.birth_date, peh.hosp_admsn_time), 0)
   AND c01.los_in_days > 0
   AND dep.DEPARTMENT_ID like '1101%';

   /*
   FROM CLARITY..pat_enc_hsp peh
INNER JOIN case01 c01 ON peh.pat_id = c01.pat_id
INNER JOIN CLARITY..patient p ON p.pat_id = peh.pat_id
WHERE (c01.los_in_days * 2) > = round(DATEDIFF(day, peh.hosp_admsn_time, peh.hosp_disch_time), 0)
AND (c01.result_date BETWEEN DATEADD(month, - 2, peh.hosp_admsn_time)
      AND DATEADD(month, 2, peh.hosp_admsn_time))
   AND (c01.age_in_days_resultdate * 2) >= round(DATEDIFF(day, p.birth_date, peh.hosp_admsn_time), 0)
   AND c01.los_in_days > 0;
   */

SELECT DISTINCT pat_id
   ,pat_mrn_id
   ,result_date
   ,los_in_days
   ,age_in_days_resultdate
   ,age_in_yr_resultdate
   ,control_group
   ,control_mrn_id
   ,birth_date
   ,hosp_admsn_time
   ,hosp_disch_time
   ,los
   ,los_percentage
   ,age_in_days
   ,age_percentage
   --, age_in_year
   ,percentage_change
   ,los_percentage_change
   ,abs_los_percentage_change
   ,age_percentage_change
   ,abs_age_percentage_change
   ,combined_percentage_change
   ,delta
   ,delta_los
   ,abs_delta_los
   ,delta_age
   ,abs_delta_age
   ,delta_sum
   ,ROW_NUMBER() OVER (
	  PARTITION BY pat_mrn_id
      ORDER BY combined_percentage_change
      ) AS RN
INTO #temp
FROM (
SELECT DISTINCT pat_id
   ,pat_mrn_id
   ,result_date
   ,los_in_days
   ,age_in_days_resultdate
   ,age_in_yr_resultdate
   ,control_group
   ,control_mrn_id
   ,birth_date
   ,hosp_admsn_time
   ,hosp_disch_time
   ,los
   ,los_percentage
   ,age_in_days
   ,age_percentage
   --, age_in_year
   ,percentage_change
   ,los_percentage_change
   ,abs_los_percentage_change
   ,age_percentage_change
   ,abs_age_percentage_change
   ,combined_percentage_change
   ,delta
   ,delta_los
   ,abs_delta_los
   ,delta_age
   ,abs_delta_age
   ,delta_sum
   ,ROW_NUMBER() OVER (
	  PARTITION BY control_mrn_id
      ORDER BY combined_percentage_change
      ) AS pat_num
FROM #crut_2444_base_v2
WHERE pat_mrn_id <> control_mrn_id
) t
WHERE pat_num = 1
ORDER BY combined_percentage_change;

SELECT DISTINCT pat_id
   ,pat_mrn_id
   ,result_date
   ,los_in_days
   ,age_in_days_resultdate
   ,age_in_yr_resultdate
   ,control_group
   ,control_mrn_id
   ,birth_date
   ,hosp_admsn_time
   ,hosp_disch_time
   ,los
   ,los_percentage
   ,age_in_days
   ,age_percentage
   --, age_in_year
   ,percentage_change
   ,los_percentage_change
   ,abs_los_percentage_change
   ,age_percentage_change
   ,abs_age_percentage_change
   ,RN
   ,combined_percentage_change
   ,delta
   ,delta_los
   ,abs_delta_los
   ,delta_age
   ,abs_delta_age
   ,delta_sum
INTO #top4
FROM #temp
WHERE RN < 5;

SELECT DISTINCT pat_mrn_id
   ,result_date
   ,los_in_days
   ,age_in_days_resultdate
   ,age_in_yr_resultdate
   ,control_group
   ,control_mrn_id
   -- , birth_date
   ,hosp_admsn_time
   ,hosp_disch_time
   ,los
   ,los_percentage
   ,age_in_days
   ,age_percentage
   -- , age_in_year
   ,percentage_change
   ,los_percentage_change
   ,abs_los_percentage_change
   ,age_percentage_change
   ,abs_age_percentage_change
   ,combined_percentage_change
   --, rank
   ,CASE 
      WHEN RN < 5
         THEN 'YES'
      ELSE 'NO'
      END three_lowest_combined_percentage_change
   ,delta
   ,delta_los
   ,abs_delta_los
   ,delta_age
   ,abs_delta_age
   ,delta_sum
INTO Analytics.dbo.[CCDA3796_Milstone_Control_Cohort]
FROM #top4
ORDER BY pat_mrn_id
   ,control_mrn_id
   ,hosp_admsn_time;

ALTER TABLE [Analytics].[dbo].[CCDA3796_Milstone_Control_Cohort] REBUILD PARTITION = ALL  WITH (DATA_COMPRESSION = Page);

SELECT *
FROM [Analytics].[dbo].[CCDA3796_Milstone_Control_Cohort];