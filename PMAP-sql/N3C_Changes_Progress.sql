IF OBJECT_ID('Results.N3C_PRE_COHORT', 'U') IS NULL
	CREATE TABLE Results.N3C_PRE_COHORT (
		person_id INT NOT NULL
		,inc_dx_strong INT NOT NULL
		,inc_dx_weak INT NOT NULL
		,inc_lab_any INT NOT NULL
		,inc_lab_pos INT NOT NULL
		,phenotype_version VARCHAR(10)
		,pt_age VARCHAR(20)
		,sex VARCHAR(20)
		,hispanic VARCHAR(20)
		,race VARCHAR(20)
		,vocabulary_version VARCHAR(20)
		);




IF OBJECT_ID('Results.N3C_CASE_COHORT', 'U') IS NULL
	CREATE TABLE Results.N3C_CASE_COHORT (
		person_id INT NOT NULL
		,pt_age VARCHAR(20)
		,sex VARCHAR(20)
		,hispanic VARCHAR(20)
		,race VARCHAR(20)
		);




IF OBJECT_ID('Results.N3C_COHORT', 'U') IS NULL
	CREATE TABLE Results.n3c_cohort (person_id INT NOT NULL);

IF OBJECT_ID('Results.final_map', 'U') IS NOT NULL
	DROP TABLE Results.final_map;

-- before beginning, remove any patients from the last run
-- IMPORTANT: do NOT truncate or drop the control-map table.
TRUNCATE TABLE Results.N3C_PRE_COHORT;
TRUNCATE TABLE Results.N3C_CASE_COHORT;
TRUNCATE TABLE Results.N3C_COHORT;

-- Phenotype Entry Criteria: A lab confirmed positive test
WITH covid_lab_pos
AS (
	SELECT DISTINCT person_id, measurement_date
	FROM dbo.MEASUREMENT
	WHERE measurement_concept_id IN (
			SELECT concept_id
			FROM dbo.CONCEPT
			-- here we look for the concepts that are the LOINC codes we're looking for in the phenotype
			WHERE concept_id IN (
					586515
					,586522
					,706179
					,586521
					,723459
					,706181
					,706177
					,706176
					,706180
					,706178
					,706167
					,706157
					,706155
					,757678
					,706161
					,586520
					,706175
					,706156
					,706154
					,706168
					,715262
					,586526
					,757677
					,706163
					,715260
					,715261
					,706170
					,706158
					,706169
					,706160
					,706173
					,586519
					,586516
					,757680
					,757679
					,586517
					,757686
					,756055
					,36659631
					,36661377
					,36661378
					,36661372
					,36661373
					,36661374
					,36661370
					,36661371
					,723479
					,723474
					,757685
					,723476
					,586524
					,586525
					,586527
					,586528
					,586529
					,715272
					,723463
					,723464
					,723465
					,723466
					,723467
					,723468
					,723469
					,723470
					,723471
					,723473
					,723475
					,723477
					,723478
					,723480
					,36661369
					,36031238
					,36031213
					,36031506
					,36031197
					,36032061
					,36031944
					,36031969
					,36031956
					,36032309
					,36032174
					,36032419
					,36031652
					,36031453
					,36032258
					,36031734
					)

			UNION

			SELECT c.concept_id
			FROM dbo.CONCEPT c
			JOIN dbo.CONCEPT_ANCESTOR ca ON c.concept_id = ca.descendant_concept_id
				-- Most of the LOINC codes do not have descendants but there is one OMOP Extension code (765055) in use that has descendants which we want to pull
				-- This statement pulls the descendants of that specific code
				AND ca.ancestor_concept_id IN (756055)
				AND c.invalid_reason IS NULL
			)
		-- Here we add a date restriction: after January 1, 2020
		AND measurement_date >= DATEFROMPARTS(2020, 01, 01)
		AND (
			-- The value_as_concept field is where we store standardized qualitative results
			-- The concept ids here represent LOINC or SNOMED codes for standard ways to code a lab that is positive
			value_as_concept_id IN (
				4126681 -- Detected
				,45877985 -- Detected
				,45884084 -- Positive
				,9191 --- Positive 
				,4181412 -- Present
				,45879438 -- Present
				,45881802 -- Reactive
				)
			-- To be exhaustive, we also look for Positive strings in the value_source_value field
			OR value_source_value IN (
				'Positive'
				,'Present'
				,'Detected'
				,'Reactive'
				)
			)
	)
	,
