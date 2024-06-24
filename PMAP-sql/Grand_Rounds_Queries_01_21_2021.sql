USE [COVID_Projection]

--Total # Covid pos pat
select count(distinct t.osler_id) "Total_Adult_Pos_Patients" from(
select distinct openc.osler_id --Pos outpatients
from derived_outpatient_encounters openc
inner join covid_pmcoe_covid_positive pos on pos.osler_id = openc.osler_id
where department_id not in ('110106333', '110200331', '110300335', '110500332')
union
select distinct enc.osler_id
from derived_inpatient_encounters enc -- Pos inpatients
inner join covid_pmcoe_covid_positive pos on pos.osler_id = enc.osler_id
union
select  distinct osler_id --Pos crisp labs + other covid labs
from derived_lab_results
where component_base_name in('COVID19ANTI','COVID19BAL','COVID19ET','COVID19EX','COVID19INT','COVID19LORES','COVID19N','COVID19NP','COVID19OP','COVID19SLV','COVID19SPT','COVID19THR','COVIDANTIGEN','EXTCOVID') 
and result_flag like 'abnormal'
union
select distinct osler_id  --Pats w/ Covid dx at encounter
from derived_encounter_dx
where icd10_code like '%u07.1'
union
select distinct osler_id --Pats w/ covid dx on problem list (capture pats who didn't have encounter)
from derived_problem_list
where icd10_code like '%u07.1') t

--Total # Covid pos outpatients (subject to change based on answers to questions)
select count(distinct enc.osler_id) "Total_Pos_Outpatients"
from derived_outpatient_encounters enc
inner join covid_pmcoe_covid_positive pos on pos.osler_id = enc.osler_id
where department_id not in ('110106333', '110200331', '110300335', '110500332')

--Total # Covid pos ED encounters which ended in admission
select count(distinct enc.osler_id) "Total_Pos_Inpatients_ED_Adm"
from derived_inpatient_encounters enc
inner join covid_pmcoe_covid_positive pos on pos.osler_id = enc.osler_id
where ed_visit_yn = 'Y'
and (adt_pat_class_c = 101 or adt_pat_class_c = 104)

--Total # Covid pos ED encounters which did not end in admission
select count(distinct enc.osler_id) "Total_Pos_Inpatients_ED_Not_Adm"
from derived_inpatient_encounters enc
inner join covid_pmcoe_covid_positive pos on pos.osler_id = enc.osler_id
where ed_visit_yn = 'Y'
and (adt_pat_class_c = 103)

--Total # of pat in registry
select count(distinct pat.osler_id) "Total_Pat_In_Registry"
FROM derived_epic_patient pat;

--Total # Covid pos inpatients 
select count(distinct enc.osler_id) "Total_Pos_Inpatients"
from derived_inpatient_encounters enc
inner join covid_pmcoe_covid_positive pos on pos.osler_id = enc.osler_id
and hosp_admsn_time >= '2020-03-01';

--Adult/Ped pos
WITH Ped_Adult AS (
select CASE WHEN t.age_at_positive < 18 THEN '< 18' ELSE 'Adult' END AS Age from(
select distinct openc.osler_id, pos.age_at_positive --Pos outpatients
from derived_outpatient_encounters openc
inner join covid_pmcoe_covid_positive pos on pos.osler_id = openc.osler_id
where department_id not in ('110106333', '110200331', '110300335', '110500332')
union
select distinct enc.osler_id, pos.age_at_positive
from derived_inpatient_encounters enc -- Pos inpatients
inner join covid_pmcoe_covid_positive pos on pos.osler_id = enc.osler_id
union
select  distinct pat.osler_id, CAST((DATEDIFF(DAY, pat.BIRTH_DATE, lab.result_time)/365.25) AS INT) "Age" --Pos crisp labs + other covid labs
from derived_lab_results lab
inner join derived_epic_patient pat on lab.osler_id = pat.osler_id
where component_base_name in('COVID19ANTI','COVID19BAL','COVID19ET','COVID19EX','COVID19INT','COVID19LORES','COVID19N','COVID19NP','COVID19OP','COVID19SLV','COVID19SPT','COVID19THR','COVIDANTIGEN','EXTCOVID') 
and result_flag like 'abnormal'
union
select distinct dx.osler_id, CAST((DATEDIFF(DAY, pat.BIRTH_DATE, dx.enc_contact_date)/365.25) AS INT) "Age"  --Pats w/ Covid dx at encounter
from derived_encounter_dx dx
inner join derived_epic_patient pat on dx.osler_id = pat.osler_id
where icd10_code like '%u07.1'
union
select distinct pat.osler_id, CAST((DATEDIFF(DAY, pat.BIRTH_DATE, prob.noted_date)/365.25) AS INT) "Age" --Pats w/ covid dx on problem list (capture pats who didn't have encounter)
from derived_problem_list prob
inner join derived_epic_patient pat on prob.osler_id = pat.osler_id
where icd10_code like '%u07.1') t )
Select Age, count(*) "Total_Covid_Pos"
FROM PED_ADULT
GROUP by Age;

--Zeger_Inp
select count(distinct osler_id) "Total_Zeger_Inpatients"
from COVID_Projection.dbo.curated_IPEvents

select count(distinct osler_id)
from curated_IPEvents