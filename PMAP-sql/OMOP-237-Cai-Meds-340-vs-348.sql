/*WITH PT_LIST AS (
(select subject_id "person_id", '348' "Cohort_Num"
from results.cohort 
where cohort_definition_id = 47
union
select subject_id, '340'
from results.cohort 
where cohort_definition_id = 49)
except
(
select subject_id, '348' "Cohort_Num"
from results.cohort 
where cohort_definition_id = 47
intersect
select subject_id, '340'
from results.cohort 
where cohort_definition_id = 49
)
)
*/
WITH Cohort_348 AS (
select subject_id "person_id"
from results.cohort 
where cohort_definition_id = 47
),
Cohort_340 AS (
select subject_id "person_id_b"
from results.cohort 
where cohort_definition_id = 49
)

,
PT_LIST AS (
/*
select a.*, b.*
from Cohort_348 a
FULL OUTER JOIN Cohort_340 b on a.person_id = b.person_id_b
where a.person_id is NULL or b.person_id_b is null
*/
(select person_id
from cohort_348
union
select person_id_b
from cohort_340)
except
(
select person_id
from cohort_348
intersect
select person_id_b
from cohort_340
)
)

select distinct PT_LIST.person_id, '348' "Cohort_Num",
d.drug_concept_id,c1.concept_name "drug_name", d.drug_exposure_start_datetime, d.drug_exposure_end_datetime
from PT_LIST
join drug_exposure d on PT_LIST.person_id = d.person_id
join concept c1 on d.drug_concept_id = c1.concept_id
order by PT_LIST.person_id, d.drug_exposure_start_datetime
