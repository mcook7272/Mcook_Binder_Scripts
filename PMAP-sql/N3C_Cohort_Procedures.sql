SELECT TOP 1000 p.*
INTO results.CURE_ID_Procedures
FROM procedure_occurrence p
INNER JOIN results.CURE_ID_Cohort coh
	ON p.visit_occurrence_id = coh.visit_occurrence_id
WHERE procedure_concept_id IN (
		'44790731'
		,'4155151'
		,'3655950'
		,'4162736'
		,'4052536'
		,'4177224'
		,'4230167'
		,'4032243'
		,'3655896'
		)
	AND DATEDIFF(day, coh.visit_start_date, p.procedure_datetime) < 3