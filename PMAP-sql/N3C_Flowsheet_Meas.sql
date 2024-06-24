/****** Script for SelectTopNRows command from SSMS  ******/
SELECT meas_id, count(*)
  FROM [JHM_OMOP_Raw_20211203].[dbo].[derived_flowsheet_data]
  where meas_id in ('301550', '3040655312', '3040655713', '304064868') --Match these with pats in cohort (device exposure? By enc id or by date?)
  group by meas_id
  order by count(*) desc
  --missing: ('301030','3040655027','30440104359','111301030','301550','3040655312')

  