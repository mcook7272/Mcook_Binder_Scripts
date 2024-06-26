/****** Script for SelectTopNRows command from SSMS  ******/
SELECT visit_concept_id, visit_source_value, count(*)
  FROM [JHM_OMOP_20211108].[dbo].[visit_occurrence]
  --where substring(visit_source_value,1,15) = 'Class=Inpatient'
  where visit_concept_id = 9201
  or substring(visit_source_value,1,15) = 'Class=Inpatient'
  group by visit_concept_id, visit_source_value
  order by count(*) desc

  select person_id, visit_start_date, visit_end_date
  from visit_occurrence
  where visit_concept_id = 9201