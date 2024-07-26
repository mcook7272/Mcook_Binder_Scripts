ALTER proc dbo.[CCDA4028_Mathioudakis_Diabetes_sp] AS
/**********************************************************************************
Author:  Michael Cook
Date: 07/29/2022
JIRA: CCDA-4028
Description: Creating patient list from ortiginal Mychart query, ignoring MyChart requirements

Inclusion criteria:	Only patients with the following criteria will be included in the extract results:
						1.	Male or female age 18-75 years (current age, inclusive) 
						2.	Body mass index (BMI) ≥ 25 kg/m2 or ≥ 23 kg/m2 for Asians(in any race field) from an encounter at JHH
						3.	Hemoglobin A1C 5.7% to 6.4% (inclusive) in the past 12 months
							OR 
							Fasting glucose 100-125 mg/dl in the past 12 months (I think the lab-base-name is GLUFAST)  
							OR  
							Serum glucose 100-125 mg/dl AND [speciman-collection-time] between 7-8AM in the past 12 months (Only out-patients) 
							OR 
							GLU2HR 140-199 mg/dl in the past 12 months.   
							OR  
							ICD-10  code for  prediabetes [R73.03] or impaired fasting glucose [R73.01], or impaired glucose tolerance [R73.02)
						4.	Patients who live within a 30-mile radius of Johns Hopkins Hospital(see ziplist excel file in jira where the zipcodes are in list format)
Exclusion criteria:	Patients with the following criteria will be excluded from the extract results:
						1.	Aortic stenosis (I35.0) active on problem list or encounter diagnosis within last 3 years 
						2.	Admission in JHHS within last 6 months with CHF (I50.X) 
						3.	Systolic blood pressure >180 mmHg in last encounter within last 3 months 
						4.	Use of any glucose-lowering medications (medication history entered or ordered meds) within past 1 year [therapeutic_class = Antihyperglycemics]
						5.	Use of any weight loss medications (medication history entered or ordered meds) within past 1 year (see Appendix 2)
						6.	Use of any systemic glucocorticoids (medication history entered or ordered meds) within the previous 3 months [pharmaceutical_class= glucocorticoids ]
						7.	Active cancer diagnosis (malignant neoplasm active on problem list or encounter diagnosis within past 3 years) (see Appendix 3)
						8.	Diagnosis of diabetes mellitus (problem list and encounter diagnosis) within past 3 years. [ICD1-0 code; E08 or E09 or E10 or E11] 
						9.	Anemia (Hematocrit <36% in men or <33% in women) or ICD-10 code for hemoglobinopathy (D58.2)
						10.	Use of antipsychotic medications [therapeutic_class = PSYCHOTHERAPEUTIC DRUGS ](medication history or ordered medications) within past 1 year 
						11.	Major psychiatric disorder (schizophrenia [F20.x], major depression [F33.x]) – problem list and encounter diagnosis within past 1 year 
						12.	Alcoholism (F10.X)
						13.	Patients known to be deceased in Epic.
						14.	Patients who have opted out of being contacted for MyChart recruitment.  
						15.	Patients who have opted out of being contacted for any reason. 
     
Revision History:
Date            Author          JIRA            Comment
07/29/2022     Michael Cook     CCDA-4028    Created proc
***********************************************************************************/

SET NOCOUNT ON;

drop table if exists Analytics.dbo.CCDA4028_Mathioudakis_Diabetes_Ptlist;

DECLARE @_Today as date = getdate()

IF OBJECT_ID(N'TEMPDB..#DX_list') IS NOT NULL DROP TABLE #DX_list
SELECT DISTINCT
DX_ID
INTO #DX_list
FROM CLARITY..EDG_CURRENT_ICD10
WHERE CODE LIKE 'R73.0[1-3]';

