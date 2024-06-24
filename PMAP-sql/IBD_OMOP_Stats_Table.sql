-- pautent count: 2,401,803
USE [JHM_OMOP_NoID]
select count(distinct person_id)
from observation_period;

-- Median follow-up (days): 1326
select top 1 PERCENTILE_CONT(0.5) WITHIN GROUP (order by max_length_days) OVER (PArtition by NULL)  AS median
from 
(
	select person_id, max(length_days) max_length_days 
	from 
	(
		select person_id, observation_period_start_date, observation_period_end_date, datediff(dd, observation_period_start_date, observation_period_end_date)  "length_days"
		from observation_period 
	) q1 group by person_id 
	--order by max_length_days
) q2

-- covered years 
SELECT min(observation_period_start_date), max(observation_period_end_date)
	FROM observation_period;
	
-- % female: 55.25% 
SELECT gender_concept_id, count(*)
FROM person
join observation_period op
on person.person_id = op.person_id 
group by gender_concept_id;

-- age mean: 36
select avg(age)
from 
(
	select datepart(year, observation_period_start_date) - year_of_birth AS age
	from observation_period op
	INNER JOIN person
	ON op.person_id = person.person_id
) q 