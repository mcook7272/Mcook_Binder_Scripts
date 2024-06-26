WITH TRACTS AS (
select distinct left(census_tract_x, 11) "Census_Tract"
  from COVID_Projection.dbo.edw_geocode_patient
  where state_or_province in('Maryland','District of Columbia')
)

SELECT left(p.Census_Geoid, 11) "Census_Tract", count(distinct p.Research_Patient_Key) "Number_of_Pats"
  FROM [CRISPCovid_Projection].[dbo].[Patient] p
  JOIN TRACTS t on left(p.Census_Geoid, 11) = t.census_tract
  WHERE right(p.DOB, 4) < '2003'
  group by left(p.Census_Geoid, 11)
  order by count(*) desc

 