--	1./4.Male or female age 18-75 years (current age, inclusive) who live within a 30-mile radius of Johns Hopkins Hospital(see ziplist excel file in jira where the zipcodes are in list format)
DROP TABLE IF EXISTS #ccda4208_cohort

   SELECT pat.PAT_ID
   INTO #ccda4208_cohort
   FROM CLARITY..PATIENT pat
   INNER JOIN CLARITY..IDENTITY_ID II ON II.PAT_ID = pat.PAT_ID and II.IDENTITY_TYPE_ID = 0
   INNER JOIN CLARITY..PATIENT_4 pat4 ON pat.pat_id = pat4.pat_id
   LEFT JOIN CLARITY..PATIENT_FYI_FLAGS fyif ON fyif.PATIENT_ID = pat.PAT_ID
      AND fyif.PAT_FLAG_TYPE_C = '1092'
   WHERE isnull(pat4.PAT_LIVING_STAT_C, 0) = '1' -- Exclude patients listed as deceased in Epic
      AND fyif.PATIENT_ID IS NULL -- Exclude patients who have opted out of being contacted for research recruitment
      AND FLOOR(DATEDIFF(dd, pat.BIRTH_DATE, @_Today) / 365.24256) BETWEEN 18
         AND 75 --age 18-75 years 
            /*live within a 30-mile radius of Johns Hopkins Hospital (see ziplist excel file in jira where the zipcodes are in list format)*/
      AND (
         pat.zip LIKE '20701%'
         OR pat.zip LIKE '20705%'
         OR pat.zip LIKE '20707%'
         OR pat.zip LIKE '20708%'
         OR pat.zip LIKE '20715%'
         OR pat.zip LIKE '20720%'
         OR pat.zip LIKE '20723%'
         OR pat.zip LIKE '20724%'
         OR pat.zip LIKE '20755%'
         OR pat.zip LIKE '20759%'
         OR pat.zip LIKE '20763%'
         OR pat.zip LIKE '20769%'
         OR pat.zip LIKE '20777%'
         OR pat.zip LIKE '20794%'
         OR pat.zip LIKE '20861%'
         OR pat.zip LIKE '20862%'
         OR pat.zip LIKE '20866%'
         OR pat.zip LIKE '20868%'
         OR pat.zip LIKE '20905%'
         OR pat.zip LIKE '21009%'
         OR pat.zip LIKE '21010%'
         OR pat.zip LIKE '21012%'
         OR pat.zip LIKE '21013%'
         OR pat.zip LIKE '21014%'
         OR pat.zip LIKE '21015%'
         OR pat.zip LIKE '21017%'
         OR pat.zip LIKE '21029%'
         OR pat.zip LIKE '21030%'
         OR pat.zip LIKE '21031%'
         OR pat.zip LIKE '21032%'
         OR pat.zip LIKE '21035%'
         OR pat.zip LIKE '21036%'
         OR pat.zip LIKE '21040%'
         OR pat.zip LIKE '21042%'
         OR pat.zip LIKE '21043%'
         OR pat.zip LIKE '21044%'
         OR pat.zip LIKE '21045%'
         OR pat.zip LIKE '21046%'
         OR pat.zip LIKE '21047%'
         OR pat.zip LIKE '21048%'
         OR pat.zip LIKE '21050%'
         OR pat.zip LIKE '21051%'
         OR pat.zip LIKE '21052%'
         OR pat.zip LIKE '21054%'
         OR pat.zip LIKE '21056%'
         OR pat.zip LIKE '21057%'
         OR pat.zip LIKE '21060%'
         OR pat.zip LIKE '21061%'
         OR pat.zip LIKE '21071%'
         OR pat.zip LIKE '21075%'
         OR pat.zip LIKE '21076%'
         OR pat.zip LIKE '21077%'
         OR pat.zip LIKE '21082%'
         OR pat.zip LIKE '21084%'
         OR pat.zip LIKE '21085%'
         OR pat.zip LIKE '21087%'
         OR pat.zip LIKE '21090%'
         OR pat.zip LIKE '21093%'
         OR pat.zip LIKE '21104%'
         OR pat.zip LIKE '21108%'
         OR pat.zip LIKE '21111%'
         OR pat.zip LIKE '21113%'
         OR pat.zip LIKE '21114%'
         OR pat.zip LIKE '21117%'
         OR pat.zip LIKE '21120%'
         OR pat.zip LIKE '21122%'
         OR pat.zip LIKE '21128%'
         OR pat.zip LIKE '21130%'
         OR pat.zip LIKE '21131%'
         OR pat.zip LIKE '21133%'
         OR pat.zip LIKE '21136%'
         OR pat.zip LIKE '21140%'
         OR pat.zip LIKE '21144%'
         OR pat.zip LIKE '21146%'
         OR pat.zip LIKE '21152%'
         OR pat.zip LIKE '21153%'
         OR pat.zip LIKE '21155%'
         OR pat.zip LIKE '21156%'
         OR pat.zip LIKE '21162%'
         OR pat.zip LIKE '21163%'
         OR pat.zip LIKE '21201%'
         OR pat.zip LIKE '21202%'
         OR pat.zip LIKE '21204%'
         OR pat.zip LIKE '21205%'
         OR pat.zip LIKE '21206%'
         OR pat.zip LIKE '21207%'
         OR pat.zip LIKE '21208%'
         OR pat.zip LIKE '21209%'
         OR pat.zip LIKE '21210%'
         OR pat.zip LIKE '21211%'
         OR pat.zip LIKE '21212%'
         OR pat.zip LIKE '21213%'
         OR pat.zip LIKE '21214%'
         OR pat.zip LIKE '21215%'
         OR pat.zip LIKE '21216%'
         OR pat.zip LIKE '21217%'
         OR pat.zip LIKE '21218%'
         OR pat.zip LIKE '21219%'
         OR pat.zip LIKE '21220%'
         OR pat.zip LIKE '21221%'
         OR pat.zip LIKE '21222%'
         OR pat.zip LIKE '21223%'
         OR pat.zip LIKE '21224%'
         OR pat.zip LIKE '21225%'
         OR pat.zip LIKE '21226%'
         OR pat.zip LIKE '21227%'
         OR pat.zip LIKE '21228%'
         OR pat.zip LIKE '21229%'
         OR pat.zip LIKE '21230%'
         OR pat.zip LIKE '21231%'
         OR pat.zip LIKE '21234%'
         OR pat.zip LIKE '21236%'
         OR pat.zip LIKE '21237%'
         OR pat.zip LIKE '21239%'
         OR pat.zip LIKE '21240%'
         OR pat.zip LIKE '21244%'
         OR pat.zip LIKE '21250%'
         OR pat.zip LIKE '21251%'
         OR pat.zip LIKE '21252%'
         OR pat.zip LIKE '21286%'
         OR pat.zip LIKE '21401%'
         OR pat.zip LIKE '21402%'
         OR pat.zip LIKE '21405%'
         OR pat.zip LIKE '21409%'
         OR pat.zip LIKE '21661%'
         OR pat.zip LIKE '21723%'
         OR pat.zip LIKE '21737%'
         OR pat.zip LIKE '21738%'
         OR pat.zip LIKE '21784%'
         OR pat.zip LIKE '21794%'
         )
   GROUP BY pat.PAT_ID
   
   INTERSECT
   --2.	Body mass index (BMI) ≥ 25 kg/m2 or ≥ 23 kg/m2 for Asians(in any race field) from an encounter at JHH
   SELECT PAT_ID
   FROM (
      SELECT PAT_ID
      FROM CLARITY..PAT_ENC e
      INNER JOIN CLARITY..CLARITY_DEP d ON e.EFFECTIVE_DEPT_ID = d.DEPARTMENT_ID
      WHERE BMI >= 25
         AND ISNULL(d.SERV_AREA_ID, 11) = 11
         AND ISNULL(E.EFFECTIVE_DATE_DT, E.CONTACT_DATE) >= DATEADD(YEAR, - 3, GETDATE())
         AND d.REV_LOC_ID LIKE '1101%'
      UNION
      SELECT e.PAT_ID
      FROM CLARITY..PAT_ENC e
      INNER JOIN CLARITY..CLARITY_DEP d ON e.EFFECTIVE_DEPT_ID = d.DEPARTMENT_ID
      INNER JOIN CLARITY..PATIENT_RACE p ON e.PAT_ID = p.PAT_ID
         AND p.PATIENT_RACE_C = 4
      WHERE BMI >= 23
         AND ISNULL(e.SERV_AREA_ID, 11) = 11
         AND ISNULL(E.EFFECTIVE_DATE_DT, E.CONTACT_DATE) >= DATEADD(YEAR, - 3, GETDATE())
         AND d.REV_LOC_ID LIKE '1101%'
      ) BMI
   GROUP BY PAT_ID
   
   INTERSECT
   --3.Hemoglobin A1C 5.7% to 6.4% (inclusive) in the past 12 months
   --	OR 
   --	Fasting glucose 100-125 mg/dl in the past 12 months (I think the lab-base-name is GLUFAST)  
   --	OR  
   --	Serum glucose 100-125 mg/dl AND [speciman-collection-time] between 7-8AM in the past 12 months (Only out-patients) 
   --	OR 
   --	GLU2HR 140-199 mg/dl in the past 12 months.   
   --	OR  
   --	ICD-10  code for  prediabetes [R73.03] or impaired fasting glucose [R73.01], or impaired glucose tolerance [R73.02)
   SELECT t.PAT_ID
   FROM (
      SELECT enc.PAT_ID
      FROM CLARITY..order_results res
      INNER JOIN CLARITY..order_proc orp ON res.ORDER_PROC_ID = orp.ORDER_PROC_ID
      INNER JOIN CLARITY..pat_enc enc ON orp.PAT_ENC_CSN_ID = enc.PAT_ENC_CSN_ID
      INNER JOIN CLARITY..clarity_component cc ON res.COMPONENT_ID = cc.COMPONENT_ID
	  INNER JOIN CLARITY..CLARITY_DEP DEP ON DEP.DEPARTMENT_ID = enc.DEPARTMENT_ID
      WHERE ISNULL(DEP.SERV_AREA_ID, 11) = 11
         AND res.RESULT_DATE >= dateadd(m, - 12, @_Today) --Past 12 months
         AND cc.BASE_NAME LIKE '%HGBA1C%' --A1C
         AND res.ORD_NUM_VALUE BETWEEN 5.7
            AND 6.4
         AND res.result_status_c = 3
      UNION
      SELECT enc.PAT_ID
      FROM CLARITY..order_results res
      INNER JOIN CLARITY..order_proc orp ON res.ORDER_PROC_ID = orp.ORDER_PROC_ID
      INNER JOIN CLARITY..pat_enc enc ON orp.PAT_ENC_CSN_ID = enc.PAT_ENC_CSN_ID
      INNER JOIN CLARITY..clarity_component cc ON res.COMPONENT_ID = cc.COMPONENT_ID
      INNER JOIN CLARITY..CLARITY_DEP DEP ON DEP.DEPARTMENT_ID = enc.DEPARTMENT_ID
      WHERE ISNULL(DEP.SERV_AREA_ID, 11) = 11
         AND res.RESULT_DATE >= dateadd(m, - 12, @_Today) --Past 12 months
         AND cc.BASE_NAME LIKE '%GLUFAST%' --fasting glucose
         AND res.ORD_NUM_VALUE BETWEEN 100
            AND 125
         AND res.result_status_c = 3
      UNION
      SELECT enc.PAT_ID
      FROM CLARITY..order_results res
      INNER JOIN CLARITY..order_proc orp ON res.ORDER_PROC_ID = orp.ORDER_PROC_ID
      INNER JOIN CLARITY..order_proc_2 orp2 ON orp.order_proc_id = orp2.order_proc_id
      INNER JOIN CLARITY..pat_enc enc ON orp.PAT_ENC_CSN_ID = enc.PAT_ENC_CSN_ID
      INNER JOIN CLARITY..clarity_component cc ON res.COMPONENT_ID = cc.COMPONENT_ID
      INNER JOIN CLARITY..CLARITY_DEP DEP ON DEP.DEPARTMENT_ID = enc.DEPARTMENT_ID
      WHERE ISNULL(DEP.SERV_AREA_ID, 11) = 11
         AND res.RESULT_DATE >= dateadd(m, - 12, @_Today) --Past 12 months
         AND TIMEFROMPARTS(DATEPART(hour, ISNULL(ORP2.SPECIMN_TAKEN_TIME,ORP2.SPECIMEN_RECV_TIME)), DATEPART(minute, orp2.
               SPECIMN_TAKEN_TIME), 0, 0, 0) BETWEEN '07:00'
            AND '08:00' --Between 7 and 8 am
         AND cc.[NAME] LIKE '%SERUM%' --Glucose serum
         AND cc.BASE_NAME = 'GLU' --Glucose serum
         AND res.ORD_NUM_VALUE BETWEEN 100
            AND 125
         AND res.result_status_c = 3
		 AND ISNULL(enc.APPT_STATUS_C,2)=2 
         AND enc.ENC_TYPE_C IN (
			'1000', '1001', '1003', '1004', '101', '108', '1199', '1200', '1201', '121', '1214', '2', '200', '210', 
			'2100', '2101', '2500', '2501', '2502', '2508', '2521', '2522', '2525', '2526', '2529', '2531', '50', '55', 
			'76', '81', '91'
			) --outpatient encounter  
	  UNION
      SELECT enc.PAT_ID
      FROM CLARITY..order_results res
      INNER JOIN CLARITY..order_proc orp ON res.ORDER_PROC_ID = orp.ORDER_PROC_ID
      INNER JOIN CLARITY..pat_enc enc ON orp.PAT_ENC_CSN_ID = enc.PAT_ENC_CSN_ID
      INNER JOIN CLARITY..clarity_component cc ON res.COMPONENT_ID = cc.COMPONENT_ID
      INNER JOIN CLARITY..CLARITY_DEP DEP ON DEP.DEPARTMENT_ID = enc.DEPARTMENT_ID
      WHERE ISNULL(DEP.SERV_AREA_ID, 11) = 11
         AND res.RESULT_DATE >= dateadd(m, - 12, @_Today) --Past 12 months
         AND cc.BASE_NAME LIKE '%GLU2HR%' --GLU2HR
         AND res.ORD_NUM_VALUE BETWEEN 140
            AND 199
         AND res.result_status_c = 3
      UNION
      SELECT a.PAT_ID
      FROM (
         SELECT PAT.PAT_ID --,ISNULL(PE.EFFECTIVE_DATE_DT,PE.CONTACT_DATE)  
         FROM CLARITY.DBO.PATIENT PAT
         INNER JOIN CLARITY..PAT_ENC PE ON PAT.PAT_ID = PE.PAT_ID
         INNER JOIN CLARITY..PAT_ENC_DX PED ON PE.PAT_ENC_CSN_ID = PED.PAT_ENC_CSN_ID
         INNER JOIN #DX_list ED ON PED.DX_ID = ED.DX_ID
         UNION
         --HSP_BILLING_DX
         SELECT PAT.PAT_ID --,ISNULL(PE.EFFECTIVE_DATE_DT,PE.CONTACT_DATE)  
         FROM CLARITY.DBO.PATIENT PAT
         INNER JOIN CLARITY..PAT_ENC PE ON PAT.PAT_ID = PE.PAT_ID
         INNER JOIN CLARITY..HSP_ACCT_DX_LIST DXL WITH (NOLOCK) ON PE.HSP_ACCOUNT_ID = DXL
            .HSP_ACCOUNT_ID
         INNER JOIN #DX_list ED ON DXL.DX_ID = ED.DX_ID
         UNION
         --PROBLEM LIST
         SELECT DISTINCT PAT.PAT_ID
         FROM CLARITY.DBO.PATIENT PAT
         INNER JOIN CLARITY..PROBLEM_LIST PL ON PAT.PAT_ID = PL.PAT_ID
         INNER JOIN #DX_list ED ON PL.DX_ID = ED.DX_ID
         WHERE ISNULL(PL.PROBLEM_STATUS_C, 0) IN (1) -- ACTIVE
         UNION
         --HSP_ADMISSION_DX
         SELECT DISTINCT PAT.PAT_ID
         FROM CLARITY.DBO.PATIENT PAT
         INNER JOIN CLARITY..HSP_ADMIT_DIAG HAD ON HAD.PAT_ID = PAT.PAT_ID
         INNER JOIN CLARITY..PAT_ENC PE ON PE.PAT_ENC_CSN_ID = HAD.PAT_ENC_CSN_ID
         INNER JOIN #DX_list ED ON HAD.DX_ID = ED.DX_ID
         UNION
         --ARPB DX
         SELECT DISTINCT PAT.PAT_ID
         FROM CLARITY.DBO.PATIENT PAT
         INNER JOIN CLARITY..ARPB_TRANSACTIONS AT ON AT.PATIENT_ID = PAT.PAT_ID
         INNER JOIN CLARITY..V_ARPB_CODING_DX ARPB ON ARPB.TX_ID = AT.TX_ID
         INNER JOIN #DX_list ED ON ARPB.DX_ID = ED.DX_ID
         ) a
      ) t
   GROUP BY PAT_ID