--First positive test
first_pos AS (
select person_id, min(measurement_date) "First_Pos_Date"
from covid_lab_pos
group by person_id
),
	-- UNION
	-- Phenotype Entry Criteria: ONE or more of the Strong Positive diagnosis codes from the ICD-10 or SNOMED tables
	-- This section constructs entry logic prior to the CDC guidance issued on April 1, 2020
dx_strong
AS (
	SELECT DISTINCT visit_occurrence_id
	FROM dbo.CONDITION_OCCURRENCE
	WHERE condition_concept_id IN (
			SELECT concept_id
			FROM dbo.CONCEPT
			-- The list of ICD-10 codes in the Phenotype Wiki
			-- This is the list of standard concepts that represent those terms
			WHERE concept_id IN (
					3661405
					,3661406
					,3662381
					,756031
					,37311061
					,3663281
					,3661408
					,756039
					,320651
					)
			)
		-- This logic imposes the restriction: these codes were only valid as Strong Positive codes between January 1, 2020 and March 31, 2020
		AND condition_start_date BETWEEN DATEFROMPARTS(2020, 01, 01)
			AND DATEFROMPARTS(2020, 03, 31)

	UNION
	-- the one condition code that maps to an observation (3731160)
		SELECT DISTINCT visit_occurrence_id
	FROM dbo.OBSERVATION
	WHERE observation_concept_id IN (
			SELECT concept_id
			FROM dbo.CONCEPT
			-- The list of ICD-10 codes in the Phenotype Wiki
			-- This is the list of standard concepts that represent those terms
			WHERE concept_id IN (37311060)
			)
		-- This logic imposes the restriction: these codes were only valid as Strong Positive codes between January 1, 2020 and March 31, 2020
		AND observation_date BETWEEN DATEFROMPARTS(2020, 01, 01)
			AND DATEFROMPARTS(2020, 03, 31)

	UNION

	-- The CDC issued guidance on April 1, 2020 that changed COVID coding conventions
	SELECT DISTINCT visit_occurrence_id
	FROM dbo.CONDITION_OCCURRENCE
	WHERE condition_concept_id IN (
			SELECT concept_id
			FROM dbo.CONCEPT
			-- The list of ICD-10 codes in the Phenotype Wiki were translated into OMOP standard concepts
			-- This is the list of standard concepts that represent those terms
			WHERE concept_id IN (
					37311061
					,3661405
					,756031
					,756039
					,3661406
					,3662381
					,3663281
					,3661408
					)

			UNION

			SELECT c.concept_id
			FROM dbo.CONCEPT c
			JOIN dbo.CONCEPT_ANCESTOR ca ON c.concept_id = ca.descendant_concept_id
				-- Here we pull the descendants (aka terms that are more specific than the concepts selected above)
				AND ca.ancestor_concept_id IN (
					3661406
					,3661408
					,37310283
					,3662381
					,3663281
					,37310287
					,3661405
					,756031
					,37310286
					,37311061
					,37310284
					,756039
					,37310254
					)
				AND c.invalid_reason IS NULL
			)

		AND condition_start_date >= DATEFROMPARTS(2020, 04, 01)
	
	UNION

	-- the one condition code that maps to an observation (3731160)
	SELECT DISTINCT visit_occurrence_id
	FROM dbo.OBSERVATION
	WHERE observation_concept_id IN (
			SELECT concept_id
			FROM dbo.CONCEPT
			-- The list of ICD-10 codes in the Phenotype Wiki were translated into OMOP standard concepts
			-- This is the list of standard concepts that represent those terms
			WHERE concept_id IN (37311060)

			UNION

			SELECT c.concept_id
			FROM dbo.CONCEPT c
			JOIN dbo.CONCEPT_ANCESTOR ca ON c.concept_id = ca.descendant_concept_id
				-- Here we pull the descendants (aka terms that are more specific than the concepts selected above)
				AND ca.ancestor_concept_id IN (37311060)
				AND c.invalid_reason IS NULL
			)

		AND observation_date >= DATEFROMPARTS(2020, 04, 01)
	)
	,

	dx_weak
