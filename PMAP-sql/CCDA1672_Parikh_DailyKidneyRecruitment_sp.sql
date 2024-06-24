USE [Analytics]
GO

/****** Object:  StoredProcedure [dbo].[CCDA1672_Parikh_DailyKidneyRecruitment_sp]    Script Date: 8/20/2020 4:53:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[CCDA1672_Parikh_DailyKidneyRecruitment_sp]
AS
/***********************************************************************************************************
Author:			N. Balding
Date:			11/11/2019
JIRA:			CCDA-1672
Description:	Dr. Chirag Parikh

				This stored procedure works within the CCDA-1672 Kidney Precision Medicine project.  It 
				is used to find eligible patients for recruitment.

				Inclusion Criteria:

				Only patients with the following criteria will be included in the extract results:

					Adult patients (>= 18 years of age) currently an inpatient at Johns Hopkins Hospital 
					having the following:
						A baseline estimated glomerular filtration rate > 45 mL/min/1.73m2 
					And
						Elevated serum creatinine at the time of the hospital admission during hospitalization, 
					defined as >= 1.5 times the baseline.
					
				Baseline eGFR:
					Query Epic laboratory results to calculate the median of the last three outpatient serum 
					creatinine results that resulted between 365 and 7 days prior to the hospital admission. 
					Outpatient results are defined as any results for serum creatinine lab tests not ordered 
					during an inpatient encounter. The order could have been placed at any JHM outpatient 
					department/clinic.
					If only two results exist within the time window, average the two serum creatinine results.
					If only one result exists within the time window, use the one serum creatinine value.

				Exclusion Criteria:
				
				Patients with the following criteria will be excluded from the extract results:

					Known to be deceased
					Having a BMI > 40 kg/m2 at the time of the hospital admission
					Having an unresolved episode of pregnancy at the time of the hospital admission
					Having an allergy to iodinated contrast (any reaction)
					Having an active chemotherapy or radiation treatment plan, as indicated in the Epic Beacon treatment plan data
					Transplant recipients (any solid organ or bone marrow)
					Existing in the CRMS study for the IRB protocol (any enrollment status)

Example:

EXEC Analytics.dbo.CCDA1672_Parikh_DailyKidneyRecruitment_sp 

Modifications:	1/7/2020	N. Balding
				Do not exclude patients with a BMI of null.  Add BMI as an output field. 
				1/8/2020	N. Balding
				Do not limit past year's creatinine labs to any location.
				1/31/2020	N. Balding
				Include Bayview admissions as well as JHH.
				2/28/2020	N. Balding
				added correction to the way reaction to iodinated contrast was being found
				8/3/2020	N. Balding
				Re-design SP to truncate tables instead of dropping and re-creating them for each run.

***********************************************************************************************************/

begin

--IF OBJECT_ID('Analytics.dbo.CCDA1672_Parikh_Cohort', 'U') IS NOT NULL DROP TABLE Analytics.dbo.CCDA1672_Parikh_Cohort
--IF OBJECT_ID('tempdb..#CCDA1672_Parikh_admittedPatients') IS NOT NULL  DROP TABLE #CCDA1672_Parikh_admittedPatients
--IF OBJECT_ID('Analytics.dbo.CCDA1672_Parikh_admittedPatients', 'U') IS NOT NULL  DROP TABLE Analytics.dbo.CCDA1672_Parikh_admittedPatients
--IF OBJECT_ID('Analytics.dbo.CCDA1672_Parikh_eGFRdata', 'U') IS NOT NULL  DROP TABLE Analytics.dbo.CCDA1672_Parikh_eGFRdata
--IF OBJECT_ID('Analytics.dbo.CCDA1672_Parikh_eGFRdata_wRows', 'U') IS NOT NULL  DROP TABLE Analytics.dbo.CCDA1672_Parikh_eGFRdata_wRows
--IF OBJECT_ID('Analytics.dbo.CCDA1672_Parikh_eGFRdata_Count', 'U') IS NOT NULL  DROP TABLE Analytics.dbo.CCDA1672_Parikh_eGFRdata_Count
--IF OBJECT_ID('Analytics.dbo.CCDA1672_Parikh_medianRange','U') IS NOT NULL  DROP TABLE Analytics.dbo.CCDA1672_Parikh_medianRange
--IF OBJECT_ID('Analytics.dbo.CCDA1672_Parikh_medianFinal','U') IS NOT NULL  DROP TABLE Analytics.dbo.CCDA1672_Parikh_medianFinal
--IF OBJECT_ID('Analytics.dbo.CCDA1672_Parikh_baselineEGFR','U') IS NOT NULL  DROP TABLE Analytics.dbo.CCDA1672_Parikh_baselineEGFR
--IF OBJECT_ID('Analytics.dbo.CCDA1672_Parikh_baselineEGFRwLab','U') IS NOT NULL  DROP TABLE Analytics.dbo.CCDA1672_Parikh_baselineEGFRwLab
--IF OBJECT_ID('Analytics.dbo.CCDA1672_Parikh_baselineEGFRwLabFINAL','U') IS NOT NULL  DROP TABLE Analytics.dbo.CCDA1672_Parikh_baselineEGFRwLabFINAL
--IF OBJECT_ID('Analytics.dbo.CCDA1672_Parikh_DefaultEGFR','U') IS NOT NULL  DROP TABLE Analytics.dbo.CCDA1672_Parikh_DefaultEGFR
--IF OBJECT_ID('Analytics.dbo.CCDA1672_Parikh_LastBUN','U') IS NOT NULL  DROP TABLE Analytics.dbo.CCDA1672_Parikh_LastBUN
--IF OBJECT_ID('Analytics.dbo.CCDA1672_Parikh_LastINR','U') IS NOT NULL  DROP TABLE Analytics.dbo.CCDA1672_Parikh_LastINR
--IF OBJECT_ID('Analytics.dbo.CCDA1672_Parikh_LastPTT','U') IS NOT NULL  DROP TABLE Analytics.dbo.CCDA1672_Parikh_LastPTT
--IF OBJECT_ID('Analytics.dbo.CCDA1672_Parikh_LastPlatelet','U') IS NOT NULL  DROP TABLE Analytics.dbo.CCDA1672_Parikh_LastPlatelet
--IF OBJECT_ID('Analytics.dbo.CCDA1672_Parikh_LastHemoglobin','U') IS NOT NULL  DROP TABLE Analytics.dbo.CCDA1672_Parikh_LastHemoglobin
--IF OBJECT_ID('Analytics.dbo.CCDA1672_Parikh_OncTreatment','U') IS NOT NULL  DROP TABLE Analytics.dbo.CCDA1672_Parikh_OncTreatment
--IF OBJECT_ID('Analytics.dbo.CCDA1672_Parikh_OrgTransplants','U') IS NOT NULL  DROP TABLE Analytics.dbo.CCDA1672_Parikh_OrgTransplants
--IF OBJECT_ID('Analytics.dbo.CCDA1672_Parikh_BmtTreatment','U') IS NOT NULL  DROP TABLE Analytics.dbo.CCDA1672_Parikh_BmtTreatment
--IF OBJECT_ID('Analytics.dbo.CCDA1672_Parikh_CurrentAPmeds','U') IS NOT NULL  DROP TABLE Analytics.dbo.CCDA1672_Parikh_CurrentAPmeds
--IF OBJECT_ID('Analytics.dbo.CCDA1672_Parikh_CurrentACmeds','U') IS NOT NULL  DROP TABLE Analytics.dbo.CCDA1672_Parikh_CurrentACmeds
--IF OBJECT_ID('Analytics.dbo.CCDA1672_Parikh_CurrentPRmeds','U') IS NOT NULL  DROP TABLE Analytics.dbo.CCDA1672_Parikh_CurrentPRmeds
--IF OBJECT_ID('Analytics.dbo.CCDA1672_Parikh_BP','U') IS NOT NULL  DROP TABLE Analytics.dbo.CCDA1672_Parikh_BP
--IF OBJECT_ID('Analytics.dbo.CCDA1672_Parikh_VentOrders','U') IS NOT NULL  DROP TABLE Analytics.dbo.CCDA1672_Parikh_VentOrders
--IF OBJECT_ID('Analytics.dbo.CCDA1672_Parikh_SerCreatPostAdmit','U') IS NOT NULL  DROP TABLE Analytics.dbo.CCDA1672_Parikh_SerCreatPostAdmit
--IF OBJECT_ID('Analytics.dbo.CCDA1672_Parikh_Report_Enc','U') IS NOT NULL  DROP TABLE Analytics.dbo.CCDA1672_Parikh_Report_Enc
--IF OBJECT_ID('Analytics.dbo.CCDA1672_Parikh_Report_Prov','U') IS NOT NULL  DROP TABLE Analytics.dbo.CCDA1672_Parikh_Report_Prov

--IF OBJECT_ID('Analytics.dbo.CCDA1672_Parikh_Allergy','U') IS NOT NULL  DROP TABLE Analytics.dbo.CCDA1672_Parikh_Allergy



--no longer limiting this to last 24 hours
--declare @startTime as datetime
--		,@endTime as datetime
---- get span of the last day in its entirety
--select @startTime = DATEADD(dd, -1, DATEDIFF(dd, 0, GETDATE())) 
--	,@endTime = dateadd(second, -1, dateadd(day, -1, datediff(day, -1, getdate()))) 
--select @startTime, @endTime



IF OBJECT_ID('tempdb..#CCDA1672_Parikh_admittedPatients') IS NOT NULL  DROP TABLE #CCDA1672_Parikh_admittedPatients

-- find list of adult patients admitted in last 24 hours even if originating from ED
select distinct 
		pat.PAT_ID
		,hsp.PAT_ENC_CSN_ID
		,coalesce(hsp.HOSP_ADMSN_TIME, hsp.adt_arrival_time)							'HOSP_ADMSN_TIME'
--,pe.ENC_TYPE_C
--,hsp.*
into #CCDA1672_Parikh_admittedPatients
from CLARITY.dbo.PATIENT pat WITH (NOLOCK) 
inner join CLARITY.dbo.PAT_ENC_HSP hsp WITH (NOLOCK) on pat.PAT_ID = hsp.PAT_ID
inner join CLARITY.dbo.PAT_ENC pe WITH (NOLOCK) on hsp.PAT_ENC_CSN_ID = pe.PAT_ENC_CSN_ID
inner join CLARITY.dbo.V_PAT_ADT_LOCATION_HX adt WITH (NOLOCK) on hsp.PAT_ENC_CSN_ID = adt.PAT_ENC_CSN
															and adt.EVENT_TYPE_C = 1 -- admission
															and adt.ADT_DEPARTMENT_ID is not null
