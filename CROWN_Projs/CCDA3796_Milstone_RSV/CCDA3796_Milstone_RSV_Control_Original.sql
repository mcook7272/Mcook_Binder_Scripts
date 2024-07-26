DROP TABLE crut_2441_case01;

CREATE TABLE crut_2441_case01 AS
   WITH pat_race AS (
         SELECT pat_race.pat_id
            ,listagg(pat_race.race, '; ') within
         GROUP (
               ORDER BY pat_race.race_rank
               ) pat_race_list
         FROM (
            SELECT DISTINCT patient_race.pat_id
               ,patient_race.patient_race_c
               ,zc_patient_race.name race
               ,patient_race.line race_recorded_order
               ,dense_rank() OVER (
                  PARTITION BY patient_race.pat_id ORDER BY patient_race.line
                  ) race_rank
            FROM clarity.patient_race patient_race
            INNER JOIN clarity.zc_patient_race zc_patient_race ON patient_race.patient_race_c = 
               zc_patient_race.patient_race_c
            WHERE lower(zc_patient_race.name) NOT IN ('refused', 'do not use')
            ) pat_race
         GROUP BY pat_race.pat_id
         )
      ,pat_ethn AS (
         SELECT DISTINCT pat_ethn.pat_id
            ,pat_ethn.ethnicity
         FROM (
            SELECT DISTINCT ethnic_background.pat_id
               ,ethnic_background.ethnic_bkgrnd_c
               ,zc_ethnic_bkgrnd.name ethnicity
               ,ethnic_background.line ethn_recorded_order
               ,dense_rank() OVER (
                  PARTITION BY ethnic_background.pat_id ORDER BY ethnic_background.line
                  ) ethn_rank
            FROM clarity.ethnic_background ethnic_background
            INNER JOIN clarity.zc_ethnic_bkgrnd zc_ethnic_bkgrnd ON ethnic_background.ethnic_bkgrnd_c = 
               zc_ethnic_bkgrnd.ethnic_bkgrnd_c
            WHERE lower(zc_ethnic_bkgrnd.name) NOT IN ('refused', 'do not use')
            ) pat_ethn
         WHERE pat_ethn.ethn_rank = 1 --picking the first one (in the event that there are many listed).
         )
      ,pat_gender AS (
         SELECT patient_4.pat_id
            ,zc_gender_identity.name gender_identity
         FROM clarity.patient_4
         LEFT JOIN clarity.zc_gender_identity ON patient_4.gender_identity_c = zc_gender_identity.
            gender_identity_c
         LEFT JOIN clarity.zc_sex ON patient_4.sex_asgn_at_birth_c = zc_sex.rcpt_mem_sex_c
         WHERE patient_4.gender_identity_c IS NOT NULL
         )
      ,pat_sex AS (
         SELECT patient.pat_id
            ,zc_sex.name sex
         FROM clarity.patient patient
         LEFT JOIN clarity.zc_sex zc_sex ON patient.sex_c = zc_sex.rcpt_mem_sex_c
         )
      ,pat_sex_asgn_at_birth AS (
         SELECT patient_4.pat_id
            ,zc_sex.name sex
         FROM clarity.patient_4 patient_4
         LEFT JOIN clarity.zc_gender_identity zc_gender_identity ON patient_4.gender_identity_c = 
            zc_gender_identity.gender_identity_c
         LEFT JOIN clarity.zc_sex zc_sex ON patient_4.sex_asgn_at_birth_c = zc_sex.rcpt_mem_sex_c
         WHERE patient_4.sex_asgn_at_birth_c IS NOT NULL
         )

