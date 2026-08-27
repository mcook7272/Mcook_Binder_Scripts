--Question 1
SELECT race, 
gender, 
COUNT(gender) as count
FROM patients
WHERE gender IN('Male','Female')
GROUP BY race, gender
ORDER BY race, gender;

--Question 2a Which age range has the most encounters?
SELECT TOP 1 CASE
WHEN DATEDIFF(YY,p.date_of_birth,e.encounter_date) -
		CASE
			WHEN DATEADD(YY,DATEDIFF(YY,p.date_of_birth,e.encounter_date),p.date_of_birth) > e.encounter_date THEN 1
			ELSE 0
		END <= 25 THEN '0-25'
WHEN DATEDIFF(YY,p.date_of_birth,e.encounter_date) -
		CASE
			WHEN DATEADD(YY,DATEDIFF(YY,p.date_of_birth,e.encounter_date),p.date_of_birth) > e.encounter_date THEN 1
			ELSE 0
		END BETWEEN 26 AND 50 THEN '26-50'
WHEN DATEDIFF(YY,p.date_of_birth,e.encounter_date) -
		CASE
			WHEN DATEADD(YY,DATEDIFF(YY,p.date_of_birth,e.encounter_date),p.date_of_birth) > e.encounter_date THEN 1
			ELSE 0
		END BETWEEN 51 AND 75 THEN '51-75'
ELSE '76+'
END as Age,
COUNT(e.enc_num) as encounter_count
FROM patients p
LEFT JOIN encounters e ON p.osler_id = e.osler_id
GROUP BY CASE
WHEN DATEDIFF(YY,p.date_of_birth,e.encounter_date) -
		CASE
			WHEN DATEADD(YY,DATEDIFF(YY,p.date_of_birth,e.encounter_date),p.date_of_birth) > e.encounter_date THEN 1
			ELSE 0
		END <= 25 THEN '0-25'
WHEN DATEDIFF(YY,p.date_of_birth,e.encounter_date) -
		CASE
			WHEN DATEADD(YY,DATEDIFF(YY,p.date_of_birth,e.encounter_date),p.date_of_birth) > e.encounter_date THEN 1
			ELSE 0
		END BETWEEN 26 AND 50 THEN '26-50'
WHEN DATEDIFF(YY,p.date_of_birth,e.encounter_date) -
		CASE
			WHEN DATEADD(YY,DATEDIFF(YY,p.date_of_birth,e.encounter_date),p.date_of_birth) > e.encounter_date THEN 1
			ELSE 0
		END BETWEEN 51 AND 75 THEN '51-75'
ELSE '76+'
END
ORDER BY encounter_count DESC;

--Question 2 Which age range using the same bins has the most patients?
SELECT TOP 1 CASE
	WHEN DATEDIFF(YY,p.date_of_birth,e.encounter_date) -
		CASE
			WHEN DATEADD(YY,DATEDIFF(YY,p.date_of_birth,e.encounter_date),p.date_of_birth) > e.encounter_date THEN 1
			ELSE 0
		END <= 25 THEN '0-25'
WHEN DATEDIFF(YY,p.date_of_birth,e.encounter_date) -
		CASE
			WHEN DATEADD(YY,DATEDIFF(YY,p.date_of_birth,e.encounter_date),p.date_of_birth) > e.encounter_date THEN 1
			ELSE 0
		END BETWEEN 26 AND 50 THEN '26-50'
WHEN DATEDIFF(YY,p.date_of_birth,e.encounter_date) -
		CASE
			WHEN DATEADD(YY,DATEDIFF(YY,p.date_of_birth,e.encounter_date),p.date_of_birth) > e.encounter_date THEN 1
			ELSE 0
		END BETWEEN 51 AND 75 THEN '51-75'
ELSE '76+'
END as Age,
COUNT(DISTINCT(p.osler_id)) as patient_count
FROM patients p
RIGHT JOIN encounters e ON p.osler_id = e.osler_id
GROUP BY CASE
	WHEN DATEDIFF(YY,p.date_of_birth,e.encounter_date) -
		CASE
			WHEN DATEADD(YY,DATEDIFF(YY,p.date_of_birth,e.encounter_date),p.date_of_birth) > e.encounter_date THEN 1
			ELSE 0
		END <= 25 THEN '0-25'
