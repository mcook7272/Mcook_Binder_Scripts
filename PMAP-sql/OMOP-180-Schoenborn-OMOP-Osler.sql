select distinct coh.subject_id, s.sourcekey as osler_id
from results.Cohort coh
join stage.SourceIDMapsPerson s on s.id = coh.subject_id
join visit_occurrence v on coh.subject_id = v.person_id
where  cohort_definition_id = 33
and s.domain = 'person'
and v.care_site_id in ('25','30','31','46','49','50','51','57','58','61',
   '65','66','73','97','103','105','107','112','117','126',
   '127','128','130','131','132','133','134','137','138','141',
   '142','144','145','146','165','166','188','196','197')
--and s.sourcekey in ('16e55a6f-1f18-442e-bb4b-0137f3fa9688','b5101075-f37f-4d14-ae57-c1dc7e3ad51d','6e6b6979-db0d-4e0e-bc3a-4595d103eaf0')
/*
osler id's map to
('E101247309', 'E105791886', 'E105263338')
emrns map to
('BV01809673', 'BV02014376', 'BV01803408')
*/

select p.person_id, s.sourcekey as osler_id
from person p
join stage.SourceIDMapsPerson s on s.id = p.person_id
WHERE s.domain = 'person'
and s.sourcekey in ('16e55a6f-1f18-442e-bb4b-0137f3fa9688','b5101075-f37f-4d14-ae57-c1dc7e3ad51d','6e6b6979-db0d-4e0e-bc3a-4595d103eaf0')

/*
maps to
(332179, 1646623, 869737)
*/

select distinct p.person_id, p.procedure_concept_id, c.concept_name, procedure_datetime
from procedure_occurrence p
join concept c on p.procedure_concept_id = c.concept_id
where person_id in (332179, 1646623, 869737)
--and p.procedure_concept_id in (2109180,2109181,2109182,2109183,2109184,2109186,2109187,2109188,2617207,2212231,2212233,42738105,2212235,2617210,2617406,42627905,45890624,40756913,40757081,40757125,42737560,2211814,42627987,2617289,40218347,40218348,2617206,2212542,2109194,2109196,2109198,2109199,2109200,2109201,2617208,2617223,2109169,2109170,2109171,2109173,2109174,2109175,2109177,2109180)
order by p.person_id


select distinct con.person_id, con.condition_concept_id, c.concept_name
from condition_occurrence con
join concept c on con.condition_concept_id = c.concept_id
where person_id in (332179, 1646623, 869737)
order by con.person_id

select count(distinct p.person_id)
from person p
join visit_occurrence v on p.person_id = v.person_id
where YEAR(v.visit_start_date) - P.year_of_birth >= 65
and v.care_site_id in ('25','30','31','46','49','50','51','57','58','61',
   '65','66','73','97','103','105','107','112','117','126',
   '127','128','130','131','132','133','134','137','138','141',
   '142','144','145','146','165','166','188','196','197')

   452,599