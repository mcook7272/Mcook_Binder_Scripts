USE [JHM_OMOP_ID_Projection]

SELECT *
      FROM dbo.CONCEPT c1
	  join concept_relationship c2 on c1.concept_id = c2.concept_id_1 and c2.relationship_id = 'Mapped from'
	  join concept c3 on c3.concept_id = c2.concept_id_2
      WHERE --c1.concept_id = '262' --ER and Inpt
	  c1.concept_id IN (37311061, 3661405, 756031, 756039, 3661406, 3662381, 3663281, 3661408)
	  and c1.vocabulary_id = 'SNOMED' and c3.vocabulary_id like 'ICD10%'
