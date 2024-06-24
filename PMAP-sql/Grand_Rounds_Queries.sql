USE [COVID_Projection]

--Total # Covid pos pat
select count(distinct t.osler_id) "Total_Pos_Patients" from(
select distinct openc.osler_id --Pos outpatients
from derived_outpatient_encounters openc
inner join covid_pmcoe_covid_positive pos on pos.osler_id = openc.osler_id
where department_id not in ('110106333', '110200331', '110300335', '110500332')
union
select distinct enc.osler_id
from derived_inpatient_encounters enc -- Pos inpatients (need to account for ED/not here?)
inner join covid_pmcoe_covid_positive pos on pos.osler_id = enc.osler_id
where ed_visit_yn = 'N'
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


--Total # Covid pos inpatients 
select count(distinct enc.osler_id) "Total_Pos_Inpatients_No_ED"
from derived_inpatient_encounters enc
inner join covid_pmcoe_covid_positive pos on pos.osler_id = enc.osler_id

--Total # Covid pos ED encounters which ended in admission
select count(distinct enc.osler_id) "Total_Pos_Inpatients_ED_Adm)"
from derived_inpatient_encounters enc
inner join covid_pmcoe_covid_positive pos on pos.osler_id = enc.osler_id
where ed_visit_yn = 'Y'
and (adt_pat_class_c = 101 or adt_pat_class_c = 104)

--Total # Covid pos ED encounters which did not end in admission
select count(distinct enc.osler_id) "Total_Pos_Inpatients_ED_Not_Adm)"
from derived_inpatient_encounters enc
inner join covid_pmcoe_covid_positive pos on pos.osler_id = enc.osler_id
where ed_visit_yn = 'Y'
and (adt_pat_class_c = 103)

--Total # of pat in registry
select count(distinct pat.osler_id) "Total_Pat_In_Registry"
FROM derived_epic_patient pat


--Workspace
select top 100 *
from derived_lab_results
where (component_base_name like '%COVID%'
or component_base_name like '%crisp%')
and ord_value not like '%no%'

select top 100 *
from derived_lab_results
where component_base_name like '%crisp%'

select count(distinct enc.osler_id) "Total_Pos_Inpatients"
from derived_inpatient_encounters enc
inner join derived_lab_results lab on lab.osler_id = enc.osler_id
where ed_visit_yn = 'N'
and component_base_name like '%COVID%'
and ord_value not like '%no%'

select count(distinct enc.osler_id) "Total_Pos_Inpatients"
from derived_inpatient_encounters enc
inner join covid_pmcoe_covid_positive pos on pos.osler_id = enc.osler_id
where ed_visit_yn = 'N'

select count(distinct enc.osler_id) "Total_Pos_Inpatients"
from derived_outpatient_encounters enc
inner join derived_lab_results lab on lab.osler_id = enc.osler_id
where component_base_name like '%COVID%'
and ord_value not like '%no%'

select count(distinct enc.osler_id) "Total_Pos_Outpatients"
from derived_outpatient_encounters enc
inner join derived_lab_results lab on lab.osler_id = enc.osler_id
where component_base_name like '%EXTCOVID%'
and ord_value not like '%no%'

select  count(distinct osler_id)
from derived_lab_results
where component_base_name like '%EXTCOVID%'
and ord_value not like '%no%'

select count(distinct osler_id) 
from derived_encounter_dx
where dx_name like '%covid%'

select count(distinct osler_id) 
from derived_medical_hx_summary
where dx_name like '%covid%'

select count(distinct osler_id) 
from derived_problem_list
where dx_name like '%covid%'

select count(distinct osler_id) 
from derived_hosp_billing_dx
where dx_name like '%covid%'

select top 100 * 
from derived_encounter_dx
where dx_name like '%covid%'

select  top 100 *
from derived_lab_results lab
inner join derived_inpatient_encounters enc on enc.osler_id = lab.osler_id
where component_base_name like '%EXTCOVID%'
and ord_value not like '%no%'

select  distinct ord_value --Pos crisp labs
from derived_lab_results
where component_base_name like '%EXTCOVID%'
and ord_value not like '%no%'
and ord_value not like '%neg%'

select count(distinct osler_id) "Total_Pos_Inpatients"
from curated_IPEvents

select count(distinct pat.osler_id) "Total_Pat_In_Registry"
FROM derived_epic_patient pat
except
select count(distinct lab.osler_id) "Total_Pat_In_Registry"
from derived_lab_results lab 
where component_base_name like '%EXTCOVID%'
and (ord_value like '%no%'
or ord_value like '%neg%')

select count(distinct t.osler_id) "Total_Pos_Inpatients" from (
select distinct enc.osler_id
from derived_inpatient_encounters enc
inner join covid_pmcoe_covid_positive pos on pos.osler_id = enc.osler_id
where ed_visit_yn = 'N'
except
select distinct enc.osler_id 
from derived_inpatient_encounters enc
inner join covid_pmcoe_covid_positive pos on pos.osler_id = enc.osler_id
where ed_visit_yn = 'Y') t

select  count(distinct osler_id)
from derived_lab_results lab
where component_base_name like '%COVID%'
and ord_value not like '%no%'
and ord_value not like '%neg%'
and ord_value not like '%cancel%'
and ord_value not like '%inval%'
and ord_value not like '%pend%'
and ord_value not like '%delete%'
and ord_value not like '%comment%'
and ord_value not like '%see%'

select  distinct component_base_name, component_name, ord_value
from derived_lab_results lab
where component_base_name like '%COVID%'
and result_flag like 'abnormal'

select distinct department_id, department_name
from derived_outpatient_encounters
where department_id not in ('110106333', '110200331', '110300335', '110500332')
order by department_id

select count(distinct osler_id)
from covid_pmcoe_covid_positive

select count(distinct ipe.osler_id) "Total_Pos_Inpatients_ED" from (
select distinct enc.pat_enc_csn_id
from derived_inpatient_encounters enc
inner join covid_pmcoe_covid_positive pos on pos.osler_id = enc.osler_id
where ed_visit_yn = 'Y'
except
select distinct enc.pat_enc_csn_id
from derived_inpatient_encounters enc
inner join covid_pmcoe_covid_positive pos on pos.osler_id = enc.osler_id
where ed_visit_yn = 'N') t
inner join derived_inpatient_encounters ipe on ipe.pat_enc_csn_id = t.pat_enc_csn_id

select count(distinct ipe.osler_id) "Total_Pos_Inpatients_ED" from (
select distinct enc.pat_enc_csn_id
from derived_inpatient_encounters enc
inner join covid_pmcoe_covid_positive pos on pos.osler_id = enc.osler_id
where ed_visit_yn = 'Y') t
inner join derived_inpatient_encounters ipe on ipe.pat_enc_csn_id = t.pat_enc_csn_id

select count(distinct enc.osler_id)
from derived_inpatient_encounters enc
inner join covid_pmcoe_covid_positive pos on pos.osler_id = enc.osler_id
where ed_visit_yn = 'Y'

select  distinct osler_id --All covid labs, hopefully to get ACH
from derived_lab_results lab
where component_base_name in('COVID19ANTI','COVID19BAL','COVID19ET','COVID19EX','COVID19INT','COVID19LORES','COVID19N','COVID19NP','COVID19OP','COVID19SLV','COVID19SPT','COVID19THR','COVIDANTIGEN','EXTCOVID') 
and result_flag like 'abnormal'

select distinct top 1000 *
from derived_inpatient_encounters enc
inner join covid_pmcoe_covid_positive pos on pos.osler_id = enc.osler_id
order by enc.osler_id