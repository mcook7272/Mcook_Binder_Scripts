/****** Script for SelectTopNRows command from SSMS  ******/

SELECT TOP (1000) [tableName]
      ,[projectionName]
      ,[cohortName]
      ,[cohortIDType]
      ,[sourceTable]
      ,[startDt]
      ,[endDt]
      ,[rowsProjected]
      ,[status]
  FROM PancreasGI_Projection.[dbo].[projection_status]
  order by endDt desc