where round(DATEDIFF(hour,pat.BIRTH_DATE, coalesce(hsp.HOSP_ADMSN_TIME, pe.CONTACT_DATE))/8766.0, 0, 1) >= 18  -- 18 years or older at time of admission or ED 
--and coalesce(hsp.HOSP_ADMSN_TIME, pe.CONTACT_DATE) between @startTime and @endTime -- beginning with admit or ED    no longer limiting to last 24 hours
--and pe.PRIMARY_LOC_ID LIKE '1101%'-- JHH FACILITIES ONLY   -- this is patient level, not encounter level
and (adt.ADT_LOC_ID LIKE '1101%'-- JHH FACILITIES 
	or adt.ADT_LOC_ID LIKE '1102%'--Bayview		-- 1/31/2020  add Bayview
	)
and isnull(hsp.ADT_PATIENT_STAT_C,0) not in (1,6) -- not HOV or preadmission
and isnull(hsp.ADMIT_CONF_STAT_C,0) not in (2,3)  -- no canceled or pending
and isnull(pe.SERV_AREA_ID,0) in (0,11)   -- remove additional service areas except null and 11
and isnull(hsp.ADT_SERV_AREA_ID,0) in (0,11)   -- remove additional service areas except null and 11
and coalesce(hsp.HOSP_ADMSN_TIME, hsp.adt_arrival_time) is NOT null  -- must have a inpatient or ED arrival time
and hsp.HOSP_DISCH_TIME is null  -- NOT discharged
order by pat.PAT_ID
--order by 'HOSP_ADMSN_TIME'




truncate table Analytics.dbo.CCDA1672_Parikh_admittedPatients

-- add date range to examine eGFR scores from 365 to 7 days prior to admission date
-- add race factor to use to calculate eGFR score
insert into Analytics.dbo.CCDA1672_Parikh_admittedPatients
	(PAT_ID, hsp.PAT_ENC_CSN_ID, HOSP_ADMSN_TIME, eGFRbaseStartDate, eGFRbaseEndDate, Race)
select	ap.* 
		,DATEADD(dd, 0, datediff(dd, 0, DATEadd(DAY, -365, ap.HOSP_ADMSN_TIME)))					'eGFRbaseStartDate'
		,dateadd(second, -1, DATEADD(dd, 1, datediff(dd, 0, DATEadd(DAY, -7, ap.HOSP_ADMSN_TIME))))	'eGFRbaseEndDate'
		,case when exists (select  *	
							from clarity.dbo.Patient_Race pr_inner WITH (NOLOCK) 
							left outer join clarity.dbo.ZC_PATIENT_RACE zpr_inner WITH (NOLOCK) on pr_inner.PATIENT_RACE_C = zpr_inner.PATIENT_RACE_C
							where pr_inner.pat_id = ap.PAT_ID
							and zpr_inner.NAME = 'Black or African American'
							)
			then 'Black'
			else 'non-Black'

			end																						'Race'
from #CCDA1672_Parikh_admittedPatients ap

ALTER TABLE Analytics.dbo.CCDA1672_Parikh_admittedPatients 
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)




-- calculate eGFR based on Creatinine labs
truncate table Analytics.dbo.CCDA1672_Parikh_eGFRdata

insert into Analytics.dbo.CCDA1672_Parikh_eGFRdata
	(PAT_ID, Race, AgeAtCollection, RESULT_TIME, LabResult, REFERENCE_UNIT, Gender, eGfrCalcValue)
select 
	distinct 
	ap.PAT_ID
	,ap.Race
	,format(round(DATEDIFF(hour
							,pat.BIRTH_DATE
							,ord.ORDERING_DATE
							)/8766.0, 0, 1)
						,'N0')								'AgeAtCollection'
--	,ord.ORDERING_DATE		
	,res.RESULT_TIME
	,case when isnull(res.ORD_NUM_VALUE,9999999) = 9999999 
			then null
			else res.ORD_NUM_VALUE
			end												'LabResult'
	,res.REFERENCE_UNIT													
	,zs.NAME												'Gender'
/**************************************************************************************************************************
********                       pulling the eGFR calculation for Creatinine                   
********
********  
********  Creatinine equation:
********  eGFR = 141 x min(SCr/?, 1)? x max(SCr /?, 1)-1.209 x 0.993Age x 1.018 [if female] x 1.159 [if Black]
********  
********  Abbreviations / Units
********  eGFR (estimated glomerular filtration rate) = mL/min/1.73 m2
********  SCr (standardized serum creatinine) = mg/dL
********  ? = 0.7 (females) or 0.9 (males)
********  ? = -0.329 (females) or -0.411 (males)
********  min = indicates the minimum of SCr/? or 1
********  max = indicates the maximum of SCr/? or 1
********  age = years
********  
********  For females: 
********  If Cr >0.7, set min to 1.
********  If Cr less than or equal to 0.7, set max to 1.
********  
********  For males:
********  If Cr >0.9, set min to 1.
********  If Cr less than or equal to 0.9, set max to 1.
********
***************************************************************************************************************************/

	,
	--format
	--(
	case when 
			res.REFERENCE_UNIT is NOT NULL 
			and res.ORD_NUM_VALUE is not null 
			and ISNUMERIC(res.ORD_NUM_VALUE) = 1
			then
			case 
				when pat.sex_c = 1 and ap.Race = 'Black' and res.ORD_NUM_VALUE <= .7 -- if Black female and value <= .7
				then 141 
					* power(res.ORD_NUM_VALUE/0.7, -0.329) 
					* power(1, -1.209)
					* power(0.993, round(DATEDIFF(hour, pat.BIRTH_DATE, ord.ORDERING_DATE)/8766.0, 0, 1)) 
					* 1.018 -- if female 
					* 1.159 -- if Black
				when pat.sex_c = 1 and ap.Race = 'Black' and res.ORD_NUM_VALUE > .7 -- if Black female and value > .7
				then 141 
					* power(1,-0.329) 
					* power(res.ORD_NUM_VALUE/0.7, -1.209)
					* power(0.993, round(DATEDIFF(hour, pat.BIRTH_DATE, ord.ORDERING_DATE)/8766.0, 0, 1)) 
					* 1.018 -- if female 
					* 1.159 -- if Black

				when pat.SEX_C = 1 and ap.Race = 'non-Black' and res.ORD_NUM_VALUE <= .7 /*race.PATIENT_RACE_C <> 2*/ -- if non-Black female
				then 141 
					* power(res.ORD_NUM_VALUE/0.7,-0.329) 
					* power(1, -1.209)
					* power(0.993, round(DATEDIFF(hour, pat.BIRTH_DATE, ord.ORDERING_DATE)/8766.0, 0, 1)) 
					* 1.018 -- if female 
				when pat.SEX_C = 1 and ap.Race = 'non-Black' and res.ORD_NUM_VALUE > .7 /*race.PATIENT_RACE_C <> 2*/ -- if non-Black female
				then 141 
					* power(1,-0.329) 
					* power(res.ORD_NUM_VALUE/0.7, -1.209)
					* power(0.993, round(DATEDIFF(hour, pat.BIRTH_DATE, ord.ORDERING_DATE)/8766.0, 0, 1)) 
					* 1.018 -- if female 

				when pat.SEX_C = 2 and ap.Race = 'Black' and res.ORD_NUM_VALUE <= .9 /*race.PATIENT_RACE_C = 2*/ -- if Black male
				then 141 
					* power((res.ORD_NUM_VALUE/0.9),-0.411) 
					* power(1, -1.209)
					* power(0.993, round(DATEDIFF(hour, pat.BIRTH_DATE, ord.ORDERING_DATE)/8766.0, 0, 1)) 
					* 1.159 -- if Black
				when pat.SEX_C = 2 and ap.Race = 'Black' and res.ORD_NUM_VALUE > .9 /*race.PATIENT_RACE_C = 2*/ -- if Black male
				then 141 
					* power(1,-0.411) 
					* power((res.ORD_NUM_VALUE/0.9), -1.209)
					* power(0.993, round(DATEDIFF(hour, pat.BIRTH_DATE, ord.ORDERING_DATE)/8766.0, 0, 1)) 
					* 1.159 -- if Black

				when pat.SEX_C = 2 and ap.Race = 'non-Black' and res.ORD_NUM_VALUE <= .9 /*race.PATIENT_RACE_C = 2*/ -- if non-Black male
				then 141 
					* power((res.ORD_NUM_VALUE/0.9),-0.411) 
					* power(1, -1.209)
					* power(0.993, round(DATEDIFF(hour, pat.BIRTH_DATE, ord.ORDERING_DATE)/8766.0, 0, 1)) 
				when pat.SEX_C = 2 and ap.Race = 'non-Black' and res.ORD_NUM_VALUE > .9 /*race.PATIENT_RACE_C = 2*/ -- if Black male
				then 141 
					* power(1,-0.411) 
					* power((res.ORD_NUM_VALUE/0.9), -1.209)
					* power(0.993, round(DATEDIFF(hour, pat.BIRTH_DATE, ord.ORDERING_DATE)/8766.0, 0, 1)) 
					* 1.159 -- if Black

			end																		

	end
	--,'N0')															
																		'eGfrCalcValue'
/**************************************************************************************************************************/

from Analytics.dbo.CCDA1672_Parikh_admittedPatients ap
inner join CLARITY.dbo.PAT_ENC pe WITH (NOLOCK) on ap.PAT_ID = pe.PAT_ID
inner join CLARITY.dbo.ORDER_PROC ord WITH (NOLOCK) on ap.PAT_ID = ord.PAT_ID
														and pe.PAT_ENC_CSN_ID = ord.PAT_ENC_CSN_ID
inner join CLARITY.dbo.ORDER_RESULTS res WITH (NOLOCK) on ord.ORDER_PROC_ID = res.ORDER_PROC_ID
														and res.RESULT_TIME between ap.eGFRbaseStartDate and ap.eGFRbaseEndDate
inner join CLARITY.dbo.CLARITY_COMPONENT cc WITH (NOLOCK) on res.COMPONENT_ID = cc.COMPONENT_ID

