WITH PT AS (
select person_id from person
where person_id in (
--286020
1108942
--291353
)
)

select d.*, c.concept_name 
from procedure_occurrence d
join PT on d.person_id = PT.person_id
join concept c on d.procedure_concept_id = c.concept_id
where procedure_concept_id = 2111025

