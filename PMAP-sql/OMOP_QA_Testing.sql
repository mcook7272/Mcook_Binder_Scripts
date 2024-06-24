Select gender_concept_id, race_concept_id, ethnicity_concept_id, gender_source_concept_id, 
race_source_concept_id, ethnicity_source_concept_id, count(*) as acount
from person
Group by gender_concept_id, race_concept_id, ethnicity_concept_id, gender_source_concept_id, 
race_source_concept_id, ethnicity_source_concept_id
--55 rows

And
Individual queries for

Select gender_concept_id, race_concept_id, ethnicity_concept_id, gender_source_concept_id, 
race_source_concept_id, ethnicity_source_concept_id, count(*) as acount
from person
Group by gender_concept_id, race_concept_id, ethnicity_concept_id, gender_source_concept_id, 
race_source_concept_id, ethnicity_source_concept_id
--55 rows

select p.[location_id] from person p
left join location l on l.location_id = p.location_id
where l.location_id is null
--1014 rows
--reason - JHM_OMOP_raw_20210909.edw_geolocation_person was not generated on the same day as the person record

select p.[provider_id] from person p
left join provider l on l.[provider_id] = p.[provider_id]
where l.[provider_id] is null
--210806 rows

select p.[provider_id] from person p
left join provider l on l.[provider_id] = p.[provider_id]
where l.[provider_id] is null and l.provider_id !=0
--null zero rows

select p.[care_site_id] from person p
left join care_site l on l.[care_site_id] = p.[care_site_id]
where l.[care_site_id] is null   
--null rows 

--And then you SPOT CHECK (Me)

SELECT TOP (1000) [person_id]
      ,[year_of_birth]
      ,[month_of_birth]
      ,[day_of_birth]
      ,[birth_datetime]
      ,[person_source_value]
      ,[gender_source_value]
      ,[race_source_value]
      ,[ethnicity_source_value]
     FROM [JHM_OMOP_20210909].[dbo].[person]

