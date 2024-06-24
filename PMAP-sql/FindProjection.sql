USE [PMAP_Analytics]

select *
from project_CuratedTables
where destdbname like '%iwash%'
order by desttabname

update project_CuratedTables
set NextRun = '2024-02-07'
where destdbname like '%iwash%'
and desttabname  like '%flowsheet%'

exec usp_Execute_process

select distinct DestDBName
from project_CuratedTables

--Menez last run:
--2021-9-27
--2023-1-20
