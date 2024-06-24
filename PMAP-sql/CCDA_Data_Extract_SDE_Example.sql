/*
Author:				G. LI
JIRA:				CCDA-5035
Study PI:			Dr. Clifton Bingham
Study Title:		The impact of COVID-19 on patient-reported measures of Health-related quality of life in patients with inflammatory arthritis
Contact:			NA
Date:				4/20/2023
Extract purpose:	Extract data for research
Current IRB status:	IRB00368258
Extract Structure:	Pipe-delimited flat file
Inclusion criteria:	Only patients with the following criteria will be included in the extract results:
-	Age 18 and over
-	Seen at Bayview Rheumatology by specific providers
	-	Clifton Bingham
	-	Laura Cappelli
	-	Thomas Grader-Beck
	-	Uzma Haque
	-	John Miller
	-	Ana-Maria Orbai

Each patient must have a qualifying encounter below:

-	June 1, 2021 – January 1, 2023: At least one in-person (follow-up or new) or telemedicine (Video or Video-New) encounter with at least one data element filled in from a questionnaire or 
smart data field listed in the RHU PROMIS LQF2000003 tab page in Covid data pull architecture Excel file.																																																			
*/
CREATE OR ALTER PROCEDURE DBO.CCDA5035_Bingham_sp
AS
IF OBJECT_ID('tempdb..#coh') IS NOT NULL  DROP TABLE #coh
--ENCOUNTER based smart forms
SELECT DISTINCT 
		PAT.PAT_ID,PE.PAT_ENC_CSN_ID
INTO #COH
	FROM CLARITY.DBO.PATIENT PAT 
	INNER JOIN CLARITY.DBO.PAT_ENC PE ON PAT.PAT_ID = PE.PAT_ID
	INNER JOIN CLARITY.DBO.CLARITY_DEP DEP ON ISNULL(PE.EFFECTIVE_DEPT_ID,PE.DEPARTMENT_ID) = DEP.DEPARTMENT_ID
	INNER JOIN CLARITY.DBO.SMRTDTA_ELEM_DATA SED ON	SED.CONTACT_SERIAL_NUM = PE.PAT_ENC_CSN_ID AND SED.CONTEXT_NAME = 'ENCOUNTER'
	INNER JOIN CLARITY.DBO.SMRTDTA_ELEM_VALUE SEV ON SEV.HLV_ID = SED.HLV_ID
	WHERE PE.ENC_TYPE_C IN (  '101','2531') --office visit, video visit)
	AND ISNULL(PE.APPT_STATUS_C,0) IN (0,2)  -- COMPLETED  -- RESEARCHER WANTS TO INCLUDE NO SHOWS
	AND ISNULL(PE.EFFECTIVE_DATE_DT,PE.CONTACT_DATE) BETWEEN '1/1/2021' AND '12/31/2022'
	AND ISNULL(PE.SERV_AREA_ID,0) IN (0,11)   -- REMOVE ADDITIONAL SERVICE AREAS EXCEPT NULL AND 11
	AND ISNULL(PE.EFFECTIVE_DEPT_ID,PE.DEPARTMENT_ID) = 110202463	--BVAAC RHEUMATOLOGY	JOHNS HOPKINS BAYVIEW RHEUMATOLOGY
	AND PE.VISIT_PROV_ID IN ('200321','2381','2506','1350','200861','202494')
	AND FLOOR(DATEDIFF(DAY,PAT.BIRTH_DATE,PE.CONTACT_DATE)/365.25) >= 18
	AND SED.ELEMENT_ID IN ('JHM#7911','RHU#086','RHU#087','RHU#088','RHU#089','RHU#090','RHU#069','RHU#091','RHU#092','RHU#093','RHU#094','RHU#070','RHU#071','RHU#072')
	AND SEV.SMRTDTA_ELEM_VALUE IS NOT NULL
	UNION
	-- questionnaires
	SELECT DISTINCT 
		PAT.PAT_ID,PE.PAT_ENC_CSN_ID
	FROM CLARITY.DBO.CL_QQUEST QSN 
	LEFT  JOIN	CLARITY.DBO.CL_QANSWER_QA CQA ON QSN.QUEST_ID=CQA.QUEST_ID
	LEFT  JOIN  CLARITY.DBO.PAT_ENC_QNRS_ANS ANS ON CQA.ANSWER_ID=ANS.APPT_QNRS_ANS_ID
	LEFT  JOIN	CLARITY.DBO.PAT_ENC_FORM_ANS ANS2 ON CQA.ANSWER_ID=ANS2.QF_HQA_ID
	INNER JOIN CLARITY.DBO.PAT_ENC PE ON COALESCE(ANS.PAT_ENC_CSN_ID,ANS2.PAT_ENC_CSN_ID) = PE.PAT_ENC_CSN_ID
	INNER JOIN CLARITY.DBO.PATIENT PAT ON PE.PAT_ID = PAT.PAT_ID
	INNER JOIN CLARITY.DBO.CLARITY_DEP DEP ON ISNULL(PE.EFFECTIVE_DEPT_ID,PE.DEPARTMENT_ID) = DEP.DEPARTMENT_ID
	WHERE PE.ENC_TYPE_C IN ( '101','2531') --OFFICE VISIT, VIDEO VISIT
	AND ISNULL(PE.APPT_STATUS_C,0) IN (0,2)  -- COMPLETED  -- RESEARCHER WANTS TO INCLUDE NO SHOWS
	AND PE.CONTACT_DATE BETWEEN '1/1/2021' AND '12/31/2022'
	AND ISNULL(PE.SERV_AREA_ID,0) IN (0,11)   -- REMOVE ADDITIONAL SERVICE AREAS EXCEPT NULL AND 11
	AND ISNULL(PE.EFFECTIVE_DEPT_ID,PE.DEPARTMENT_ID) = 110202463	--BVAAC RHEUMATOLOGY	JOHNS HOPKINS BAYVIEW RHEUMATOLOGY
	AND PE.VISIT_PROV_ID IN ('200321','2381','2506','1350','200861','202494')
	AND ROUND(DATEDIFF(HOUR,PAT.BIRTH_DATE,PE.CONTACT_DATE)/8766.0, 0, 1) >= 18
	AND QSN.QUEST_ID IN ('1400001510','1400001758','1400001759','1400001760','1400001761','1400001762','1400001763','1400001764'
						,'1400001765','105379','110810','110811','110104','110812','140001979','110813','110814','1400001707'
						,'110815','140001980','140001981','140001982','1400001731','1400001734','1400001732','1400001733'
						,'1400001735','1400001736','1400001737','1400001738','1400001750','1400001751','1400001752','1400001753'
						,'1400001754','1400001755','1400001756','1400001757','1400001748','1400001742','1400001743','1400001744'
						,'1400001713','1400001714','1400001715','1400001716','1400001722','1400001723','1400001724','1400001725'
						,'2100109407','2101094071','2101094072','2101094073','2101094074','111438','111439')

	AND CQA.QUEST_ANSWER IS NOT NULL