/*Exclusion criteria
Patients with the following criteria will be excluded from the extract results:*/
--1.	Aortic stenosis (I35.0) active on problem list or encounter diagnosis within last 3 years 
DELETE
FROM #ccda4208_cohort
WHERE PAT_ID IN (
      SELECT cht.PAT_ID
      FROM #ccda4208_cohort cht
      INNER JOIN CLARITY..PROBLEM_LIST prb ON cht.PAT_ID = prb.PAT_ID
      INNER JOIN CLARITY..EDG_CURRENT_ICD10 icd ON prb.DX_ID = icd.DX_ID
      WHERE CODE LIKE 'I35.0%'
         AND PROBLEM_STATUS_C = 1
      
      UNION
      
      SELECT enc.PAT_ID
      FROM #ccda4208_cohort cht
      INNER JOIN CLARITY..PAT_ENC enc ON cht.PAT_ID = enc.PAT_ID
      INNER JOIN CLARITY..PAT_ENC_DX pex ON pex.PAT_ENC_CSN_ID = enc.PAT_ENC_CSN_ID
      INNER JOIN CLARITY..EDG_CURRENT_ICD10 icd ON pex.DX_ID = icd.DX_ID
      INNER JOIN CLARITY..CLARITY_DEP DEP ON DEP.DEPARTMENT_ID = enc.DEPARTMENT_ID
      WHERE ISNULL(DEP.SERV_AREA_ID, 11) = 11
         AND CODE LIKE 'I35.0%'
         AND ISNULL(ENC.EFFECTIVE_DATE_DT, pex.CONTACT_DATE) >= dateadd(yy, - 3, @_Today)
      )

