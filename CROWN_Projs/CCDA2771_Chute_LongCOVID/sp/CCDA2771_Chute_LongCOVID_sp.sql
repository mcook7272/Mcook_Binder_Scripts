/****** Script for SelectTopNRows command from SSMS  ******/
SELECT distinct
	 pat.emrn
	,pat.pat_name
	,pat.birth_date
    ,[department_name]
    ,[dept_specialty]
	,contact_date
	,appt_visit_type
	,visit_provider   
  FROM [COVID_Projection].[dbo].[derived_outpatient_encounters] enc
  inner join COVID_Projection.dbo.derived_epic_patient pat on enc.osler_id = pat.osler_id
  where 
  --department_id in ('113000550','110203550','110202462') 
  (department_id = '113000550'and appt_visit_type = 'VIDEO RETURN - PACT') --or video return and tag like %pact%
  OR (department_id = '110203550' AND appt_visit_type like 'FOLLOW UP%' AND DATENAME(WEEKDAY, enc.contact_date) = 'Tuesday') 
  OR (department_id = '110202462' AND appt_visit_type = 'VIDEO RETURN - PACT')
  order by pat.emrn, department_name, appt_visit_type, visit_provider



