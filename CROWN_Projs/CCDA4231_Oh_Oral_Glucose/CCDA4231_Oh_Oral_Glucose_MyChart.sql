/****************************************************************************************
Author:			mcook49
Date:			2022-09-28
JIRA:			[CCDA-4231]
Description:	Oral Glucose Tolerance Test for Alzheimer�s Disease Biomarker Development

Inclusion:		
1.	Age: 40 - 90 as of the query run.
2.	Seen at all JHHS location, except ACH.
3.	Diagnosis of Mild Cognitive Impairment (MCI) or Alzheimer�s disease (AD) at any time. Will be looking for diagnosis in encounter diagnosis, billing diagnosis, and problem list (active)

Study team will provide a list of diagnosis of interests.

4.	Have active Proxy MyChart account.


Exclusion:																													
																															
1.	Patients known to be deceased in Epic.
2.	Patients have opted out of being contacted for MyChart recruitment.  
3.	Patients have opted out of being contacted for any reason. 
4.	Patients with diagnosis of the followings in last two years.:
	a.	Type 2 Diabetes
	b.	Have had a stroke
	c.	Have multiple sclerosis
	d.	Parkinson�s disease

				
****************************************************************************************/
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET NOCOUNT ON;

--MCI or AD
IF OBJECT_ID(N'TEMPDB..#inc_dx') IS NULL CREATE TABLE #inc_dx (DX_ID NUMERIC)
INSERT INTO #inc_dx (DX_ID)
SELECT DX_ID FROM CLARITY..EDG_CURRENT_ICD10 
WHERE CODE LIKE 'G31.84'
   OR CODE LIKE 'I69%'
   OR CODE LIKE 'R41%'
   OR CODE LIKE 'G30%'
   OR CODE LIKE 'F00%'
   OR CODE LIKE 'F01%'
   OR CODE LIKE 'F02%'
   OR CODE LIKE 'F03%'
   OR CODE LIKE 'G30%'
   OR CODE LIKE 'G31.0%'
   OR CODE LIKE 'G31.1%'
   OR CODE LIKE 'G31.83'