inner join Analytics.dbo.CCDA1672_Parikh_Creatinine_Labs kcl on cc.COMPONENT_ID = kcl.Component_ID

inner join CLARITY.dbo.PATIENT pat WITH (NOLOCK) on ap.pat_id = pat.PAT_ID
left outer join CLARITY.dbo.ZC_SEX zs on pat.SEX_C = zs.RCPT_MEM_SEX_C

where 
--ord.PROC_START_TIME >= @dateBegin 
--AND ord.PROC_START_TIME < @dateEnd
isnull(ord.ORDER_STATUS_C,0) in (0,5) -- completed or null
AND ISNULL(cc.RECORD_STATE_C,0) = 0
and ord.LAB_STATUS_C in (3,5) -- final or final edited
and res.REFERENCE_UNIT = 'mg/dL'

-- no longer limiting past year's creatinine labs to any location 
--and pe.PRIMARY_LOC_ID LIKE '1101%'-- JHH FACILITIES ONLY

-- no longer limiting to in-person outpatient encounters
--and pe.enc_type_c in ('6', '1000', '1001', '1003', '1004', '101', '108', '1200', '1201', '121', '1214', '2', '200'
--					,'210', '2100', '2101', '2501', '2502', '2508', '2520', '2525', '2526', '50', '81' ) 

and isnull(pe.SERV_AREA_ID,0) in (0,11)   --  remove additional service areas except null and 11
and isnull(ord.SERV_AREA_ID,0) in (0,11)   --  remove additional service areas except null and 11

order by ap.Pat_ID, res.RESULT_TIME --, eGfrCalcValue



ALTER TABLE Analytics.dbo.CCDA1672_Parikh_eGFRdata 
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)




-- number each eGFR score in chronological order for each patient
truncate table Analytics.dbo.CCDA1672_Parikh_eGFRdata_wRows

insert into Analytics.dbo.CCDA1672_Parikh_eGFRdata_wRows
	(PAT_ID, Race, AgeAtCollection, RESULT_TIME, LabResult, REFERENCE_UNIT, Gender, eGfrCalcValue, PAT_eGFR_ROW)
select * 
	,ROW_NUMBER() OVER (PARTITION BY PAT_ID order by pat_ID, result_TIME) AS PAT_eGFR_ROW
from Analytics.dbo.CCDA1672_Parikh_eGFRdata
where LabResult is not null
order by PAT_ID  , PAT_eGFR_ROW  --RESULT_TIME


ALTER TABLE Analytics.dbo.CCDA1672_Parikh_eGFRdata_wRows
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)




-- find count of labs per patient
truncate table Analytics.dbo.CCDA1672_Parikh_eGFRdata_Count


insert into Analytics.dbo.CCDA1672_Parikh_eGFRdata_Count
	(pat_id, CountOfLabsPerPat)
select pat_id
		,COUNT(pat_id)		CountOfLabsPerPat
--		,COUNT(pat_id) % 2	OddNumber -- test for odd number
from Analytics.dbo.CCDA1672_Parikh_eGFRdata_wRows
group by PAT_ID
order by PAT_ID


ALTER TABLE Analytics.dbo.CCDA1672_Parikh_eGFRdata_Count
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)




-- for patients with 3 or more eGFR scores in past year, find the latest 3 values
-- in preparation to find median for last 3 scores
truncate table Analytics.dbo.CCDA1672_Parikh_medianRange


insert into Analytics.dbo.CCDA1672_Parikh_medianRange
	(PAT_ID, startMedianRange, endMedianRange)
select	PAT_ID
		, max(PAT_eGFR_ROW) - 2		'startMedianRange'
		, max(PAT_eGFR_ROW)			'endMedianRange'
from Analytics.dbo.CCDA1672_Parikh_eGFRdata_wRows
where pat_id in 
	(select PAT_ID 
	from Analytics.dbo.CCDA1672_Parikh_eGFRdata_wRows
	group by pat_id
	having COUNT(PAT_ID) >= 3
	--order by PAT_ID
	)
group by PAT_ID
order by PAT_ID


ALTER TABLE Analytics.dbo.CCDA1672_Parikh_medianRange
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)




-- rank the last 3 values and put them in order
-- in preparation to find median for last 3 scores
truncate table Analytics.dbo.CCDA1672_Parikh_medianFinal

insert into Analytics.dbo.CCDA1672_Parikh_medianFinal
	(PAT_ID, eGfrCalcValue, FinalOrderRow)
select grp.PAT_ID
		,grp.eGfrCalcValue
		,ROW_NUMBER() over (partition by pat_ID order by grp.OrderRank, grp.PAT_eGFR_ROW) as FinalOrderRow
from 
	(select r.* 
			,RANK() over(partition by r.pat_id order by r.eGfrCalcValue asc) as OrderRank
	from Analytics.dbo.CCDA1672_Parikh_medianRange mr
	inner join Analytics.dbo.CCDA1672_Parikh_eGFRdata_wRows r on mr.PAT_ID = r.PAT_ID
	where r.PAT_eGFR_ROW between mr.startMedianRange and mr.endMedianRange
	) grp

ALTER TABLE Analytics.dbo.CCDA1672_Parikh_medianFinal
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)



-- calculate baseline eGFR scores for each patient
truncate table Analytics.dbo.CCDA1672_Parikh_baselineEGFR

insert into Analytics.dbo.CCDA1672_Parikh_baselineEGFR
	(PAT_ID, BaseLineEGFR, Method)
select 
	distinct
	ec.PAT_ID 
	,case 
		-- if number of eGFR readings >= 3 and count is an even number, calculate median
		when ec.CountOfLabsPerPat >= 3 
			then 
				(	select mf.eGfrCalcValue
					from Analytics.dbo.CCDA1672_Parikh_medianFinal mf
					where mf.pat_id = ec.PAT_ID
					and mf.FinalOrderRow = 2
				)	

		-- if number of eGFR readings = 2, calculate average
		when ec.CountOfLabsPerPat = 2
			then 
				(
					(select er.eGfrCalcValue
					from Analytics.dbo.CCDA1672_Parikh_eGFRdata_wRows er
					where er.pat_id = ec.PAT_ID
					and er.PAT_eGFR_ROW = 1
					)
				+
					(select er.eGfrCalcValue
					from Analytics.dbo.CCDA1672_Parikh_eGFRdata_wRows er
					where er.pat_id = ec.PAT_ID
					and er.PAT_eGFR_ROW = 2
					)
				)
				/ 2

		-- if number of eGFR readings = 1, use the 1 eGFR score
		when ec.CountOfLabsPerPat = 1
			then
				(	select er.eGfrCalcValue
					from Analytics.dbo.CCDA1672_Parikh_eGFRdata_wRows er
					where er.pat_id = ec.PAT_ID
					and er.PAT_eGFR_ROW = 1
				)	

		end									BaseLineEGFR
	,case 
		-- if number of eGFR readings >= 3 and count is an even number, calculate median
		when ec.CountOfLabsPerPat >= 3 
			then 'Median'	

		-- if number of eGFR readings = 2, calculate average
		when ec.CountOfLabsPerPat = 2
			then 'Average'

		-- if number of eGFR readings = 1, use the 1 eGFR score
		when ec.CountOfLabsPerPat = 1
			then 'Single'	
		end									Method

from Analytics.dbo.CCDA1672_Parikh_eGFRdata_Count ec 
order by ec.PAT_ID



ALTER TABLE Analytics.dbo.CCDA1672_Parikh_baselineEGFR
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)




-- pull in original serum creatine score for each patient if match can be found 
-- by the baseline eGFR score
-- For those patients with exactly 2 scores of the same value, a match will NOT 
-- be found because the average of 2 eGFR scores was taken.
truncate table Analytics.dbo.CCDA1672_Parikh_baselineEGFRwLab

insert into Analytics.dbo.CCDA1672_Parikh_baselineEGFRwLab
	(PAT_ID, egfr.BaseLineEGFR, LabResult, Method)
select	distinct
		egfr.PAT_ID
		,egfr.BaseLineEGFR
		,er.LabResult
		,egfr.Method
from Analytics.dbo.CCDA1672_Parikh_baselineEGFR egfr
left outer join Analytics.dbo.CCDA1672_Parikh_eGFRdata_wRows er 
				on egfr.PAT_ID = er.PAT_ID
				and egfr.BaseLineEGFR = er.eGfrCalcValue
order by egfr.PAT_ID



ALTER TABLE Analytics.dbo.CCDA1672_Parikh_baselineEGFRwLab
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)




-- Pull baseline and serum creatinine scores into FINAL table if serum creatinine 
-- scores can be found.
-- Extrapolate serum creatine values by calculating the average where no match could be found and 
-- exactly 2 differing eGFR scores were found per patient.
truncate table Analytics.dbo.CCDA1672_Parikh_baselineEGFRwLabFINAL

insert into Analytics.dbo.CCDA1672_Parikh_baselineEGFRwLabFINAL
	(PAT_ID, egfr.BaseLineEGFR, LabResult, Method)
select grp.*
from 
	(
	select *
	from Analytics.dbo.CCDA1672_Parikh_baselineEGFRwLab bel
	where bel.LabResult is NOT NULL

	UNION

	select distinct 
			bel.PAT_ID
			,bel.BaseLineEGFR
			,(
				select sum(er.LabResult) / 2
				from Analytics.dbo.CCDA1672_Parikh_eGFRdata_wRows er 
				where er.PAT_ID = bel.PAT_ID 
				and er.PAT_eGFR_ROW in (1,2)
			
			)															LabResult
			,bel.Method
	from Analytics.dbo.CCDA1672_Parikh_baselineEGFRwLab bel
	inner join Analytics.dbo.CCDA1672_Parikh_eGFRdata_Count c on bel.PAT_ID = c.PAT_ID
																	and c.CountOfLabsPerPat = 2
	where bel.LabResult is null
	--order by bel.PAT_ID
	)
	grp
order by grp.PAT_ID


ALTER TABLE Analytics.dbo.CCDA1672_Parikh_baselineEGFRwLabFINAL
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)





-- find patients where there is no valid serum creatinine lab in past year
truncate table Analytics.dbo.CCDA1672_Parikh_DefaultEGFR

insert into Analytics.dbo.CCDA1672_Parikh_DefaultEGFR
	(PAT_ID, hsp.PAT_ENC_CSN_ID, HOSP_ADMSN_TIME, eGFRbaseStartDate, eGFRbaseEndDate, Race)
