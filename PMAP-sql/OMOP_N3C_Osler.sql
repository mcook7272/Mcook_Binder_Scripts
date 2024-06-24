select p.person_id, s.sourcekey as osler_id, vis.visit_source_value
--into Results.N3C_CASE_COHORT_Osler
from person p
join Results.N3C_CASE_COHORT nc3 on nc3.person_id = p.person_id
join stage.SourceIDMapsPerson s on s.id = p.person_id
join visit_occurrence vis on vis.person_id = p.person_id
where  1 = 1
and substring(visit_source_value,1,15) = 'Class=Inpatient'
and s.domain = 'person'