--T2DM, Stroke, MS, or Parkinson's
IF OBJECT_ID(N'TEMPDB..#excl_dx') IS NOT NULL DROP TABLE #excl_dx
SELECT DISTINCT DX_ID,CODE
INTO #excl_dx
FROM EDG_CURRENT_ICD10
WHERE CODE LIKE 'E11.9%'
OR CODE LIKE 'G20%'
OR CODE LIKE 'G35%'
OR CODE LIKE 'G45.0%'
OR CODE LIKE 'G45.1%'
OR CODE LIKE 'G45.2%'
OR CODE LIKE 'G45.8%'
OR CODE LIKE 'G45.9%'
OR CODE LIKE 'G46.0%'
OR CODE LIKE 'G46.1%'
OR CODE LIKE 'G46.2%'
OR CODE LIKE 'G46.3%'
OR CODE LIKE 'G46.4%'
OR CODE LIKE 'G46.5%'
OR CODE LIKE 'G46.6%'
OR CODE LIKE 'G46.7%'
OR CODE LIKE 'G46.8%'
OR CODE LIKE 'G97.31'
OR CODE LIKE 'G97.32'
OR CODE LIKE 'I60.00'
OR CODE LIKE 'I60.01'
OR CODE LIKE 'I60.02'
OR CODE LIKE 'I60.10'
OR CODE LIKE 'I60.11'
OR CODE LIKE 'I60.12'
OR CODE LIKE 'I60.20'
OR CODE LIKE 'I60.21'
OR CODE LIKE 'I60.22'
OR CODE LIKE 'I60.30'
OR CODE LIKE 'I60.31'
OR CODE LIKE 'I60.32'
OR CODE LIKE 'I60.4%'
OR CODE LIKE 'I60.50'
OR CODE LIKE 'I60.51'
OR CODE LIKE 'I60.52'
OR CODE LIKE 'I60.6%'
OR CODE LIKE 'I60.7%'
OR CODE LIKE 'I60.8%'
OR CODE LIKE 'I60.9%'
OR CODE LIKE 'I61.0%'
OR CODE LIKE 'I61.1%'
OR CODE LIKE 'I61.2%'
OR CODE LIKE 'I61.3%'
OR CODE LIKE 'I61.4%'
OR CODE LIKE 'I61.5%'
OR CODE LIKE 'I61.6%'
OR CODE LIKE 'I61.8%'
OR CODE LIKE 'I61.9%'
OR CODE LIKE 'I63.00'
OR CODE LIKE 'I63.011'
OR CODE LIKE 'I63.012'
OR CODE LIKE 'I63.013'
OR CODE LIKE 'I63.019'
OR CODE LIKE 'I63.02'
OR CODE LIKE 'I63.031'
OR CODE LIKE 'I63.032'
OR CODE LIKE 'I63.039'
OR CODE LIKE 'I63.09'
OR CODE LIKE 'I63.10'
OR CODE LIKE 'I63.111'
OR CODE LIKE 'I63.112'
OR CODE LIKE 'I63.119'
OR CODE LIKE 'I63.12'
OR CODE LIKE 'I63.131'
OR CODE LIKE 'I63.132'
OR CODE LIKE 'I63.139'
OR CODE LIKE 'I63.19'
OR CODE LIKE 'I63.20'
OR CODE LIKE 'I63.211'
OR CODE LIKE 'I63.212'
OR CODE LIKE 'I63.213'
OR CODE LIKE 'I63.219'
OR CODE LIKE 'I63.22'
OR CODE LIKE 'I63.231'
OR CODE LIKE 'I63.232'
OR CODE LIKE 'I63.233'
OR CODE LIKE 'I63.239'
OR CODE LIKE 'I63.29'
OR CODE LIKE 'I63.30'
OR CODE LIKE 'I63.311'
OR CODE LIKE 'I63.312'
OR CODE LIKE 'I63.313'
OR CODE LIKE 'I63.319'
OR CODE LIKE 'I63.321'
OR CODE LIKE 'I63.322'
OR CODE LIKE 'I63.323'
OR CODE LIKE 'I63.329'
OR CODE LIKE 'I63.331'
OR CODE LIKE 'I63.332'
OR CODE LIKE 'I63.333'
OR CODE LIKE 'I63.339'
OR CODE LIKE 'I63.341'
OR CODE LIKE 'I63.342'
OR CODE LIKE 'I63.343'
OR CODE LIKE 'I63.349'
OR CODE LIKE 'I63.39'
OR CODE LIKE 'I63.40'
OR CODE LIKE 'I63.411'
OR CODE LIKE 'I63.412'
OR CODE LIKE 'I63.413'
OR CODE LIKE 'I63.419'
OR CODE LIKE 'I63.421'
OR CODE LIKE 'I63.422'
OR CODE LIKE 'I63.423'
OR CODE LIKE 'I63.429'
OR CODE LIKE 'I63.431'
OR CODE LIKE 'I63.432'
OR CODE LIKE 'I63.433'
OR CODE LIKE 'I63.439'
OR CODE LIKE 'I63.441'
OR CODE LIKE 'I63.442'
OR CODE LIKE 'I63.443'
OR CODE LIKE 'I63.449'
OR CODE LIKE 'I63.49'
OR CODE LIKE 'I63.50'
OR CODE LIKE 'I63.511'
OR CODE LIKE 'I63.512'
OR CODE LIKE 'I63.513'
OR CODE LIKE 'I63.519'
OR CODE LIKE 'I63.521'
OR CODE LIKE 'I63.522'
OR CODE LIKE 'I63.523'
OR CODE LIKE 'I63.529'
OR CODE LIKE 'I63.531'
OR CODE LIKE 'I63.532'
OR CODE LIKE 'I63.533'
OR CODE LIKE 'I63.539'
OR CODE LIKE 'I63.541'
OR CODE LIKE 'I63.542'
OR CODE LIKE 'I63.543'
OR CODE LIKE 'I63.549'
OR CODE LIKE 'I63.59'
OR CODE LIKE 'I63.6%'
OR CODE LIKE 'I63.8%'
OR CODE LIKE 'I63.9%'
OR CODE LIKE 'I66.01'
OR CODE LIKE 'I66.02'
OR CODE LIKE 'I66.03'
OR CODE LIKE 'I66.09'
OR CODE LIKE 'I66.11'
OR CODE LIKE 'I66.12'
OR CODE LIKE 'I66.13'
OR CODE LIKE 'I66.19'
OR CODE LIKE 'I66.21'
OR CODE LIKE 'I66.22'
OR CODE LIKE 'I66.23'
OR CODE LIKE 'I66.29'
OR CODE LIKE 'I66.3%'
OR CODE LIKE 'I66.8%'
OR CODE LIKE 'I66.9%'
OR CODE LIKE 'I67.841'
OR CODE LIKE 'I67.848'
OR CODE LIKE 'I67.89'
OR CODE LIKE 'I97.810'
OR CODE LIKE 'I97.811'
OR CODE LIKE 'I97.820'
OR CODE LIKE 'I97.821'

--Patients with proxy acocunt
IF OBJECT_ID(N'TEMPDB..#prox') IS NOT NULL DROP TABLE #prox
SELECT DISTINCT PAT_ID
INTO #prox
FROM PAT_MYC_PRXY_ACSS
WHERE PROXY_STATUS_C = 1