select distinct ap.*
from Analytics.dbo.CCDA1672_Parikh_admittedPatients ap
-- patient cannot have any valid numeric serum creatinine lab result in past year
where ap.pat_id not in (
						select 
							distinct 
							ap.PAT_ID
						from Analytics.dbo.CCDA1672_Parikh_admittedPatients ap
						inner join CLARITY.dbo.PAT_ENC pe WITH (NOLOCK) on ap.PAT_ID = pe.PAT_ID
						inner join CLARITY.dbo.ORDER_PROC ord WITH (NOLOCK) on ap.PAT_ID = ord.PAT_ID
																				and pe.PAT_ENC_CSN_ID = ord.PAT_ENC_CSN_ID
						inner join CLARITY.dbo.ORDER_RESULTS res WITH (NOLOCK) on ord.ORDER_PROC_ID = res.ORDER_PROC_ID
																				and res.RESULT_TIME between ap.eGFRbaseStartDate and ap.eGFRbaseEndDate
						inner join CLARITY.dbo.CLARITY_COMPONENT cc WITH (NOLOCK) on res.COMPONENT_ID = cc.COMPONENT_ID
						-- using Creatinine labs defined by another study
						inner join Analytics.dbo.CCDA1672_Parikh_Creatinine_Labs kcl on cc.COMPONENT_ID = kcl.Component_ID
						inner join CLARITY.dbo.PATIENT pat WITH (NOLOCK) on ap.pat_id = pat.PAT_ID
						left outer join CLARITY.dbo.ZC_SEX zs on pat.SEX_C = zs.RCPT_MEM_SEX_C

						where 
						isnull(ord.ORDER_STATUS_C,0) in (0,5) -- completed or null
						AND ISNULL(cc.RECORD_STATE_C,0) = 0
						and ord.LAB_STATUS_C in (3,5) -- final or final edited
						and res.REFERENCE_UNIT = 'mg/dL'
						
						-- no longer limiting past year's creatinine labs to any location 
						--and pe.PRIMARY_LOC_ID LIKE '1101%'-- JHH FACILITIES ONLY
						--no longer limiting this to in-person outpatient encounters
							-- outpatient encounters only
						--and pe.enc_type_c in ('6', '1000', '1001', '1003', '1004', '101', '108', '1200', '1201', '121', '1214', '2', '200'
						--					,'210', '2100', '2101', '2501', '2502', '2508', '2520', '2525', '2526', '50', '81' ) 
						and isnull(pe.SERV_AREA_ID,0) in (0,11)   --  remove additional service areas except null and 11
						and isnull(ord.SERV_AREA_ID,0) in (0,11)   --  remove additional service areas except null and 11
						and isnull(res.ORD_NUM_VALUE,9999999) <> 9999999  -- numeric value
)



ALTER TABLE Analytics.dbo.CCDA1672_Parikh_DefaultEGFR
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)





-- need to set serum creatine default value to 1.0 mg/dL and calculate the eGFR for each individual patient
-- given age and race for all patients that fit criteria but have no valid serum creatinine lab in past year
declare @defaultSerumCreatinine as float 
set @defaultSerumCreatinine = 1.0

truncate table Analytics.dbo.CCDA1672_Parikh_baselineEGFRwLabFINAL

INSERT into Analytics.dbo.CCDA1672_Parikh_baselineEGFRwLabFINAL
	(PAT_ID, BaseLineEGFR, LabResult, Method)
select 
	distinct 
	ap.PAT_ID
	,case 
		when pat.sex_c = 1 and ap.Race = 'Black' and @defaultSerumCreatinine <= .7 -- if Black female and value <= .7
		then 141 
			* power(@defaultSerumCreatinine/0.7, -0.329) 
			* power(1, -1.209)
			* power(0.993, round(DATEDIFF(hour, pat.BIRTH_DATE, getdate())/8766.0, 0, 1)) 
			* 1.018 -- if female 
			* 1.159 -- if Black
		when pat.sex_c = 1 and ap.Race = 'Black' and @defaultSerumCreatinine > .7 -- if Black female and value > .7
		then 141 
			* power(1,-0.329) 
			* power(@defaultSerumCreatinine/0.7, -1.209)
			* power(0.993, round(DATEDIFF(hour, pat.BIRTH_DATE, getdate())/8766.0, 0, 1)) 
			* 1.018 -- if female 
			* 1.159 -- if Black

		when pat.SEX_C = 1 and ap.Race = 'non-Black' and @defaultSerumCreatinine <= .7 /*race.PATIENT_RACE_C <> 2*/ -- if non-Black female
		then 141 
			* power(@defaultSerumCreatinine/0.7,-0.329) 
			* power(1, -1.209)
			* power(0.993, round(DATEDIFF(hour, pat.BIRTH_DATE, getdate())/8766.0, 0, 1)) 
			* 1.018 -- if female 
		when pat.SEX_C = 1 and ap.Race = 'non-Black' and @defaultSerumCreatinine > .7 /*race.PATIENT_RACE_C <> 2*/ -- if non-Black female
		then 141 
			* power(1,-0.329) 
			* power(@defaultSerumCreatinine/0.7, -1.209)
			* power(0.993, round(DATEDIFF(hour, pat.BIRTH_DATE, getdate())/8766.0, 0, 1)) 
			* 1.018 -- if female 

		when pat.SEX_C = 2 and ap.Race = 'Black' and @defaultSerumCreatinine <= .9 /*race.PATIENT_RACE_C = 2*/ -- if Black male
		then 141 
			* power((@defaultSerumCreatinine/0.9),-0.411) 
			* power(1, -1.209)
			* power(0.993, round(DATEDIFF(hour, pat.BIRTH_DATE, getdate())/8766.0, 0, 1)) 
			* 1.159 -- if Black
		when pat.SEX_C = 2 and ap.Race = 'Black' and @defaultSerumCreatinine > .9 /*race.PATIENT_RACE_C = 2*/ -- if Black male
		then 141 
			* power(1,-0.411) 
			* power((@defaultSerumCreatinine/0.9), -1.209)
			* power(0.993, round(DATEDIFF(hour, pat.BIRTH_DATE, getdate())/8766.0, 0, 1)) 
			* 1.159 -- if Black

		when pat.SEX_C = 2 and ap.Race = 'non-Black' and @defaultSerumCreatinine <= .9 /*race.PATIENT_RACE_C = 2*/ -- if non-Black male
		then 141 
			* power((@defaultSerumCreatinine/0.9),-0.411) 
			* power(1, -1.209)
			* power(0.993, round(DATEDIFF(hour, pat.BIRTH_DATE, getdate())/8766.0, 0, 1)) 
		when pat.SEX_C = 2 and ap.Race = 'non-Black' and @defaultSerumCreatinine > .9 /*race.PATIENT_RACE_C = 2*/ -- if Black male
		then 141 
			* power(1,-0.411) 
			* power((@defaultSerumCreatinine/0.9), -1.209)
			* power(0.993, round(DATEDIFF(hour, pat.BIRTH_DATE, getdate())/8766.0, 0, 1)) 
			* 1.159 -- if Black

	end																		
																'BaseLineEGFR'
/**************************************************************************************************************************/
	,@defaultSerumCreatinine									'LabResult'
	,'Imputed'													'Method'

from Analytics.dbo.CCDA1672_Parikh_DefaultEGFR ap
inner join CLARITY.dbo.PATIENT pat WITH (NOLOCK) on ap.pat_id = pat.PAT_ID
left outer join CLARITY.dbo.ZC_SEX zs on pat.SEX_C = zs.RCPT_MEM_SEX_C


ALTER TABLE Analytics.dbo.CCDA1672_Parikh_baselineEGFRwLabFINAL
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)




-- find most recent BUN value
truncate table Analytics.dbo.CCDA1672_Parikh_LastBUN

insert into Analytics.dbo.CCDA1672_Parikh_LastBUN
	(PAT_ID, [Most Recent Blood Urea Nitrogen (BUN) (mg/dL)])
select	distinct grp.PAT_ID
		-- wants value without the units
		--,cast(res.ORD_NUM_VALUE as varchar(25)) + ' ' + res.REFERENCE_UNIT		'Most Recent Blood Urea Nitrogen (BUN)'
		,res.ORD_NUM_VALUE 		'Most Recent Blood Urea Nitrogen (BUN) (mg/dL)'
from 
(select	distinct 
		ap.PAT_ID
		,max(res.ORDER_PROC_ID)		LastBUNorder
from Analytics.dbo.CCDA1672_Parikh_admittedPatients ap
inner join CLARITY.dbo.ORDER_PROC ord WITH (NOLOCK) on ap.PAT_ID = ord.PAT_ID
inner join CLARITY.dbo.ORDER_RESULTS res WITH (NOLOCK) on ord.ORDER_PROC_ID = res.ORDER_PROC_ID
inner join CLARITY.dbo.CLARITY_COMPONENT cc WITH (NOLOCK) on res.COMPONENT_ID = cc.COMPONENT_ID
-- using BUN labs defined by researcher
inner join Analytics.dbo.CCDA1672_Parikh_LabsBUN plb on cc.COMPONENT_ID = plb.Component_ID
where isnull(ord.ORDER_STATUS_C,0) in (0,5) -- completed or null
AND ISNULL(cc.RECORD_STATE_C,0) = 0
and ord.LAB_STATUS_C in (3,5) -- final or final edited
--and isnull(res.REFERENCE_UNIT,'') = 'mg/dL'
and isnull(res.ORD_NUM_VALUE,9999999) <> 9999999  -- must be numeric result
and isnull(ord.SERV_AREA_ID,0) in (0,11)   --  remove additional service areas except null and 11
group by ap.PAT_ID
) grp
inner join CLARITY.dbo.ORDER_RESULTS res WITH (NOLOCK) on grp.LastBUNorder = res.ORDER_PROC_ID
inner join Analytics.dbo.CCDA1672_Parikh_LabsBUN plb on res.COMPONENT_ID = plb.Component_ID
where isnull(res.ORD_NUM_VALUE,9999999) <> 9999999  -- must be numeric result
order by grp.PAT_ID


ALTER TABLE Analytics.dbo.CCDA1672_Parikh_LastBUN
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)




-- find most recent INR value
truncate table Analytics.dbo.CCDA1672_Parikh_LastINR

