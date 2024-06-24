SELECT c.*
	--,DATEDIFF(day, coh.visit_start_date, c.condition_start_datetime)
into results.CURE_ID_Condition_Occurrence
FROM condition_occurrence c
INNER JOIN results.CURE_ID_Cohort coh
	ON c.visit_occurrence_id = coh.visit_occurrence_id
WHERE condition_concept_id IN (
		'703441'
		,'37311061'
		,'4013106'
		,'317009'
		,'255573'
		,'4063381'
		,'201820'
		,'316866'
		,'4028244'
		,'46271022'
		,'4212540'
		,'4157007'
		,'381316'
		,'4182210'
		)
	AND DATEDIFF(day, coh.visit_start_date, c.condition_start_datetime) < 3