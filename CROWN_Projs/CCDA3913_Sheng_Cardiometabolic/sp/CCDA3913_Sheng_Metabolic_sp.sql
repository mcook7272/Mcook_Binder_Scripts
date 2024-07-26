ALTER proc dbo.[CCDA3913_Sheng_Metabolic_sp] AS
/**********************************************************************************
Author:  Michael Cook
Date: 6/2/2022
JIRA: CCDA-3913
Description: A one-time extract To identify patients with history of early stage breast cancer and at least 3 months from 
completion of local and systemic therapy with an upcoming visit at hopkins, and to obtain their
most recent Hba1c, BMI and lipid panel within the past 12 months.

Inclusion criteria 
Only patients with the following criteria will be included in the extract results:

-Adults (>= 18 years of age) 
-Having an upcoming appointment at one of the following locations with one of the listed providers for the following timeframe July 2022- Dec 2022:
	-110107517    JHH VRGH BREAST GYNONC: Melissa Camp, Amy Deery, David Euhus, Lisa Jacobs, Danjela Jelovac, Julie Lange, Angelina Johnson, Justin Mahosky, Anisha Ninan, Patricia Njoku, Katherine Papthakis, Carol Riley, Cesar Santa-maria, Vered Stearns, Jessica Tao, Antonio Wolff
	-113000510    GSS SOM ONCOLOGY: Rima Couzi, John Fetting, Danjela Jelovac, Antonio Wolff, Nelli Zafman 
	-110400323	SMH MEDICAL ONCOLOGY: Karen Smith, Mary Wilkinson, Cesar Santa Maria, Raquel Nunes
Exclusion criteria
Patients known to be deceased in Epic
Patients with the following Metastatic ICD10 listed anytime on their Problem List
-C78 Secondary malignant neoplasm of respiratory and digestive organs
-C78.0 Secondary malignant neoplasm of lung
-C78.1 Secondary malignant neoplasm of mediastinum
-C78.2 Secondary malignant neoplasm of pleura Malignant pleural effusion NOS
-C78.3 Secondary malignant neoplasm of other and unspecified respiratory organs
-C78.4 Secondary malignant neoplasm of small intestine
-C78.5 Secondary malignant neoplasm of large intestine and rectum
-C78.6 Secondary malignant neoplasm of retroperitoneum and peritoneum Malignant ascites NOS
-C78.7 Secondary malignant neoplasm of liver and intrahepatic bile duct
-C78.8 Secondary malignant neoplasm of other and unspecified digestive organs
-C79 Secondary malignant neoplasm of other and unspecified sites
-C79.0 Secondary malignant neoplasm of kidney and renal pelvis
-C79.1 Secondary malignant neoplasm of bladder and other and unspecified urinary organs
-C79.2 Secondary malignant neoplasm of skin
-C79.3 Secondary malignant neoplasm of brain and cerebral meninges
-C79.4 Secondary malignant neoplasm of other and unspecified parts of nervous system
-C79.5 Secondary malignant neoplasm of bone and bone marrow
-C79.6 Secondary malignant neoplasm of ovary
-C79.7 Secondary malignant neoplasm of adrenal gland
-C79.8 Secondary malignant neoplasm of other specified sites
-C79.9 Secondary malignant neoplasm, unspecified site
-C50.919 Malignant neoplasm of unspecified site of unspecified female breast


Example:
    EXEC dbo.[CCDA3913_Sheng_Metabolic_sp]
     
Revision History:
Date            Author          JIRA            Comment
6/2/2022     Michael Cook     CCDA-3913      Created proc
***********************************************************************************/

SET NOCOUNT ON;
--Cohort

SELECT DISTINCT PAT.PAT_ID, I10.CODE
into #excl_dx
FROM CLARITY.DBO.PATIENT PAT
INNER JOIN CLARITY.DBO.PROBLEM_LIST PL ON PAT.PAT_ID = PL.PAT_ID
INNER JOIN CLARITY.DBO.EDG_CURRENT_ICD10 I10 ON I10.DX_ID = PL.DX_ID
WHERE ISNULL(PL.PROBLEM_STATUS_C, 0) IN (1,2) -- ACTIVE/RESOLVED
   AND (
      I10.CODE LIKE 'C7[8-9]'
      OR I10.CODE LIKE 'C78.[0-8]'
      OR I10.CODE LIKE 'C79.[0-9]'
      OR I10.CODE = 'C50.919'
      );

