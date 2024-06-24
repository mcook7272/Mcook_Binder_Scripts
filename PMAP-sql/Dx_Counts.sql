--Group 1
select count(distinct emr.osler_id) "Unique_Patients", count(emr.icd10list) "Total_Dx" from derived_emr_diagnosis_info emr
inner join covid_pmcoe_covid_positive pos on pos.osler_id = emr.osler_id
where icd10list like '%D80%'
--Group2
select count(distinct emr.osler_id) "Unique_Patients", count(emr.icd10list) "Total_Dx" from derived_emr_diagnosis_info emr
inner join covid_pmcoe_covid_positive pos on pos.osler_id = emr.osler_id
where icd10list like '%D81.0%'
or icd10list like '%D81.1%'
or icd10list like '%D81.2%'
or icd10list like '%D81.3%'
or icd10list like '%D81.4%'
or icd10list like '%D81.5%'
or icd10list like '%D81.6%'
or icd10list like '%D81.7%'
or icd10list like '%D81.810%'
or icd10list like '%D81.818%'
or icd10list like '%D81.819%'
or icd10list like'%D81.89%'
or icd10list like '%D81.9%'
--Group 3
select count(distinct emr.osler_id) "Unique_Patients", count(emr.icd10list) "Total_Dx" from derived_emr_diagnosis_info emr
inner join covid_pmcoe_covid_positive pos on pos.osler_id = emr.osler_id
where icd10list like '%D82.0%'
or icd10list like '%D82.1%'
or icd10list like '%D82.2%'
or icd10list like '%D82.3%'
or icd10list like '%D82.8%'
or icd10list like '%D82.9%'
--Group 4
select count(distinct emr.osler_id) "Unique_Patients", count(emr.icd10list) "Total_Dx" from derived_emr_diagnosis_info emr
inner join covid_pmcoe_covid_positive pos on pos.osler_id = emr.osler_id
where icd10list like '%D83.0%'
or icd10list like '%D83.1%'
or icd10list like '%D83.2%'
or icd10list like '%D83.8%'
or icd10list like '%D83.9%'


