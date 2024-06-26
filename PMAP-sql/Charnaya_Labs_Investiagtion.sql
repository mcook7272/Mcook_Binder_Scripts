/****** Script for SelectTopNRows command from SSMS  ******/
SELECT distinct  component_base_name
  FROM [COVID_Projection].[dbo].[derived_lab_results]
  where component_name like '%covid%'
  or component_base_name like '%covid%'
  order by component_base_name
except
  select distinct  component_base_name
  FROM [COVID_Projection].[dbo].[derived_lab_results] lab
  inner join COVID_Projection..covid_pmcoe_covid_positive pos on pos.osler_id = lab.osler_id
  where component_name like '%covid%'
  or component_base_name like '%covid%'
  order by component_base_name

  SELECT distinct  component_base_name
  FROM [COVID_Projection].[dbo].[derived_lab_results]
  where component_base_name like '%covid%'
  and component_base_name not in (select distinct  component_base_name
  FROM [COVID_Projection].[dbo].[derived_lab_results] lab
  inner join COVID_Projection..covid_pmcoe_covid_positive pos on pos.osler_id = lab.osler_id
  where component_name like '%covid%'
  or component_base_name like '%covid%')
  union all
  select distinct component_base_name
  from [COVID_Projection].[dbo].[derived_lab_results] lab
  inner join covid_projection..derived_inpatient_encounters enc on enc.osler_id = lab.osler_id
  where department_id like '1108%'
  and (component_name like '%covid%'
  or component_base_name like '%covid%')

  select distinct component_base_name
  from [COVID_Projection].[dbo].[derived_lab_results] lab
  inner join covid_projection..derived_inpatient_encounters enc on enc.osler_id = lab.osler_id
  where department_id like '1108%'
  and (component_name like '%covid%'
  or component_base_name like '%covid%')
  and component_base_name not in (SELECT distinct  component_base_name
  FROM [COVID_Projection].[dbo].[derived_lab_results]
  where component_base_name like '%covid%'
  and component_base_name not in (select distinct  component_base_name
  FROM [COVID_Projection].[dbo].[derived_lab_results] lab
  inner join COVID_Projection..covid_pmcoe_covid_positive pos on pos.osler_id = lab.osler_id
  where component_name like '%covid%'
  or component_base_name like '%covid%'))
  order by component_base_name