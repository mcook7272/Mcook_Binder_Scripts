USE [JHM_OMOP_NoId];

DROP TABLE IF EXISTS #COH;

SELECT TOP 10 person_id
INTO #COH
FROM PERSON;

SELECT p.person_id, gender_concept_id, birth_datetime, race_concept_id, ethnicity_concept_id
FROM person p
INNER JOIN #COH ON p.person_id = #COH.person_id;

SELECT condition_occurrence_id, c.person_id, condition_concept_id, condition_start_date, 
   condition_end_date, condition_type_concept_id, condition_status_concept_id
FROM condition_occurrence c
INNER JOIN #COH ON c.person_id = #COH.person_id;

SELECT drug_exposure_id, d.person_id, drug_concept_id, drug_exposure_start_date, drug_exposure_end_date, 
   drug_type_concept_id
FROM Drug_Exposure d
INNER JOIN #COH ON d.person_id = #COH.person_id;

SELECT visit_occurrence_id, v.person_id, v.visit_concept_id, v.visit_start_datetime, v.visit_end_datetime, 
   v.visit_type_concept_id
FROM VISIT_OCCURRENCE v
INNER JOIN #COH ON v.person_id = #COH.person_id;

SELECT m.measurement_id, m.person_id, m.measurement_concept_id, m.measurement_datetime, m.
   measurement_type_concept_id, m.value_as_number, m.value_as_concept_id, m.unit_concept_id
FROM measurement m
INNER JOIN #COH ON m.person_id = #COH.person_id
WHERE m.measurement_concept_id IN (
      '3027018', '40762499', '3024171', '3004249', '3012888', '3020891', '4353936', '4141684', '21492241', 
      '3000963', '3019550', '3016723', '3006906', '3004501', '3018311', '3024929', '3023314', '3020416', 
      '3023599', '3012030'
      );--Top 20 measurements