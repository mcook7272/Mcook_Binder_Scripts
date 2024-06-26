
WITH mapped AS (
 SELECT DISTINCT r.concept_id_1, c1.concept_name "concept_name_1", c1.concept_code "concept_code_1",c1.vocabulary_id "vocabulary_id_1",r.relationship_id,
 r.concept_id_2, c2.concept_name "concept_name_2", c2.concept_code "concept_code_2", c2.vocabulary_id "vocabulary_id_2"
 FROM CONCEPT_RELATIONSHIP r
 INNER JOIN CONCEPT c1 on r.concept_id_1 = c1.concept_id
 INNER JOIN CONCEPT c2 on r.concept_id_2 = c2.concept_id
 WHERE concept_id_1 = 4082249 --Oxygenator Therapy
 AND relationship_id in('Maps to','Mapped from')
)

SELECT *
FROM CONCEPT_ANCESTOR a
RIGHT JOIN mapped m on a.ancestor_concept_id = m.concept_id_2