SELECT t.*
into #cohort
FROM (
   SELECT PAT.PAT_ID, PE.PAT_ENC_CSN_ID --,ISNULL(PE.EFFECTIVE_DATE_DT,PE.CONTACT_DATE)  
   FROM CLARITY.DBO.PATIENT PAT
   INNER JOIN CLARITY.DBO.V_SCHED_APPT PE ON PAT.PAT_ID = PE.PAT_ID
   INNER JOIN CLARITY.DBO.CLARITY_DEP DEP ON DEP.DEPARTMENT_ID = PE.DEPARTMENT_ID
   WHERE ISNULL(PE.APPT_DTTM, PE.CONTACT_DATE) BETWEEN '2022-07-01'
         AND '2022-12-31' -- Appt between July 2022 and Dec 2022
      AND ISNULL(PE.SERV_AREA_ID, 11) = 11
      AND ISNULL(PE.APPT_STATUS_C, 1) = 1 --Schedulded
      AND FLOOR(DATEDIFF(DD, PAT.BIRTH_DATE, GETDATE()) / 365.25) >= 18 --Adult
      AND DEP.DEPARTMENT_ID = '110107517' --JHH VRGH BREAST GYNONC
      AND pe.PROV_ID IN (
         '414366', '80628', '5041', '100656', '200373', '2757', '1014348', '202518', '3086', '402540', '2733', 
         '5729', '402922', '4630', '402087', '65259'
         ) --Given providers
   UNION
   SELECT PAT.PAT_ID, PE.PAT_ENC_CSN_ID --,ISNULL(PE.EFFECTIVE_DATE_DT,PE.CONTACT_DATE)  
   FROM CLARITY.DBO.PATIENT PAT
   INNER JOIN CLARITY.DBO.V_SCHED_APPT PE ON PAT.PAT_ID = PE.PAT_ID
   INNER JOIN CLARITY.DBO.CLARITY_DEP DEP ON DEP.DEPARTMENT_ID = PE.DEPARTMENT_ID
   WHERE ISNULL(PE.APPT_DTTM, PE.CONTACT_DATE) BETWEEN '2022-07-01'
         AND '2022-12-31' -- Appt between July 2022 and Dec 2022
      AND ISNULL(PE.SERV_AREA_ID, 11) = 11
      AND ISNULL(PE.APPT_STATUS_C, 1) = 1 --Schedulded
      AND FLOOR(DATEDIFF(DD, PAT.BIRTH_DATE, GETDATE()) / 365.25) >= 18 --Adult
      AND DEP.DEPARTMENT_ID = '113000510' --GSS SOM ONCOLOGY
      AND pe.PROV_ID IN ('5041', '2757', '2118', '100884', '1050823') --Given providers
   UNION
   SELECT PAT.PAT_ID, PE.PAT_ENC_CSN_ID --,ISNULL(PE.EFFECTIVE_DATE_DT,PE.CONTACT_DATE)  
   FROM CLARITY.DBO.PATIENT PAT
   INNER JOIN CLARITY.DBO.V_SCHED_APPT PE ON PAT.PAT_ID = PE.PAT_ID
   INNER JOIN CLARITY.DBO.CLARITY_DEP DEP ON DEP.DEPARTMENT_ID = PE.DEPARTMENT_ID
   WHERE ISNULL(PE.APPT_DTTM, PE.CONTACT_DATE) BETWEEN '2022-07-01'
         AND '2022-12-31' -- Appt between July 2022 and Dec 2022
      AND ISNULL(PE.SERV_AREA_ID, 11) = 11
      AND ISNULL(PE.APPT_STATUS_C, 1) = 1 --Schedulded
      AND FLOOR(DATEDIFF(DD, PAT.BIRTH_DATE, GETDATE()) / 365.25) >= 18 --Adult
      AND DEP.DEPARTMENT_ID = '110400323' --SMH MEDICAL ONCOLOGY
      AND pe.PROV_ID IN ('200373', '1002335', '1017749', '424626') --Given providers
   ) t
