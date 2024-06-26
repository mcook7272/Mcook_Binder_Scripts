/****** Script for SelectTopNRows command from SSMS  ******/

USE [CROWNSwenor_Projection];

WITH Cov_Test AS (
select osler_id,component_base_name, specimen_taken_time
from CROWNSwenor_Projection.dbo.derived_lab_results
where component_base_name in ('COVID19BAL',
    'COVID19ET',
    'COVID19EX',
    'COVID19N',
    'COVID19SPT',
    'COVIDNATNP',
    'COVIDPRELIM')
	AND result_flag = 'Abnormal'

)

SELECT pos.osler_id, pos.initial_dx_date,pos.positive_result_date, pos.positive_collection_date, 
  lab.specimen_taken_time, lab.component_base_name, 
  DATEDIFF(HH, pos.positive_collection_date, lab.specimen_taken_time) "Date_Diff"
  FROM CROWNSwenor_Projection.[dbo].[covid_pmcoe_covid_positive] pos
  join Cov_Test lab on pos.osler_id = lab.osler_id
  where positive_collection_date is not NULL
  and initial_dx_source = 'LAB'
  order by pos.osler_id, DATEDIFF(HH, pos.positive_collection_date, lab.specimen_taken_time) desc

  derived_lab_results
  where osler_id = '004fbcd0-934a-4e94-b3a2-bc89ff7dc90e'
  and specimen_taken_time between '2021-05-25' and '2021-05-27'
  order by specimen_taken_time

  COVID_Projection.dbo.derived_epic_patient
  where osler_id = '004fbcd0-934a-4e94-b3a2-bc89ff7dc90e'

  COVID_Projection.dbo.derived_lab_results
  where component_base_name like 'EXTCOVID'
  and osler_id = '004fbcd0-934a-4e94-b3a2-bc89ff7dc90e'