IF OBJECT_ID('Analytics.dbo.CCDA5035_Bingham_Cohort_PatID_Master', 'U') IS NOT NULL drop TABLE Analytics.dbo.CCDA5035_Bingham_Cohort_PatID_Master

--mask PAT_IDs 
SELECT 
	c.*
	,ROW_NUMBER() OVER (ORDER BY c.PAT_ID) as 'Mask_Pat_ID'  
INTO Analytics.dbo.CCDA5035_Bingham_Cohort_PatID_Master
FROM ( Select distinct PAT_ID 
		FROM #COH)  c
--compress table
ALTER TABLE Analytics.dbo.CCDA2393_Bingham_Cohort_PatIDMask
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)


IF OBJECT_ID('Analytics.dbo.CCDA5035_Bingham_Cohort_ENC_Master', 'U') IS NOT NULL drop TABLE Analytics.dbo.CCDA5035_Bingham_Cohort_ENC_Master
--mask CSNs 
SELECT 
	c.*
	,ROW_NUMBER() OVER (ORDER BY c.Pat_Enc_CSN_ID) as 'mkCSN'  
INTO Analytics.dbo.CCDA5035_Bingham_Cohort_ENC_Master
FROM ( Select distinct PAT_ENC_CSN_ID
		FROM #COH)  c
--compress table
ALTER TABLE Analytics.dbo.CCDA2393_Bingham_Cohort_CsnMask
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)


-----------------------------------
-- Demographic Report
-----------------------------------
select	distinct 
		cm.Mask_Pat_ID					'Masked Patient ID'	
		,pat.Birth_Date					'DOB'
		,zs.Name						'Gender'
		--,stuff((select ', ' + A.NAME 
		--	from 
		--		(SELECT *,ROW_NUMBER()OVER(PARTITION BY A.PAT_ID ORDER BY A.PAT_ID) AS Line 
		--		FROM (
		--				SELECT DISTINCT PR.PAT_ID,ZCR.NAME
		--				FROM CLARITY..PATIENT_RACE PR 
		--				inner join Analytics.dbo.CCDA2393_Bingham_Cohort pat_cohort_in on pat_cohort_in.PAT_ID = pr.pat_id
		--				left JOIN CLARITY..ZC_PATIENT_RACE ZCR ON ZCR.PATIENT_RACE_C = PR.PATIENT_RACE_C
		--			) A
		--		) A 
		--	where 
		--	A.PAT_ID = pat.PAT_ID
		--	order by A.line FOR XML PATH('')),1,1,''
		--	)														'Race'
		,[dbo].[udfConcatenateRace](pat.pat_id)	'Race'
		,Isnull(zeg.NAME,'Unknown')									'Ethnicity'
		,zpls.NAME													'Current Status'
from 
CCDA5035_Bingham_Cohort_PatID_Master cm 
inner join CLARITY.dbo.patient pat on cM.pat_id = pat.pat_ID
left outer join clarity.dbo.ZC_sex zs on pat.sex_c = zs.RCPT_MEM_SEX_C
LEFT JOIN CLARITY..ZC_ETHNIC_GROUP zeg ON zeg.ETHNIC_GROUP_C = pat.ETHNIC_GROUP_C
left outer join CLARITY.dbo.PATIENT_4 pat4 on pat.Pat_ID = pat4.Pat_ID
left outer join CLARITY.dbo.ZC_PAT_LIVING_STAT zpls on pat4.PAT_LIVING_STAT_C = zpls.PAT_LIVING_STAT_C