AS (
SELECT DISTINCT visit_occurrence_id
	FROM (
		SELECT visit_occurrence_id
		FROM dbo.CONDITION_OCCURRENCE
		WHERE condition_concept_id IN (
				SELECT concept_id
				FROM dbo.CONCEPT
				-- The list of ICD-10 codes in the Phenotype Wiki were translated into OMOP standard concepts
				-- It also includes the OMOP only codes that are on the Phenotype Wiki
				-- This is the list of standard concepts that represent those terms
				WHERE concept_id IN (
						260125
						,260139
						,46271075
						,4307774
						,4195694
						,257011
						,442555
						,4059022
						,4059021
						,256451
						,4059003
						,4168213
						,434490
						,439676
						,254761
						,4048098
						,37311061
						,4100065
						,320136
						,4038519
						,312437
						,4060052
						,4263848
						,37311059
						,37016200
						,4011766
						,437663
						,4141062
						,4164645
						,4047610
						,4260205
						,4185711
						,4289517
						,4140453
						,4090569
						,4109381
						,4330445
						,255848
						,4102774
						,436235
						,261326
						,436145
						,40482061
						,439857
						,254677
						,40479642
						,256722
						,4133224
						,4310964
						,4051332
						,4112521
						,4110484
						,4112015
						,4110023
						,4112359
						,4110483
						,4110485
						,254058
						,40482069
						,4256228
						,37016114
						,46273719
						,312940
						,36716978
						,37395564
						,4140438
						,46271074
						,319049
						,314971
						,320651
						)
				)
			-- This code list is only valid for CDC guidance before 04-01-2020
			AND condition_start_date >= DATEFROMPARTS(2020, 04, 01)

		-- Now we group by person_id and visit_occurrence_id to find people who have 2 or more
		GROUP BY person_id ,visit_occurrence_id
		HAVING count(distinct condition_concept_id) >= 2
	-- AFTER 04-01-2020 WEAK POSITIVE LOGIC:
	-- Here we start looking in the CONDITION_OCCCURRENCE table for visits on the same visit
	
		) dx_same_encounter

	UNION

	-- Now we apply logic to look for same visit AND same date
	SELECT DISTINCT visit_occurrence_id
	FROM (
		SELECT visit_occurrence_id
		FROM dbo.CONDITION_OCCURRENCE
		WHERE condition_concept_id IN (
				SELECT concept_id
				FROM dbo.CONCEPT
				-- The list of ICD-10 codes in the Phenotype Wiki were translated into OMOP standard concepts
				-- It also includes the OMOP only codes that are on the Phenotype Wiki
				-- This is the list of standard concepts that represent those term
				WHERE concept_id IN (
						260125
						,260139
						,46271075
						,4307774
						,4195694
						,257011
						,442555
						,4059022
						,4059021
						,256451
						,4059003
						,4168213
						,434490
						,439676
						,254761
						,4048098
						,37311061
						,4100065
						,320136
						,4038519
						,312437
						,4060052
						,4263848
						,37311059
						,37016200
						,4011766
						,437663
						,4141062
						,4164645
						,4047610
						,4260205
						,4185711
						,4289517
						,4140453
						,4090569
						,4109381
						,4330445
						,255848
						,4102774
						,436235
						,261326
						,320651
						)
				)
			-- This code list is based on CDC Guidance for code use AFTER 04-01-2020
			AND condition_start_date >= DATEFROMPARTS(2020, 04, 01)
		-- Now we group by person_id and visit_occurrence_id to find people who have 2 or more
		GROUP BY visit_occurrence_id
			,condition_start_date
		HAVING count(distinct condition_concept_id) >= 2
		) dx_same_date

),

inpat AS (
select v.person_id, v.visit_occurrence_id, visit_start_date, visit_end_date,
p.First_Pos_Date, DATEDIFF(day,p.First_Pos_Date, v.visit_start_date) "Days_From_First_Pos"
, ABS(DATEDIFF(day,p.First_Pos_Date, v.visit_start_date)) "Abs_Days_From_First_Pos"
,CASE WHEN DATEDIFF(day,p.First_Pos_Date, v.visit_start_date) < 0 THEN -1 ELSE 1 END AS Before_Or_After
,CASE WHEN dx_strong.visit_occurrence_id is not NULL THEN 1 ELSE 0 END AS dx_strong
,CASE WHEN dx_weak.visit_occurrence_id is not NULL THEN 1 ELSE 0 END AS dx_weak
  from visit_occurrence v
  join first_pos p on v.person_id = p.person_id
  left join dx_strong on v.visit_occurrence_id = dx_strong.visit_occurrence_id
  left join dx_weak on v.visit_occurrence_id = dx_weak.visit_occurrence_id
  where visit_concept_id = 9201
  and v.visit_start_date >= '2020-01-01'
  and (DATEDIFF(day,p.First_Pos_Date, v.visit_start_date) > -7 and DATEDIFF(day,p.First_Pos_Date, v.visit_start_date) < 21 )
  and (dx_strong.visit_occurrence_id is not NULL or dx_weak.visit_occurrence_id is not NULL)
),

