/****************************************************************************************
Author:			gli18
Date:			2022-07-15
JIRA:			[CCDA-4023]
Description:	A Phase 1b/2, randomized, double-blind, placebo-controlled, multi-center study of STMC-103H in neonates and infants at risk for developing allergic disease

Inclusion:		
1.	Age: Birth to 6 years of age as of the query runs.
2.	Patients of Pediatric allergy clinic (Dep_ID: 110103536).
3.	Have active Proxy MyChart account.







Exclusion:		

1.	Patients known to be deceased in Epic.
2.	Patients’ proxy has opted out of being contacted for MyChart recruitment.  
3.	Patients’ proxy have opted out of being contacted for any reason. 


			
****************************************************************************************/

IF OBJECT_ID(N'TEMPDB..#inc_pt') IS NOT NULL DROP TABLE #inc_pt
SELECT DISTINCT 
P.PAT_ID,PXY.PROXY_PAT_ID
INTO #inc_pt
FROM 
	PATIENT P
	INNER JOIN PAT_ENC PE ON PE.PAT_ID = P.PAT_ID
	INNER JOIN CLARITY_DEP DEP ON DEP.DEPARTMENT_ID = ISNULL(PE.EFFECTIVE_DEPT_ID,PE.DEPARTMENT_ID)
	INNER JOIN PAT_MYC_PRXY_ACSS PXY ON PXY.PAT_ID = PE.PAT_ID
WHERE
	DEP.DEPARTMENT_ID = '110103536'
	AND ISNULL(PE.APPT_STATUS_C,2) = 2 
	AND FLOOR(DATEDIFF(DD,P.BIRTH_DATE,GETDATE())/365.25) BETWEEN 0 AND 6
	AND pe.ENC_TYPE_C in	('1000','1001','1003','1004','101','108','1199','1200','1201','121','1214','2','200','210','2100','2101','2500','2501','2502','2508','2521','2522','2525','2526','2529','2531','50','55','76','81','91') --face to face visit
	AND PXY.PROXY_STATUS_C = 1

SELECT DISTINCT
PAT.PAT_ID	AS 'ID'--,C.CITY,CT.county,PAT.CITY,ZCC.NAME
FROM
	CLARITY.DBO.PATIENT PAT
	INNER JOIN #inc_pt INC ON INC.PAT_ID = PAT.PAT_ID
	INNER JOIN CLARITY..IDENTITY_ID II ON II.PAT_ID = PAT.PAT_ID AND II.IDENTITY_TYPE_ID = 0
	INNER JOIN	CLARITY.dbo.PATIENT_4					pat4	on pat.pat_id = pat4.pat_id 
	INNER JOIN	CLARITY.dbo.PATIENT_MYC					mychart on mychart.pat_id = INC.PROXY_PAT_ID
	INNER JOIN	CLARITY.dbo.MYC_PATIENT					myc		on myc.pat_id = INC.PROXY_PAT_ID
	INNER JOIN	CLARITY.dbo.COMMUNICATION_PREFERENCES	cp		on cp.PREFERENCES_ID=pat4.PREFERENCES_ID
	INNER JOIN	CLARITY.dbo.COMM_PREFERENCES_APRV		aprv	on cp.PREFERENCES_ID=aprv.PREFERENCES_ID and cp.LINE=aprv.GROUP_LINE
		LEFT JOIN	CLARITY.dbo.PATIENT_FYI_FLAGS fyif	ON fyif.PATIENT_ID = INC.PROXY_PAT_ID and fyif.PAT_FLAG_TYPE_C = '1092'
		
WHERE 
	 	MYCHART.MYCHART_STATUS_C = '1'					-- PATIENTS WITH AN ACTIVE MYCHART ACCOUNT (DEFINED AS HAVING A LOG IN WITHIN THE LAST YEAR – BASED ON EXTRACT DATE)
AND		ISNULL(PAT4.PAT_LIVING_STAT_C,0) = '1'			-- EXCLUDE PATIENTS LISTED AS DECEASED IN EPIC
AND		FYIF.PATIENT_ID IS NULL							-- EXCLUDE PATIENTS WHO HAVE OPTED OUT OF BEING CONTACTED FOR RESEARCH RECRUITME
AND		CP.COMMUNICATION_CONCEPT_ID = '28102'
AND		APRV.APRV_MEDIA_C = '2'	
AND		PAT.EMAIL_ADDRESS IS NOT NULL					-- EMAIL ADDRESS MUST NOT BE NULL 
AND		PAT.EMAIL_ADDRESS LIKE '%@%.%'					-- EMAIL MUST BE IN PROPER FORMAT ABC@GMAIL.COM 