WHEN DATEDIFF(YY,p.date_of_birth,e.encounter_date) -
		CASE
			WHEN DATEADD(YY,DATEDIFF(YY,p.date_of_birth,e.encounter_date),p.date_of_birth) > e.encounter_date THEN 1
			ELSE 0
		END BETWEEN 26 AND 50 THEN '26-50'
WHEN DATEDIFF(YY,p.date_of_birth,e.encounter_date) -
		CASE
			WHEN DATEADD(YY,DATEDIFF(YY,p.date_of_birth,e.encounter_date),p.date_of_birth) > e.encounter_date THEN 1
			ELSE 0
		END BETWEEN 51 AND 75 THEN '51-75'
ELSE '76+'
END
ORDER BY patient_count DESC;

--Question 3 - Identify how many patients have any Type 2 diabetes mellitus diagnosis (symptoms) Hint: Use ICD Code (ICD10CM:E11.xx) from the symptoms table
SELECT
COUNT(DISTINCT(p.osler_id)) AS 'patient_count'
FROM patients p
INNER JOIN symptoms s ON p.osler_id=s.osler_id
WHERE s.diagnosis_code_icd10 LIKE 'E11.%';


--Question 4 - Building off the previous query, exclude patients that have a diagnosis Type 1 diabetes mellitus diagnosis (symptoms) Hint: Use ICD Code (ICD10CM:E10.xx). How many are left?
SELECT
COUNT(DISTINCT(p.osler_id)) AS 'patient_count'
FROM patients p
INNER JOIN symptoms s ON p.osler_id=s.osler_id
WHERE s.diagnosis_code_icd10 LIKE 'E11.%' 
AND s.osler_id NOT IN(
	SELECT
		DISTINCT(p2.osler_id)
	FROM patients p2
	INNER JOIN symptoms s2 ON p2.osler_id=s2.osler_id
	WHERE s2.diagnosis_code_icd10 LIKE 'E10.%'
);

--Question 5 Building off the previous query include only patients that are 18 y/0 or older( measured on 2018-01-01)
-- **You have now defined your Base Cohort, which you will use for the rest of the questions**
SELECT
COUNT(DISTINCT(p.osler_id)) AS 'patient_count'
FROM patients p
LEFT JOIN symptoms s ON p.osler_id=s.osler_id
WHERE s.diagnosis_code_icd10 LIKE 'E11.%' 
AND s.osler_id NOT IN(
	SELECT
		DISTINCT(p2.osler_id)
	FROM patients p2
	INNER JOIN symptoms s2 ON p2.osler_id=s2.osler_id
	WHERE s2.diagnosis_code_icd10 LIKE 'E10.%'
)
AND DATEDIFF(YY,p.date_of_birth,'2018-01-01') -
		CASE
			WHEN DATEADD(YY,DATEDIFF(YY,p.date_of_birth,'2018-01-01'),p.date_of_birth) > '2018-01-01' THEN 1
			ELSE 0
		END >= 18;



--Question 6 Building off the previous query, how many patients are female vs male?
SELECT 
t.gender,
COUNT(t.gender) AS gender_count
FROM (
	-- Base Cohort
	SELECT
	DISTINCT(p.osler_id), p.gender
	FROM patients p
	LEFT JOIN symptoms s ON p.osler_id=s.osler_id
	WHERE s.diagnosis_code_icd10 LIKE 'E11.%' 
	AND s.osler_id NOT IN(
		SELECT
			DISTINCT(p2.osler_id)
		FROM patients p2
		INNER JOIN symptoms s2 ON p2.osler_id=s2.osler_id
		WHERE s2.diagnosis_code_icd10 LIKE 'E10.%'
	)
	AND DATEDIFF(YY,p.date_of_birth,'2018-01-01') -
		CASE
			WHEN DATEADD(YY,DATEDIFF(YY,p.date_of_birth,'2018-01-01'),p.date_of_birth) > '2018-01-01' THEN 1
			ELSE 0
		END >= 18
) t
WHERE t.gender IN('Male','Female')
GROUP BY t.gender;

