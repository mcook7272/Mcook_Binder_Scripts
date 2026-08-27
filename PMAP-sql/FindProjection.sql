USE [PMAP_Analytics]

select *
from project_CuratedTables
where destdbname like '%pand%'
order by desttabname

update project_CuratedTables
set NextRun = '2025-03-18'
where destdbname like '%pand%'
and desttabname  like '%flowsheet%'

exec usp_Execute_process

select distinct DestDBName
from project_CuratedTables

--Menez last run:
--2021-9-27
--2023-1-20
