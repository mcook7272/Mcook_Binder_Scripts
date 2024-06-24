USE [PMAP_Analytics]
GO

/****** Object:  StoredProcedure [dbo].[CCDA2046_Cox_NoHyphens]    Script Date: 8/29/2022 3:40:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO












ALTER PROCEDURE [dbo].[CCDA2046_Cox_NoHyphens]
AS
SET NOCOUNT ON;
--EXEC DBO.CCDA2046_Cox
IF OBJECT_ID('dbo.CCDA2046_Cox_Final_NoHyphens', 'U') IS NOT NULL 
  DROP TABLE dbo.CCDA2046_Cox_Final_NoHyphens; 

WITH CTE_BMI AS 
(SELECT osler_id,ROW_NUMBER()OVER (partition BY osler_id
ORDER BY RECORDED_TIME DESC) AS RN,meas_value,RECORDED_TIME FROM CCPSEI_Projection.dbo.derived_flowsheet_data 
WHERE meas_id='301070'
),
CTE_DX AS
(SELECT OSLER_ID,icd10_code,icd9_code FROM CCPSEI_Projection..derived_problem_list
UNION
SELECT OSLER_ID,icd10_code,icd9_code FROM CCPSEI_Projection..derived_medical_hx_summary
),
CTE_CUR_SMK AS
(
SELECT osler_id
		,ROW_NUMBER()OVER (partition BY osler_id	ORDER BY CONTACT_DATE DESC) AS RN
		,tobacco_user 
		,smoking_tobacco_use 
		,cigarettes_yn
 FROM ccpsei_projection..derived_social_history_changes
),
CTE_WBC AS
(
SELECT DISTINCT
ENROLL.OSLER_ID
,PLASMA.[Study ID]
,specimen_recv_timE
,PLASMA.[Visit Date]
,WBC_ord_value
,ABS(DATEDIFF(MINUTE,specimen_recv_timE,PLASMA.[Visit Date])) AS DATEDF
,ROW_NUMBER()OVER (partition BY ENROLL.osler_id,[Visit Date] ORDER BY ABS(DATEDIFF(MINUTE,specimen_recv_timE,PLASMA.[Visit Date]))) AS RN
 from PMAP_Analytics..[CoxAvailSpecimens_Current]  PLASMA
 INNER JOIN CCPSEI_Projection..crms_enrollments enroll on plasma.[Study ID]=enroll.[subject_number]
 INNER JOIN CCPSEI_projection..curated_Inflam_Markers inflam2 on ENROLL.OSLER_ID=inflam2.OSLER_ID
 WHERE inflam2.WBC_ord_value IS NOT NULL
),
CTE_LYM AS
(
SELECT DISTINCT
ENROLL.OSLER_ID
,PLASMA.[Study ID]
,specimen_recv_timE
,PLASMA.[Visit Date]
,Lymphabs_ord_value
,ABS(DATEDIFF(MINUTE,specimen_recv_timE,PLASMA.[Visit Date])) AS DATEDF
,ROW_NUMBER()OVER (partition BY ENROLL.osler_id,[Visit Date] ORDER BY ABS(DATEDIFF(MINUTE,specimen_recv_timE,PLASMA.[Visit Date]))) AS RN
 from PMAP_Analytics..[CoxAvailSpecimens_Current]  PLASMA
 INNER JOIN CCPSEI_Projection..crms_enrollments enroll on plasma.[Study ID]=enroll.[subject_number]
 INNER JOIN CCPSEI_projection..curated_Inflam_Markers inflam2 on ENROLL.OSLER_ID=inflam2.OSLER_ID
 WHERE inflam2.Lymphabs_ord_value IS NOT NULL
),
CTE_NEU AS 
(
 SELECT DISTINCT
ENROLL.OSLER_ID
,PLASMA.[Study ID]
,specimen_recv_timE
,PLASMA.[Visit Date]
,lab.ord_num_value
,ABS(DATEDIFF(MINUTE,specimen_recv_timE,PLASMA.[Visit Date])) AS DATEDF
,ROW_NUMBER()OVER (partition BY ENROLL.osler_id,[Visit Date] ORDER BY ABS(DATEDIFF(MINUTE,specimen_recv_timE,PLASMA.[Visit Date]))) AS RN
 from PMAP_Analytics..[CoxAvailSpecimens_Current]  PLASMA
 INNER JOIN CCPSEI_Projection..crms_enrollments enroll on plasma.[Study ID]=enroll.[subject_number]
 INNER JOIN CCPSEI_projection.[dbo].[derived_lab_results] lab on ENROLL.OSLER_ID=lab.OSLER_ID
 WHERE lab.component_base_name in( 'NEUTROABSMAN','NEUTROABS')
 AND ord_num_value <> 9999999
 --AND ENROLL.osler_id = '7724ccee-c8d8-41f2-936c-4ef9c89e2599'
),
CTE_CRP AS
(
SELECT DISTINCT
ENROLL.OSLER_ID
,PLASMA.[Study ID]
,specimen_recv_timE
,PLASMA.[Visit Date]
,CRP_ord_value
,ABS(DATEDIFF(MINUTE,specimen_recv_timE,PLASMA.[Visit Date])) AS DATEDF
,ROW_NUMBER()OVER (partition BY ENROLL.osler_id,[Visit Date] ORDER BY ABS(DATEDIFF(MINUTE,specimen_recv_timE,PLASMA.[Visit Date]))) AS RN
 from PMAP_Analytics..[CoxAvailSpecimens_Current]  PLASMA
 INNER JOIN CCPSEI_Projection..crms_enrollments enroll on plasma.[Study ID]=enroll.[subject_number]
 INNER JOIN CCPSEI_projection..curated_Inflam_Markers inflam2 on ENROLL.OSLER_ID=inflam2.OSLER_ID
 WHERE inflam2.CRP_ord_value IS NOT NULL
),
CTE_DDM AS 
(
SELECT DISTINCT
ENROLL.OSLER_ID
,PLASMA.[Study ID]
,specimen_recv_timE
,PLASMA.[Visit Date]
,DDimer_ord_num_value
,ABS(DATEDIFF(MINUTE,specimen_recv_timE,PLASMA.[Visit Date])) AS DATEDF
,ROW_NUMBER()OVER (partition BY ENROLL.osler_id,[Visit Date] ORDER BY ABS(DATEDIFF(MINUTE,specimen_recv_timE,PLASMA.[Visit Date]))) AS RN
 from PMAP_Analytics..[CoxAvailSpecimens_Current]  PLASMA
 INNER JOIN CCPSEI_Projection..crms_enrollments enroll on plasma.[Study ID]=enroll.[subject_number]
 INNER JOIN CCPSEI_projection..curated_Inflam_Markers inflam2 on ENROLL.OSLER_ID=inflam2.OSLER_ID
 WHERE inflam2.DDimer_ord_num_value IS NOT NULL
 AND DDimer_ord_num_value <> 9999999
),
CTE_CNCR AS
(
SELECT DISTINCT ENROLL.OSLER_ID
from PMAP_Analytics..[CoxAvailSpecimens_Current] PLASMA
INNER JOIN CCPSEI_Projection..crms_enrollments enroll on plasma.[Study ID]=enroll.[subject_number]
INNER JOIN CCPSEI_Projection..derived_emr_diagnosis_info pl ON PL.OSLER_ID = ENROLL.OSLER_ID
WHERE 
	(
	pl.icd10list like '%,C%' or pl.icd10list like 'C%'
	or pl.icd10list like '%D0%'
	or pl.icd10list like '%D45%'
	or pl.icd10list like '%D46%'
	or pl.icd10list like '%Z85%'
)
),
CTE_WHO_CURRENT AS
(SELECT DISTINCT
E.osler_id,C.[Visit Date],IE.HOSP_ADMSN_TIME,START,WHO.[END],WHO_SCORE_GROUPED,WHO_SCORE,who_score_numeric
,ROW_NUMBER()OVER 
	(partition BY E.osler_id,C.[Visit Date]
	ORDER BY ABS(DATEDIFF(MINUTE,ISNULL(WHO.START,HOSP_ADMSN_TIME),C.[Visit Date])),WHO_SCORE DESC) AS RN
FROM
PMAP_Analytics.[dbo].[CoxAvailSpecimens_Current] C
INNER JOIN CCPSEI_Projection..crms_enrollments  E ON C.[STUDY ID] = E.[subject_number] --258
LEFT JOIN COVID_PROJECTION.[dbo].[curated_who_status] WHO ON WHO.OSLER_ID = E.OSLER_ID
LEFT JOIN COVID_PROJECTION.DBO.DERIVED_INPATIENT_ENCOUNTERS IE ON IE.PAT_ENC_CSN_ID = WHO.INIT_pat_enc_csn_id
),
CTE_WHO_MAX AS 
(
SELECT DISTINCT
MAX_S.*,WHO.who_score,who_score_grouped
FROM
	(SELECT DISTINCT
	E.osler_id,MAX(WHO.who_score_numeric) AS MAX_S
	FROM
	PMAP_Analytics.[dbo].[CoxAvailSpecimens_Current] C
	INNER JOIN CCPSEI_Projection..crms_enrollments  E ON C.[STUDY ID] = E.[subject_number] --258
	LEFT JOIN COVID_PROJECTION.[dbo].[curated_who_status] WHO ON WHO.OSLER_ID = E.OSLER_ID
	GROUP BY E.osler_id) max_s
	INNER JOIN COVID_PROJECTION.[dbo].[curated_who_status] WHO ON WHO.OSLER_ID = MAX_S.OSLER_ID 
																AND MAX_S.MAX_S = WHO.who_score_numeric
),

CTE_Vacc_Status AS (
Select osler_id, jab_immune_type "Vaccine_Type", jab_date
FROM covid_projection.dbo.curated_covid_immunizationsEAV
),

CTE_Sequence AS (
SELECT distinct osler_id, lineage, clade
FROM [COVID_Projection].[dbo].[covid_sequence_data_linked]
),

CTE_PCR AS (
SELECT DISTINCT osler_id, order_time, result_flag, ord_value
,ROW_NUMBER()OVER 
	(partition BY lab.osler_id
	ORDER BY order_time DESC) AS RN
FROM COVID_Projection.dbo.derived_lab_results lab
WHERE component_base_name IN (
      'COVIDNATNP', 'COVID19NP', 'COVID19ET', 'EXTCOVID', 'COVID19OP', 'COVID19SPT', 'SARSCOV2', 
      'COVID19SLV', 'COVID19EX', 'COVID19N', 'COVID19BAL'
      )
   AND (
      result_flag IN ('Abnormal', 'High')
      OR ord_value IN ('Positive', 'RNA Detected', '* DETECTED *')
      )
)


SELECT DISTINCT
	ENROLL.SUBJECT_NUMBER 
	,CAST(ENROLL.EMRN AS VARCHAR) AS EMRN 
	,PT.osler_id
	,PLASMA.[visit date]	AS 'Date of Blood Draw'
	,CASE WHEN DATEDIFF(DD,PT.BIRTH_DATE,PLASMA.[visit date])/365.25 <=89 THEN 
								CAST((FLOOR(DATEDIFF(DD,PT.BIRTH_DATE,PLASMA.[visit date])/365.25)) AS VARCHAR)
		  WHEN DATEDIFF(DD,PT.BIRTH_DATE,PLASMA.[visit date])/365.25 > 89 THEN '90+'
		  ELSE '??' END AS 'Age at the time of the blood draw' 
	,PT.gender	AS 'Gender'
	,PT.FIRST_RACE		AS 'Race'
	,PT.ETHNIC_GROUP	AS 'Ethnicity'
	,WHO_M.WHO_SCORE_GROUPED	AS 'Max WHO Score Group'
	,WHO_M.who_score AS 'Max WHO Score'
	,WHO_M.MAX_S AS 'Max WHO Score Numeric'
	,BMI.meas_value		AS 'BMI(most recent)'
	,z3.positive_test_time
	,z3.INPT_ADMIT_TIME			AS 'admit_time'
	,z3.OXYGEN_RX				AS 'Oxygen Start Time'
	,z3.OXYGEN_END				AS 'Oxygen End Time'
	,z3.INT_DIALYSIS_RX			AS 'INT Dialysis Start Time'
	,z3.INT_DIALYSIS_END		AS 'INT Dialysis End Time'
	,z3.NIPPV_RX				AS 'NIPPV Start Time'
	,z3.NIPPV_END				AS 'NIPPV End Time'
	,z3.HIFLOW_RX				AS 'Hi flow Start Time'
	,z3.HIFLOW_END				AS 'Hi flow End Time'
	,z3.VENT_START				AS 'Vent Start Time'
	,z3.VENT_END				AS 'Vent End Time'
	,z3.IVPRESSOR_RX			AS 'IV Pressor Start Time'
	,z3.IVPRESSOR_END			AS 'IV Pressor End Time'
	,z3.CRRT_RX					AS 'CRRT Start Time'
	,z3.CRRT_END				AS 'CRRT End Time'
	,z3.INIT_DNR_DNI			AS 'DNR/DNI Time'
	,z3.FINAL_HOSP_DISCH_TIME	AS 'Final Hospital Discharge Time'
	,z3.DEATH_TIME				AS 'Death Time'	
	,CASE WHEN diab.icd10_code IS NOT NULL THEN 'Y' ELSE 'N' END AS 'Diabetes Y/N'
	,CASE WHEN cad.icd10_code IS NOT NULL THEN 'Y' ELSE 'N' END AS 'Coronary Disease Y/N'
	,CASE WHEN hf.icd10_code IS NOT NULL THEN 'Y' ELSE 'N' END AS 'Heart Failure Y/N'
	,CASE WHEN sot.icd10_code IS NOT NULL THEN 'Y' ELSE 'N' END AS 'Solid Organ Transplant Y/N'
	,CASE WHEN HIV.icd10_code IS NOT NULL THEN 'Y' ELSE 'N' END AS 'HIV Y/N'
	,CASE WHEN HCV.icd10_code IS NOT NULL THEN 'Y' ELSE 'N' END AS 'HCV Y/N'
	,CASE WHEN HTN.icd10_code IS NOT NULL THEN 'Y' ELSE 'N' END AS 'HTN Y/N'
	,CASE WHEN CLD.icd10_code IS NOT NULL THEN 'Y' ELSE 'N' END AS 'Chronic Lung Disease Y/N'
	,CASE WHEN ATD.icd10_code IS NOT NULL THEN 'Y' ELSE 'N' END AS 'Autoimmune Disease Y/N'
	,CASE WHEN SMK.tobacco_user ='Yes' OR smoking_tobacco_use like '%current%' OR cigarettes_yn='Y'
			THEN 'Y'
		  WHEN SMK.osler_id IS NULL THEN NULL
		  ELSE 'N' END AS 'Current Smoker Y/N'
	,CASE WHEN CNCR.OSLER_ID IS NOT NULL THEN 'Y' ELSE 'N' END AS 'Cancer Y/N'
	,WBC.WBC_ord_value	AS 'WBC'
	,WBC.specimen_recv_time AS 'WBC specimen recieved time'
	,LYM.Lymphabs_ord_value	AS 'Total lymphocyte count'
	,LYM.specimen_recv_time AS 'lymphocyte specimen recieved time'
	,NEU.ord_num_value	AS 'Total neutrophil count'
	,NEU.specimen_recv_time AS 'Neutrophil specimen recieved time'
	,CRP.CRP_ord_value	AS 'CRP'
	,crp.specimen_recv_time AS 'CRP specimen recieved time'
	,DDM.DDimer_ord_num_value	AS 'D-Dimer'
	,DDM.specimen_recv_time		AS 'D-Dimer specimen recieved time'
	--,ISNULL(WHO.START,WHO.HOSP_ADMSN_TIME) AS 'Max WHO Start Time'
	--,WHO.[END] AS 'Max WHO End Time'
	,WHO.who_score_grouped AS 'Current WHO Score Group'
	,WHO.who_score AS 'Current WHO Score'
	,WHO.who_score_numeric AS 'Current WHO Score Numeric'
	,vax.Vaccine_Type
	,vax.jab_date
	,seq.lineage
	,seq.clade
	,pcr.order_time "Positive_PCR_Time"
	--,who.rn
--	,MEAS.MEAS_DISP_NAME,meas_id,RECORDED_TIME
--INTO #T
INTO DBO.CCDA2046_Cox_Final_NoHyphens
FROM 
	CCPSEI_Projection..crms_enrollments enroll
	INNER JOIN PMAP_Analytics.[dbo].[CoxAvailSpecimens_Current] plasma	on plasma.[Study ID]=enroll.[subject_number]
	INNER JOIN CCPSEI_Projection..derived_epic_patient PT ON PT.OSLER_ID = ENROLL.OSLER_ID
	LEFT JOIN COVID_Projection.[dbo].covid_pmcoe_ipevents_v5 z3 ON z3.OSLER_ID = PT.OSLER_ID
	LEFT JOIN CTE_DX diab on diab.OSLER_ID=ENROLL.OSLER_ID 
							AND (diab.icd10_code like 'E11%'
							or diab.icd10_code like 'Z79.4%')		--diabetes
	LEFT JOIN CTE_DX cad on cad.OSLER_ID=ENROLL.OSLER_ID
							AND cad.icd10_code like 'I25%'			  --coronary disease
	LEFT JOIN CTE_DX hf on hf.OSLER_ID=ENROLL.OSLER_ID
							AND hf.icd10_code like 'I50%'			 --heart failure
	LEFT JOIN CTE_DX sot on sot.OSLER_ID=ENROLL.OSLER_ID
							and (sot.icd10_code like 'Z94.[0-4]%'
								or sot.icd10_code like 'Z94.9%'
								or sot.icd10_code like 'Z94.83%')	 --solid organ transplant
	LEFT JOIN CTE_DX HIV ON HIV.osler_id=ENROLL.osler_id
							AND (HIV.icd10_code like 'B20%'
								or HIV.icd10_code like 'Z21%')	 --HIV
	LEFT JOIN CTE_DX HCV ON HCV.osler_id=ENROLL.osler_id		
							AND (HCV.icd10_code like 'Z22.52%'
								OR HCV.icd10_code like 'B18.2%'
								OR HCV.icd10_code like 'B19.2%')	 --HCV
	LEFT JOIN CTE_DX HTN ON HTN.osler_id=ENROLL.osler_id		
							AND HTN.icd10_code like 'I10%'		--HTN	
	LEFT JOIN CTE_DX CLD ON CLD.osler_id = enroll.osler_id
							AND (CLD.icd10_code like 'I27.8%'
							or CLD.icd10_code like 'I27.9%'
							or CLD.icd10_code LIKE 'J4[01234567]%' 
							or CLD.icd10_code LIKE 'J6[01234567]%' 
							or CLD.icd10_code like 'J68.4%'
							or CLD.icd10_code like 'J70.1%'
							or CLD.icd10_code like 'J70.3%'
							or CLD.icd10_code like 'J81.1%'
							or CLD.icd10_code like 'J82%'
							or CLD.icd10_code like 'J84%'
							or CLD.icd10_code like 'J98.4%')		 --Chronic Lung disease		
	LEFT JOIN CTE_DX ATD ON ATD.osler_id = enroll.osler_id
							AND (ATD.icd10_code like 'M32%'
							OR ATD.icd10_code like 'L93%'
							OR ATD.icd10_code like 'M05%'
							OR ATD.icd10_code like 'M06%'
							OR ATD.icd10_code like 'L40%'
							OR ATD.icd10_code like 'K50%'
							OR ATD.icd10_code like 'K51%'
							OR ATD.icd10_code like 'M31%'
							OR ATD.icd10_code like 'M33%'
							OR ATD.icd10_code like 'M45%'
							OR ATD.icd10_code like 'M34%')			--Autoimmune Disease 	
	LEFT JOIN CTE_CUR_SMK SMK ON SMK.osler_id = enroll.osler_id	AND SMK.RN =1	
	LEFT JOIN CTE_WBC WBC ON WBC.[Study ID] = plasma.[Study ID]	
							AND plasma.[Visit Date] = WBC.[Visit Date]	
							AND WBC.RN = 1
	LEFT JOIN CTE_LYM LYM ON LYM.[Study ID] = plasma.[Study ID]	
							AND plasma.[Visit Date] = LYM.[Visit Date]		
							AND LYM.RN = 1
	LEFT JOIN CTE_NEU NEU ON NEU.[Study ID] = plasma.[Study ID]	
							AND plasma.[Visit Date] = NEU.[Visit Date]		
							AND NEU.RN = 1
	LEFT JOIN CTE_CRP CRP ON CRP.[Study ID] = plasma.[Study ID]	
							AND plasma.[Visit Date] = CRP.[Visit Date]		
							AND CRP.RN = 1
	LEFT JOIN CTE_DDM DDM ON DDM.[Study ID] = plasma.[Study ID]	
							AND plasma.[Visit Date] = DDM.[Visit Date]		
							AND DDM.RN = 1
	LEFT JOIN CTE_BMI BMI ON BMI.OSLER_ID=ENROLL.OSLER_ID AND BMI.RN = 1
	LEFT JOIN CTE_CNCR CNCR ON CNCR.OSLER_ID = ENROLL.OSLER_ID
	LEFT JOIN (SELECT * FROM CTE_WHO_CURRENT WHERE RN=1) WHO ON WHO.OSLER_ID = ENROLL.OSLER_ID AND WHO.[Visit Date] = plasma.[Visit Date]
	LEFT JOIN CTE_WHO_MAX WHO_M ON WHO_M.osler_id = ENROLL.osler_id
	LEFT JOIN CTE_Vacc_Status vax ON ENROLL.osler_id = vax.osler_id
	LEFT JOIN CTE_Sequence seq	ON ENROLL.osler_id = seq.osler_id
	LEFT JOIN CTE_PCR pcr ON ENROLL.osler_id = pcr.osler_id AND pcr.RN = 1

ORDER BY SUBJECT_NUMBER								

--SELECT DISTINCT * FROM #T WHERE [D-Dimer] = '9999999'
GO