INNER JOIN CLARITY.dbo.PATIENT_4 pat4 ON t.pat_id = pat4.pat_id
WHERE t.PAT_ID NOT IN (SELECT PAT_ID FROM #excl_dx) --Exclude pats with listed ICD codes
   AND ISNULL(PAT4.PAT_LIVING_STAT_C, 0) = '1'; -- EXCLUDE PATIENTS LISTED AS DECEASED IN EPIC



--Demographics
drop table if exists Analytics.dbo.CCDA3913_Sheng_Demographics;

WITH COH AS (
SELECT DISTINCT PAT_ID, PAT_ENC_CSN_ID
FROM #cohort
),

BMI AS (
SELECT *
FROM COH A CROSS APPLY udfLatestBMI_tb(A.PAT_ID,GETDATE())
),

BMI_DATE AS (
SELECT BMI.PAT_ID, BMI.bmi, BMI.csn, ISNULL(PE.EFFECTIVE_DATE_DTTM, PE.CONTACT_DATE) "Date_Of_BMI"
FROM BMI
INNER JOIN CLARITY.dbo.PAT_ENC PE ON BMI.csn = PE.PAT_ENC_CSN_ID
--INNER JOIN CLARITY.dbo.IP_FLWSHT_REC IP_FLWSHT_REC  ON PE.INPATIENT_DATA_ID=IP_FLWSHT_REC.INPATIENT_DATA_ID
--INNER JOIN CLARITY.dbo.IP_FLWSHT_MEAS IP_FLWSHT_MEAS  ON IP_FLWSHT_REC.FSD_ID=IP_FLWSHT_MEAS.FSD_ID
)

Select DISTINCT II.IDENTITY_ID "EMRN", PT.PAT_MRN_ID "Preferred_MRN",
FLOOR(DATEDIFF(DD, PT.BIRTH_DATE, GETDATE()) / 365.25) "Age",
ISNULL(gen.[NAME], sex.[NAME]) "Gender", zc_race.[NAME] "Race", ethn.[NAME] "Ethnicity",
STUFF(
              (SELECT ', ' + ADD_LINE_1 +', '+ISNULL(ADD_LINE_2+', ','')+CITY+', '+S.NAME+', '+ZIP
              FROM clarity..PATIENT pt1
              WHERE PT1.PAT_ID = PT.PAT_ID
              FOR XML PATH ('')
              ), 1, 1, ''
                     ) "Address_Info",
PT.EMAIL_ADDRESS, BMI_DATE.bmi, BMI_DATE.Date_Of_BMI
INTO Analytics.dbo.CCDA3913_Sheng_Demographics
FROM Clarity..PATIENT PT
INNER JOIN COH ON COH.PAT_ID = Pt.PAT_ID
INNER JOIN CLARITY..IDENTITY_ID II ON II.PAT_ID = PT.PAT_ID and II.IDENTITY_TYPE_ID = 0
LEFT JOIN CLARITY..PATIENT_4 PT4 on PT.PAT_ID = PT4.PAT_ID
LEFT JOIN CLARITY..ZC_STATE S ON S.STATE_C = PT.STATE_C
LEFT JOIN CLARITY.dbo.ZC_GENDER_IDENTITY gen on PT4.GENDER_IDENTITY_C = gen.GENDER_IDENTITY_C
LEFT JOIN CLARITY.dbo.ZC_SEX sex on PT.SEX_C = sex.RCPT_MEM_SEX_C
LEFT JOIN CLARITY.dbo.PATIENT_RACE race on PT.PAT_ID = race.PAT_ID AND race.LINE = 1
LEFT JOIN CLARITY.dbo.ZC_PATIENT_RACE zc_race on race.PATIENT_RACE_C = zc_race.PATIENT_RACE_C
LEFT JOIN CLARITY.dbo.ZC_ETHNIC_GROUP ethn on PT.ETHNIC_GROUP_C = ethn.ETHNIC_GROUP_C
LEFT JOIN CLARITY..ZC_ETHNIC_GROUP ETG ON ETG.ETHNIC_GROUP_C = PT.ETHNIC_GROUP_C
LEFT JOIN BMI_DATE on PT.PAT_ID = BMI_DATE.PAT_ID
ORDER BY EMRN;

ALTER TABLE [Analytics].[dbo].[CCDA3913_Sheng_Demographics] REBUILD PARTITION = ALL  WITH (DATA_COMPRESSION = Page);

--Encounters

drop table if exists Analytics.dbo.CCDA3913_Sheng_Encounters;


WITH COH AS (
SELECT DISTINCT *
FROM #cohort
)

Select DISTINCT II.IDENTITY_ID "EMRN", enc.PAT_ENC_CSN_ID,
ISNULL(enc.EFFECTIVE_DATE_DTTM, enc.CONTACT_DATE) "Appointment_date",
DEP.DEPARTMENT_ID, DEP.DEPARTMENT_NAME, prov.prov_name "Provider_Name"
INTO Analytics.dbo.CCDA3913_Sheng_Encounters
FROM Clarity.DBO.PATIENT PT
INNER JOIN COH ON COH.PAT_ID = Pt.PAT_ID
INNER JOIN CLARITY.DBO.IDENTITY_ID II ON II.PAT_ID = PT.PAT_ID and II.IDENTITY_TYPE_ID = 0
INNER JOIN CLARITY.DBO.PAT_ENC enc on COH.pat_enc_csn_id = enc.pat_enc_csn_id
LEFT JOIN CLARITY.DBO.CLARITY_DEP dep on enc.EFFECTIVE_DEPT_ID = dep.DEPARTMENT_ID
LEFT JOIN CLARITY.DBO.CLARITY_SER prov on enc.VISIT_PROV_ID = prov.PROV_ID
ORDER BY EMRN, enc.PAT_ENC_CSN_ID;

ALTER TABLE Analytics.dbo.CCDA3913_Sheng_Encounters REBUILD PARTITION = ALL  WITH (DATA_COMPRESSION = Page);

--Lab_Results

drop table if exists Analytics.dbo.CCDA3913_Sheng_Lab_Results;


WITH COH AS (
SELECT DISTINCT PAT_ID
FROM #cohort
),

COMP AS (
SELECT *
FROM CLARITY.DBO.CLARITY_COMPONENT
WHERE COMPONENT_ID IN (
      '1810006', '1233000435', 
      '1233000636', '1234000412', '1234000465', '1237000008', '1239000066', '1239001383', '2000000042', 
      '2000002050', '2100002446', '2100012552', '2100013005', '3000000058', '3000002066', '4000000821', 
      '4000000822', '4000000823', '4100000395', '5000001448', '5000001449', '6000000345', '6000001280', 
      '6000001301', '6000001316', '7000002227', '7100000254', '7100002099', '7100002100', '7100002583', 
      '7200000156', '7200000604', '8100000374', '8100001550', '8100004002', '8100004929', '8200000034', 
      '8200000058', '8200002020', '8200002055', '8200002206', '8200002207', '8200003591', '8200003592', 
      '8200006159', '9000000214', '9000000654', '9100000424', '9100006036', '9300000666', '9500000029', 
      '9700000016', '9700000045', '21000130563'
      ) --Hba1c
	  OR COMPONENT_ID IN (
      '8100004657', '8100000152', '2000000321', '7200000067', '3000000337', '7100002264', '9700000018', 
      '1233000390', '6000000257', '9300000671', '7000002104', '5000001431', '4000000219', '7000002103', 
      '8200000008', '8100004638', '8100004645', '7100002266', '9700000020', '4000000222', '8100000149', 
      '7200000072', '8100004655', '5000001433', '7000002239', '7100000308', '9300000672', '2000000323', 
      '1233000392', '8200000357', '3000000339', '6000000359', '6000000392', '5000001434', '3000000340', 
      '9300000678', '7100002267', '1233000393', '2000000324', '820001447', '7100000309', '8200000373', 
      '7000002321', '4000000220', '8100000044', '7200000069', '8100000719', '9700000021', '1233000222', 
      '8100004656', '9700000036', '820001445', '7000002388', '8100004658', '8100000321', '7100000310', 
      '8100000362', '7100002268', '1233000125', '2100002294', '8100000609', '2000000325', '5000001435', 
      '1233000394', '3000000341', '7200000073', '7100000307', '820001446', '7000002577', '6000000644', 
      '7100002265', '1233000391', '7200000068', '8200000021', '9300000674', '2000000322', '9700000019', 
      '8100000225', '3000000338', '8100004637', '7100000306', '4000000308', '5000001432', '7200000071', 
      '8200000368', '7000002690'
      ) --Lipid Panel
),

LATEST_VAL AS (
	SELECT A.*,ROW_NUMBER()OVER (partition BY PAT_ID,COMPONENT_ID ORDER BY ORDERING_DATE DESC) AS RN
	FROM (SELECT DISTINCT
			S.PAT_ID
			,cc.COMPONENT_ID
			,ord.ORDER_PROC_ID
			,ord.ORDERING_DATE
		FROM 
			COH S
			INNER JOIN CLARITY..order_proc ord on S.PAT_ID = ord.PAT_ID 
			INNER JOIN CLARITY.DBO.order_results res ON ord.ORDER_PROC_ID = res.ORDER_PROC_ID
			INNER JOIN COMP cc ON cc.COMPONENT_ID = res.COMPONENT_ID	
		WHERE ord.ORDER_STATUS_C = 5 ) A
)

SELECT DISTINCT II.IDENTITY_ID "EMRN", enc.PAT_ENC_CSN_ID, res.RESULT_DATE,
   --Collection time?
   ord.ORDER_TIME, eap.PROC_NAME, cc.BASE_NAME, cc.name AS COMPONENTNAME, CC.EXTERNAL_NAME, RES.
   ORD_NUM_VALUE "VALUE_NUMERIC", RES.ORD_VALUE "VALUE_TEXT", RES.REFERENCE_UNIT, RES.REFERENCE_LOW, RES.
   REFERENCE_HIGH, CMT.RESULTS_CMT "RESULT_COMMENTS", DEP.DEPARTMENT_ID, DEP.DEPARTMENT_NAME, PROV.
   PROV_NAME "PROVIDER_NAME", EAP.PROC_ID, EAP.PROC_CODE, EAP.ORDER_DISPLAY_NAME, CC.COMPONENT_ID
INTO Analytics.dbo.CCDA3913_Sheng_Lab_Results
FROM COH
INNER JOIN CLARITY.DBO.PATIENT Pt ON COH.PAT_ID = Pt.PAT_ID
INNER JOIN CLARITY.DBO.IDENTITY_ID II ON II.PAT_ID = PT.PAT_ID AND II.IDENTITY_TYPE_ID = 0
INNER JOIN CLARITY.DBO.PAT_ENC enc ON COH.PAT_ID = enc.PAT_ID
INNER JOIN CLARITY..order_proc ord ON ENC.PAT_ENC_CSN_ID = ord.PAT_ENC_CSN_ID
INNER JOIN LATEST_VAL val ON ord.ORDER_PROC_ID = val.ORDER_PROC_ID AND val.RN = 1
INNER JOIN CLARITY.DBO.CLARITY_EAP eap ON eap.PROC_ID = ord.PROC_ID
INNER JOIN CLARITY.DBO.order_results res ON ord.ORDER_PROC_ID = res.ORDER_PROC_ID
INNER JOIN COMP cc ON cc.COMPONENT_ID = res.COMPONENT_ID
LEFT JOIN CLARITY.DBO.ORDER_RES_COMMENT cmt ON res.ORDER_PROC_ID = cmt.ORDER_ID
LEFT JOIN CLARITY.DBO.CLARITY_DEP dep ON enc.EFFECTIVE_DEPT_ID = dep.DEPARTMENT_ID
LEFT JOIN CLARITY.DBO.CLARITY_SER prov ON enc.VISIT_PROV_ID = prov.PROV_ID
WHERE (res.RESULT_STATUS_C IN (3, 4))
ORDER BY EMRN, COMPONENT_ID, RESULT_DATE;
--ORDER BY proc_name, cc.base_name;

ALTER TABLE Analytics.dbo.CCDA3913_Sheng_Lab_Results REBUILD PARTITION = ALL  WITH (DATA_COMPRESSION = Page);