--2.	Admission in JHHS within last 6 months with CHF (I50.X) 
DELETE
FROM #ccda4208_cohort
WHERE PAT_ID IN (
      SELECT cht.PAT_ID
      FROM #ccda4208_cohort cht
      INNER JOIN CLARITY..F_IP_HSP_ADMISSION adm ON cht.PAT_ID = adm.PAT_ID
      INNER JOIN CLARITY..PAT_ENC_HSP hsp ON adm.PAT_ENC_CSN_ID = hsp.PAT_ENC_CSN_ID
      --JOIN CLARITY..HSP_ACCT_ADMIT_DX dx on hsp.HSP_ACCOUNT_ID = dx.HSP_ACCOUNT_ID
      INNER JOIN CLARITY..HSP_ACCT_DX_LIST dx ON hsp.HSP_ACCOUNT_ID = dx.HSP_ACCOUNT_ID
      INNER JOIN CLARITY..EDG_CURRENT_ICD10 icd ON dx.DX_ID = icd.DX_ID
      WHERE adm.HOSP_ADM_DATE >= dateadd(mm, - 6, @_Today)
         AND icd.CODE LIKE 'I50%'
      )

--3.	Systolic blood pressure >180 mmHg in last encounter within last 3 months 
DELETE
FROM #ccda4208_cohort
WHERE PAT_ID IN (
      SELECT PAT_ID
      FROM (
         SELECT BP_SYSTOLIC, cht.PAT_ID, ROW_NUMBER() OVER (
               PARTITION BY cht.PAT_ID ORDER BY ISNULL(ENC.EFFECTIVE_DATE_DT, enc.CONTACT_DATE) DESC
               ) AS RowNum
         FROM #ccda4208_cohort cht
         INNER JOIN CLARITY..PAT_ENC enc ON cht.PAT_ID = enc.PAT_ID
         WHERE ISNULL(SERV_AREA_ID, 11) = 11
            AND ISNULL(ENC.EFFECTIVE_DATE_DT, enc.CONTACT_DATE) >= dateadd(mm, - 3, @_Today)
            AND BP_SYSTOLIC IS NOT NULL
         ) systolic_bp
      WHERE RowNum = 1
         AND BP_SYSTOLIC > 180
      )

