-- if specialty_source_value is a coding system that exists in OMOP, 
-- please join to concept on concept_code and show the concept_name
SELECT
specialty_source_value,
CASE WHEN visit_occurrence_id IS NOT NULL THEN 'Y' ELSE 'N' END AS has_visit,
COUNT(*) AS provider_specialty_count
FROM provider 
LEFT JOIN visit_occurrence ON visit_occurrence.provider_id = provider.provider_id
GROUP BY specialty_source_value,
CASE WHEN visit_occurrence_id IS NOT NULL THEN 'Y' ELSE 'N' END
ORDER by specialty_source_value;

SELECT
care_site_id,
place_of_service_concept_id,
COUNT(*) AS place_of_service_count
FROM care_site 
JOIN provider ON care_site.care_site_id = provider.care_site_id
GROUP BY place_of_service_source_value,
place_of_service_concept_id;

SELECT
place_of_service_source_value,
place_of_service_concept_id,
concept_name,
COUNT(*) 
FROM care_site 
LEFT JOIN concept ON concept.concept_id = care_site.place_of_service_concept_id
GROUP BY place_of_service_source_value,
place_of_service_concept_id,
concept_name;