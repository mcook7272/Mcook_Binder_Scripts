USE [CAMP_DM_Projection]

/* 

Database Querying in Health Final Project 

Michael Cook

Server Name: esmpmdbpr4
 DB Name: CAMP_DM_Projection

 Complex Query Checklist - Inspect each step
	-	Visualize the question. Use the ERD 
	-	Identify the minimal fields and tables needed for query
	-	Identify filters
	-	Determine joining key
	-		Do counts on both tables before join and after join
	-	Determine what is the level of aggregation for the question. 
	-		Is this per patient 
	-		per patient-encounter
	-		patient-encounter-measurement
	-	Add calculations, groupers on fields

Inspect each step

Inspect the data using Select top 10 of * from the join of these tables
	Inspect counts at each step
Try to make it easy to read
	Use comments
	
Use indentations
	Use capitalization
	Use aliases
*/
/* 1. How many patients have Type I or Type II diabetes 
  Hint: Use ICD10 Code
*/
SELECT count(DISTINCT osler_id) "Q1_Count"
FROM symptoms
WHERE left(diagnosis_code_icd10, 3) IN ('E10', 'E11');

/* 2. How many patients have an A1C > 6.5 and have Type II ICD10 */
SELECT count(DISTINCT l.osler_id) "Q2_Count"
FROM labs l
INNER JOIN symptoms s ON l.osler_id = s.osler_id
WHERE (
      l.base_name LIKE '%a1c%'
      AND l.result > 6.5
      )
   AND left(s.diagnosis_code_icd10, 3) = 'E11'; --type 2

/* 
3. How many Type 1 diabetics have an Rx for insulin? 
Hint: Use ICD10 Code and Pharmacutical Class
*/
SELECT count(DISTINCT m.osler_id) "Q3_Count"
FROM meds m
INNER JOIN symptoms s ON m.osler_id = s.osler_id
WHERE m.pharmaceutical_class LIKE '%insulin%'
   AND left(s.diagnosis_code_icd10, 3) = 'E10'; --type 1

/* 
4. How many patients with Type 2 Diabetes are taking metformin? 
Hint: Use ICD10 Code and Medication names of

*/

SELECT count(DISTINCT m.osler_id) "Q4_Count"
FROM meds m
INNER JOIN symptoms s ON m.osler_id = s.osler_id
WHERE m.medication_name LIKE '%metformin%'
   AND left(s.diagnosis_code_icd10, 3) = 'E11'; --type 2

/* 
5. How many patients with high blood pressure (one reading over 140 systolic or 90 diastolic) have a hypertension dx (I10)? 
Hint: Use symptoms table and diagnosis Code, watch Clinical Correlation 2 video for more insights
Hypertension is I10
*/
SELECT count(DISTINCT v.osler_id) "Q5_Count"
FROM vitals_bp v
INNER JOIN symptoms s ON v.enc_num = s.enc_num
WHERE (
      PARSENAME(REPLACE(bp_systolic_diastolic, '/', '.'), 2) > 140
      OR PARSENAME(REPLACE(bp_systolic_diastolic, '/', '.'), 1) > 90
      )
   AND left(s.diagnosis_code_icd10, 3) = 'I10'; --Hypertension

/* 
6. List top 5 medications by number of patients for patients with hypertension? 
   Sort results with highest to lowest patient counts.
Hint: Use symptoms and meds tables; watch Clinical Correlation 2 video for more insights
*/

WITH dx AS (
      SELECT DISTINCT osler_id
      FROM symptoms
      WHERE left(diagnosis_code_icd10, 3) = 'I10' --Hypertension
      )

SELECT TOP 5 medication_name, count(DISTINCT m.osler_id) AS Q6_pt_cnt
FROM meds m
INNER JOIN dx ON m.osler_id = dx.osler_id
GROUP BY medication_name
ORDER BY Q6_pt_cnt DESC;
/*
7.	How many patients are compliant/non-compliant with their Glycemic Targets? 
Hint: A1C < 7.2 is Compliant and A1C > 7.2 = Non-Compliant; A1C measured at least twice?
*/

WITH A1C_twice AS (
      SELECT osler_id, count(DISTINCT enc_num) "Total_Count"
      FROM labs
      WHERE base_name LIKE '%a1c%'
         AND result IS NOT NULL
      GROUP BY osler_id
      HAVING count(DISTINCT enc_num) >= 2
      )

SELECT 'Compliant_Count' AS A1c_Compliance, count(DISTINCT l.osler_id) AS Q7_Count
FROM labs l
INNER JOIN A1C_twice a ON l.osler_id = a.osler_id
WHERE l.base_name LIKE '%a1c%'
   AND l.result <= 7.2
   AND l.result IS NOT NULL
UNION
SELECT 'Non-Compliant_Count', count(DISTINCT l.osler_id)
FROM labs l
INNER JOIN A1C_twice a ON l.osler_id = a.osler_id
WHERE l.base_name LIKE '%a1c%'
   AND l.result > 7.2
   AND l.result IS NOT NULL;
/* 
8. How many patients went from normal to to diabetic via A1C 
Hint: A1C of 7.2 or lower is considered normal 
*/

WITH norm AS (
      SELECT *
      FROM labs
      WHERE base_name LIKE '%a1c%'
         AND result IS NOT NULL
		 AND result <= 7.2
      )

SELECT count(distinct l.osler_id) as Q8_Count
FROM labs l
INNER JOIN norm n ON l.osler_id = n.osler_id
WHERE l.base_name LIKE '%a1c%'
   AND l.result > 7.2
   AND l.order_date > n.order_date;

/*
9. What percentage of patients are at risk of Type 2 Diabetes without being diagnosed?
Hint: Use CTE's to calculate Median Height and Weight
Hint: At Risk for Diabetes should be considered as 1) pre-diabetes or 2) BMI ≥ 30 (Obesity Classification)
*/

WITH height AS (
      SELECT DISTINCT osler_id
         ,(
            PERCENTILE_CONT(0.5) WITHIN GROUP (
                  ORDER BY height
                  ) OVER (PARTITION BY osler_id)
            ) * 0.0254 AS median_height
      FROM vitals_height
      )
   ,weight AS (
      SELECT DISTINCT osler_id
         ,PERCENTILE_CONT(0.5) WITHIN GROUP (
            ORDER BY weight
            ) OVER (PARTITION BY osler_id) AS median_weight
      FROM vitals_weight
      )
   ,bmi AS (
      SELECT DISTINCT h.osler_id
         ,median_height
         ,median_weight
         ,(median_weight / (median_height * median_height)) AS bmi
      FROM height h
      INNER JOIN weight w ON h.osler_id = w.osler_id
      )

SELECT count(DISTINCT l.osler_id) AS Q9_Count
FROM labs l
INNER JOIN bmi ON l.osler_id = bmi.osler_id
WHERE (
      l.base_name LIKE '%a1c%'
      AND l.result BETWEEN 5.7
         AND 6.4
      ) --prediabetic
   AND bmi.bmi >= 30 --bmi
   AND bmi.osler_id not in (SELECT osler_id FROM symptoms WHERE LEFT(diagnosis_code_icd10, 4) = 'E11.'); --Not diagnosed w/ type 2 diabetes

   /*
10. Fill in the following:
So Few Workers Get Home On time
*/