--4.	Use of any glucose-lowering medications (medication history entered or ordered meds) within past 1 year [therapeutic_class = Antihyperglycemics]
--10.	Use of antipsychotic medications [therapeutic_class = PSYCHOTHERAPEUTIC DRUGS ](medication history or ordered medications) within past 1 year 
DELETE
FROM #ccda4208_cohort
WHERE PAT_ID IN (
      SELECT enc.pat_id
      FROM #ccda4208_cohort cht
      INNER JOIN CLARITY..PAT_ENC enc ON cht.PAT_ID = enc.PAT_ID
      INNER JOIN CLARITY..ORDER_MED orm ON orm.PAT_ENC_CSN_ID = enc.PAT_ENC_CSN_ID
      INNER JOIN CLARITY..CLARITY_MEDICATION med ON orm.MEDICATION_ID = med.MEDICATION_ID
      INNER JOIN CLARITY..CLARITY_DEP DEP ON DEP.DEPARTMENT_ID = enc.DEPARTMENT_ID
      WHERE ISNULL(DEP.SERV_AREA_ID, 11) = 11
         AND orm.ORDERING_DATE >= dateadd(yy, - 1, @_Today)
         AND (
            THERA_CLASS_C = 31 --ANTIHYPERGLYCEMICS
            OR THERA_CLASS_C = 35
            ) --PSYCHOTHERAPEUTIC DRUGS
      )

--5.	Use of any weight loss medications (medication history entered or ordered meds) within past 1 year (see Appendix 2)
DELETE
FROM #ccda4208_cohort
WHERE PAT_ID IN (
      SELECT enc.PAT_ID
      FROM #ccda4208_cohort cht
      INNER JOIN CLARITY..PAT_ENC enc ON cht.PAT_ID = enc.PAT_ID
      INNER JOIN CLARITY..ORDER_MED orm ON orm.PAT_ENC_CSN_ID = enc.PAT_ENC_CSN_ID
      INNER JOIN CLARITY..CLARITY_MEDICATION med ON orm.MEDICATION_ID = med.MEDICATION_ID
      INNER JOIN CLARITY..CLARITY_DEP DEP ON DEP.DEPARTMENT_ID = enc.DEPARTMENT_ID
      WHERE ISNULL(DEP.SERV_AREA_ID, 11) = 11
         AND orm.ORDERING_DATE >= dateadd(yy, - 1, @_Today)
         AND (
            [NAME] LIKE '%xenical%'
            OR generic_name LIKE '%orlistat%'
            OR [NAME] LIKE '%belviq%'
            OR generic_name LIKE '%Lorcaserin%'
            OR (
               GENERIC_NAME LIKE '%Phentermine%'
               AND GENERIC_NAME LIKE '%Topiramate%'
               )
            OR [NAME] LIKE '%Qsymia%'
            OR [NAME] LIKE '%Saxenda%'
            OR GENERIC_NAME LIKE '%Liraglutide%'
            OR (
               GENERIC_NAME LIKE '%Buproprion%'
               AND GENERIC_NAME LIKE '%Naltrexone%'
               )
            OR [NAME] LIKE '%Contrave%'
            OR generic_name LIKE '%Benzphetamine%'
            OR [NAME] LIKE '%didrex%'
            OR [NAME] LIKE '%Regimex%'
            OR GENERIC_NAME LIKE '%Diethylpropion%'
            OR GENERIC_NAME LIKE '%Phentermine%'
            OR [NAME] LIKE '%Adipex%'
            OR [NAME] LIKE '%Lomaira%'
            OR [NAME] LIKE '%Suprenza%'
            OR GENERIC_NAME LIKE '%Phendimetrazine%'
            OR [NAME] LIKE '%Bontril%'
            OR GENERIC_NAME LIKE '%Bromocriptine%'
            OR [NAME] LIKE '%Parlodel%'
            OR [NAME] LIKE '%Cycloset%'
            OR generic_name LIKE '%Colesevelam%'
            OR [NAME] LIKE '%Welchol%'
            )
      )

