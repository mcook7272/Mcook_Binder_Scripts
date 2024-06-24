/*
Patients between the ages of 0 and 18
Seen at Johns Hopkins All Children’s Hospital between 10/1/2020 and 10/31/2020
Having any surgical procedure requiring general anesthesia, performed by pediatric surgeons (list provided by study team)
Having a positive COVID test during the encounter associated with the surgical procedure

*/


WITH ptlist AS
(
select distinct z.osler_id
from
(
select distinct osler_id, hosp_admsn_time
from COVID_Projection..derived_inpatient_encounters
where hosp_admsn_time between '10/01/2020' and '10/31/2020'
and (department_id like '%1108%' or department_id like '%1150%')
union 
select osler_id, max(contact_date) as maxenctime
from COVID_Projection..derived_outpatient_encounters
where contact_date between '10/01/2020' and '10/31/2020'
and (department_id like '%1108%' or department_id like '%1150%')
group by osler_id
) z 

)

select distinct pat.osler_id
from COVID_Projection..derived_epic_patient pat
inner join ptlist pt on pat.osler_id = pt.osler_id
inner join COVID_Projection..derived_epic_surgeries srg on srg.osler_id = pat.osler_id
inner join COVID_Projection..covid_pmcoe_covid_positive cp on cp.osler_id = pt.osler_id
inner join COVID_Projection..derived_lab_results lab on lab.osler_id = srg.osler_id
where 
srg.primary_surgeon_id in ('92132', '490581', '92097', '490580', '92149', '1054140', '92150', '92203', '92189')
--and datediff(day, srg.surgery_date, lab.result_time) = 0 --Surgery and lab result on same day
and surgery_date <= dateadd(yy, 18, birth_date) -- 18 or younger at time of surgery
and srg.anesthesia_type like 'General'
and ((cp.initial_dx_source like 'LAB' and lab.component_base_name not in ('EXTCOVID')) 
      or (lab.component_base_name in ('COVID19IA1','COVID19IGA','COVID19IG1','COVID19IGG','COVID19INT','COVID19LORES','COVID19OP','COVID19SE','COVID19SLV','COVID19THR', 'COVID19NP') and lab.result_flag in ('abnormal','high')))

	  74454c83-b805-4cc3-9bcb-63686a29fb47 


/*
select distinct pat.osler_id, pat.birth_date, surgery_date
from COVID_Projection..derived_epic_patient pat
inner join COVID_Projection..derived_epic_surgeries srg on srg.osler_id = pat.osler_id
inner join COVID_Projection..covid_pmcoe_covid_positive cp on cp.osler_id = pat.osler_id
where (srgenc_dept_id like '%1108%'
or srgenc_dept_id like '%1150%')
and surgery_date <= dateadd(yy, 18, birth_date)
order by birth_date

select distinct lab.osler_id, srg.surgery_date, lab.result_time, lab.order_time
from covid_projection..derived_lab_results lab
inner join covid_projection..derived_epic_surgeries srg on srg.osler_id = lab.osler_id
where datediff(day, srg.surgery_date, lab.result_time) = 0
*/

select distinct pat.osler_id
from COVID_Projection..derived_epic_patient pat
inner join COVID_Projection..derived_epic_surgeries srg on srg.osler_id = pat.osler_id
inner join COVID_Projection..covid_pmcoe_covid_positive cp on cp.osler_id = pat.osler_id
inner join COVID_Projection..derived_lab_results lab on lab.osler_id = srg.osler_id
where 
srg.primary_surgeon_id in ('92132', '490581', '92097', '490580', '92149', '1054140', '92150', '92203', '92189')
and datediff(day, srg.surgery_date, lab.result_time) = 7 --Surgery and lab result on same day/close to same day
and surgery_date between '10/01/2020' and '10/31/2020'
and surgery_date <= dateadd(yy, 18, birth_date) -- 18 or younger at time of surgery
and ((cp.initial_dx_source like 'LAB' and lab.component_base_name not in ('EXTCOVID')) 
      or (lab.component_base_name in ('COVID19IA1','COVID19IGA','COVID19IG1','COVID19IGG','COVID19INT','COVID19LORES','COVID19OP','COVID19SE','COVID19SLV','COVID19THR') and lab.result_flag in ('abnormal','high')))
