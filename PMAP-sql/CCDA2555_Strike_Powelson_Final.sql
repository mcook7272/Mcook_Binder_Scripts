alter proc dbo.CCDA2555_StrikePowelson_AcuteLimb_Ischemia_sp AS

/**********************************************************************************
Author:  Michael Cook
Date: 2021-04-22
JIRA: CCDA-2555
Description: Gets list of adult, COVID-positive patients admitted to Johns Hopkins Hospital or Bayview Medical Center 
as inpatients on or after 3/1/2020 (no ED discharges, but ED to inpatient or Observation to inpatient should be included), and
having a consult note authored by Orthopedic Surgery, Plastic Surgery, Vascular Surgery, or Interventional Radiology.


    EXEC dbo.[CCDA2555_StrikePowelson_AcuteLimb_Ischemia_sp] 
     
Revision History:
Date            Author          JIRA            Comment
2021-06-08      Michael Cook    CCDA-2555        Turned final version of code into stored proc
2021-06-08		Michael Cook	CCDA-2555		 Added "or linked_csn is not NULL" per Bonnie's suggestion
***********************************************************************************/

BEGIN

SET NOCOUNT ON;

drop table if exists PMAP_analytics.dbo.CCDA2555_Strike_Powelson_osler;

select distinct pat.emrn, pat.bmcmrn, pat.jhhmrn, pat.pat_name, pat.lastname, pat.firstname, pat.birth_date, pat.gender, note.create_instant_dttm "note_create_time", note.ip_note_type_c, note.ip_note_type, note.author_specialty
into PMAP_analytics.dbo.CCDA2555_Strike_Powelson_osler
from COVID_Projection.dbo.derived_epic_patient pat
inner join COVID_Projection.dbo.curated_ipevents ipe on pat.osler_id = ipe.osler_id
inner join COVID_Projection.dbo.derived_epic_notes_metadata note on ipe.osler_id = note.osler_id
where  ipe.age >= 18
and (ipe.init_hosp_loc_abbr like 'BV%'
or ipe.init_hosp_loc_abbr like '%JHH'
or linked_csn is not NULL)
and note.author_specialty in ('Orthopedic surgery', 'Interventional Radiology', 'Plastic surgery', 'Vascular surgery')
and note.create_instant_dttm >= '2020-03-01'
order by pat.emrn, note_create_time;

END

GO