--6.	Use of any systemic glucocorticoids (medication history entered or ordered meds) within the previous 3 months [pharmaceutical_class= glucocorticoids ]
DELETE
FROM #ccda4208_cohort
WHERE PAT_ID IN (
      SELECT enc.PAT_ID
      FROM #ccda4208_cohort cht
      INNER JOIN CLARITY..PAT_ENC enc ON cht.PAT_ID = enc.PAT_ID
      INNER JOIN CLARITY..ORDER_MED orm ON orm.PAT_ENC_CSN_ID = enc.PAT_ENC_CSN_ID
      INNER JOIN CLARITY..CLARITY_MEDICATION med ON orm.MEDICATION_ID = med.MEDICATION_ID
      INNER JOIN CLARITY..ZC_PHARM_CLASS zpc ON med.PHARM_CLASS_C = zpc.PHARM_CLASS_C
      INNER JOIN CLARITY..CLARITY_DEP DEP ON DEP.DEPARTMENT_ID = enc.DEPARTMENT_ID
      WHERE ISNULL(DEP.SERV_AREA_ID, 11) = 11
         AND orm.ORDERING_DATE >= dateadd(mm, - 3, @_Today)
         AND zpc.NAME LIKE '%glucocorticoid%'
      )

--7.	Active cancer diagnosis (malignant neoplasm active on problem list or encounter diagnosis within past 3 years) (see Appendix 3)
DECLARE @_Active_Cancer_DX TABLE (DX_ID NUMERIC(18, 0))

INSERT INTO @_Active_Cancer_DX
SELECT dx_id
FROM CLARITY..edg_current_icd10
WHERE code LIKE 'C0%'
   OR code LIKE 'C10%'
   OR code LIKE 'C11%'
   OR code LIKE 'C12%'
   OR code LIKE 'C13%'
   OR code LIKE 'C14%' --C00-C14	Malignant neoplasms of lip, oral cavity and pharynx
   OR code LIKE 'C15%'
   OR code LIKE 'C16%'
   OR code LIKE 'C17%'
   OR code LIKE 'C18%'
   OR code LIKE 'C19%'
   OR code LIKE 'C20%'
   OR code LIKE 'C21%'
   OR code LIKE 'C22%'
   OR code LIKE 'C23%'
   OR code LIKE 'C24%'
   OR code LIKE 'C25%'
   OR code LIKE 'C26%' --C15-C26	Malignant neoplasms of digestive organs
   OR code LIKE 'C3%' --C30-C39	Malignant neoplasms of respiratory and intrathoracic organs
   OR (
      code LIKE 'C4%'
      AND NOT code LIKE 'C4A%'
      ) 
   --C40-C41: Malignant neoplasms of bone and articular cartilage; C43-C44: Melanoma and other malignant neoplasms of skin; C45-C49: Malignant neoplasms of mesothelial and soft tissue
   OR code LIKE 'C5%' 
   --C50: Malignant neoplasms of breast; C51-C58: Malignant neoplasms of female genital organs
   OR code LIKE 'C6%' 
   --C60-C63: Malignant neoplasms of male genital organs; C64-C68: Malignant neoplasms of urinary tract
   OR code LIKE 'C70%'
   OR code LIKE 'C71%'
   OR code LIKE 'C72%' 
   --C69-C72	Malignant neoplasms of eye, brain and other parts of central nervous system
   OR code LIKE 'C73%'
   OR code LIKE 'C74%'
   OR code LIKE 'C75%' --C73-C75	Malignant neoplasms of thyroid and other endocrine glands
   OR code LIKE 'C76%'
   OR code LIKE 'C77%'
   OR code LIKE 'C78%'
   OR code LIKE 'C79%'
   OR code LIKE 'C80%' 
   --C76-C80	Malignant neoplasms of ill-defined, other secondary and unspecified sites
   OR code LIKE 'C7A%' --C7A	Malignant neuroendocrine tumors
   OR code LIKE 'C7B%' --C7B	Secondary neuroendocrine tumors
   OR code LIKE 'C8%'
   OR code LIKE 'C9%' --C81-C96	Malignant neoplasms of lymphoid, hematopoietic and related tissue

DELETE
FROM #ccda4208_cohort
WHERE PAT_ID IN (
      SELECT cht.PAT_ID
      FROM #ccda4208_cohort cht
      INNER JOIN CLARITY..PROBLEM_LIST prb ON cht.PAT_ID = prb.PAT_ID
      INNER JOIN @_Active_Cancer_DX icd ON prb.DX_ID = icd.DX_ID
      WHERE prb.PROBLEM_STATUS_C = 1 --Active
      )

DELETE
FROM #ccda4208_cohort
WHERE PAT_ID IN (
      SELECT enc.PAT_ID
      FROM #ccda4208_cohort cht
      INNER JOIN CLARITY..PAT_ENC enc ON cht.PAT_ID = enc.PAT_ID
      INNER JOIN CLARITY..PAT_ENC_DX pex ON enc.PAT_ENC_CSN_ID = pex.PAT_ENC_CSN_ID
      INNER JOIN @_Active_Cancer_DX icd ON pex.DX_ID = icd.DX_ID
      INNER JOIN CLARITY..CLARITY_DEP DEP ON DEP.DEPARTMENT_ID = enc.DEPARTMENT_ID
      WHERE ISNULL(DEP.SERV_AREA_ID, 11) = 11
         AND ISNULL(ENC.EFFECTIVE_DATE_DT, enc.CONTACT_DATE) >= dateadd(yy, - 3, @_Today)
      )