--Question 7 What is the Average Age of your base population regardless of gender?
SELECT 
FLOOR(AVG(DATEDIFF(YY,date_of_birth,'2018-01-01') -
		CASE
			WHEN DATEADD(YY,DATEDIFF(YY,date_of_birth,'2018-01-01'),date_of_birth) > '2018-01-01' THEN 1
			ELSE 0
		END)) AS [Average Age]
FROM (
--Base Cohort
	SELECT
	DISTINCT(p.osler_id),
	p.date_of_birth
	FROM patients p
	LEFT JOIN symptoms s ON p.osler_id=s.osler_id
	WHERE s.diagnosis_code_icd10 LIKE 'E11.%' 
	AND s.osler_id NOT IN(
		SELECT
			DISTINCT(p2.osler_id)
		FROM patients p2
		INNER JOIN symptoms s2 ON p2.osler_id=s2.osler_id
		WHERE s2.diagnosis_code_icd10 LIKE 'E10.%'
	)
	AND DATEDIFF(YY,p.date_of_birth,'2018-01-01') -
		CASE
			WHEN DATEADD(YY,DATEDIFF(YY,p.date_of_birth,'2018-01-01'),p.date_of_birth) > '2018-01-01' THEN 1
			ELSE 0
		END >= 18
) AS t ;

-- Temp table for patients with ICD10 E10.xx
WITH temp_e10 AS (
	SELECT
		DISTINCT(p2.osler_id)
	FROM patients p2
	INNER JOIN symptoms s2 ON p2.osler_id=s2.osler_id
	WHERE s2.diagnosis_code_icd10 LIKE 'E10.%'
)
--Question 8 Find out how many patients from the existing cohort
SELECT Diagnosis,
	COUNT(osler_id) AS patient_count,
	COUNT(osler_id) *100.0 / SUM(COUNT(osler_id)) OVER () AS Prcnt
FROM (
	SELECT DISTINCT(p.osler_id), 
	CASE
		WHEN s.diagnosis_code_icd10 = 'E66.2' THEN 'Morbid(severe) obesity with alveolar hypoventilation (ICD10CM:E66.2)'
		WHEN s.diagnosis_code_icd10 = 'E66.9' THEN 'Obesity unspecified (ICD10CM:E66.9)'
		WHEN s.diagnosis_code_icd10 IN('E66.01','E66.02','E66.03','E66.04','E66.05','E66.06','E66.07','E66.08','E66.09') THEN 'Obesity due to excess calories (ICD10CM:E66.01-E66.09)'
		WHEN s.diagnosis_code_icd10 = 'E66.8' THEN 'Other Obesity'
		ELSE 'Type 2 diabetes mellitus diagnosis (ICD10CM:E11.xx)'
	END AS Diagnosis
	FROM patients p
	LEFT JOIN symptoms s ON p.osler_id=s.osler_id
	WHERE (s.diagnosis_code_icd10 LIKE 'E11.%' 
	OR  s.diagnosis_code_icd10 IN('E66.2','E66.9','E66.01','E66.02','E66.03','E66.04','E66.05','E66.06','E66.07','E66.08','E66.09','E66.8'))
	AND s.osler_id NOT IN(SELECT osler_id FROM temp_e10)
	AND DATEDIFF(YY,p.date_of_birth,'2018-01-01') -
		CASE
			WHEN DATEADD(YY,DATEDIFF(YY,p.date_of_birth,'2018-01-01'),p.date_of_birth) > '2018-01-01' THEN 1
			ELSE 0
		END >= 18
) AS q8
GROUP BY Diagnosis;

--Question 9
-- Temp table for patients with ICD10 E10.xx
WITH temp_q9 AS (
	SELECT
		DISTINCT(p2.osler_id)
	FROM patients p2
	INNER JOIN symptoms s2 ON p2.osler_id=s2.osler_id
	WHERE s2.diagnosis_code_icd10 LIKE 'E10.%'
	
)
SELECT 
	diagnosis,
	COUNT(diagnosis) AS diagnosis_count  