SELECT DISTINCT p.pat_id
   ,p.pat_mrn_id
   ,p.birth_date
   ,pr.pat_race_list
   ,pe.ethnicity
   ,pg.gender_identity
   ,ps.sex AS sex
   ,psaab.sex AS sex_asgn_at_birth
   ,round(pe.hosp_admsn_time - p.birth_date) AS age_in_days_admission
   ,floor(round(pe.hosp_admsn_time - p.birth_date) / 365) AS age_in_yr_admission
   ,round(op2.specimn_taken_time - p.birth_date) AS age_in_days_collectiontime
   ,floor(round(op2.specimn_taken_time - p.birth_date) / 365) AS age_in_yr_collectiontime
   ,round(res.result_date - p.birth_date) AS age_in_days_resultdate
   ,floor(round(res.result_date - p.birth_date) / 365) AS age_in_yr_resultdate
   ,pe.pat_enc_csn_id
   ,pat_enc_bmi.wt_kg
   ,pat_enc_bmi.ht_cm
   ,pe.contact_date
   ,pe.hosp_admsn_time
   ,pe.hosp_dischrg_time
   ,round(pe.hosp_dischrg_time - pe.hosp_admsn_time) AS LOS_in_days
   ,nvl(op2.specimn_taken_time, op2.specimn_taken_date) specimn_taken_time -- collection time
   ,trunc(nvl(op2.specimn_taken_time, op2.specimn_taken_date)) specimn_taken_date
   ,cc.name
   ,cc.external_name
   ,cc.common_name
   ,op.abnormal_yn
   ,res.result_date
   ,pe.department_id
   ,dep.department_name
   ,dep.dept_abbreviation
FROM patient p
INNER JOIN clarity_adt adt ON adt.pat_id = p.pat_id
INNER JOIN pat_enc pe ON pe.pat_enc_csn_id = adt.pat_enc_csn_id
LEFT JOIN pat_enc_hsp peh ON peh.pat_enc_csn_id = adt.pat_enc_csn_id
INNER JOIN order_proc op ON op.pat_enc_csn_id = pe.pat_enc_csn_id
INNER JOIN order_proc_2 op2 ON op.order_proc_id = op2.order_proc_id 
   --AND op2.pat_enc_csn_id=pe.pat_enc_csn_id
INNER JOIN order_results res ON op.order_proc_id = res.order_proc_id 
   --AND res.pat_enc_csn_id=op.pat_enc_csn_id
INNER JOIN clarity_eap eap ON op.proc_id = eap.proc_id
INNER JOIN clarity_component cc ON res.component_id = cc.component_id
LEFT JOIN clarity_dep dep ON dep.department_id = pe.department_id -- department name
LEFT JOIN pat_race pr ON p.pat_id = pr.pat_id -- race info
LEFT JOIN pat_ethn pe ON p.pat_id = pe.pat_id -- ethnicity info
LEFT JOIN pat_gender pg ON p.pat_id = pg.pat_id -- gender info 
LEFT JOIN pat_sex ps ON p.pat_id = ps.pat_id -- sex info
LEFT JOIN pat_sex_asgn_at_birth psaab ON p.pat_id = psaab.pat_id -- sex at birth info
LEFT JOIN research.pat_enc_bmi pat_enc_bmi ON pat_enc_bmi.PAT_ENC_CSN_ID = pe.PAT_ENC_CSN_ID
--discharge  
LEFT JOIN zc_disch_disp zdd ON peh.disch_disp_c = zdd.disch_disp_c -- pull discharge name
LEFT JOIN zc_ed_disposition zed ON peh.ed_disposition_c = zed.ed_disposition_c -- ed disposition
WHERE (
      regexp_like(cc.name, 
         '(rhino|noro|adeno|rota|astro|sapo|corona)virus|influenza|flu\s|rsv|resp.*sync|hmpv|human metapneum.*'
         , 'i')
      OR regexp_like(eap.proc_name, 
         '(rhino|noro|adeno|rota|astro|sapo|corona)virus|influenza|flu\s|rsv|resp.*sync|hmpv|human metapneum.*'
         , 'i')
      )
   AND regexp_like(res.ord_value, '(pos)|[^(not)]\sdetected', 'i')
   AND lower(abnormal_yn) = 'y'
--INCLUDE MRN(s)
ORDER BY p.pat_id
   ,pe.hosp_admsn_time;

DROP TABLE crut_2444_base_v2;

