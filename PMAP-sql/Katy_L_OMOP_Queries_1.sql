SELECT
measurement_type_concept_id,
CASE WHEN provider_id IS NOT NULL Then 'Y' ELSE 'N' END AS has_provider,
CASE WHEN visit_occurrence_id IS NOT NULL Then 'Y' ELSE 'N' END AS has_visit,
COUNT(*) AS measurement_count
FROM measurement
GROUP BY measurement_type_concept_id,CASE WHEN provider_id IS NOT NULL Then 'Y' ELSE 'N' END,CASE WHEN visit_occurrence_id IS NOT NULL Then 'Y' ELSE 'N' END;

SELECT
procedure_type_concept_id,
CASE WHEN provider_id IS NOT NULL Then 'Y' ELSE 'N' END AS has_provider,
CASE WHEN visit_occurrence_id IS NOT NULL Then 'Y' ELSE 'N' END AS has_visit,
COUNT(*) as procedure_count
FROM procedure_occurrence
GROUP BY procedure_type_concept_id,
CASE WHEN provider_id IS NOT NULL Then 'Y' ELSE 'N' END,
CASE WHEN visit_occurrence_id IS NOT NULL Then 'Y' ELSE 'N' END;

SELECT
drug_type_concept_id,
CASE WHEN provider_id IS NOT NULL Then 'Y' ELSE 'N' END AS has_provider,
CASE WHEN visit_occurrence_id IS NOT NULL Then 'Y' ELSE 'N' END AS has_visit,
COUNT(*) as drug_count
FROM drug_exposure
GROUP BY drug_type_concept_id,
CASE WHEN provider_id IS NOT NULL Then 'Y' ELSE 'N' END,
CASE WHEN visit_occurrence_id IS NOT NULL Then 'Y' ELSE 'N' END;

SELECT
device_type_concept_id,
CASE WHEN provider_id IS NOT NULL Then 'Y' ELSE 'N' END AS has_provider,
CASE WHEN visit_occurrence_id IS NOT NULL Then 'Y' ELSE 'N' END AS has_visit,
COUNT(*) as device_count
FROM device_exposure
GROUP BY device_type_concept_id,
CASE WHEN provider_id IS NOT NULL Then 'Y' ELSE 'N' END,
CASE WHEN visit_occurrence_id IS NOT NULL Then 'Y' ELSE 'N' END;