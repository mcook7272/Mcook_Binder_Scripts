WITH tab as (
select distinct person_id, c.concept_name "gender", 
	CASE WHEN CAST(DATEDIFF(day,birth_datetime, CURRENT_TIMESTAMP) / 365.25 AS INT) < 18 THEN 'Pediatric'
	ELSE 'Adult'
	END AS Age
from Results.cohort coh
join person p on coh.subject_id = p.person_id
join concept c on p.gender_concept_id = c.concept_id
where cohort_definition_id = 24 )

select gender, age, count(distinct person_id) "person_count"
from tab
group by gender, age
order by person_count desc
