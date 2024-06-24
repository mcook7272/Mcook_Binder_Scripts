USE [JHM_OMOP_20211203]

-- 1) 6/18 procedures in PMAP, not in omop
Select p.person_id,s.sourcekey as osler_id, p.procedure_concept_id,
p.procedure_date, p.procedure_source_value
from procedure_occurrence p
join stage.SourceIDMapsPerson s on s.id = p.person_id
where p.person_id = '255174'
and s.domain = 'person'
and p.procedure_date between '2018-06-17' and '2018-06-19'
order by procedure_date

/*
Checked databricks (query used below), found they had 2 procedures that day, CPT 67028 and HCPCS J0178
These map to 2111025 (standard) and 43533212 (non-standard)

DB query:

select * 
from derived.profee_billing_px
where pat_id = 'Z364541'
and proc_date between '2018-06-17' and '2018-06-19'
order by proc_date
*/

--First appears in OMOP, second doesn't
select procedure_concept_id, count(*)
from procedure_occurrence
where procedure_concept_id in ('2111025','43533212')
group by procedure_concept_id
order by count(*) desc

--Why did the CPT code not map for the patient? Reach out to Alan

-- 2) Duplicate procs
Select p.person_id,s.sourcekey as osler_id, p.procedure_concept_id,
p.procedure_date, p.procedure_source_value
from procedure_occurrence p
join stage.SourceIDMapsPerson s on s.id = p.person_id
where p.person_id = '257423'
and s.domain = 'person'
and p.procedure_date between '2016-10-12' and '2016-10-14'
order by procedure_date

--Only difference appears to be provider id
Select * 
from procedure_occurrence p
join stage.SourceIDMapsPerson s on s.id = p.person_id
where p.person_id = '257423'
and s.domain = 'person'
and p.procedure_date between '2016-10-12' and '2016-10-14'
order by procedure_date

/*
According to Databricks (query below), they actually had 3 procs on this day, but only 67028 was captured
(other two map to 40757022  and 2313635, both standard)

DB query:

select * 
from derived.profee_billing_px
where pat_id = 'Z3191311'
and proc_date between '2016-10-12' and '2016-10-14'
order by proc_date

*/

--Both are populated
select procedure_concept_id, count(*)
from procedure_occurrence
where procedure_concept_id in ('40757022','2313635')
group by procedure_concept_id
order by count(*) desc

--Why did 67028 map twice? And the others not map at all? Ask Alan

-- 3) Pat missing Avastin?
Select p.person_id
from person p
join stage.SourceIDMapsPerson s on s.id = p.person_id
where s.domain = 'person'
and s.sourcekey = '9d2577e4-2dab-45af-9a16-e4a5beb46920';

--Person is getting bevacizumab on the dates of interest
select d.person_id, d.drug_exposure_start_date, d.drug_concept_id
,c.concept_name
from drug_exposure d
join concept c on d.drug_concept_id = c.concept_id
where d.person_id = '560729'

--This may need to be fixed in Chenyu's code, not OMOP mapping