--Get included patients
IF OBJECT_ID(N'TEMPDB..#inc') IS NOT NULL DROP TABLE #inc
SELECT DISTINCT DX.*
INTO #inc
FROM 
		(
		SELECT DISTINCT PL.PAT_ID 
		FROM CLARITY..PROBLEM_LIST PL
		JOIN CLARITY..CLARITY_EDG EDG ON EDG.DX_ID=PL.DX_ID
		INNER JOIN #inc_dx I ON I.DX_ID = PL.DX_ID
		WHERE ISNULL(PL.PROBLEM_STATUS_C,0) IN(0,1) -- ACTIVE
		UNION
		SELECT DISTINCT PAT.PAT_ID --,ISNULL(ENC.EFFECTIVE_DATE_DTTM,ENC.CONTACT_DATE)
		FROM CLARITY..PATIENT PAT 
		JOIN CLARITY..PAT_ENC ENC ON ENC.PAT_ID=PAT.PAT_ID
		JOIN CLARITY..PAT_ENC_DX DX ON DX.PAT_ENC_CSN_ID=ENC.PAT_ENC_CSN_ID
		JOIN CLARITY..CLARITY_EDG EDG ON EDG.DX_ID=DX.DX_ID
		INNER JOIN #inc_dx I ON I.DX_ID = DX.DX_ID
		UNION
		SELECT DISTINCT PAT.PAT_ID
		FROM        
		CLARITY..PATIENT PAT 
		JOIN CLARITY..PAT_ENC ENC ON ENC.PAT_ID=PAT.PAT_ID
		JOIN CLARITY..ARPB_TRANSACTIONS ARPB ON ARPB.PATIENT_ID=PAT.PAT_ID
		JOIN CLARITY..CLARITY_EDG EDG ON EDG.DX_ID=ARPB.PRIMARY_DX_ID 
		INNER JOIN #inc_dx I ON I.DX_ID = EDG.DX_ID
		UNION
		SELECT DISTINCT PAT.PAT_ID  
		FROM CLARITY..PATIENT PAT
		INNER JOIN CLARITY..PAT_ENC PE ON PAT.PAT_ID = PE.PAT_ID
		INNER JOIN CLARITY..HSP_ACCT_DX_LIST DXL  ON PE.HSP_ACCOUNT_ID = DXL.HSP_ACCOUNT_ID	
		INNER JOIN CLARITY..CLARITY_EDG EDG ON EDG.DX_ID = DXL.DX_ID
		INNER JOIN #inc_dx I ON I.DX_ID = EDG.DX_ID
		) DX
		INNER JOIN PATIENT P ON P.PAT_ID = DX.PAT_ID
		INNER JOIN PAT_ENC PE ON PE.PAT_ID = DX.PAT_ID
		INNER JOIN CLARITY_DEP DEP ON DEP.DEPARTMENT_ID = ISNULL(PE.EFFECTIVE_DEPT_ID,PE.DEPARTMENT_ID)
		INNER JOIN #prox on P.PAT_ID = #prox.PAT_ID
WHERE
		ISNULL(DEP.SERV_AREA_ID,11)=11
		AND DEP.DEPARTMENT_ID NOT LIKE '1108%' --Not ACH
		AND DEP.DEPARTMENT_ID NOT LIKE '1150%' --Not ACH
		AND ISNULL(PE.APPT_STATUS_C,2) = 2 
		AND FLOOR(DATEDIFF(DD,P.BIRTH_DATE,GETDATE())/365.25) BETWEEN 40 AND 90
		--AND pe.ENC_TYPE_C in	('1000','1001','1003','1004','101','108','1199','1200','1201','121','1214','2','200','210','2100','2101','2500','2501','2502','2508','2521','2522','2525','2526','2529','2531','50','55','76','81','91','3') --face to face visit
		--AND ISNULL(PE.EFFECTIVE_DATE_DT,PE.CONTACT_DATE)>=DATEADD(MONTH,-12,GETDATE())