inpat_closest_vis AS (
select person_id, min(Abs_Days_From_First_Pos) "Closest_Vis"
from inpat
group by person_id
),
--select Closest_Vis from inpat_closest_vis

inpat_first_vis AS(
--
select i.person_id, max(Before_Or_After) "Flag"
from inpat i
inner join inpat_closest_vis v on i.person_id = v.person_id AND i.Abs_Days_From_First_Pos = v.Closest_Vis
group by i.person_id
),



Vis_Occ AS (

Select distinct i.*--, c.Closest_Vis, v.Flag
from inpat i
inner join inpat_closest_vis c
	on i.person_id = c.person_id 
	and i.Abs_Days_From_First_Pos = c.Closest_Vis
inner join inpat_first_vis v 
	on i.person_id = v.person_id 
	and i.Before_Or_After = v.Flag

)

--drop table #test;

select t.* 
into #test
from Vis_Occ t;

select p.person_id , s.sourcekey as osler_id
from #test p
join stage.SourceIDMapsPerson s on s.id = p.person_id;

--Find antibody loinc code to exclude

covid_lab
AS (
	SELECT DISTINCT person_id
	FROM dbo.MEASUREMENT
	WHERE measurement_concept_id IN (
			SELECT concept_id
			FROM dbo.CONCEPT
			-- here we look for the concepts that are the LOINC codes we're looking for in the phenotype
			WHERE concept_id IN (
					586515
					,586522
					,706179
					,586521
					,723459
					,706181
					,706177
					,706176
					,706180
					,706178
					,706167
					,706157
					,706155
					,757678
					,706161
					,586520
					,706175
					,706156
					,706154
					,706168
					,715262
					,586526
					,757677
					,706163
					,715260
					,715261
					,706170
					,706158
					,706169
					,706160
					,706173
					,586519
					,586516
					,757680
					,757679
					,586517
					,757686
					,756055
					,36659631
					,36661377
					,36661378
					,36661372
					,36661373
					,36661374
					,36661370
					,36661371
					,723479
					,723474
					,757685
					,723476
					,586524
					,586525
					,586527
					,586528
					,586529
					,715272
					,723463
					,723464
					,723465
					,723466
					,723467
					,723468
					,723469
					,723470
					,723471
					,723473
					,723475
					,723477
					,723478
					,723480
					,36661369
					,36031238
					,36031213
					,36031506
					,36031197
					,36032061
					,36031944
					,36031969
					,36031956
					,36032309
					,36032174
					,36032419
					,36031652
					,36031453
					,36032258
					,36031734
					)

			UNION

			SELECT c.concept_id
			FROM dbo.CONCEPT c
			JOIN dbo.CONCEPT_ANCESTOR ca ON c.concept_id = ca.descendant_concept_id
				-- Most of the LOINC codes do not have descendants but there is one OMOP Extension code (765055) in use that has descendants which we want to pull
				-- This statement pulls the descendants of that specific code
				AND ca.ancestor_concept_id IN (756055)
				AND c.invalid_reason IS NULL
			)

		AND measurement_date >= DATEFROMPARTS(2020, 01, 01)
	)
	,
covid_cohort
AS (
	SELECT DISTINCT person_id
	FROM dx_strong

	UNION

	SELECT DISTINCT person_id
	FROM dx_weak

	UNION

	SELECT DISTINCT person_id
	FROM covid_lab
	)
	,cohort
AS (
	SELECT covid_cohort.person_id
		,CASE
			WHEN dx_strong.person_id IS NOT NULL
				THEN 1
			ELSE 0
			END AS inc_dx_strong
		,CASE
			WHEN dx_weak.person_id IS NOT NULL
				THEN 1
			ELSE 0
			END AS inc_dx_weak
		,CASE
			WHEN covid_lab.person_id IS NOT NULL
				THEN 1
			ELSE 0
			END AS inc_lab_any
		,CASE
			WHEN covid_lab_pos.person_id IS NOT NULL
				THEN 1
			ELSE 0
			END AS inc_lab_pos
	FROM covid_cohort
	LEFT OUTER JOIN dx_strong ON covid_cohort.person_id = dx_strong.person_id
	LEFT OUTER JOIN dx_weak ON covid_cohort.person_id = dx_weak.person_id
	LEFT OUTER JOIN covid_lab ON covid_cohort.person_id = covid_lab.person_id
	LEFT OUTER JOIN covid_lab_pos ON covid_cohort.person_id = covid_lab_pos.person_id
	)
