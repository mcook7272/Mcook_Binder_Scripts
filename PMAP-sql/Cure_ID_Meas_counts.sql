select measurement_concept_id, concept_name, count(*) "Observations", count(distinct person_id) "People"
from results.CURE_ID_Measurements
group by measurement_concept_id, concept_name
order by count(*) desc