insert into Analytics.dbo.CCDA1672_Parikh_LastINR
select	grp.PAT_ID
		,res.ORD_NUM_VALUE		'Most Recent International Normalized Ratios (INR)'
from 
(select	distinct 
		ap.PAT_ID
		,max(res.ORDER_PROC_ID)		LastINRorder
from Analytics.dbo.CCDA1672_Parikh_admittedPatients ap
inner join CLARITY.dbo.ORDER_PROC ord WITH (NOLOCK) on ap.PAT_ID = ord.PAT_ID
inner join CLARITY.dbo.ORDER_RESULTS res WITH (NOLOCK) on ord.ORDER_PROC_ID = res.ORDER_PROC_ID
inner join CLARITY.dbo.CLARITY_COMPONENT cc WITH (NOLOCK) on res.COMPONENT_ID = cc.COMPONENT_ID
-- using INR labs defined by researcher
inner join Analytics.dbo.CCDA1672_Parikh_LabsINR plb on cc.COMPONENT_ID = plb.Component_ID
where isnull(ord.ORDER_STATUS_C,0) in (0,5) -- completed or null
AND ISNULL(cc.RECORD_STATE_C,0) = 0
and ord.LAB_STATUS_C in (3,5) -- final or final edited
--and isnull(res.REFERENCE_UNIT,'') = 'mg/dL'
and isnull(res.ORD_NUM_VALUE,9999999) <> 9999999  -- must be numeric result
and isnull(ord.SERV_AREA_ID,0) in (0,11)   --  remove additional service areas except null and 11
group by ap.PAT_ID
) grp
inner join CLARITY.dbo.ORDER_RESULTS res WITH (NOLOCK) on grp.LastINRorder = res.ORDER_PROC_ID
inner join Analytics.dbo.CCDA1672_Parikh_LabsINR plb on res.COMPONENT_ID = plb.Component_ID
where isnull(res.ORD_NUM_VALUE,9999999) <> 9999999  -- must be numeric result
order by grp.PAT_ID


ALTER TABLE Analytics.dbo.CCDA1672_Parikh_LastINR
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)



-- find most recent PTT value
truncate table Analytics.dbo.CCDA1672_Parikh_LastPTT

insert into Analytics.dbo.CCDA1672_Parikh_LastPTT
	(PAT_ID, [Most Recent PTT (seconds)])
select	grp.PAT_ID
		-- wants value without the units
		--,cast(res.ORD_NUM_VALUE as varchar(25)) + ' ' + res.REFERENCE_UNIT		'Most Recent PTT'
		,res.ORD_NUM_VALUE			'Most Recent PTT (seconds)'
from 
(select	distinct 
		ap.PAT_ID
		,max(res.ORDER_PROC_ID)		LastPTTorder
from Analytics.dbo.CCDA1672_Parikh_admittedPatients ap
inner join CLARITY.dbo.ORDER_PROC ord WITH (NOLOCK) on ap.PAT_ID = ord.PAT_ID
inner join CLARITY.dbo.ORDER_RESULTS res WITH (NOLOCK) on ord.ORDER_PROC_ID = res.ORDER_PROC_ID
inner join CLARITY.dbo.CLARITY_COMPONENT cc WITH (NOLOCK) on res.COMPONENT_ID = cc.COMPONENT_ID
-- using PTT labs defined by researcher
inner join Analytics.dbo.CCDA1672_Parikh_LabsPTT plb on cc.COMPONENT_ID = plb.Component_ID
where isnull(ord.ORDER_STATUS_C,0) in (0,5) -- completed or null
AND ISNULL(cc.RECORD_STATE_C,0) = 0
and ord.LAB_STATUS_C in (3,5) -- final or final edited
--and isnull(res.REFERENCE_UNIT,'') = 'mg/dL'
and isnull(res.ORD_NUM_VALUE,9999999) <> 9999999  -- must be numeric result
and isnull(ord.SERV_AREA_ID,0) in (0,11)   --  remove additional service areas except null and 11
group by ap.PAT_ID
) grp
inner join CLARITY.dbo.ORDER_RESULTS res WITH (NOLOCK) on grp.LastPTTorder = res.ORDER_PROC_ID
inner join Analytics.dbo.CCDA1672_Parikh_LabsPTT plb on res.COMPONENT_ID = plb.Component_ID
where isnull(res.ORD_NUM_VALUE,9999999) <> 9999999  -- must be numeric result
order by grp.PAT_ID


ALTER TABLE Analytics.dbo.CCDA1672_Parikh_LastPTT
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)




-- find most recent Platelet value
truncate table Analytics.dbo.CCDA1672_Parikh_LastPlatelet

insert into Analytics.dbo.CCDA1672_Parikh_LastPlatelet
	(PAT_ID, [Most Recent Platelet Count (K/cu mm)])
select	grp.PAT_ID
		-- wants value without the units
		--,cast(res.ORD_NUM_VALUE as varchar(25)) + ' ' + res.REFERENCE_UNIT		'Most Recent Platelet Count'
		,res.ORD_NUM_VALUE			'Most Recent Platelet Count (K/cu mm)'
from 
(select	distinct 
		ap.PAT_ID
		,max(res.ORDER_PROC_ID)		LastPlateletorder
from Analytics.dbo.CCDA1672_Parikh_admittedPatients ap
inner join CLARITY.dbo.ORDER_PROC ord WITH (NOLOCK) on ap.PAT_ID = ord.PAT_ID
inner join CLARITY.dbo.ORDER_RESULTS res WITH (NOLOCK) on ord.ORDER_PROC_ID = res.ORDER_PROC_ID
inner join CLARITY.dbo.CLARITY_COMPONENT cc WITH (NOLOCK) on res.COMPONENT_ID = cc.COMPONENT_ID
-- using platelet labs defined by researcher
inner join Analytics.dbo.CCDA1672_Parikh_LabsPlatelets plb on cc.COMPONENT_ID = plb.Component_ID
where isnull(ord.ORDER_STATUS_C,0) in (0,5) -- completed or null
AND ISNULL(cc.RECORD_STATE_C,0) = 0
and ord.LAB_STATUS_C in (3,5) -- final or final edited
--and isnull(res.REFERENCE_UNIT,'') = 'mg/dL'
and isnull(res.ORD_NUM_VALUE,9999999) <> 9999999  -- must be numeric result
and isnull(ord.SERV_AREA_ID,0) in (0,11)   --  remove additional service areas except null and 11
group by ap.PAT_ID
) grp
inner join CLARITY.dbo.ORDER_RESULTS res WITH (NOLOCK) on grp.LastPlateletorder = res.ORDER_PROC_ID
inner join Analytics.dbo.CCDA1672_Parikh_LabsPlatelets plb on res.COMPONENT_ID = plb.Component_ID
where isnull(res.ORD_NUM_VALUE,9999999) <> 9999999  -- must be numeric result
order by grp.PAT_ID


ALTER TABLE Analytics.dbo.CCDA1672_Parikh_LastPlatelet
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)





-- find most recent Hemoglobin value
truncate table Analytics.dbo.CCDA1672_Parikh_LastHemoglobin

insert into Analytics.dbo.CCDA1672_Parikh_LastHemoglobin
	(PAT_ID, [Most Recent Hemoglobin (g/dL)])
select	grp.PAT_ID
		-- wants value without the units
		--,cast(res.ORD_NUM_VALUE as varchar(25)) + ' ' + res.REFERENCE_UNIT		'Most Recent Hemoglobin'
		,res.ORD_NUM_VALUE				'Most Recent Hemoglobin (g/dL)'
from 
(select	distinct 
		ap.PAT_ID
		,max(res.ORDER_PROC_ID)		LastHemoglobinorder
from Analytics.dbo.CCDA1672_Parikh_admittedPatients ap
inner join CLARITY.dbo.ORDER_PROC ord WITH (NOLOCK) on ap.PAT_ID = ord.PAT_ID
inner join CLARITY.dbo.ORDER_RESULTS res WITH (NOLOCK) on ord.ORDER_PROC_ID = res.ORDER_PROC_ID
inner join CLARITY.dbo.CLARITY_COMPONENT cc WITH (NOLOCK) on res.COMPONENT_ID = cc.COMPONENT_ID
-- using hemoglobin labs defined by researcher
inner join Analytics.dbo.CCDA1672_Parikh_LabsHemoglobin plb on cc.COMPONENT_ID = plb.Component_ID
where isnull(ord.ORDER_STATUS_C,0) in (0,5) -- completed or null
AND ISNULL(cc.RECORD_STATE_C,0) = 0
and ord.LAB_STATUS_C in (3,5) -- final or final edited
--and isnull(res.REFERENCE_UNIT,'') = 'mg/dL'
and isnull(res.ORD_NUM_VALUE,9999999) <> 9999999  -- must be numeric result
and isnull(ord.SERV_AREA_ID,0) in (0,11)   --  remove additional service areas except null and 11
group by ap.PAT_ID
) grp
inner join CLARITY.dbo.ORDER_RESULTS res WITH (NOLOCK) on grp.LastHemoglobinorder = res.ORDER_PROC_ID
inner join Analytics.dbo.CCDA1672_Parikh_LabsHemoglobin plb on res.COMPONENT_ID = plb.Component_ID
where isnull(res.ORD_NUM_VALUE,9999999) <> 9999999  -- must be numeric result
order by grp.PAT_ID


ALTER TABLE Analytics.dbo.CCDA1672_Parikh_LastHemoglobin
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)




-- find patients from cohort with an active oncology treatment plan
truncate table Analytics.dbo.CCDA1672_Parikh_OncTreatment

insert into Analytics.dbo.CCDA1672_Parikh_OncTreatment
	(PAT_ID)
select distinct ap.PAT_ID
From Analytics..CCDA1672_Parikh_admittedPatients ap
inner join CLARITY.dbo.V_ONC_TREATMENT_PLAN_ORDERS vo on ap.PAT_ID = vo.PAT_ID
where vo.PLAN_RECORD_TYPE_C = 1 -- treatment plan
and vo.PLAN_STATUS_C = 1 -- active


ALTER TABLE Analytics.dbo.CCDA1672_Parikh_OncTreatment
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)



-- find patients from cohort with solid organ transplants
truncate table Analytics.dbo.CCDA1672_Parikh_OrgTransplants

insert into Analytics.dbo.CCDA1672_Parikh_OrgTransplants
	(PAT_ID)
