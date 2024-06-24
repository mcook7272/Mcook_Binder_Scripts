select t.*
into PMAP_Analytics.dbo.OMOP_298_Legend_Cohort
from (
select SUBJECT_ID as person_id
from JHM_OMOP.results.cohort
where cohort_definition_ID = 57
union
select SUBJECT_ID
from JHM_OMOP.results.cohort
where cohort_definition_ID = 58
union
select SUBJECT_ID
from JHM_OMOP.results.cohort
where cohort_definition_ID = 59
union
select SUBJECT_ID
from JHM_OMOP.results.cohort
where cohort_definition_ID = 60) t