-----------------------------------
-- Encounters Report
-----------------------------------
select	distinct

		pidm.Mask_Pat_ID							'Masked_Patient_ID'
		,encm.mkCSN							'Masked_Encounter_ID'
		,isnull(pe.effective_date_dttm,pe.CONTACT_DATE	)					'Encounter_date/time'
		,DEP.DEPARTMENT_NAME					'Encounter_Department/location'
		,PE.VISIT_PROV_ID					'Visit_Provider_ID'
		,DET.NAME							'Encounter_Type'
		,pe.BMI
		,cast(round(DATEDIFF(hour
							,p.birth_date
							,pe.CONTACT_DATE)/8766.0, 0, 1) as int)		'Age_At_Encounter'				
		--,epm.PAYOR_NAME						'Insurance'
		,epm1.PAYOR_NAME	AS 'Primary_Insurance'
		,epm2.PAYOR_NAME	AS 'Secondary_Insurance'
		,epm3.PAYOR_NAME	AS 'Tertiary_Insurance'		

from Analytics.dbo.CCDA5035_Bingham_Cohort_enc_Master encm
inner join CLARITY.dbo.PAT_ENC pe on encm.PAT_ENC_CSN_ID = pe.PAT_ENC_CSN_ID
inner join Analytics.dbo.CCDA5035_Bingham_Cohort_PatID_Master pidm on pidm.PAT_ID = pe.PAT_ID
inner join clarity..patient p on p.pat_id = pidm.pat_id
INNER JOIN CLARITY..CLARITY_DEP DEP ON DEP.DEPARTMENT_ID = ISNULL(PE.EFFECTIVE_DEPT_ID,PE.DEPARTMENT_ID)
INNER JOIN CLARITY..ZC_DISP_ENC_TYPE DET ON DET.DISP_ENC_TYPE_C = PE.ENC_TYPE_C
LEFT JOIN CLARITY..PAT_ACCT_CVG CL ON CL.ACCOUNT_ID = PE.ACCOUNT_ID
left outer join CLARITY.dbo.COVERAGE cov1 on CL.coverage_id = cov1.coverage_id AND CL.LINE=1
	left outer join CLARITY.dbo.CLARITY_EPM epm1 on cov1.payor_id = epm1.PAYOR_ID
left outer join CLARITY.dbo.COVERAGE cov2 on CL.coverage_id = cov2.coverage_id AND CL.LINE=2
	left outer join CLARITY.dbo.CLARITY_EPM epm2 on cov2.payor_id = epm2.PAYOR_ID
left outer join CLARITY.dbo.COVERAGE cov3 on CL.coverage_id = cov3.coverage_id AND CL.LINE=3
	left outer join CLARITY.dbo.CLARITY_EPM epm3 on cov3.payor_id = epm3.PAYOR_ID





-----------------------------------
-- Encounter Diagnoses Report
-----------------------------------
select	distinct
		pidm.Mask_Pat_ID					'Masked_Patient_ID'
		,encm.mkCSN							'Masked_Encounter_ID'
		,edg.CURRENT_ICD10_LIST				'Diagnosis Code'
		,edg.DX_NAME						'Diagnosis Name'

from Analytics.dbo.CCDA5035_Bingham_Cohort_enc_Master encm
inner join CLARITY.dbo.PAT_ENC pe on encm.PAT_ENC_CSN_ID = pe.PAT_ENC_CSN_ID
inner join Analytics.dbo.CCDA5035_Bingham_Cohort_PatID_Master pidm on pidm.PAT_ID = pe.PAT_ID
inner join clarity..patient p on p.pat_id = pidm.pat_id
inner join CLARITY.dbo.PAT_ENC_DX ped on pe.PAT_ENC_CSN_ID = ped.PAT_ENC_CSN_ID
inner join CLARITY.dbo.CLARITY_EDG edg on ped.DX_ID = edg.DX_ID

where edg.DX_ID <> 19004	-- 19004	ERRONEOUS ENCOUNTER--DISREGARD

--order by cm.mkPAT_ID, csnm.mkCSN, edg.CURRENT_ICD10_LIST



-----------------------------------
-- Problem List Report
-----------------------------------
select	distinct
		c.Mask_Pat_ID								'Masked Patient ID'
		,case when edg.CURRENT_ICD10_LIST is null
				then 'ICD 9'
				else 'ICD 10'
				end												'Diagnosis Code Set'
		,coalesce(edg.CURRENT_ICD10_LIST,edg.CURRENT_ICD9_LIST)	'Diagnosis Code'
		,edg.DX_NAME											'Diagnosis Name'
		,pl.NOTED_DATE											'Noted Date'
		,pl.DATE_OF_ENTRY										'Entry Date'
		,zps.NAME												'Status'

from CCDA5035_Bingham_Cohort_PatID_Master c
inner join CLARITY.dbo.PROBLEM_LIST pl WITH (NOLOCK) on c.PAT_ID = pl.PAT_ID
inner join CLARITY.dbo.CLARITY_EDG edg WITH (NOLOCK) on pl.DX_ID = edg.DX_ID
left join CLARITY.dbo.ZC_PROBLEM_STATUS zps WITH (NOLOCK) on pl.PROBLEM_STATUS_C = zps.PROBLEM_STATUS_C

where isnull(pl.PROBLEM_STATUS_C,0) <> 3 -- deleted
and edg.DX_ID <> 19004	-- 19004	ERRONEOUS ENCOUNTER--DISREGARD

