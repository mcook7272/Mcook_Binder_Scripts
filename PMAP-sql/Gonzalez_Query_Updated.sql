select distinct pat.pat_name, pat.emrn, pat.jhhmrn, pat.bmcmrn, pat.hcgmrn, pat.shmrn, pat.smhmrn, srg.surgery_date, srg.primary_surgeon_name, srg.proc_name
from COVID_Projection..derived_epic_patient pat
inner join COVID_Projection..derived_epic_surgeries srg on srg.osler_id = pat.osler_id
inner join COVID_Projection..covid_pmcoe_covid_positive cp on cp.osler_id = pat.osler_id
inner join COVID_Projection..derived_lab_results lab on lab.osler_id = srg.osler_id
where 
srg.primary_surgeon_id in ('92132', '490581', '92097', '490580', '92149', '1054140', '92150', '92203', '92189')
and datediff(day, srg.surgery_date, lab.result_time) = 7 --Surgery and lab result on same day/close to same day
and surgery_date between '10/01/2020' and '11/05/2020'
and surgery_date <= dateadd(yy, 18, birth_date) -- 18 or younger at time of surgery
and ((cp.initial_dx_source like 'LAB' and lab.component_base_name not in ('EXTCOVID')) 
      or (lab.component_base_name in ('COVID19IA1','COVID19IGA','COVID19IG1','COVID19IGG','COVID19INT','COVID19LORES','COVID19OP','COVID19SE','COVID19SLV','COVID19THR') and lab.result_flag in ('abnormal','high'))) --More labs needed here?