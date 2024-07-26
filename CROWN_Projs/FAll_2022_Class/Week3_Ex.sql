USE [CAMP_DM_Projection]
--What is the average age of patients who are hospitalized?
select CAST(avg(datediff(day,pat.date_of_birth, enc.encounter_date)/365.25) AS INT) as avg_age
from CAMP_DM_Projection..encounters enc
join CAMP_DM_Projection..patients pat on enc.osler_id = pat.osler_id
where encounter_type = 'Hospital Encounter'

--How many hospitalizations encounters had a diagnosis of type 2 (E11) diabetes vs type 1 (E10)?
select 'type 1 count', count(distinct s.enc_num) "cnt"
from symptoms s
join encounters e on s.enc_num = e.enc_num
where diagnosis_code_icd10 like 'E10%'
and encounter_type = 'Hospital Encounter'
Union
select 'type 2 count', count(distinct s.enc_num) "cnt"
from symptoms s
join encounters e on s.enc_num = e.enc_num
where diagnosis_code_icd10 like 'E11%'
and encounter_type = 'Hospital Encounter';

--What is the average age of patients with type 1 vs type 2 diabetes from their date of birth to the time of their first diagnosis?
select 'type 1 avg age', CAST(avg(datediff(day,pat.date_of_birth, enc.encounter_date)/365.25) AS INT) as avg_age
from symptoms s
join CAMP_DM_Projection..patients pat on s.osler_id = pat.osler_id
join encounters enc on s.enc_num = enc.enc_num
where diagnosis_code_icd10 like 'E10%'
Union
select 'type 2 avg age', CAST(avg(datediff(day,pat.date_of_birth, enc.encounter_date)/365.25) AS INT) as avg_age
from symptoms s
join CAMP_DM_Projection..patients pat on s.osler_id = pat.osler_id
join encounters enc on s.enc_num = enc.enc_num
where diagnosis_code_icd10 like 'E11%';

--How many total encounters recorded both height and weight for patients?

--What percentage of patients have a matched height/weight measure in at least one of their encounters?