--order by cm.mkPAT_ID, coalesce(edg.CURRENT_ICD10_LIST,edg.CURRENT_ICD9_LIST)



-----------------------------------
-- Labs Report
-----------------------------------
select	distinct
		c.Mask_Pat_ID														'Masked Patient ID'

	--,CONVERT(VARCHAR(10), res.RESULT_TIME, 101)  
	--			+ ' ' 
	--			+ left(CONVERT(VARCHAR(24),res.RESULT_TIME,8),5)			'Result Date/Time'
	,res.RESULT_TIME			'Result Date/Time'


	--,CONVERT(VARCHAR(10), ord2.SPECIMN_TAKEN_TIME, 101)
	--			+ ' ' 
	--			+ left(CONVERT(VARCHAR(24),ord2.SPECIMN_TAKEN_TIME,8),5)	'Collection Date/Time'
	,ord2.SPECIMN_TAKEN_TIME												'Collection Date/Time'

	,coalesce(ord.ORDERING_DATE, ORDER_INST)								'Order Date/Time'
	,eap.ORDER_DISPLAY_NAME													'Test Name' -----------------------------
	,cc.EXTERNAL_NAME														'Lab Name'
	,cc.BASE_NAME															'Base Name'

	,case when isnull(res.ORD_NUM_VALUE,9999999) = 9999999 then null
									else res.ORD_NUM_VALUE
							end												'Value - numeric'
	,case when isnumeric(res.ORD_VALUE) = 1 then null
							else res.ORD_VALUE
							end												'Value - text'
--	,cmt.ObservationComment													'Text Comments'
	,res.REFERENCE_UNIT														'Unit'
	,res.REFERENCE_LOW														'Reference range - low'
	,res.REFERENCE_HIGH														'Reference range - high'
	,dep.EXTERNAL_NAME														'Ordering Department'

from Analytics.dbo.CCDA5035_Bingham_Cohort_PatID_Master c
inner join CLARITY.dbo.PAT_ENC pe WITH (NOLOCK) on c.PAT_ID = pe.PAT_ID
inner join CLARITY.dbo.CLARITY_DEP dep WITH (NOLOCK) on pe.EFFECTIVE_DEPT_ID = dep.DEPARTMENT_ID
inner join CLARITY.dbo.ORDER_PROC ord WITH (NOLOCK) on pe.PAT_ENC_CSN_ID = ord.PAT_ENC_CSN_ID
inner join CLARITY.DBO.ORDER_PROC_2 ord2 WITH (NOLOCK) on ord2.ORDER_PROC_ID = ord.ORDER_PROC_ID
inner join CLARITY.dbo.ORDER_RESULTS res WITH (NOLOCK) on ord.ORDER_PROC_ID = res.ORDER_PROC_ID
inner join CLARITY.dbo.CLARITY_EAP eap WITH (NOLOCK) on ord.PROC_ID = eap.PROC_ID
left outer join CLARITY.dbo.CLARITY_COMPONENT cc WITH (NOLOCK) on res.COMPONENT_ID = cc.COMPONENT_ID
left outer join CLARITY.dbo.CLARITY_SER ser WITH (NOLOCK) on pe.VISIT_PROV_ID = ser.PROV_ID

where 
isnull(pe.SERV_AREA_ID,0) in (0,11)   -- remove additional service areas except null and 11
and res.RESULT_TIME BETWEEN '2021-6-1' and getdate() 

and isnull(pe.APPT_STATUS_C,0) = 2  -- completed
and (ISNULL(ord.ORDER_STATUS_C,0) <> 4 /*not canceled*/ 
and ord.LAB_STATUS_C in (3,5)) -- final or final edited

--order by cm.mkPAT_ID, res.RESULT_TIME

-------------------------------------------------------
-- Med Orders Report (ordered by specified providers)
-------------------------------------------------------
select	distinct
		pidm.Mask_Pat_ID											'Masked Patient ID'
		,encm.mkCSN											'Masked Encounter ID'
		,med.NAME											'Medication Name'
		,om.HV_DISCRETE_DOSE								'Dose'
		,om.SIG
		,om.ORDERING_DATE									'Ordering Date'
		,ztc.Name											'Therapeutic Class'
		,zpc.Name											'Pharmaceutical Class'
		,zps.Name											'Pharmaceutical Subclass'

from Analytics.dbo.CCDA5035_Bingham_Cohort_enc_Master encm
inner join CLARITY.dbo.PAT_ENC pe on encm.PAT_ENC_CSN_ID = pe.PAT_ENC_CSN_ID
inner join Analytics.dbo.CCDA5035_Bingham_Cohort_PatID_Master pidm on pidm.PAT_ID = pe.PAT_ID
inner join CLARITY.dbo.ORDER_MED om on encm.Pat_enc_CSN_ID = om.Pat_enc_CSN_ID
inner join CLARITY.dbo.CLARITY_MEDICATION med on om.MEDICATION_ID = med.MEDICATION_ID 
left outer join CLARITY.dbo.zc_pharm_class zpc on med.pharm_class_c = zpc.pharm_class_c
left outer join CLARITY.dbo.zc_thera_class ztc on med.thera_class_c = ztc.thera_class_c
left outer join CLARITY.dbo.zc_pharm_subclass zps on med.pharm_subclass_c = zps.pharm_subclass_c
where  
--isnull(pe.APPT_STATUS_C,0) in (0,2)  -- completed
--and isnull(pe.SERV_AREA_ID,0) in (0,11)   -- remove additional service areas except null and 11
--and 
isnull(om.ORDER_STATUS_C,0) not in ('4','6','7','8') -- NOT any of these --> Canceled,Holding for Referral ,Denied Approval,Suspend
and isnull(om.IS_PENDING_ORD_YN,'N') <> 'y'
and om.MED_PRESC_PROV_ID in ('200321','3017441','2381','2506','1350','200861','202494')


