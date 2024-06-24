WITH PATS AS (
SELECT distinct subject_id
  FROM [JHM_OMOP_20210909].[Results].[cohort]
  where cohort_definition_id = 24
)

select care.care_site_id, care.care_site_name, count(distinct vis.person_id) "Person_Count"
from care_site care
join visit_occurrence vis on care.care_site_id = vis.care_site_id
join PATS on vis.person_id = PATS.subject_id
where care.care_site_name like 'JHH%'
or care.care_site_source_value like '1101%'
group by care.care_site_id,care.care_site_name
order by count(vis.person_id) desc

