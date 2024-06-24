/*
Michael Cook
Database Querying in Health Midterm
*/
USE [CAMP_DM_Projection]

--Q1: Identify how many patients have any Type 2 diabetes mellitus diagnosis 
--(symptoms) (ICD10CM:E11.xx)
SELECT count(DISTINCT osler_id) "Q1_Count"
FROM symptoms
WHERE LEFT(diagnosis_code_icd10, 4) = 'E11.'

--A:53557

--Q2: Building off the previous query exclude patients that have a diagnosis Type 1
--diabetes, mellitus diagnosis (ICD10CM:E10.00-E10.9. How many are left?)
SELECT count(DISTINCT osler_id) "Q2_Count"
FROM symptoms
WHERE LEFT(diagnosis_code_icd10, 4) = 'E11.'
   AND osler_id NOT IN (
      SELECT DISTINCT osler_id
      FROM symptoms
      WHERE LEFT(diagnosis_code_icd10, 4) = 'E10.'
      )

--A:51,450

--Q3: Building off the previous query include only patients that are 18 y/o or older
--(measured on 2018-01-01)?
SELECT count(DISTINCT sym.osler_id) "Q3_Count"
FROM symptoms sym
INNER JOIN patients p ON sym.osler_id = p.osler_id
WHERE LEFT(diagnosis_code_icd10, 4) = 'E11.'
   AND sym.osler_id NOT IN (
      SELECT DISTINCT osler_id
      FROM symptoms
      WHERE LEFT(diagnosis_code_icd10, 4) = 'E10.'
      )
   AND DATEDIFF(year, date_of_birth, '2018-01-01') >= 18

--A:50,948

--Note: This will be your base cohort size.
--Save cohort for later:
DROP TABLE IF EXISTS #coh;

   SELECT DISTINCT sym.osler_id
   INTO #coh
   FROM symptoms sym
   INNER JOIN patients p ON sym.osler_id = p.osler_id
   WHERE LEFT(diagnosis_code_icd10, 4) = 'E11.'
      AND sym.osler_id NOT IN (
         SELECT DISTINCT osler_id
         FROM symptoms
         WHERE LEFT(diagnosis_code_icd10, 4) = 'E10.'
         )
      AND DATEDIFF(year, date_of_birth, '2018-01-01') >= 18

--Q4 Then, find how many patients are female vs male (hint: do the query with one 
--and then
--the other)
SELECT 'Female_Count', count(DISTINCT p.osler_id) "Count"
FROM patients p
INNER JOIN #coh ON p.osler_id = #coh.osler_id
WHERE p.gender = 'Female'

UNION

SELECT 'Male_Count', count(DISTINCT p.osler_id) "Count"
FROM patients p
INNER JOIN #coh ON p.osler_id = #coh.osler_id
WHERE p.gender = 'Male'

--A: F-25744,M-25202
--Q5: What is the Average Age of your base population regardless of gender?
SELECT AVG(DATEDIFF(year, date_of_birth, '2018-01-01')) "Q5_Avg_Age"
FROM patients p
INNER JOIN #coh ON p.osler_id = #coh.osler_id

--A:63
/*
--Q6: Find out how many patients from the existing cohort regardless of gender who 
also have a diagnosis of: Morbid(severe) obesity with alveolar hypoventilation 
(ICD10CM:E66.2) or Obesity unspecified (ICD10CM:E66.9) or Obesity due to excess 
calories (ICD10CM:E66.01-E66.09) or Other Obesity (ICD10CM:E66.8) 
--What is the percent of patients with obesity compared to the base cohort?
*/
SELECT count(DISTINCT symptoms.osler_id) "Q6_Count"
FROM symptoms
INNER JOIN #coh ON symptoms.osler_id = #coh.osler_id
WHERE diagnosis_code_icd10 = 'E66.2'
   OR diagnosis_code_icd10 LIKE 'E66.[8-9]'
   OR diagnosis_code_icd10 LIKE 'E66.0[1-9]'

--A: 10953 (21.5%)

--Q7: From the main cohort in Q3,  how many patients have a diagnosis of: Cerebral 
--Infarction (ICD10CM:I63.00-I63.9) 
--What is the percent of patients with Stroke compared to the base cohort?
SELECT count(DISTINCT symptoms.osler_id) "Q7_Count"
FROM symptoms
INNER JOIN #coh ON symptoms.osler_id = #coh.osler_id
WHERE diagnosis_code_icd10 LIKE 'I63.[0-9]%'

--A: 1425(2.8%)

--Q8: Find out how many patients have a diagnosis of: Cerebrovascular diseases(I60-I69)
--(ICD10CM:I60.00-I69.998) or Ischemic Heart Diseases (I20-I25) (ICD10CM:I20.0-I25.9) or
--Heart Failure (ICD10CM:I50.1-I50.9) or Atherosclerosis (ICD10CM:I70.0-I70.92).  
--Compare to the base cohort.
SELECT count(DISTINCT symptoms.osler_id) "Q8_Count"
FROM symptoms
INNER JOIN #coh ON symptoms.osler_id = #coh.osler_id
WHERE diagnosis_code_icd10 BETWEEN 'I60.00'
      AND 'I69.998'
   OR diagnosis_code_icd10 LIKE 'I2[0-5]%'
   OR diagnosis_code_icd10 LIKE 'I50.[1-9]%'
   OR diagnosis_code_icd10 BETWEEN 'I70.0'
      AND 'I70.92'
         --A: 11141