-------------------------------------------------------
-- Social History
-------------------------------------------------------
IF OBJECT_ID('tempdb..#CCDA5035_Bingham_SocHx') IS NOT NULL  DROP TABLE #CCDA2393_Bingham_SocHx

select	distinct
		c.Mask_Pat_ID											'Masked Patient ID'
		,sm.contact_date											'record_date'
--c.PAT_ID
--,pe.Pat_enc_csn_id															
	--,sm.SMOKING_TOB_USE_C														'Smoking Status ID'
	,smu.NAME																	'Smoking Status'
	--,sm.ALCOHOL_USE_C															'Alcohol Use ID'
	,zau.NAME																	'Alcohol Use'
	--,sm.ILL_DRUG_USER_C															'Drug Use ID'
	,zidu.NAME																	'Drug Use'

--into #CCDA5035_Bingham_SocHx
from Analytics.dbo.CCDA5035_Bingham_Cohort_PatID_Master c
--inner join Analytics.dbo.CCDA2393_Bingham_Cohort_PatIDMask cm on c.PAT_ID = cm.PAT_ID
inner join CLARITY.dbo.PAT_ENC pe on c.PAT_ID = pe.PAT_ID
inner join CLARITY.dbo.SOCIAL_HX sm on pe.PAT_ENC_CSN_ID = sm.PAT_ENC_CSN_ID
left join CLARITY.dbo.PAT_ENC_HSP hsp on pe.PAT_ENC_CSN_ID = hsp.PAT_ENC_CSN_ID
left join CLARITY.dbo.ZC_SMOKING_TOB_USE smu on sm.SMOKING_TOB_USE_C = smu.SMOKING_TOB_USE_C
left join CLARITY.dbo.ZC_ALCOHOL_USE zau on sm.ALCOHOL_USE_C = zau.ALCOHOL_USE_C
left join CLARITy.dbo.ZC_ILL_DRUG_USER zidu on sm.ILL_DRUG_USER_C = zidu.ILL_DRUG_USER_C

WHERE
(isnull(pe.APPT_STATUS_C,0) in (0,2) /*completed*/ OR isnull(hsp.ADMIT_CONF_STAT_C,0) not in (2,3)  /*no canceled or pending*/ )
and (pe.CONTACT_DATE BETWEEN '2021-6-1' and getdate() 
	OR 
	isnull(hsp.ADT_ARRIVAL_TIME,0)BETWEEN '2021-6-1' and getdate() 
	OR isnull(hsp.HOSP_ADMSN_TIME,0)BETWEEN '2021-6-1' and getdate() 
	)
and isnull(pe.SERV_AREA_ID,0) in (0,11)   -- remove additional service areas except null and 11
and isnull(sm.SMOKING_TOB_USE_C,'') <> ''

--select * from #CCDA2393_Bingham_SocHx sh order by [masked patient id]

--select csnm.PAT_ENC_CSN_ID, sh.* 
--from #CCDA2393_Bingham_SocHx sh
--left outer join Analytics.dbo.CCDA2393_Bingham_Cohort_CsnMask csnm on sh.PAT_ENC_CSN_ID = csnm.PAT_ENC_CSN_ID
--order by sh.PAT_ID, sh.PAT_ENC_CSN_ID

--select max(mkPat_ID) from Analytics.dbo.CCDA2393_Bingham_Cohort_PatIDMask cm



--IF OBJECT_ID('Analytics.dbo.CCDA2393_Bingham_Cohort_SocHxCsnMask', 'U') IS NOT NULL drop TABLE Analytics.dbo.CCDA2393_Bingham_Cohort_SocHxCsnMask

----mask CSNs 
--SELECT 
--	c.*
--	, (ROW_NUMBER() OVER (ORDER BY c.Pat_Enc_CSN_ID) + 1000) as 'mkCSN'  
--INTO Analytics.dbo.CCDA2393_Bingham_Cohort_SocHxCsnMask
--FROM ( Select distinct PAT_ENC_CSN_ID
--		FROM #CCDA2393_Bingham_SocHx sh)  c


----compress table
--ALTER TABLE Analytics.dbo.CCDA2393_Bingham_Cohort_SocHxCsnMask
--REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)


--select	distinct
--		pm.mkPAT_ID				'Masked Patient ID'
--		,shm.mkCSN				'Masked Encounter ID'
--		,sh.[Smoking Status]
--		,sh.[Alcohol Use]
--		,sh.[Drug Use]
--FROM #CCDA2393_Bingham_SocHx sh
--inner join Analytics.dbo.CCDA2393_Bingham_Cohort_SocHxCsnMask shm on sh.PAT_ENC_CSN_ID = shm.PAT_ENC_CSN_ID
--inner join Analytics.dbo.CCDA2393_Bingham_Cohort_PatIDMask pm on sh.PAT_ID = pm.PAT_ID
--order by pm.mkPAT_ID, shm.mkCSN