select distinct ap.PAT_ID 
From Analytics..CCDA1672_Parikh_admittedPatients ap
inner join CLARITY.dbo.TRANSPLANT_INFO ti on ap.PAT_ID = ti.PAT_ID
where ti.TX_EPSD_TYPE_C = 2  -- recipient
and ti.EPISODE_STATUS_C <> 3 -- not deleted
and ti.TX_CURRENT_STAGE_C = 50  -- transplanted


ALTER TABLE Analytics.dbo.CCDA1672_Parikh_OrgTransplants
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)






-- find patients from cohort with bone marrow transplants
truncate table Analytics.dbo.CCDA1672_Parikh_BmtTreatment

insert into Analytics.dbo.CCDA1672_Parikh_BmtTreatment
	(PAT_ID)
select distinct ap.PAT_ID 
From Analytics..CCDA1672_Parikh_admittedPatients ap
inner join CLARITY.dbo.PAT_ENC pe WITH (NOLOCK) on ap.PAT_ID = pe.PAT_ID
inner join CLARITY.dbo.EPISODE_LINK epilnk WITH (NOLOCK) on pe.PAT_ENC_CSN_ID = epilnk.PAT_ENC_CSN_ID
inner join CLARITY.dbo.EPISODE epi WITH (NOLOCK) on epilnk.EPISODE_ID = epi.EPISODE_ID
where epi.SUM_BLK_TYPE_ID in (20804,2050001100)  -- bone marrow transplant
and epilnk.SUM_BLK_TYPE_ID in (20804,2050001100)  -- bone marrow transplant -- needs to be referenced in this table because 1 CSN can be referenced in multiple episodes/and episode types
and isnull(epi.STATUS_C,0) = 2   -- resolved
and isnull(pe.SERV_AREA_ID,0) in (0,11)   --  remove additional service areas except null and 11
and isnull(epi.SERV_AREA_ID,0) in (0,11)   --  remove additional service areas except null and 11
and year(pe.CONTACT_DATE) = 2019 and MONTH(pe.CONTACT_DATE) = 11


ALTER TABLE Analytics.dbo.CCDA1672_Parikh_BmtTreatment
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)




-- find patients from the cohort who are currently prescribed anti-platelet meds
truncate table Analytics.dbo.CCDA1672_Parikh_CurrentAPmeds

insert into Analytics.dbo.CCDA1672_Parikh_CurrentAPmeds
	(PAT_ID)
select distinct 
		ap.PAT_ID
from CCDA1672_Parikh_admittedPatients ap
inner join CLARITY.dbo.ORDER_MED om on ap.PAT_ID = om.PAT_ID
inner join Analytics.dbo.CCDA1672_Parikh_AntiPlatelet map on om.MEDICATION_ID = map.MedicationID
where isnull(om.IS_PENDING_ORD_YN,'N') <> 'y'
and isnull(om.ORDER_STATUS_C,0) not in (4,8,9)  -- canceled, suspend, discontinued
and (
		isnull(om.END_DATE,0) = 0 
		OR isnull(om.END_DATE,0) > getdate()
	)


ALTER TABLE Analytics.dbo.CCDA1672_Parikh_CurrentAPmeds
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)




-- find patients from the cohort who are currently prescribed anti-coagulant meds
truncate table Analytics.dbo.CCDA1672_Parikh_CurrentACmeds

insert into Analytics.dbo.CCDA1672_Parikh_CurrentACmeds
	(PAT_ID)
select distinct 
		ap.PAT_ID
from CCDA1672_Parikh_admittedPatients ap
inner join CLARITY.dbo.ORDER_MED om on ap.PAT_ID = om.PAT_ID
inner join Analytics.dbo.CCDA1672_Parikh_AntiCoagulant map on om.MEDICATION_ID = map.MedicationID
where isnull(om.IS_PENDING_ORD_YN,'N') <> 'y'
and isnull(om.ORDER_STATUS_C,0) not in (4,8,9)  -- canceled, suspend, discontinued
and (
		isnull(om.END_DATE,0) = 0 
		OR isnull(om.END_DATE,0) > getdate()
	)
and map.MedicationID NOT in (212650,212782)  -- remove HEPARIN, PORCINE (PF) 5,000 UNIT/0.5 ML SUBCUTANEOUS SYRINGE
                                                                                 -- and HEPARIN, PORCINE (PF) SUBQ


ALTER TABLE Analytics.dbo.CCDA1672_Parikh_CurrentACmeds
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)




-- find patients from the cohort who are currently prescribed pressor meds
truncate table Analytics.dbo.CCDA1672_Parikh_CurrentPRmeds

insert into Analytics.dbo.CCDA1672_Parikh_CurrentPRmeds
	(PAT_ID)
select distinct 
		ap.PAT_ID
from CCDA1672_Parikh_admittedPatients ap
inner join CLARITY.dbo.ORDER_MED om on ap.PAT_ID = om.PAT_ID
									and om.ORDERING_DATE >= ap.HOSP_ADMSN_TIME  -- medicine ordered since admission
inner join Analytics.dbo.CCDA1672_Parikh_Pressors map on om.MEDICATION_ID = map.MedicationID
inner join CLARITY.dbo.ZC_DISPENSE_ROUTE zdr on om.MED_ROUTE_C = zdr.DISPENSE_ROUTE_C
where isnull(om.IS_PENDING_ORD_YN,'N') <> 'y'
and isnull(om.ORDER_STATUS_C,0) not in (4,8,9)  -- canceled, suspend, discontinued
and (
		isnull(om.END_DATE,0) = 0 
		OR isnull(om.END_DATE,0) > getdate()
	)
and zdr.NAME like '%venous%' -- any IV route


ALTER TABLE Analytics.dbo.CCDA1672_Parikh_CurrentPRmeds
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)




-- locate latest blood pressure from flowsheets and and parse systolic and diastolic values
truncate table Analytics.dbo.CCDA1672_Parikh_BP

insert into Analytics.dbo.CCDA1672_Parikh_BP
	(PAT_ID, meas.RECORDED_TIME, meas.MEAS_VALUE, Delimiter, BP_Systolic, BP_DIASTOLIC)
select	ap.PAT_ID
		--,gp.FLO_MEAS_NAME										
		,meas.RECORDED_TIME										
		,meas.MEAS_VALUE	
		,CHARINDEX('/',ltrim(rtrim(meas.MEAS_VALUE)))																		'Delimiter'
		,SUBSTRING(meas.meas_value, 1, CHARINDEX('/',ltrim(rtrim(meas.MEAS_VALUE))) - 1)									'BP_Systolic'
		,SUBSTRING(meas.MEAS_VALUE, CHARINDEX('/',ltrim(rtrim(meas.MEAS_VALUE))) + 1, len(ltrim(rtrim(meas.MEAS_VALUE))))	'BP_DIASTOLIC'
From Analytics.dbo.CCDA1672_Parikh_admittedPatients ap
inner join CLARITY.dbo.PAT_ENC_HSP hsp on ap.PAT_ENC_CSN_ID = hsp.PAT_ENC_CSN_ID
INNER JOIN CLARITY.dbo.IP_FLWSHT_REC iprec ON hsp.INPATIENT_DATA_ID = iprec.INPATIENT_DATA_ID
INNER JOIN CLARITY.dbo.IP_FLWSHT_MEAS meas ON iprec.FSD_ID = meas.FSD_ID
inner join clarity.dbo.IP_FLO_GP_DATA gp on gp.FLO_MEAS_ID = meas.FLO_MEAS_ID
inner join (select	ap.PAT_ID
					,max(meas.RECORDED_TIME)	LastBP										
			From Analytics.dbo.CCDA1672_Parikh_admittedPatients ap
			inner join CLARITY.dbo.PAT_ENC_HSP hsp on ap.PAT_ENC_CSN_ID = hsp.PAT_ENC_CSN_ID
			INNER JOIN CLARITY.dbo.IP_FLWSHT_REC iprec ON hsp.INPATIENT_DATA_ID = iprec.INPATIENT_DATA_ID
			INNER JOIN CLARITY.dbo.IP_FLWSHT_MEAS meas ON iprec.FSD_ID = meas.FSD_ID
			inner join clarity.dbo.IP_FLO_GP_DATA gp on gp.FLO_MEAS_ID = meas.FLO_MEAS_ID
			where gp.FLO_MEAS_NAME = 'BLOOD PRESSURE'
			group by ap.PAT_ID
			--order by ap.PAT_ID
			) lbp on ap.PAT_ID = lbp.PAT_ID
					and meas.RECORDED_TIME = lbp.LastBP
where gp.FLO_MEAS_NAME = 'BLOOD PRESSURE'
order by ap.PAT_ID


ALTER TABLE Analytics.dbo.CCDA1672_Parikh_BP
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)




-- find patients where a ventilator was ordered after admission
truncate table Analytics.dbo.CCDA1672_Parikh_VentOrders

insert into Analytics.dbo.CCDA1672_Parikh_VentOrders
	(PAT_ID)
select distinct ap.PAT_ID
From Analytics.dbo.CCDA1672_Parikh_admittedPatients ap
inner join CLARITY.dbo.PAT_ENC pe on ap.PAT_ID = pe.PAT_ID
inner join CLARITY.dbo.ORDER_PROC op on pe.PAT_ENC_CSN_ID = op.PAT_ENC_CSN_ID
										and op.ORDERING_DATE >= ap.HOSP_ADMSN_TIME
inner join Analytics.dbo.CCDA1672_Parikh_Ventilators vent on op.PROC_ID = vent.ProcID
where isnull(op.ORDER_STATUS_C,0) <> 4 -- cancelled


ALTER TABLE Analytics.dbo.CCDA1672_Parikh_VentOrders
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)




-- find latest serum creatinine value after admission
truncate table Analytics.dbo.CCDA1672_Parikh_SerCreatPostAdmit

insert into Analytics.dbo.CCDA1672_Parikh_SerCreatPostAdmit
	(PAT_ID, LastSerumCreatinine)
select	distinct ap.PAT_ID
		,res.ORD_NUM_VALUE	'LastSerumCreatinine'
from Analytics.dbo.CCDA1672_Parikh_admittedPatients ap
inner join CLARITY.dbo.PAT_ENC pe WITH (NOLOCK) on ap.PAT_ID = pe.PAT_ID
inner join CLARITY.dbo.ORDER_PROC ord WITH (NOLOCK) on ap.PAT_ID = ord.PAT_ID
														and pe.PAT_ENC_CSN_ID = ord.PAT_ENC_CSN_ID
