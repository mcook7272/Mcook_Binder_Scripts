SELECT o.*
into results.CURE_ID_Observations
FROM observation o
INNER JOIN results.CURE_ID_Cohort coh
	ON o.visit_occurrence_id = coh.visit_occurrence_id
WHERE observation_concept_id IN (
		'3022304'
		,'3046965'
		,'46236995'
		,'4306655'
		,'46235215'
		,'3046853'
		,'4298794'
		,'42528957'
		)
	AND DATEDIFF(day, coh.visit_start_date, o.observation_datetime) < 3