--8.	Diagnosis of diabetes mellitus (problem list and encounter diagnosis) within past 3 years. [ICD1-0 code; E08 or E09 or E10 or E11]
DELETE
FROM #ccda4208_cohort
WHERE PAT_ID IN (
      SELECT cht.PAT_ID
      FROM #ccda4208_cohort cht
      INNER JOIN CLARITY..PROBLEM_LIST prb ON cht.PAT_ID = prb.PAT_ID
      INNER JOIN CLARITY..EDG_CURRENT_ICD10 icd ON prb.DX_ID = icd.DX_ID
      WHERE prb.PROBLEM_STATUS_C = 1 --Active
         AND (
            icd.CODE LIKE 'E08.%'
            OR icd.CODE LIKE 'E09.%'
            OR CODE LIKE 'E10.%'
            OR code LIKE 'E11.%'
            ) --	ICD-10 code; E08 or E09 or E10 or E11]
      )

DELETE
FROM #ccda4208_cohort
WHERE PAT_ID IN (
      SELECT enc.PAT_ID
      FROM #ccda4208_cohort cht
      INNER JOIN CLARITY..PAT_ENC enc ON cht.PAT_ID = enc.PAT_ID
      INNER JOIN CLARITY..PAT_ENC_DX pex ON enc.PAT_ENC_CSN_ID = pex.PAT_ENC_CSN_ID
      INNER JOIN CLARITY..EDG_CURRENT_ICD10 icd ON pex.DX_ID = icd.DX_ID
      INNER JOIN CLARITY..CLARITY_DEP DEP ON DEP.DEPARTMENT_ID = enc.DEPARTMENT_ID
      WHERE ISNULL(DEP.SERV_AREA_ID, 11) = 11
         AND ISNULL(ENC.EFFECTIVE_DATE_DT, enc.CONTACT_DATE) >= dateadd(yy, - 3, @_Today)
         AND (
            icd.CODE LIKE 'E08%'
            OR icd.CODE LIKE 'E09%'
            OR CODE LIKE 'E10%'
            OR code LIKE 'E11%'
            ) --	ICD-10 code; E08 or E09 or E10 or E11]
      )

--9.	Anemia (Hematocrit <36% in men or <33% in women) or ICD-10 code for hemoglobinopathy (D58.2)
DELETE
FROM #ccda4208_cohort
WHERE PAT_ID IN (
      SELECT pat.PAT_ID
      FROM #ccda4208_cohort cht
      INNER JOIN CLARITY..pat_enc enc ON cht.PAT_ID = enc.PAT_ID
      INNER JOIN CLARITY..order_proc orp ON orp.PAT_ENC_CSN_ID = enc.PAT_ENC_CSN_ID
      INNER JOIN CLARITY..order_results res ON res.ORDER_PROC_ID = orp.ORDER_PROC_ID
      INNER JOIN CLARITY..patient pat ON enc.PAT_ID = pat.PAT_ID
      INNER JOIN CLARITY..clarity_component cc ON res.COMPONENT_ID = cc.COMPONENT_ID
      INNER JOIN CLARITY..CLARITY_DEP DEP ON DEP.DEPARTMENT_ID = enc.DEPARTMENT_ID
      WHERE ISNULL(DEP.SERV_AREA_ID, 11) = 11
         --and res.RESULT_DATE >= dateadd(yy,-3,@_Today)
         AND BASE_NAME LIKE '%HCT%'
         AND NOT BASE_NAME IN ('PTHCTERM', 'HCTAPH')
         AND res.ORD_NUM_VALUE < 36
         AND res.result_status_c = 3
         AND pat.SEX_C = 2 --men
      )

DELETE
FROM #ccda4208_cohort
WHERE PAT_ID IN (
      SELECT pat.PAT_ID
      FROM #ccda4208_cohort cht
      INNER JOIN CLARITY..pat_enc enc ON cht.PAT_ID = enc.PAT_ID
      INNER JOIN CLARITY..order_proc orp ON orp.PAT_ENC_CSN_ID = enc.PAT_ENC_CSN_ID
      INNER JOIN CLARITY..order_results res ON res.ORDER_PROC_ID = orp.ORDER_PROC_ID
      INNER JOIN CLARITY..patient pat ON enc.PAT_ID = pat.PAT_ID
      INNER JOIN CLARITY..clarity_component cc ON res.COMPONENT_ID = cc.COMPONENT_ID
      INNER JOIN CLARITY..CLARITY_DEP DEP ON DEP.DEPARTMENT_ID = enc.DEPARTMENT_ID
      WHERE ISNULL(DEP.SERV_AREA_ID, 11) = 11
         --and res.RESULT_DATE >= dateadd(yy,-3,@_Today)
         AND BASE_NAME LIKE '%HCT%'
         AND NOT BASE_NAME IN ('PTHCTERM', 'HCTAPH')
         AND res.ORD_NUM_VALUE < 33
         AND res.result_status_c = 3
         AND pat.SEX_C = 1 --women
      )

DELETE
FROM #ccda4208_cohort
WHERE PAT_ID IN (
      SELECT cht.PAT_ID
      FROM #ccda4208_cohort cht
      INNER JOIN CLARITY..PROBLEM_LIST prb ON cht.PAT_ID = prb.PAT_ID
      INNER JOIN CLARITY..EDG_CURRENT_ICD10 icd ON prb.DX_ID = icd.DX_ID
      WHERE prb.PROBLEM_STATUS_C = 1 --Active
         AND icd.CODE LIKE 'D58.2%'
      )