inner join CLARITY.dbo.ORDER_RESULTS res WITH (NOLOCK) on ord.ORDER_PROC_ID = res.ORDER_PROC_ID
														and res.RESULT_TIME >= ap.HOSP_ADMSN_TIME
inner join CLARITY.dbo.CLARITY_COMPONENT cc WITH (NOLOCK) on res.COMPONENT_ID = cc.COMPONENT_ID
-- using Creatinine labs defined by another study
inner join Analytics.dbo.CCDA1672_Parikh_Creatinine_Labs kcl on cc.COMPONENT_ID = kcl.Component_ID
inner join (select	distinct ap.PAT_ID
					,max(res.RESULT_TIME)		LastResult
			from Analytics.dbo.CCDA1672_Parikh_admittedPatients ap
			inner join CLARITY.dbo.PAT_ENC pe WITH (NOLOCK) on ap.PAT_ID = pe.PAT_ID
			inner join CLARITY.dbo.ORDER_PROC ord WITH (NOLOCK) on ap.PAT_ID = ord.PAT_ID
																	and pe.PAT_ENC_CSN_ID = ord.PAT_ENC_CSN_ID
			inner join CLARITY.dbo.ORDER_RESULTS res WITH (NOLOCK) on ord.ORDER_PROC_ID = res.ORDER_PROC_ID
																	and res.RESULT_TIME >= ap.HOSP_ADMSN_TIME
			inner join CLARITY.dbo.CLARITY_COMPONENT cc WITH (NOLOCK) on res.COMPONENT_ID = cc.COMPONENT_ID
			-- using Creatinine labs defined by another study
			inner join Analytics.dbo.CCDA1672_Parikh_Creatinine_Labs kcl on cc.COMPONENT_ID = kcl.Component_ID

			where 
			isnull(ord.ORDER_STATUS_C,0) in (0,5) -- completed or null
			AND ISNULL(cc.RECORD_STATE_C,0) = 0
			and ord.LAB_STATUS_C in (3,5) -- final or final edited
			and res.REFERENCE_UNIT = 'mg/dL'
			and isnull(pe.SERV_AREA_ID,0) in (0,11)   --  remove additional service areas except null and 11
			and isnull(ord.SERV_AREA_ID,0) in (0,11)   --  remove additional service areas except null and 11
			and isnull(res.ORD_NUM_VALUE,9999999) <> 9999999  -- must be numeric result

			group by ap.pat_id
			) lr on ap.PAT_ID = lr.PAT_ID
					and res.RESULT_TIME = lr.LastResult

where 
isnull(ord.ORDER_STATUS_C,0) in (0,5) -- completed or null
AND ISNULL(cc.RECORD_STATE_C,0) = 0
and ord.LAB_STATUS_C in (3,5) -- final or final edited
and res.REFERENCE_UNIT = 'mg/dL'
and isnull(pe.SERV_AREA_ID,0) in (0,11)   --  remove additional service areas except null and 11
and isnull(ord.SERV_AREA_ID,0) in (0,11)   --  remove additional service areas except null and 11
and isnull(res.ORD_NUM_VALUE,9999999) <> 9999999  -- must be numeric result
order by ap.PAT_ID


ALTER TABLE Analytics.dbo.CCDA1672_Parikh_SerCreatPostAdmit
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)




--  find patients with reaction to iodinated contrast
truncate table Analytics.dbo.CCDA1672_Parikh_Allergy

insert into Analytics.dbo.CCDA1672_Parikh_Allergy
	(PAT_ID)
select distinct ap.PAT_ID
from Analytics.dbo.CCDA1672_Parikh_admittedPatients ap
inner join CLARITY.DBO.ALLERGY alg WITH (NOLOCK) ON ap.PAT_ID = alg.PAT_ID
inner JOIN clarity..CL_ELG elg WITH (NOLOCK) ON elg.ALLERGEN_ID = alg.ALLERGEN_ID
												and elg.ALLERGEN_ID = 31897  -- IODINATED CONTRAST MEDIA
inner JOIN CLARITY.DBO.ZC_ALLERGY_SEVERIT zalg WITH (NOLOCK) ON alg.ALLERGY_SEVERITY_C = zalg.ALLERGY_SEVERITY_C
order by PAT_ID

ALTER TABLE Analytics.dbo.CCDA1672_Parikh_Allergy
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)



-- ENCOUNTER REPORT
-- find patients elevated serum creatinine results >= 1.5 times baseline during hospitalization
-- and patients with baseline eGFR score over 45
-- remove exclusions
truncate table Analytics.dbo.CCDA1672_Parikh_Report_Enc

insert into Analytics.dbo.CCDA1672_Parikh_Report_Enc
	([JH MRN], [Encounter ID], [Patient First Name], [Patient Last Name], [Hospital Admission Date/Time]
	,[Admission Location], [Baseline Serum Creatinine], [Baseline eGFR], Method, [Qualifying Serum Creatinine]
	,[Most Recent Blood Urea Nitrogen (BUN) (mg/dL)], [Most Recent International Normalized Ratios (INR)]
	,[Most Recent PTT (seconds)], [Most Recent Platelet Count (K/cu mm)], [Most Recent Hemoglobin (g/dL)]
	,[Current meds - anti-platelet agents], [Current meds - systemic anticoagulation], [BP Systolic > 140]
	,[BP Systolic < 90], [Ventilator-dependent], [Elevated Serum Creatinine Increase of 0.3 mg/dL]
	,Hypotension, BMI
	)
select	distinct 
--ap.pat_id,
		id.IDENTITY_ID														'JH MRN'
		,ap.PAT_ENC_CSN_ID													'Encounter ID'
		,pat.PAT_FIRST_NAME													'Patient First Name'
		,pat.PAT_LAST_NAME													'Patient Last Name'
		,ap.HOSP_ADMSN_TIME													'Hospital Admission Date/Time'
		,adt.ADT_DEPARTMENT_NAME											'Admission Location'
		,fin.LabResult														'Baseline Serum Creatinine'
		,fin.BaseLineEGFR													'Baseline eGFR'
		,fin.Method
--		,res.ORD_NUM_VALUE													'Qualifying Serum Creatinine'
		,scpa.LastSerumCreatinine											'Qualifying Serum Creatinine'
		,bun.[Most Recent Blood Urea Nitrogen (BUN) (mg/dL)]
		,inr.[Most Recent International Normalized Ratios (INR)]
		,ptt.[Most Recent PTT (seconds)]
		,platelet.[Most Recent Platelet Count (K/cu mm)]
		,hemoglobin.[Most Recent Hemoglobin (g/dL)]

		,CASE when capm.PAT_ID IS null 
				then 'N'
				else 'Y'
				end															'Current meds - anti-platelet agents'
		,CASE when cacm.PAT_ID IS null 
				then 'N'
				else 'Y'
				end															'Current meds - systemic anticoagulation'
		,CASE when bp.BP_Systolic > 140
				then 'Y'
				else 'N'
				end															'BP Systolic > 140'
		,CASE when bp.BP_Systolic < 90
				then 'Y'
				else 'N'
				end															'BP Systolic < 90'
		
		,CASE when vent.PAT_ID IS null
				then 'N'
				else 'Y'
				end															'Ventilator-dependent'

		,CASE when ISNULL(scpa.LastSerumCreatinine,0) - fin.LabResult > 0.3
				then 'Y'
				else 'N'
				end															'Elevated Serum Creatinine Increase of 0.3 mg/dL'

		,CASE when cprm.PAT_ID IS null 
				then 'N'
				else 'Y'
				end															'Hypotension'

		,enc.bmi															'BMI'

--,hsp.ADT_SERV_AREA_ID
		--,ap.PAT_ID
		--,cc.EXTERNAL_NAME													'Lab Name'
		--,cc.BASE_NAME														'Base Name'
		--,case when isnull(res.ORD_NUM_VALUE,9999999) = 9999999 then null
		--								else res.ORD_NUM_VALUE
		--						end											'Result value - as numeric'
		--,res.REFERENCE_UNIT													'Reference Range Unit'
		--,CONVERT(VARCHAR(10), res.RESULT_TIME, 101)  
		--			+ ' ' 
		--			+ left(CONVERT(VARCHAR(24),res.RESULT_TIME,8),5)		'Result Date/Time'
		
		--,prov.ATTENDING_PROV_ID
		--,ser.PROV_NAME
		--,ser.PROV_TYPE
	
from Analytics.dbo.CCDA1672_Parikh_admittedPatients ap
inner join CLARITY.dbo.PAT_ENC enc WITH (NOLOCK) on ap.PAT_ENC_CSN_ID = enc.PAT_ENC_CSN_ID
inner join CLARITY.dbo.IDENTITY_ID id WITH (NOLOCK) on ap.PAT_ID = id.PAT_ID
									and id.IDENTITY_TYPE_ID = 38 -- JHMRN
inner join Analytics.dbo.CCDA1672_Parikh_baselineEGFRwLabFINAL fin 
				on ap.PAT_ID = fin.PAT_ID
				and fin.BaseLineEGFR > 45	-- baseline eGFR is greater than 45											
--inner join CLARITY.dbo.ORDER_PROC ord WITH (NOLOCK) on ap.PAT_ID = ord.PAT_ID
--														and ap.PAT_ENC_CSN_ID = ord.PAT_ENC_CSN_ID  -- joining to the current hospital encounter
--inner join CLARITY.dbo.ORDER_RESULTS res WITH (NOLOCK) on ord.ORDER_PROC_ID = res.ORDER_PROC_ID
--inner join CLARITY.dbo.CLARITY_COMPONENT cc WITH (NOLOCK) on res.COMPONENT_ID = cc.COMPONENT_ID
---- using Creatinine labs defined by another study
--inner join Analytics.dbo.CCDA1672_Parikh_Creatinine_Labs kcl on cc.COMPONENT_ID = kcl.Component_ID
inner join CLARITY.dbo.PATIENT pat WITH (NOLOCK) on ap.pat_id = pat.PAT_ID
inner join CLARITY.dbo.PATIENT_4 pat4 WITH (NOLOCK) on pat.pat_id = pat4.pat_id 
inner join CLARITY.dbo.V_PAT_ADT_LOCATION_HX adt WITH (NOLOCK) on ap.PAT_ENC_CSN_ID = adt.PAT_ENC_CSN
															and adt.EVENT_TYPE_C = 1 -- admission
															and adt.ADT_DEPARTMENT_ID is not null