-------------------------------------------------------
-- Medical History
-------------------------------------------------------
IF OBJECT_ID('tempdb..#CCDA5035_Bingham_MedHx') IS NOT NULL  DROP TABLE #CCDA5035_Bingham_MedHx

select 
		distinct 
		c.Mask_Pat_ID
		--,mh.Pat_enc_csn_ID	
		--,mh.CONTACT_DATE						'Record Date'
		,mh.Medical_HX_Date						'Medical History Date'
	--	,edg.DX_ID								'Diagnosis ID'
		,edg.DX_NAME							'Diagnosis Name'
		,edg.DX_GROUP							'Diagnosis Group'
		,edg.CURRENT_ICD10_LIST					'Diagnosis Code'

--INTO #CCDA5035_Bingham_MedHx
FROM
-- find most recent medical history record for each diagnosis
--(
--	select	distinct 
--			c.pat_ID
--			,c.Mask_Pat_ID
--			,max(mh.contact_Date)		Maxd
--			,mh.DX_ID
--	from Analytics.dbo.CCDA5035_Bingham_Cohort_PatID_Master c
--	inner join  CLARITY.dbo.MEDICAL_HX mh on c.PAT_ID = mh.PAT_ID
--	--inner join CLARITY.dbo.PAT_ENC pe on c.PAT_ID = pe.PAT_ID
--	--									and mh.Pat_enc_csn_ID = pe.Pat_enc_csn_id
--	--where isnull(pe.SERV_AREA_ID,0) in (0,11)   -- remove additional service areas except null and 11
--	group by c.pat_ID,Mask_Pat_ID, mh.DX_ID

--)  MostRecent
Analytics.dbo.CCDA5035_Bingham_Cohort_PatID_Master c
inner join  CLARITY.dbo.MEDICAL_HX mh on c.PAT_ID = mh.PAT_ID
													--and MostRecent.Maxd = mh.contact_Date
													--and MostRecent.DX_ID = mh.DX_ID
inner join clarity.dbo.clarity_edg edg on edg.dx_id = mh.Dx_id
left join CLARITY.dbo.EDG_CURRENT_ICD10 edg10 on mh.DX_ID = edg10.DX_ID


--select * from #CCDA2393_Bingham_MedHx mh


--IF OBJECT_ID('Analytics.dbo.CCDA2393_Bingham_Cohort_MedHxCsnMask', 'U') IS NOT NULL drop TABLE Analytics.dbo.CCDA2393_Bingham_Cohort_MedHxCsnMask

----mask CSNs 
--SELECT 
--	c.*
--	, (ROW_NUMBER() OVER (ORDER BY c.Pat_Enc_CSN_ID) + 10000) as 'mkCSN'  
--INTO Analytics.dbo.CCDA2393_Bingham_Cohort_MedHxCsnMask
--FROM ( Select distinct PAT_ENC_CSN_ID
--		FROM #CCDA2393_Bingham_MedHx mh)  c


----compress table
--ALTER TABLE Analytics.dbo.CCDA2393_Bingham_Cohort_MedHxCsnMask
--REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)

----select * from Analytics.dbo.CCDA2393_Bingham_Cohort_MedHxCsnMask mhm
----select * from #CCDA2393_Bingham_MedHx mh


--select	distinct
--		pm.mkPAT_ID						'Masked Patient ID'
--		,mhm.mkCSN						'Masked Encounter ID'
--		,mh.[Medical History Date]
--		,mh.[Diagnosis Name]
--		,mh.[Diagnosis Code]
--FROM #CCDA2393_Bingham_MedHx mh
--inner join Analytics.dbo.CCDA2393_Bingham_Cohort_MedHxCsnMask mhm on mh.PAT_ENC_CSN_ID = mhm.PAT_ENC_CSN_ID
--inner join Analytics.dbo.CCDA2393_Bingham_Cohort_PatIDMask pm on mh.PAT_ID = pm.PAT_ID
--order by pm.mkPAT_ID, mhm.mkCSN, mh.[Diagnosis Name]



-------------------------------------------------------
-- Flowsheets  (Although all meas IDs were found, they are not all represented in the data pull.)
-------------------------------------------------------
select	distinct
		pidm.Mask_Pat_ID				'Masked Patient ID'
		,gp.DISP_NAME			'Flowsheet Display Name'
		,meas.MEAS_VALUE		'Flowsheet Value'
		,meas.RECORDED_TIME

from Analytics.dbo.CCDA5035_Bingham_Cohort_enc_Master encm
inner join CLARITY.dbo.PAT_ENC pe1 on encm.PAT_ENC_CSN_ID = pe1.PAT_ENC_CSN_ID
inner join Analytics.dbo.CCDA5035_Bingham_Cohort_PatID_Master pidm on pidm.PAT_ID = pe1.PAT_ID
inner join CLARITY.dbo.PAT_ENC pe on pidm.PAT_ID = pe.PAT_ID
													--and pe.CONTACT_DATE BETWEEN '3/5/2019' and '2021-03-05 23:59:00.000'
