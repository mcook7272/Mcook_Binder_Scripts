/****** Script for SelectTopNRows command from SSMS  ******/
SELECT distinct MedName, MedDisplayName, TheraClass, PharmClass, PharmSubClass
into CROWNDioverti_Scratch.dbo.Med_List
  FROM [CROWNDioverti_Projection].[dbo].[derived_med_orders]
  where MedName like '%RITUXIMAB%'