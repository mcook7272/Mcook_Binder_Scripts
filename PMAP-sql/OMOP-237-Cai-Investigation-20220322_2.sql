WITH PT AS (
select person_id from person
where person_id in (
--286020
715763
--291353
)
)

select d.*, c.concept_name, c2.concept_name "type" 
from procedure_occurrence d
join PT on d.person_id = PT.person_id
join concept c on d.procedure_concept_id = c.concept_id
join concept c2 on d.procedure_type_concept_id = c2.concept_id
where procedure_concept_id = 2111025

select d.procedure_type_concept_id, c2.concept_name, count(*)
from procedure_occurrence d
join concept c2 on d.procedure_type_concept_id = c2.concept_id
group by procedure_type_concept_id, c2.concept_name
order by count(*) desc