INSERT INTO Results.N3C_PRE_COHORT
-- populate the pre-cohort table
SELECT DISTINCT c.person_id
	,inc_dx_strong
	,inc_dx_weak
	,inc_lab_any
	,inc_lab_pos
	,'3.3' AS phenotype_version
	,CASE
		WHEN datediff(year, d.birth_datetime, getdate()) BETWEEN 0
				AND 4
			THEN '0-4'
		WHEN datediff(year, d.birth_datetime, getdate()) BETWEEN 5
				AND 9
			THEN '5-9'
		WHEN datediff(year, d.birth_datetime, getdate()) BETWEEN 10
				AND 14
			THEN '10-14'
		WHEN datediff(year, d.birth_datetime, getdate()) BETWEEN 15
				AND 19
			THEN '15-19'
		WHEN datediff(year, d.birth_datetime, getdate()) BETWEEN 20
				AND 24
			THEN '20-24'
		WHEN datediff(year, d.birth_datetime, getdate()) BETWEEN 25
				AND 29
			THEN '25-29'
		WHEN datediff(year, d.birth_datetime, getdate()) BETWEEN 30
				AND 34
			THEN '30-34'
		WHEN datediff(year, d.birth_datetime, getdate()) BETWEEN 35
				AND 39
			THEN '35-39'
		WHEN datediff(year, d.birth_datetime, getdate()) BETWEEN 40
				AND 44
			THEN '40-44'
		WHEN datediff(year, d.birth_datetime, getdate()) BETWEEN 45
				AND 49
			THEN '45-49'
		WHEN datediff(year, d.birth_datetime, getdate()) BETWEEN 50
				AND 54
			THEN '50-54'
		WHEN datediff(year, d.birth_datetime, getdate()) BETWEEN 55
				AND 59
			THEN '55-59'
		WHEN datediff(year, d.birth_datetime, getdate()) BETWEEN 60
				AND 64
			THEN '60-64'
		WHEN datediff(year, d.birth_datetime, getdate()) BETWEEN 65
				AND 69
			THEN '65-69'
		WHEN datediff(year, d.birth_datetime, getdate()) BETWEEN 70
				AND 74
			THEN '70-74'
		WHEN datediff(year, d.birth_datetime, getdate()) BETWEEN 75
				AND 79
			THEN '75-79'
		WHEN datediff(year, d.birth_datetime, getdate()) BETWEEN 80
				AND 84
			THEN '80-84'
		WHEN datediff(year, d.birth_datetime, getdate()) BETWEEN 85
				AND 89
			THEN '85-89'
		WHEN datediff(year, d.birth_datetime, getdate()) >= 90
			THEN '90+'
		END AS pt_age
	,d.gender_concept_id AS sex
	,d.ethnicity_concept_id AS hispanic
	,d.race_concept_id AS race
	,(
		SELECT TOP 1 vocabulary_version
		FROM dbo.vocabulary
		WHERE vocabulary_id = 'None'
		) AS vocabulary_version
FROM cohort c
JOIN dbo.person d ON c.person_id = d.person_id;

--populate the case table
INSERT INTO Results.N3C_CASE_COHORT (person_id
									,pt_age
									,sex
									,hispanic
									,race )
SELECT 	person_id
		,pt_age
		,sex
		,hispanic
		,race
FROM Results.N3C_PRE_COHORT
WHERE inc_dx_strong = 1
	OR inc_lab_pos = 1
	OR inc_dx_weak = 1;




-- Now that the pre-cohort and case tables are populated, we start matching cases and controls, and updating the case and control tables as needed.
-- all cases need two control buddies. We select on progressively looser demographic criteria until every case has two control matches, or we run out of patients in the control pool.
-- First handle instances where someone who was in the control group in the prior run is now a case
-- just delete both the case and the control from the mapping table. The case will repopulate automatically with a replaced control.


-- Match #1 - age, sex, race, ethnicity







-- Match #2 - age, sex, race





-- Match #3 -- age, sex