inner join CLARITY.dbo.IP_FLWSHT_REC rec on pe.INPATIENT_DATA_ID = rec.INPATIENT_DATA_ID
INNER JOIN CLARITY.dbo.IP_FLWSHT_MEAS meas on meas.FSD_ID = rec.FSD_ID
inner join CLARITY.dbo.IP_FLO_GP_DATA gp on gp.FLO_MEAS_ID = meas.FLO_MEAS_ID
left outer join CLARITY.dbo.ZC_DISP_ENC_TYPE zet on pe.ENC_TYPE_C = zet.DISP_ENC_TYPE_C

where 
isnull(pe.SERV_AREA_ID,0) in (0,11)   
and pe.CONTACT_DATE BETWEEN '2021-6-1' and getdate() 
and meas.FLO_MEAS_ID in ('1580000158','1580000164','13189','1580000156','13190','13191','1580000162','1580000163'
						,'1580000157','1580000160','1580000159','1580000161')
--order by pm.mkPAT_ID, meas.RECORDED_TIME, gp.DISP_NAME


-------------------------------------------------------
-- Questionnaires
-------------------------------------------------------
IF OBJECT_ID('tempdb..#CCDA5035_Bingham_Quest') IS NOT NULL  DROP TABLE #CCDA5035_Bingham_Quest

select 
		distinct
		c.Mask_Pat_ID
	--	,enc.PAT_ENC_CSN_ID
		,COALESCE(ans.CONTACT_DATE,ans2.CONTACT_DATE)	'Encounter Date'
		,dep.EXTERNAL_NAME								'Encounter Department'
		,qsn.QUEST_ID									'Question_ID'
		,qsn.QUEST_NAME									'Question'
		,cqa.QUEST_ANSWER								'Answer'
		--,COALESCE(ans.LINE,ans2.LINE)					LINE
--INTO #CCDA5035_Bingham_Quest	
from CLARITY.dbo.CL_QQUEST qsn 
LEFT  JOIN	CLARITY.dbo.CL_QANSWER_QA cqa on qsn.QUEST_ID=cqa.QUEST_ID
LEFT  JOIN  CLARITY.dbo.PAT_ENC_QNRS_ANS ans on cqa.ANSWER_ID=ans.APPT_QNRS_ANS_ID
LEFT  JOIN	CLARITY.dbo.PAT_ENC_FORM_ANS ans2 on cqa.ANSWER_ID=ans2.QF_HQA_ID
INNER JOIN CLARITY.dbo.PAT_ENC enc on coalesce(ans.PAT_ENC_CSN_ID,ans2.PAT_ENC_CSN_ID) = enc.PAT_ENC_CSN_ID
INNER JOIN Analytics.dbo.CCDA5035_Bingham_Cohort_PatID_Master c on enc.PAT_ID = c.PAT_ID
inner join CLARITY.dbo.CLARITY_DEP dep on enc.EFFECTIVE_DEPT_ID = dep.DEPARTMENT_ID
where isnull(enc.SERV_AREA_ID,0) in (0,11)   
and enc.CONTACT_DATE BETWEEN '2021-6-1' and getdate() 
and qsn.QUEST_ID in ('1400001510','1400001758','1400001759','1400001760','1400001761','1400001762','1400001763','1400001764'
					,'1400001765','105379','110810','110811','110104','110812','140001979','110813','110814','1400001707'
					,'110815','140001980','140001981','140001982','1400001731','1400001734','1400001732','1400001733'
					,'1400001735','1400001736','1400001737','1400001738','1400001750','1400001751','1400001752','1400001753'
					,'1400001754','1400001755','1400001756','1400001757','1400001748','1400001742','1400001743','1400001744'
					,'1400001713','1400001714','1400001715','1400001716','1400001722','1400001723','1400001724','1400001725'
					,'2100109407','2101094071','2101094072','2101094073','2101094074','111438','111439')
--order by c.PAT_ID--,ans.CONTACT_DATE,ans2.CONTACT_DATE


--IF OBJECT_ID('Analytics.dbo.CCDA2393_Bingham_Cohort_QuestionnaireCsnMask', 'U') IS NOT NULL drop TABLE Analytics.dbo.CCDA2393_Bingham_Cohort_QuestionnaireCsnMask

----mask CSNs 
--SELECT 
--	c.*
--	, (ROW_NUMBER() OVER (ORDER BY c.Pat_Enc_CSN_ID) + 100000) as 'mkCSN'  
--INTO Analytics.dbo.CCDA2393_Bingham_Cohort_QuestionnaireCsnMask
--FROM ( Select distinct PAT_ENC_CSN_ID
--		FROM #CCDA2393_Bingham_Quest)  c


----compress table
--ALTER TABLE Analytics.dbo.CCDA2393_Bingham_Cohort_QuestionnaireCsnMask
--REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)


--select	distinct
--		pm.mkPAT_ID				'Masked Patient ID'
--		,qm.mkCSN				'Masked Encounter ID'
--		,q.CONTACT_DATE			'Encounter Date'
--		,q.DeptName				'Encounter Department'
--		,q.QUEST_ID				'Question ID'
--		,q.QUEST_NAME			'Question'
--		,q.Answer				'Answer'
--from #CCDA2393_Bingham_Quest q
--inner join Analytics.dbo.CCDA2393_Bingham_Cohort_PatIDMask pm on q.PAT_ID = pm.PAT_ID
--inner join Analytics.dbo.CCDA2393_Bingham_Cohort_QuestionnaireCsnMask qm on q.PAT_ENC_CSN_ID = qm.PAT_ENC_CSN_ID
--order by pm.mkPAT_ID, qm.mkCSN, q.QUEST_NAME