--Exclude pts with T2DM, Stroke, MS, or Parkinson's
IF OBJECT_ID(N'TEMPDB..#excl') IS NOT NULL DROP TABLE #excl
SELECT DISTINCT t.*
INTO #excl
FROM 
		(
		SELECT DISTINCT PL.PAT_ID 
		FROM CLARITY..PROBLEM_LIST PL
		JOIN CLARITY..CLARITY_EDG EDG ON EDG.DX_ID=PL.DX_ID
		INNER JOIN #excl_dx I ON I.DX_ID = PL.DX_ID
		WHERE ISNULL(PL.PROBLEM_STATUS_C,0) IN(0,1) -- ACTIVE
		UNION
		SELECT DISTINCT PAT.PAT_ID --,ISNULL(ENC.EFFECTIVE_DATE_DTTM,ENC.CONTACT_DATE)
		FROM CLARITY..PATIENT PAT 
		JOIN CLARITY..PAT_ENC ENC ON ENC.PAT_ID=PAT.PAT_ID
		JOIN CLARITY..PAT_ENC_DX DX ON DX.PAT_ENC_CSN_ID=ENC.PAT_ENC_CSN_ID
		JOIN CLARITY..CLARITY_EDG EDG ON EDG.DX_ID=DX.DX_ID
		INNER JOIN #excl_dx I ON I.DX_ID = DX.DX_ID
		UNION
		SELECT DISTINCT PAT.PAT_ID
		FROM        
		CLARITY..PATIENT PAT 
		JOIN CLARITY..PAT_ENC ENC ON ENC.PAT_ID=PAT.PAT_ID
		JOIN CLARITY..ARPB_TRANSACTIONS ARPB ON ARPB.PATIENT_ID=PAT.PAT_ID
		JOIN CLARITY..CLARITY_EDG EDG ON EDG.DX_ID=ARPB.PRIMARY_DX_ID 
		INNER JOIN #excl_dx I ON I.DX_ID = EDG.DX_ID
		UNION
		SELECT DISTINCT PAT.PAT_ID  
		FROM CLARITY..PATIENT PAT
		INNER JOIN CLARITY..PAT_ENC PE ON PAT.PAT_ID = PE.PAT_ID
		INNER JOIN CLARITY..HSP_ACCT_DX_LIST DXL  ON PE.HSP_ACCOUNT_ID = DXL.HSP_ACCOUNT_ID	
		INNER JOIN CLARITY..CLARITY_EDG EDG ON EDG.DX_ID = DXL.DX_ID--4599
		INNER JOIN #excl_dx I ON I.DX_ID = EDG.DX_ID
		) t

SELECT DISTINCT
PAT.PAT_ID	AS 'ID'
FROM
	CLARITY.DBO.PATIENT PAT
	INNER JOIN CLARITY..IDENTITY_ID II ON II.PAT_ID = PAT.PAT_ID AND II.IDENTITY_TYPE_ID = 0
	INNER JOIN	CLARITY.dbo.PATIENT_4					pat4	on pat.pat_id = pat4.pat_id 
	INNER JOIN	CLARITY.dbo.PATIENT_MYC					mychart on mychart.pat_id = pat.pat_id
	INNER JOIN	CLARITY.dbo.MYC_PATIENT					myc		on myc.pat_id = pat.pat_id
	INNER JOIN	CLARITY.dbo.COMMUNICATION_PREFERENCES	cp		on cp.PREFERENCES_ID=pat4.PREFERENCES_ID
	INNER JOIN	CLARITY.dbo.COMM_PREFERENCES_APRV		aprv	on cp.PREFERENCES_ID=aprv.PREFERENCES_ID and cp.LINE=aprv.GROUP_LINE
		LEFT JOIN	CLARITY.dbo.PATIENT_FYI_FLAGS fyif	ON fyif.PATIENT_ID = pat.PAT_ID and fyif.PAT_FLAG_TYPE_C = '1092'
	INNER JOIN #inc DX ON DX.PAT_ID = PAT.PAT_ID
	LEFT JOIN  (
		SELECT * FROM #excl
		) EXCL ON EXCL.PAT_ID = DX.PAT_ID
WHERE 
	 	MYCHART.MYCHART_STATUS_C = '1'					-- PATIENTS WITH AN ACTIVE MYCHART ACCOUNT (DEFINED AS HAVING A LOG IN WITHIN THE LAST YEAR � BASED ON EXTRACT DATE)
AND		ISNULL(PAT4.PAT_LIVING_STAT_C,0) = '1'			-- EXCLUDE PATIENTS LISTED AS DECEASED IN EPIC
AND		FYIF.PATIENT_ID IS NULL							-- EXCLUDE PATIENTS WHO HAVE OPTED OUT OF BEING CONTACTED FOR RESEARCH RECRUITME
AND		CP.COMMUNICATION_CONCEPT_ID = '28102'
AND		APRV.APRV_MEDIA_C = '2'	
AND		PAT.EMAIL_ADDRESS IS NOT NULL					-- EMAIL ADDRESS MUST NOT BE NULL 
AND		PAT.EMAIL_ADDRESS LIKE '%@%.%'					-- EMAIL MUST BE IN PROPER FORMAT ABC@GMAIL.COM 
AND		EXCL.PAT_ID IS NULL
