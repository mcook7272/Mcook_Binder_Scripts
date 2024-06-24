--Join on osler_id
select distinct pat.emrn, pat.bmcmrn, pat.jhhmrn, pat.pat_name, pat.lastname, pat.firstname, pat.birth_date, pat.gender, note.create_instant_dttm "note_create_time", note.ip_note_type_c, note.ip_note_type, note.author_specialty
--into PMAP_analytics.dbo.CCDA2555_Strike_Powelson_osler
from COVID_Projection.dbo.derived_epic_patient pat
inner join COVID_Projection.dbo.curated_ipevents ipe on pat.osler_id = ipe.osler_id
inner join COVID_Projection.dbo.derived_epic_notes_metadata note on ipe.osler_id = note.osler_id
where  ipe.age >= 18
and (ipe.init_hosp_loc_abbr like 'BV%'
or ipe.init_hosp_loc_abbr like '%JHH')
and note.author_specialty in ('Orthopedic surgery', 'Interventional Radiology', 'Plastic surgery', 'Vascular surgery')
and note.create_instant_dttm >= '2020-03-01'
order by pat.emrn, note_create_time

--Join on enc_csn_id
select distinct pat.emrn, pat.bmcmrn, pat.jhhmrn, pat.pat_name, pat.lastname, pat.firstname, pat.birth_date, pat.gender, note.create_instant_dttm "note_create_time", note.ip_note_type_c, note.ip_note_type, note.author_specialty
--into PMAP_analytics.dbo.CCDA2555_Strike_Powelson_csn
from COVID_Projection.dbo.derived_epic_patient pat
inner join COVID_Projection.dbo.curated_ipevents ipe on pat.osler_id = ipe.osler_id
inner join COVID_Projection.dbo.derived_epic_notes_metadata note on ipe.init_pat_enc_csn_id = note.pat_enc_csn_id
where  ipe.age >= 18
and (ipe.init_hosp_loc_abbr like 'BV%'
or ipe.init_hosp_loc_abbr like '%JHH')
and note.author_specialty in ('Orthopedic surgery', 'Interventional Radiology', 'Plastic surgery', 'Vascular surgery')
and note.create_instant_dttm >= '2020-03-01'
order by pat.emrn, note_create_time

select count(distinct emrn)
from PMAP_analytics.dbo.CCDA2555_Strike_Powelson_osler

select count(distinct emrn)
from PMAP_analytics.dbo.CCDA2555_Strike_Powelson_csn