-------------------------------------------------------
-- Smart Data
-------------------------------------------------------
--IF OBJECT_ID('tempdb..#CCDA2393_Bingham_Smart') IS NOT NULL  DROP TABLE #CCDA2393_Bingham_Smart

SELECT	distinct 
	c.Mask_Pat_ID
	--,sed.CONTACT_SERIAL_NUM				'Pat_Enc_CSN_ID'
	,pe.CONTACT_DATE					'Encounter Date'
	,dep.EXTERNAL_NAME					'Encounter Department'
	,sc.CONCEPT_ID						'SDE Number'
	,cc.NAME							'Question'
	,sev.SMRTDTA_ELEM_VALUE				'Answer'

--INTO #CCDA2393_Bingham_Smart

FROM Analytics.dbo.CCDA5035_Bingham_Cohort_PatID_Master c
inner join CLARITY.dbo.Pat_Enc pe on c.Pat_ID = pe.Pat_ID
inner join CLARITY.dbo.SMRTDTA_ELEM_DATA sed on	sed.CONTACT_SERIAL_NUM = pe.PAT_ENC_CSN_ID
												and sed.CONTEXT_NAME = 'ENCOUNTER'
inner join CLARITY.dbo.SMRTDTA_ELEM_VALUE sev on sev.HLV_ID = sed.HLV_ID
inner join CLARITY.dbo.SMARTFORM_CONCEPT sc on sed.ELEMENT_ID = sc.CONCEPT_ID
inner join CLARITY.dbo.CLARITY_CONCEPT cc on sc.CONCEPT_ID = cc.CONCEPT_ID
left outer join CLARITY.dbo.CLARITY_DEP dep on pe.EFFECTIVE_DEPT_ID = dep.DEPARTMENT_ID

where isnull(pe.SERV_AREA_ID,0) in (0,11)   -- remove additional service areas except null and 11
and pe.CONTACT_DATE BETWEEN '2021-6-1' and getdate() 
and sc.CONCEPT_ID in ('JHM#7911','RHU#086','RHU#087','RHU#088','RHU#089','RHU#090','RHU#069','RHU#091','RHU#092'
						,'RHU#093','RHU#094','RHU#070','RHU#071','RHU#072','RHU#160','RHU#161','RHU#163','RHU#162'
						,'RHU#165','RHU#164','RHU#166','RHU#167')

--order by c.PAT_ID, 'pat_enc_csn_id', sc.CONCEPT_ID


--IF OBJECT_ID('Analytics.dbo.CCDA2393_Bingham_Cohort_SmartCsnMask', 'U') IS NOT NULL drop TABLE Analytics.dbo.CCDA2393_Bingham_Cohort_SmartCsnMask

----mask CSNs 
--SELECT 
--	c.*
--	, (ROW_NUMBER() OVER (ORDER BY c.Pat_Enc_CSN_ID) + 1000000) as 'mkCSN'  
--INTO Analytics.dbo.CCDA2393_Bingham_Cohort_SmartCsnMask
--FROM ( Select distinct PAT_ENC_CSN_ID
--		FROM #CCDA2393_Bingham_Smart)  c


----compress table
--ALTER TABLE Analytics.dbo.CCDA2393_Bingham_Cohort_SmartCsnMask
--REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)



--select	distinct
--		pm.mkPAT_ID				'Masked Patient ID'
--		,sm.mkCSN				'Masked Encounter ID'
--		,s.[Encounter Date]
--		,s.[SDE Number]
----		,s.[Encounter Department]
--		,s.Question
--		,s.Answer
--from #CCDA2393_Bingham_Smart s
--inner join Analytics.dbo.CCDA2393_Bingham_Cohort_PatIDMask pm on s.PAT_ID = pm.PAT_ID
--inner join Analytics.dbo.CCDA2393_Bingham_Cohort_SmartCsnMask sm on s.PAT_ENC_CSN_ID = sm.PAT_ENC_CSN_ID
--order by pm.mkPAT_ID, sm.mkCSN, s.Question


-------------------------------------------------------
-- Immunizations  (don't think I should include the real ORDER ID)
-------------------------------------------------------
select	distinct
		c.Mask_Pat_ID				'Masked Patient ID'
		,imm.IMMUNE_DATE		'Administered Date'
		,cm.NAME				'Immunization Name'
from Analytics.dbo.CCDA5035_Bingham_Cohort_PatID_Master c
inner join CLARITY.dbo.IMMUNE imm WITH (NOLOCK) on c.Pat_ID = imm.PAT_ID
inner join CLARITY..CLARITY_IMMUNZATN cm WITH (NOLOCK) on imm.IMMUNZATN_ID = cm.IMMUNZATN_ID
--inner join Analytics.dbo.CCDA2393_Bingham_Cohort_PatIDMask pm on c.PAT_ID = pm.PAT_ID

where isnull(imm.IMMNZTN_STATUS_C,0) = 1  -- given
and imm.IMMUNE_DATE BETWEEN '2021-6-1' and getdate() 
--order by pm.mkPAT_ID, imm.IMMUNE_DATE, cm.NAME
