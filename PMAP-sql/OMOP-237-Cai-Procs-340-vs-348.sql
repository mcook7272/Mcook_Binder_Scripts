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
p.procedure_concept_id,c1.concept_name "procedure_name", p.procedure_datetime
from PT_LIST
join procedure_occurrence p on PT_LIST.person_id = p.person_id
join concept c1 on p.procedure_concept_id = c1.concept_id
order by PT_LIST.person_id, p.procedure_datetime
