USE COVID_Projection;

select medication_id, medication_name, pharm_classname, thera_classname, omop.source_code, COUNT(*) "Num_Missing"
into PMAP_Analytics.dbo.FDA_CROWN_Missing_Drugs
from curated_IPEvents ipe
inner join derived_med_admin med on ipe.osler_id = med.osler_id
left join PMAP_Analytics.dbo.OMOP_Med omop on med.medication_id = omop.source_code
where omop.source_code is NULL
group by medication_id, medication_name, pharm_classname, thera_classname, omop.source_code
order by count(*) desc