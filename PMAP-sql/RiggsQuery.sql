WITH ptlist AS
(
select distinct z.osler_id
from
(
select distinct osler_id, hosp_admsn_time
from COVID_Projection..derived_inpatient_encounters
where adt_pat_class_c = 103
and (department_id like '1101%')
and ed_visit_yn = 'Y'
union 
select osler_id, max(contact_date) as maxenctime
from COVID_Projection..derived_outpatient_encounters
where contact_date between '05/01/2020' and CURRENT_TIMESTAMP
and (department_id like '1101%')
group by osler_id
having max(contact_date) >= '05/01/2020'
) z 

)

select distinct pat.osler_id,emrn,pat.lastname, pat.firstname, birth_date,cp.initial_dx_date
from COVID_Projection..derived_epic_patient pat
inner join ptlist pt on pat.osler_id = pt.osler_id
left join COVID_Projection..covid_pmcoe_covid_positive cp on cp.osler_id = pt.osler_id
left join COVID_Projection..derived_lab_results lab on lab.osler_id = pt.osler_id
left join COVID_Projection..curated_IPEvents ipe on ipe.osler_id = pt.osler_id
where ipe.osler_id is null
and cp.age_at_positive < 18
and ((cp.initial_dx_source like 'LAB' and lab.component_base_name not in ('EXTCOVID')) 
       or (lab.component_base_name in ('COVID19IA1','COVID19IGA','COVID19IG1','COVID19IGG') and lab.result_flag in ('abnormal','high')))
order by pat.lastname, pat.firstname
