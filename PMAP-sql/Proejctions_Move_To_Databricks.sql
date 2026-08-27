SELECT distinct projection_name, destination_server_name, destination_database_name, lastupdate_dttm--, create_dttm
  FROM [PMAP_ELT_Config_int].[dbo].[vw_v2Proj]
  where active = 1 AND destination_server_name = 'Databricks' AND lastupdate_dttm >= '2026-01-01' AND create_dttm < '2025-10-10'
  order by lastupdate_dttm desc, projection_name
