select p.procedure_concept_id, c.concept_name, count(*) "record_count"
from procedure_occurrence p
join concept c on p.procedure_concept_id = c.concept_id
where procedure_concept_id in (725120,759715,2213601,2313971,2313972,2414390,2414391,2414392,2414393,2414394,2414395,2414396,2414397,2414398,2514399,2514400,2514493,2514494,42628033,42628640)
group by p.procedure_concept_id, c.concept_name
order by record_count desc