CREATE TABLE crut_2444_base_v2 AS
   WITH case01 AS (
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
            ,specimn_taken_date
            ,result_date
         FROM crut_2441_case01
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
   ,p.pat_mrn_id AS control_mrn_id
   ,p.birth_date
   ,peh.hosp_admsn_time
   ,peh.hosp_disch_time
   ,round(peh.hosp_disch_time - peh.hosp_admsn_time) AS los
   ,round(((round(peh.hosp_disch_time - peh.hosp_admsn_time) / c01.los_in_days) * 100
         ), 2) || ' %' AS los_percentage
   ,round(peh.hosp_admsn_time - p.birth_date) AS age_in_days
   ,round(((round(peh.hosp_admsn_time - p.birth_date) / c01.age_in_days_resultdate) * 100
         ), 2) || ' %' AS age_percentage
   --, floor(round(peh.hosp_admsn_time-p.birth_date)/365) as age_in_year
   ,'percentage_change--->' percentage_change
   ,100 - (
      round(((round(peh.hosp_disch_time - peh.hosp_admsn_time) / c01.los_in_days) * 100
            ), 2)
      ) AS los_percentage_change
   ,abs(100 - (
         round((
               (round(peh.hosp_disch_time - peh.hosp_admsn_time) / c01.los_in_days) * 
               100
               ), 2)
         )) AS abs_los_percentage_change
   ,100 - (
      round(((round(peh.hosp_admsn_time - p.birth_date) / c01.age_in_days_resultdate) * 100
            ), 2)
      ) AS age_percentage_change
   ,abs(100 - (
         round((
               (round(peh.hosp_admsn_time - p.birth_date) / c01.age_in_days_resultdate
                  ) * 100
               ), 2)
         )) AS abs_age_percentage_change
   ,(
      abs(100 - (
            round((
                  (round(peh.hosp_disch_time - peh.hosp_admsn_time) / c01.los_in_days
                     ) * 100
                  ), 2)
            ))
      ) + (
      abs(100 - (
            round((
                  (round(peh.hosp_admsn_time - p.birth_date) / c01.age_in_days_resultdate
                     ) * 100
                  ), 2)
            ))
      ) AS combined_percentage_change
   ,'delta --->' delta
   ,((round(peh.hosp_disch_time - peh.hosp_admsn_time)) - (c01.los_in_days)) / c01
   .los_in_days AS delta_los
   ,abs(((round(peh.hosp_disch_time - peh.hosp_admsn_time)) - (c01.los_in_days)
         ) / c01.los_in_days) AS abs_delta_los
   ,((round(peh.hosp_admsn_time - p.birth_date)) - (c01.age_in_days_resultdate)) 
   / c01.age_in_days_resultdate AS delta_age
   ,abs((
         (round(peh.hosp_admsn_time - p.birth_date)) - (c01.age_in_days_resultdate
            )
         ) / c01.age_in_days_resultdate) AS abs_delta_age
   ,round((
         (
            abs((
                  (
                     (round(peh.hosp_admsn_time - p.birth_date)) - (c01.age_in_days_resultdate
                        )
                     ) / c01.age_in_days_resultdate
                  ) * (- 1))
            ) + (
            abs((
                  (
                     (round(peh.hosp_disch_time - peh.hosp_admsn_time)) - (c01.los_in_days
                        )
                     ) / c01.los_in_days
                  ) * (- 1))
            )
         ), 3) AS delta_sum
FROM pat_enc_hsp peh
INNER JOIN case01 c01 ON c01.result_date BETWEEN add_months(peh.hosp_admsn_time, - 2)
      AND add_months(peh.hosp_admsn_time, 2)
INNER JOIN patient p ON p.pat_id = peh.pat_id
WHERE (c01.los_in_days * 2) > = round(peh.hosp_disch_time - peh.hosp_admsn_time)
   AND (c01.age_in_days_resultdate * 2) >= round(peh.hosp_admsn_time - p.birth_date);

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
      WHEN rank < 4
         THEN 'YES'
      ELSE 'NO'
      END three_lowest_combined_percentage_change
   ,delta
   ,delta_los
   ,abs_delta_los
   ,delta_age
   ,abs_delta_age
   ,delta_sum
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
      ,rank
      ,combined_percentage_change
      ,delta
      ,delta_los
      ,abs_delta_los
      ,delta_age
      ,abs_delta_age
      ,delta_sum
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
         ,row_number() OVER (
            ORDER BY combined_percentage_change
            ) rank
      FROM crut_2444_base_v2
      ORDER BY combined_percentage_change
      ) top3
   )
ORDER BY pat_mrn_id
   ,control_mrn_id
   ,hosp_admsn_time