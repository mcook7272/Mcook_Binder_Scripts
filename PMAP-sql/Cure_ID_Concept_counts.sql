select measurement_concept_id, concept_name, count(*) "Observations", count(distinct person_id) "People"
from results.CURE_ID_Measurements
group by measurement_concept_id, concept_name
order by count(*) desc;

select d.device_concept_id, c.concept_name, count(*) "Observations", count(distinct person_id) "People"
from results.CURE_ID_Device_Exposure d
join concept c on d.device_concept_id = c.concept_id
group by d.device_concept_id, c.concept_name
order by count(*) desc

select o.observation_concept_id, c.concept_name, count(*) "Observations", count(distinct person_id) "People"
from results.CURE_ID_Observations o
join concept c on o.observation_concept_id = c.concept_id
group by o.observation_concept_id, c.concept_name
order by count(*) desc

select o.condition_concept_id, c.concept_name, count(*) "Observations", count(distinct person_id) "People"
from Results.CURE_ID_Condition_Occurrence o
join concept c on o.condition_concept_id = c.concept_id
group by o.condition_concept_id, c.concept_name
order by count(*) desc

--Procedures are empty