DELETE
FROM #ccda4208_cohort
WHERE PAT_ID IN (
      SELECT enc.PAT_ID
      FROM #ccda4208_cohort cht
      INNER JOIN CLARITY..PAT_ENC enc ON cht.PAT_ID = enc.PAT_ID
      INNER JOIN CLARITY..PAT_ENC_DX pex ON enc.PAT_ENC_CSN_ID = pex.PAT_ENC_CSN_ID
      INNER JOIN CLARITY..EDG_CURRENT_ICD10 icd ON pex.DX_ID = icd.DX_ID
      INNER JOIN CLARITY..CLARITY_DEP DEP ON DEP.DEPARTMENT_ID = enc.DEPARTMENT_ID
      WHERE ISNULL(DEP.SERV_AREA_ID, 11) = 11
         AND icd.CODE LIKE 'D58.2%'
      )

--11.	Major psychiatric disorder (schizophrenia [F20.x], major depression [F33.x]) – problem list and encounter diagnosis within past 1 year 
DELETE
FROM #ccda4208_cohort
WHERE PAT_ID IN (
      SELECT cht.PAT_ID
      FROM #ccda4208_cohort cht
      INNER JOIN CLARITY..PROBLEM_LIST prb ON cht.PAT_ID = prb.PAT_ID
      INNER JOIN CLARITY..EDG_CURRENT_ICD10 icd ON prb.DX_ID = icd.DX_ID
      WHERE prb.PROBLEM_STATUS_C = 1 --Active
         AND (icd.CODE LIKE 'F20.%') --schizophrenia [F20.x], major depression [F33.x]
      )

DELETE
FROM #ccda4208_cohort
WHERE PAT_ID IN (
      SELECT enc.PAT_ID
      FROM #ccda4208_cohort cht
      INNER JOIN CLARITY..PAT_ENC enc ON cht.PAT_ID = enc.PAT_ID
      INNER JOIN CLARITY..PAT_ENC_DX pex ON enc.PAT_ENC_CSN_ID = pex.PAT_ENC_CSN_ID
      INNER JOIN CLARITY..EDG_CURRENT_ICD10 icd ON pex.DX_ID = icd.DX_ID
      INNER JOIN CLARITY..CLARITY_DEP DEP ON DEP.DEPARTMENT_ID = enc.DEPARTMENT_ID
      WHERE ISNULL(DEP.SERV_AREA_ID, 11) = 11
         AND ISNULL(ENC.EFFECTIVE_DATE_DT, enc.CONTACT_DATE) >= dateadd(yy, - 1, @_Today)
         AND (icd.CODE LIKE 'F20.%') --schizophrenia [F20.x], major depression [F33.x]
      )

--12.	Alcoholism (F10.X)
DELETE
FROM #ccda4208_cohort
WHERE PAT_ID IN (
      SELECT cht.PAT_ID
      FROM #ccda4208_cohort cht
      INNER JOIN CLARITY..PROBLEM_LIST prb ON cht.PAT_ID = prb.PAT_ID
      INNER JOIN CLARITY..EDG_CURRENT_ICD10 icd ON prb.DX_ID = icd.DX_ID
      WHERE prb.PROBLEM_STATUS_C = 1 --Active
         AND icd.CODE LIKE 'F10.%'
      )

DELETE
FROM #ccda4208_cohort
WHERE PAT_ID IN (
      SELECT cht.PAT_ID
      FROM #ccda4208_cohort cht
      INNER JOIN CLARITY..MEDICAL_HX mhx ON cht.PAT_ID = mhx.PAT_ID
      INNER JOIN CLARITY..EDG_CURRENT_ICD10 icd ON mhx.DX_ID = icd.DX_ID
      WHERE icd.CODE LIKE 'F10.%'
      )

--Load into table
SELECT DISTINCT II.IDENTITY_ID "EMRN", pat.PAT_NAME, pat.BIRTH_DATE,
zc_my.NAME "MYCHART_STATUS", prov.PROV_ID, prov.PROV_NAME, 
	STUFF((
         SELECT ', ' + ADDR_LINE_1 + ', ' + ISNULL(ADDR_LINE_2 + ', ', '') + CITY + ', ' + S.NAME + ', ' + ZIP
         FROM CLARITY..CLARITY_SER_ADDR addr1
         WHERE addr1.PROV_ID = prov.PROV_ID
		 AND addr1.LINE = 1
         FOR XML PATH('')
         ), 1, 1, '') "PCP_ADDRESS"
INTO Analytics.dbo.CCDA4028_Mathioudakis_Diabetes_Ptlist
FROM #ccda4208_cohort pt
INNER JOIN CLARITY..PATIENT pat ON pt.PAT_ID = pat.PAT_ID
INNER JOIN CLARITY..IDENTITY_ID II ON II.PAT_ID = pat.PAT_ID
   AND II.IDENTITY_TYPE_ID = 0
INNER JOIN CLARITY..PATIENT_4 pat4 ON pat.pat_id = pat4.pat_id
LEFT JOIN CLARITY..CLARITY_SER prov ON pat.CUR_PCP_PROV_ID = prov.PROV_ID
LEFT JOIN CLARITY..CLARITY_SER_ADDR addr ON prov.PROV_ID = addr.PROV_ID
LEFT JOIN CLARITY..ZC_STATE S ON addr.STATE_C = S.STATE_C
LEFT JOIN CLARITY..PATIENT_MYC mychart ON mychart.pat_id = pat.pat_id
LEFT JOIN CLARITY..ZC_MYCHART_STATUS zc_my ON mychart.MYCHART_STATUS_C = zc_my.MYCHART_STATUS_C
ORDER BY EMRN;

ALTER TABLE Analytics.dbo.CCDA4028_Mathioudakis_Diabetes_Ptlist REBUILD PARTITION = ALL  WITH (DATA_COMPRESSION = Page);