FROM (
	SELECT 
		CASE 
		WHEN diagnosis_code_icd10 LIKE 'I6_.%' THEN 'Cerebrovascular diseases (I60-I69)'
		WHEN diagnosis_code_icd10 LIKE 'I2[0-5].%' THEN 'Ischemic Heart Diseases (I20-I25)'
		WHEN diagnosis_code_icd10 LIKE 'I50.[1-9]' THEN 'Heart Failure (I50.1-I50.9)'
		ELSE 'Atherosclerosis (I70.0-I70.92)'
		END AS diagnosis
	FROM (
		SELECT
			DISTINCT(p.osler_id),
			s.diagnosis_code_icd10
		FROM patients p
		LEFT JOIN symptoms s ON p.osler_id=s.osler_id
		WHERE (s.diagnosis_code_icd10 LIKE 'I6_.%' 
		OR s.diagnosis_code_icd10 LIKE 'I2[0-5].%'
		OR s.diagnosis_code_icd10 LIKE 'I50.[1-9]'
		OR (s.diagnosis_code_icd10 LIKE 'I70.[0-9]' OR diagnosis_code_icd10 LIKE 'I70._[0-9]')
		)
		AND s.osler_id NOT IN(SELECT osler_id FROM temp_q9)
		AND DATEDIFF(YY,p.date_of_birth,'2018-01-01') -
		CASE
			WHEN DATEADD(YY,DATEDIFF(YY,p.date_of_birth,'2018-01-01'),p.date_of_birth) > '2018-01-01' THEN 1
			ELSE 0
		END >= 18
	) AS t1
) AS q9
GROUP BY diagnosis;


--Question 10
-- 10. What is the percent of patients with the diseases in Question 9 compared to the base cohort?

SELECT ((
       CAST(SUM(heart_failure) AS float) +
	   CAST(SUM(cerebrovascular_disease) AS float) +
	   CAST(SUM(ischemic_heart_disease) AS float) +
	   CAST(SUM(athersclerosis) AS float)) / CAST(COUNT(dc.osler_id) AS float)) * 100.00 as "Percent to Base" 
FROM(
	SELECT
	dt.osler_id,
	CASE WHEN SUM(CASE WHEN diagnosis_code_icd10 LIKE 'I6[0-9].%' THEN 1 ELSE 0 END) > 0 THEN 1 ELSE 0 
	END as cerebrovascular_disease,
	CASE WHEN SUM(CASE WHEN diagnosis_code_icd10 LIKE 'I2[0-5].%' THEN 1 ELSE 0 END) > 0 THEN 1 ELSE 0 
	END as ischemic_heart_disease,
	CASE WHEN SUM(CASE WHEN diagnosis_code_icd10 LIKE 'I50.[1-9]%' THEN 1 ELSE 0 END) > 0 THEN 1 ELSE 0 
	END as heart_failure,
	CASE WHEN SUM(CASE WHEN diagnosis_code_icd10 LIKE 'I70.[0-9]%' THEN 1 ELSE 0 END) > 0 THEN 1 ELSE 0 
	END as athersclerosis
	FROM (
		SELECT *, FLOOR(DATEDIFF(day, dbo.patients.date_of_birth, '2018-01-01') / 365.2425) as age
		FROM dbo.patients
		WHERE FLOOR(DATEDIFF(day, dbo.patients.date_of_birth, '2018-01-01') / 365.2425) > 17
		) as dt
	INNER JOIN
		(
			SELECT *
			FROM dbo.symptoms
			WHERE dbo.symptoms.osler_id in
			(
				SELECT dbo.symptoms.osler_id
				FROM dbo.symptoms
				GROUP BY dbo.symptoms.osler_id
				HAVING SUM(CASE WHEN diagnosis_code_icd10 LIKE 'E11.%' THEN 1 ELSE 0 END) > 0
					  AND SUM(CASE WHEN diagnosis_code_icd10 LIKE 'E10.%' THEN 1 ELSE 0 END) = 0
			) 
		) AS dt2
	ON dt.osler_id=dt2.osler_id
	GROUP BY dt.osler_id) as dc;
