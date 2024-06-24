-- 2,397 patients; 55,432 notes
WITH temp AS (
SELECT 
      distinct [note_id]
	  ,pat.emrn
	  ,nlp.create_instant_dttm
	  ,pos.initial_dx_date
      ,[ip_note_type_c]
      ,[ip_note_type]
       ,[text_exists_yn]
	   ,datediff(day,pos.initial_dx_date,nlp.create_instant_dttm) "Days_Between" 
from
    COVID_Projection.dbo.derived_epic_patient pat
inner join COVID_Projection.dbo.derived_inpatient_encounters enc
with (nolock) on enc.osler_id = pat.osler_id						-- use nolock statement

inner join COVID_Projection.dbo.derived_epic_notes_metadata nlp
with (nolock) on nlp.osler_id = enc.osler_id

inner join COVID_Projection.dbo.covid_pmcoe_covid_positive pos
on pos.osler_id = enc.osler_id

inner join COVID_Projection.dbo.curated_IPEvents ipe
on ipe.osler_id = enc.osler_id

where

--ipe.garibaldi_desc_study <> 'Y'
 nlp.text_exists_yn = 'Y'
and (ipe.ADMIT_TIME >= '3/1/2020' and enc.hosp_admsn_time >= '3/1/2020' and create_instant_dttm >= '3/1/2020')
and pat.BIRTH_DATE <= CAST(CAST(DATEADD(YEAR,-18,GETDATE()) AS DATE) AS DATETIME) -- adults

and
nlp.ip_note_type_c in 
(
'1','30440106000','4','26','1600000002','19','1600000005','8','1600000004','6','2','1300000003'
)
and 
datediff(day,pos.initial_dx_date,nlp.create_instant_dttm) between -2 and 2
and nlp.create_instant_dttm >= '2020-10-01') --Change date
--and nlp.list_resolved_yn = 'y'


select note.osler_id, note.pat_enc_csn_id, note.note_id, note.create_instant_dttm
from covid_projection.dbo.derived_epic_notes_metadata note
inner join temp on temp.note_id = note.note_id
order by osler_id, create_instant_dttm