--link with last serum creatinine result post admission
inner join Analytics.dbo.CCDA1672_Parikh_SerCreatPostAdmit scpa on ap.PAT_ID = scpa.PAT_ID


-- check for any reactions to iodinated contrasts
left outer JOIN CLARITY.DBO.ALLERGY alg WITH (NOLOCK) ON ap.PAT_ID = alg.PAT_ID
left outer JOIN clarity..CL_ELG elg WITH (NOLOCK) ON elg.ALLERGEN_ID = alg.ALLERGEN_ID
												and elg.ALLERGEN_ID = 31897  -- IODINATED CONTRAST MEDIA
left outer JOIN CLARITY.DBO.ZC_ALLERGY_SEVERIT zalg WITH (NOLOCK) ON alg.ALLERGY_SEVERITY_C = zalg.ALLERGY_SEVERITY_C

left outer join Analytics.dbo.CCDA1672_Parikh_LastBUN bun on ap.PAT_ID = bun.PAT_ID
left outer join Analytics.dbo.CCDA1672_Parikh_LastINR inr on ap.PAT_ID = inr.PAT_ID
left outer join Analytics.dbo.CCDA1672_Parikh_lastPTT ptt on ap.PAT_ID = ptt.PAT_ID
left outer join Analytics.dbo.CCDA1672_Parikh_lastPlatelet platelet on ap.PAT_ID = platelet.PAT_ID
left outer join Analytics.dbo.CCDA1672_Parikh_lastHemoglobin hemoglobin on ap.PAT_ID = hemoglobin.PAT_ID

-- link to possible pregnancy episode
left outer join CLARITY.dbo.EPISODE_LINK epilnk WITH (NOLOCK) on ap.PAT_ENC_CSN_ID = epilnk.PAT_ENC_CSN_ID
left outer join CLARITY.dbo.EPISODE epi WITH (NOLOCK) on epilnk.EPISODE_ID = epi.EPISODE_ID
														and epi.SUM_BLK_TYPE_ID = 2 -- pregnancy

-- current meds
left outer join Analytics.dbo.CCDA1672_Parikh_CurrentACmeds cacm on ap.PAT_ID = cacm.PAT_ID
left outer join Analytics.dbo.CCDA1672_Parikh_CurrentAPmeds capm on ap.PAT_ID = capm.PAT_ID
left outer join Analytics.dbo.CCDA1672_Parikh_CurrentPRmeds cprm on ap.PAT_ID = cprm.PAT_ID

-- link latest BP record from flowsheets
left outer join Analytics.dbo.CCDA1672_Parikh_BP bp on ap.PAT_ID = bp.PAT_ID

-- link possible ventilator orders
left outer join Analytics.dbo.CCDA1672_Parikh_VentOrders vent on ap.PAT_ID = vent.PAT_ID

where 
--isnull(ord.ORDER_STATUS_C,0) in (0,5) -- completed or null
--AND ISNULL(cc.RECORD_STATE_C,0) = 0
--and ord.LAB_STATUS_C in (3,5) -- final or final edited
--and isnull(res.ORD_NUM_VALUE,9999999) <> 9999999  -- must be numeric result
--and res.REFERENCE_UNIT = 'mg/dL'
--and res.ORD_NUM_VALUE > fin.LabResult * 1.5 -- hospitalization serum creatinine must be 1.5 times greater than baseline serum creatinine level
--and isnull(ord.SERV_AREA_ID,0) in (0,11)   --  remove additional service areas except null and 11


-- use the last Serum Creatinine to compare with baseline lab result
scpa.LastSerumCreatinine > fin.LabResult * 1.5 -- !LAST! hospitalization serum creatinine must be 1.5 times greater than baseline serum creatinine level

-----------------------------------------------------------------------------------------
--Remove Exclusions

-- remove enrolled patients
and ap.PAT_ID not in (SELECT distinct PRE.PAT_ID
						FROM CLARITY..PAT_RSH_ENROLL AS PRE
						INNER JOIN CLARITY..IDENTITY_ID AS II ON II.PAT_ID = PRE.PAT_ID and II.IDENTITY_TYPE_ID = 0 
						INNER JOIN CLARITY..ENROLL_INFO AS EI ON EI.ENROLL_ID = PRE.ENROLLMENT_ID
						INNER JOIN CLARITY..CLARITY_RSH AS CR ON CR.RESEARCH_ID = EI.RESEARCH_STUDY_ID
						WHERE CR.STUDY_CODE = 'CRMS-71585' 
						AND EI.ENROLL_STATUS_C IN (1055, 1060) -- consented or enrolled
						)
and isnull(pat4.PAT_LIVING_STAT_C,0) = 1 -- Exclude patients listed as deceased in Epic

-- modification 1/7/2020
and (isnull(enc.bmi,0) <= 40 or isnull(enc.bmi,0) = 0) -- bmi cannot be > 40 but can be null

and isnull(epi.STATUS_C,0) <> 1 -- cannot have an active pregnancy episode 

-- 2/28/2020  nlb correction
--and zalg.ALLERGY_SEVERITY_C is null  -- must not have reaction to iodinated contrast
and ap.PAT_ID not in (select distinct allergy.Pat_ID
						from Analytics.dbo.CCDA1672_Parikh_Allergy  allergy
						)  -- exclude patients with reaction to iodinated contrast

and ap.PAT_ID not in (select distinct onc.PAT_ID
						From Analytics.dbo.CCDA1672_Parikh_OncTreatment onc
						)  -- exclude patients with an active oncology treatment
and ap.PAT_ID not in (select distinct orgt.PAT_ID
						From Analytics.dbo.CCDA1672_Parikh_OrgTraplants orgt
						)  -- exclude patients with solid organ transplants
and ap.PAT_ID not in (select distinct bmt.PAT_ID
						From Analytics.dbo.CCDA1672_Parikh_BmtTreatment bmt
						)  -- exclude patients with bone marrow treatment

---- remove patients ever having a BUN lab result > 80 mg/dL
--and ap.PAT_ID not in (select	distinct 
--							ap.PAT_ID
--							--,res.ORD_NUM_VALUE
--							--,res.REFERENCE_UNIT
--					from Analytics.dbo.CCDA1672_Parikh_admittedPatients ap
--					inner join CLARITY.dbo.ORDER_PROC ord WITH (NOLOCK) on ap.PAT_ID = ord.PAT_ID
--					inner join CLARITY.dbo.ORDER_RESULTS res WITH (NOLOCK) on ord.ORDER_PROC_ID = res.ORDER_PROC_ID
--					inner join CLARITY.dbo.CLARITY_COMPONENT cc WITH (NOLOCK) on res.COMPONENT_ID = cc.COMPONENT_ID
--					-- using BUN labs defined by researcher
--					inner join Analytics.dbo.CCDA1672_Parikh_LabsBUN plb on cc.COMPONENT_ID = plb.Component_ID
--					where isnull(ord.ORDER_STATUS_C,0) in (0,5) -- completed or null
--					AND ISNULL(cc.RECORD_STATE_C,0) = 0
--					and ord.LAB_STATUS_C in (3,5) -- final or final edited
--					and isnull(res.REFERENCE_UNIT,'') = 'mg/dL'
--					and isnull(res.ORD_NUM_VALUE,9999999) <> 9999999  -- must be numeric result
--					and isnull(ord.SERV_AREA_ID,0) in (0,11)   --  remove additional service areas except null and 11
--					and res.ORD_NUM_VALUE > 80
--					)

order by 'JH MRN'
--ap.Pat_ID
--, res.RESULT_TIME 


ALTER TABLE Analytics.dbo.CCDA1672_Parikh_Report_Enc
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)





-- PROVIDER REPORT
truncate table Analytics.dbo.CCDA1672_Parikh_Report_Prov

insert into Analytics.dbo.CCDA1672_Parikh_Report_Prov
	([JH MRN], [Encounter ID], [Provider ID], [Provider Name], [Provider Type])
select	grp.[JH MRN]
		,grp.[Encounter ID]
		,grp.PROV_ID			'Provider ID'
		,grp.PROV_NAME			'Provider Name'
		,grp.PROV_TYPE			'Provider Type'
from (
		select	pre.[JH MRN]
				,pre.[Encounter ID]
				,ser.PROV_ID
				,ser.PROV_NAME
				,ser.PROV_TYPE
		from Analytics.dbo.CCDA1672_Parikh_Report_Enc pre
		inner join CLARITY.dbo.TREATMENT_TEAM tt WITH (NOLOCK) on pre.[Encounter ID] = tt.PAT_ENC_CSN_ID
		inner join CLARITY.dbo.CLARITY_SER ser WITH (NOLOCK) on tt.TR_TEAM_ID = ser.PROV_ID
		where ser.PROV_TYPE is not null

		UNION

		select	pre.[JH MRN]
				,pre.[Encounter ID]
				,ser.PROV_ID
				,ser.PROV_NAME
				,ser.PROV_TYPE
		from Analytics.dbo.CCDA1672_Parikh_Report_Enc pre
		inner join CLARITY.dbo.PAT_ENC_HSP hsp WITH (NOLOCK) on pre.[Encounter ID] = hsp.PAT_ENC_CSN_ID
		inner join CLARITY.dbo.HSP_ACCT_ATND_PROV prov WITH (NOLOCK) on hsp.HSP_ACCOUNT_ID = prov.HSP_ACCOUNT_ID
		inner join CLARITY.dbo.CLARITY_SER ser WITH (NOLOCK) on prov.ATTENDING_PROV_ID = ser.PROV_ID

		UNION

		select	pre.[JH MRN]
				,pre.[Encounter ID]
				,ser.PROV_ID
				,ser.PROV_NAME
				,ser.PROV_TYPE
		from Analytics.dbo.CCDA1672_Parikh_Report_Enc pre
		inner join CLARITY.dbo.HSP_TRTMT_TEAM htt on pre.[Encounter ID] = htt.PAT_ENC_CSN_ID
		inner join CLARITY.dbo.CLARITY_SER ser WITH (NOLOCK) on htt.PROV_ID = ser.PROV_ID

	) grp
order by grp.[JH MRN], grp.PROV_NAME


ALTER TABLE Analytics.dbo.CCDA1672_Parikh_Report_Prov
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)



END

GO


