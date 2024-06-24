WITH PATS AS (
SELECT distinct subject_id
  FROM [JHM_OMOP_20210909].[Results].[cohort]
  where cohort_definition_id = 24
),

SITES AS (
Select care_site_id 
from care_site
where care_site_id in (24,26,27,29,30,31) --Care sites of interest from Sophie
)

select distinct vis.person_id
from visit_occurrence vis 
JOIN SITES on vis.care_site_id = SITES.care_site_id
join PATS on vis.person_id = PATS.subject_id


