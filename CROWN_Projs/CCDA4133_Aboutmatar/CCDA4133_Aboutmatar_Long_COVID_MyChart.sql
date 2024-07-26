/****************************************************************************************
Author:			mcook49
Date:			2022-09-21
JIRA:			[CCDA-4133]
Description:	Long COVID-19 survey

Inclusion:		
1.	Age 18+ 
2.	Patients hospitalized due to COVID-19 infection (U07.1, J12.81) for 10+ days between July 1, 2021 and August 1, 2022 at JHH, HCGH, Suburban, BVMC, Sibley
Exclusion:																													
																															
1.	Patients known to be deceased in Epic.																					
2.	Patients who have opted out of being contacted for MyChart recruitment.  
3.	Patients who have opted out of being contacted for any reason. 
4.	Patients who do not speak English
5.	Patients with impairment that affects their capacity to speak and comprehend 
				
****************************************************************************************/
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET NOCOUNT ON;

--COVID-19 Infection
IF OBJECT_ID(N'TEMPDB..#inc_DX_LIST') IS NULL CREATE TABLE #inc_DX_LIST (DX_ID NUMERIC)
INSERT INTO #inc_DX_LIST (DX_ID)
SELECT DX_ID FROM CLARITY..EDG_CURRENT_ICD10 WHERE CODE LIKE 'U07.1%' OR CODE LIKE 'J12.81'

--Get patients Hospitalized with Covid
IF OBJECT_ID(N'TEMPDB..#inc_dx') IS NOT NULL DROP TABLE #inc_dx
SELECT T.PAT_ID
INTO #inc_dx
FROM (
   SELECT DISTINCT enc.PAT_ID--, enc.HOSP_ADMSN_TIME, enc.HOSP_DISCH_TIME, DATEDIFF(dd, enc.HOSP_ADMSN_TIME, enc.HOSP_DISCH_TIME) "los_manual", los.LENGTH_OF_STAY_DAYS
   FROM clarity..PAT_ENC_HSP enc
   INNER JOIN clarity..HSP_ACCOUNT ha ON ha.HSP_ACCOUNT_ID = enc.HSP_ACCOUNT_ID
   INNER JOIN clarity..HSP_ACCT_DX_LIST hspdx ON hspdx.hsp_account_id = ha.hsp_account_id
   INNER JOIN #inc_DX_LIST dx on hspdx.DX_ID = dx.DX_ID
   LEFT JOIN clarity..length_of_stay los on enc.PAT_ENC_CSN_ID = los.PAT_ENC_CSN_ID
   WHERE enc.ADT_PAT_CLASS_C IN (101, 103, 104) --Inpatient, Outpatient, Observation (from Zeger definition)
      AND enc.HOSP_ADMSN_TIME >= '2021-07-01' --Admitted by July 1, 2021
	  AND enc.HOSP_DISCH_TIME <= '2022-08-01' --Discharged by August 1
	  AND los.LENGTH_OF_STAY_DAYS >= 10 --Hospitalized for 10+ days
      AND enc.ADT_PATIENT_STAT_C NOT IN (1, 5, 6) --Exclude Preadmission, Leave of Absence, and Hospital Outpatient Visit (from Zeger definition)
      AND enc.ADMIT_CONF_STAT_C NOT IN (3) --Exclude Canceled (from Zeger definition)
      AND ha.COMPLETN_STS_HA_C = 4 --Completed (from Zeger definition)
   ) T

SELECT DISTINCT
PAT.PAT_ID	AS 'ID'
FROM
	CLARITY.DBO.PATIENT PAT
	INNER JOIN	CLARITY.dbo.PATIENT_4					pat4	on pat.pat_id = pat4.pat_id 
	INNER JOIN  CLARITY.dbo.PATIENT_5					pat5	on pat.pat_id = pat5.pat_id
	INNER JOIN	CLARITY.dbo.PATIENT_MYC					mychart on mychart.pat_id = pat.pat_id
	INNER JOIN	CLARITY.dbo.MYC_PATIENT					myc		on myc.pat_id = pat.pat_id
	INNER JOIN	CLARITY.dbo.COMMUNICATION_PREFERENCES	cp		on cp.PREFERENCES_ID=pat4.PREFERENCES_ID
	INNER JOIN	CLARITY.dbo.COMM_PREFERENCES_APRV		aprv	on cp.PREFERENCES_ID=aprv.PREFERENCES_ID and cp.LINE=aprv.GROUP_LINE
		LEFT JOIN	CLARITY.dbo.PATIENT_FYI_FLAGS fyif	ON fyif.PATIENT_ID = pat.PAT_ID and fyif.PAT_FLAG_TYPE_C = '1092'
	INNER JOIN CLARITY..PAT_ENC PE ON PE.PAT_ID = PAT.PAT_ID
	INNER JOIN #inc_dx DX ON DX.PAT_ID = PAT.PAT_ID
WHERE 
FLOOR(DATEDIFF(DD,PAT.BIRTH_DATE,GETDATE())/365.25) >= 18 	--Age currently >= 18
AND 	MYCHART.MYCHART_STATUS_C = '1'					-- PATIENTS WITH AN ACTIVE MYCHART ACCOUNT (DEFINED AS HAVING A LOG IN WITHIN THE LAST YEAR – BASED ON EXTRACT DATE)
AND		ISNULL(PAT4.PAT_LIVING_STAT_C,0) = '1'			-- EXCLUDE PATIENTS LISTED AS DECEASED IN EPIC
AND		FYIF.PATIENT_ID IS NULL							-- EXCLUDE PATIENTS WHO HAVE OPTED OUT OF BEING CONTACTED FOR RESEARCH RECRUITME
AND		CP.COMMUNICATION_CONCEPT_ID = '28102'			-- Include patients who approved bulk communication as a communication concept.
AND		APRV.APRV_MEDIA_C = '2'							-- Include patients where MyChart is the approved communication media for a communication concept.
AND		PAT.EMAIL_ADDRESS IS NOT NULL					-- EMAIL ADDRESS MUST NOT BE NULL 
AND		PAT.EMAIL_ADDRESS LIKE '%@%.%'					-- EMAIL MUST BE IN PROPER FORMAT ABC@GMAIL.COM 
AND		ISNULL(PE.SERV_AREA_ID,11)=11
AND		(		ISNULL(PE.EFFECTIVE_DEPT_ID,DEPARTMENT_ID) LIKE '1101%' --JHH
			OR	ISNULL(PE.EFFECTIVE_DEPT_ID,DEPARTMENT_ID) LIKE '1103%'--HCGH
			OR	ISNULL(PE.EFFECTIVE_DEPT_ID,DEPARTMENT_ID) LIKE '1105%'--Suburban
			OR	ISNULL(PE.EFFECTIVE_DEPT_ID,DEPARTMENT_ID) LIKE '1102%'--BVMC
			OR	ISNULL(PE.EFFECTIVE_DEPT_ID,DEPARTMENT_ID) LIKE '1104%'--Sibley
		)
AND		ISNULL(PAT.INTRPTR_NEEDED_YN,'N') <> 'Y'		--EXCLUDE interpreter=yes (i.e. exclude pts who do not speak english)
AND		ISNULL(pat5.SPEECH_IMPAIRED_C, 0) <> 1			--EXCLUDE patients with speech impairment
AND		ISNULL(pat5.SPEECH_IMPAIRED_C, 0) <> 1			--EXCLUDE patients with speech impairment
