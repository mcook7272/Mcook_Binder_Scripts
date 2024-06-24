/**********************************************************************************

Author:  mcook49

Date: 08/18/2023

JIRA: CCDA-5073

Description:  Counts for CCDA-5073

Criteria:
-Patients seen at any operating room (OR) or intensive care unit (ICU) at Howard County General Hospital from Jan 1, 2017 - December 31, 2022
-Study team provided specific room nubers of interest

-Count of 5914 patients in specified ICU rooms and 4299 surgeries in OR 4 as of 8/18/2023

***********************************************************************************/

select count(distinct peh.pat_id)  
from V_PAT_ADT_LOCATION_HX adt 
inner join clarity..PAT_ENC_HSP peh on peh.PAT_ENC_CSN_ID = adt.PAT_ENC_CSN
inner join clarity..CLARITY_ROM crom on crom.ROOM_CSN_ID = adt.ADT_ROOM_CSN
where adt.ADT_LOC_ID like '%1103%' 
and adt.EVENT_TYPE_C in (1,3) 
and adt.IN_DTTM between '2017-01-01' AND '2022-12-31'
and crom.ROOM_NUMBER in  ('3316','3315','3314','3313','3312','3311','3310','3309','3308','3307','3306','3305','3304','3303','3302','3301') -- ICU;
--OR rm.ROOM_ID = '300730004' -- HCGH Main OR 4
--5914 patients

--Surgery counts (HCGH MAIN OR ROOM 04)
--4299
select count (Distinct orlog.log_id)
,cloc.LOC_ID
,cloc.LOC_NAME
,cser.PROV_ID
,cser.PROV_NAME
from  or_case orcase
inner join or_log orlog on orlog.LOG_ID = orcase.LOG_ID
inner join clarity_loc cloc on cloc.LOC_ID = orcase.LOC_ID
left outer join clarity_ser cser on cser.PROV_ID = orcase.OR_ID
where cloc.loc_ID like '%1103%'
and orcase.SURGERY_DATE  between '2017-01-01' AND '2022-12-31'
and orlog.STATUS_C NOT IN (4,6) 
group by cloc.LOC_ID
,cloc.LOC_NAME
,cser.PROV_ID
,cser.PROV_NAME
