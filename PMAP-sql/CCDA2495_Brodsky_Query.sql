--drop table if exists CROWNBrodsky_Projection.dbo.derived_epic_patient;
drop table if exists PMAP_Analytics.dbo.CCDA2495_Brodsky_Patients;

select distinct pat.pat_name, emrn,jhhmrn,bmcmrn,hcgmrn,smhmrn,shmrn,birth_date,pat.pat_status,pat.death_date,
note.author_specialty, note.note_csn_id, note.ip_note_type, note.create_instant_dttm
--into CROWNBrodsky_Projection.dbo.derived_epic_patient
--into PMAP_Analytics.dbo.CCDA2495_Brodsky_Patients
from COVID_Projection..derived_epic_patient pat
inner join COVID_Projection.dbo.derived_inpatient_encounters enc on pat.osler_id = enc.osler_id
inner join COVID_Projection.dbo.covid_pmcoe_covid_positive cov on enc.osler_id = cov.osler_id
inner join COVID_Projection.dbo.derived_epic_notes_metadata note on enc.pat_enc_csn_id = note.pat_enc_csn_id
inner join COVID_Projection.dbo.curated_ipevents ipe on enc.pat_enc_csn_id = ipe.init_pat_enc_csn_id
where enc.department_id like '1101%'
and cov.age_at_positive >= 18
and enc.hosp_admsn_time >= '2020-03-01'
--Speech pathology Consult during encounter
and note.author_specialty in ('Speech Pathology')
--Intubated/traechetomy
and (ipe.vent_start is not null
or ipe.trach_dtm is not null)