WITH gen_provs AS (
	SELECT DISTINCT ser.PROV_ID, emp.USER_ID
	FROM CLARITY..CLARITY_SER ser
	LEFT JOIN CLARITY..CLARITY_EMP emp on ser.PROV_ID = emp.PROV_ID
	WHERE ser.PROV_TYPE = 'Genetics Counselor' --Genetics counselor
),COH AS (

SELECT enc.PAT_ID
FROM CLARITY..PAT_ENC enc
LEFT JOIN CLARITY..CLARITY_DEP dep on enc.DEPARTMENT_ID = dep.DEPARTMENT_ID
  WHERE COALESCE(enc.effective_date_dttm, enc.contact_date)  >= '2016-07-01'
    and COALESCE(enc.effective_date_dttm, enc.contact_date) < GETDATE()
    AND COALESCE(enc.SERV_AREA_ID,-1) IN (11,-1)
    AND COALESCE(enc.APPT_STATUS_C,-1) NOT IN (	3	--Canceled
                                                ,4	--No Show
												,5	--Left without seen
                                              )
    AND COALESCE(enc.DEPARTMENT_ID, enc.EFFECTIVE_DEPT_ID) IN (110106469,110106508,110107457,110200800,110204460
,110205460,110205901,110306805,110401800,110500460,113000466,113000800,113002800,113002802,113002805
,113004800,113004803,113004805,113022800,113022803,113023800,113023801,113024800,113025800,113027800,113027801
,113028800,113029800,113030800,113030801,113031800,113034800,113034801,113035801,113038801,113038802,113039800
,113041800,113042800,113043800,113043801,113043805,113062000,113063000,113063001,113070000,113085000,113095000
,113095460,113096001)
    --AND COALESCE(enc.effective_date_dttm, enc.contact_date)  >= pat.adult_age_date
    and enc.enc_type_c in (2501,62,2502,121,101,2531,2525)
UNION
SELECT enc.PAT_ID
FROM CLARITY..PAT_ENC enc
INNER JOIN gen_provs on enc.visit_prov_id = gen_provs.prov_id --Genetics counselor
LEFT JOIN CLARITY..CLARITY_DEP dep on enc.DEPARTMENT_ID = dep.DEPARTMENT_ID
WHERE enc.contact_date BETWEEN '2016-07-01' AND GETDATE() --Encounter since 2016-07-01
--AND enc.contact_date >= pat.adult_age_date --Adult at time of encounter
AND COALESCE(enc.APPT_STATUS_C,-1) NOT IN (3,4,5) 
), MSSGS AS (
SELECT MESSAGE_ID, 'to_pat' as mssg_type
FROM CLARITY.dbo.MYC_MESG mm
join COH c on mm.pat_id = c.PAT_ID
join gen_provs prov on mm.FROM_USER_ID = prov.user_id
WHERE mm.TOFROM_PAT_C = 1
UNION
SELECT MESSAGE_ID,'to_prov' as mssg_type
FROM CLARITY.dbo.MYC_MESG mm
join gen_provs prov on mm.TO_USER_ID = prov.user_id
join COH c on mm.PAT_ID = c.PAT_ID
WHERE mm.TOFROM_PAT_C = 2
)--, MSSG_SAMPLE AS (
--SELECT TOP 16000 *
--FROM MSSGS
--WHERE mssg_type = 'to_pat'
--ORDER BY RAND(1128)
--)
--select count(*)
---FROM (
select 
	distinct
--top 50 

ID.IDENTITY_ID AS EMRN
	--c.[Enterprise ID]
	, vmm.MESSAGE_ID
	,zmmt.name					'Message_Type'
	,vmm.CREATED_TIME			'MSG_DELIVERED'
	,vmm.FIRST_READ_IN_MYC_DTTM
	,vmm.REPLY_YN				'REPLY_TO_MSG'
	,CASE vmm.TO_PAT_YN
		 WHEN 'N' 
			THEN iif( myp1.PAT_NAME = MYCALL.PAT_NAME, 'PATIENT', 'PROXY' )  
		 ELSE 'PROVIDER'
		END						'SENDER'
--,mm.TO_USER_ID
,iif(vmm.TO_PAT_YN <> 'N',ser.PROV_TYPE,'')	'Author_Type'
,iif(vmm.TO_PAT_YN <> 'N',vp.primary_specialty,'') 'Author_Specialty'
,iif(vmm.TO_PAT_YN <> 'N',dep.external_name,'') 'Author_Department'


--,vmm.FROM_USER_ID
--,emp.EMP_RECORD_TYPE_C
--,zert.NAME EmployeeType
--,vmm.ENC_PROV_ID
--,ser.PROV_TYPE
--,ser.PROVIDER_TYPE_C
--,vmm.ENC_DEP_ID
--,dep.EXTERNAL_NAME

	,vmm.TO_PAT_YN				'TO_PATIENT'

	,mm.PROXY_PAT_ID  -- only filled in if proxy (who is also a different patient) is logging in to send the message
	,mm.WPR_OWNER_WPR_ID  -- Owner
	,mm.PROXY_WPR_ID -- Proxy

	,cast(STUFF(
		(SELECT ' ' + mt_inner.MSG_TXT
		 FROM CLARITY.dbo.MSG_TXT mt_inner
		 WHERE mt_inner.MESSAGE_ID = mt.MESSAGE_ID
		 ORDER BY mt_inner.LINE, mt_inner.MSG_TXT
		 FOR XML PATH ('')
		), 1, 1, '' 
			 ) as nvarchar(max))				'Email_Text'
--INTO DBO.CCDA2983_Gleason_Mychart_rpt
from COH c
inner join CLARITY.dbo.V_MYC_MESG vmm on c.PAT_ID = vmm.PAT_ID
inner join CLARITY.dbo.MSG_TXT mt on vmm.MESSAGE_ID = mt.MESSAGE_ID
inner join MSSGS on mt.MESSAGE_ID = MSSGS.MESSAGE_ID
inner join CLARITY.dbo.MYC_PATIENT mycall ON c.PAT_ID = mycall.PAT_ID
inner join CLARITY.dbo.MYC_MESG mm ON vmm.MESSAGE_ID = mm.MESSAGE_ID
inner join CLARITY..IDENTITY_ID ID ON c.PAT_ID = ID.PAT_ID AND IDENTITY_TYPE_ID = 0
left outer join CLARITY.dbo.ZC_MYC_MSG_TYP zmmt on vmm.myc_msg_typ_c = zmmt.myc_msg_typ_c
left outer join CLARITY.dbo.MYC_PATIENT MYP ON myp.MYPT_ID = mm.PROXY_WPR_ID -- Proxy
left outer join CLARITY.dbo.MYC_PATIENT MYP1 ON myp1.MYPT_ID = mm.WPR_OWNER_WPR_ID  -- Owner

--left outer join CLARITY.dbo.CLARITY_EMP emp on vmm.FROM_USER_ID = emp.USER_ID
--left outer join CLARITY.dbo.ZC_EMP_RECORD_TYPE zert on emp.EMP_RECORD_TYPE_C = zert.EMP_RECORD_TYPE_C
left outer join CLARITY.dbo.CLARITY_SER ser on vmm.ENC_PROV_ID = ser.PROV_ID
left outer join CLARITY.dbo.V_CUBE_D_PROVIDER vp on ser.PROV_ID = vp.PROVIDER_ID  -- finding primary specialty
left outer join CLARITY.dbo.CLARITY_SER_DEPT serdep on ser.PROV_ID = serdep.PROV_ID and serdep.LINE = 1 -- finding primary department
left outer join CLARITY.dbo.CLARITY_DEP dep on serdep.DEPARTMENT_ID = dep.DEPARTMENT_ID
left outer join CLARITY..CLARITY_EMP emp on vmm.ENC_PROV_ID = emp.prov_id

where 
vmm.CREATED_TIME >= '2016-07-01'
--vmm.CREATED_TIME  >= '10/3/2017' and vmm.CREATED_TIME  < '10/3/2018'
--vmm.CREATED_TIME  >= '10/3/2018' and vmm.CREATED_TIME < '10/3/2019'
--vmm.CREATED_TIME  >= '10/3/2019' and vmm.CREATED_TIME < '10/3/2020'
--vmm.CREATED_TIME  >= '10/3/2020' and vmm.CREATED_TIME < '10/3/2021'
--vmm.CREATED_TIME  >= '10/3/2021' and vmm.CREATED_TIME < '10/4/2022'
and vmm.MYC_MSG_TYP_C not in (19,21,24,31,32,33,35,39,43,98,999,72002,72005,72006
								,72012,72014,72015,101001,720001,21077701,21077702)
--AND vmm.MYC_MSG_TYP_C in (1,11,18,25,36,45,47,51,55,96,98)
--) t