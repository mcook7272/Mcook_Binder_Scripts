SELECT 'Patients' AS Category, CAST(COUNT(*)/1000000.0 AS DECIMAL(5,2)) "Count (in millions)"
FROM person
UNION
SELECT 'Visits' AS Category, CAST(COUNT(DISTINCT visit_occurrence_id)/1000000.0 AS DECIMAL(5,2)) "Count (in millions)"
FROM VISIT_OCCURRENCE
UNION
SELECT 'Procedures' AS Category, CAST(COUNT(DISTINCT procedure_occurrence_id)/1000000.0 AS DECIMAL(5,2)) "Count (in millions)"
FROM PROCEDURE_OCCURRENCE
UNION
SELECT 'Meds' AS Category, CAST(COUNT(DISTINCT drug_exposure_id)/1000000.0 AS DECIMAL(5,2)) "Count (in millions)"
FROM DRUG_EXPOSURE
UNION
SELECT 'Conditions' AS Category, CAST(COUNT(DISTINCT condition_occurrence_id)/1000000.0 AS DECIMAL(5,2)) "Count (in millions)"
FROM CONDITION_OCCURRENCE
UNION
SELECT 'Labs' AS Category, CAST(COUNT(DISTINCT measurement_id)/1000000.0 AS DECIMAL(5,2)) "Count (in millions)"
FROM MEASUREMENT