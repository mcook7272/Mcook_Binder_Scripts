USE [JHM_OMOP_ID_Projection]

select COHORT_DEFINITION_ID, count(distinct subject_id) "row_count"
from results.cohort
where COHORT_DEFINITION_ID >= 427
group by COHORT_DEFINITION_ID
order by COHORT_DEFINITION_ID desc