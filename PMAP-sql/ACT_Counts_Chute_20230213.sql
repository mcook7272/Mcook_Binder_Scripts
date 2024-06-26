/****** Script for SelectTopNRows command from SSMS  ******/
SELECT sex_cd, case when age_in_years_num < 18 THEN '< 18' ELSE 'Adult' END AS age_cat,count(distinct patient_num)
  FROM [ACTProdData].[dbo].[PATIENT_DIMENSION]
  group by sex_cd, case when age_in_years_num < 18 THEN '< 18' ELSE 'Adult' END

  select count(distinct patient_num)
  FROM [ACTProdData].[dbo].[PATIENT_DIMENSION]