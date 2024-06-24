select distinct pos.pos_id, pos.pos_name, pos.zip
--loc.loc_id, loc.LOC_NAME,loc.ADT_PARENT_ID,HOSP_PARENT_LOC_ID
--into ANALYTICS.dbo.CCDA1067_Care_Site_Map
from clarity_pos pos
join clarity_loc loc on pos.pos_id = loc.loc_id
where ISNULL(pos.SERVICE_AREA_ID, 11) = 11
--AND LOC_TYPE_C = 3
--ADT_PARENT_ID vs HOSP_PARENT_LOC_ID
--JHM_OMOP_TriNetX on ACT
--Add mapping table after

drop table if exists ANALYTICS.dbo.CCDA1067_Care_Site_Map;

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT DISTINCT
      c.care_site_id
	  ,c.care_site_name
	  ,c.care_site_source_value
      ,[zip]
  into [PMAP_Analytics].[dbo].[CCDA1067_Care_Site_Map_complete]
  FROM JHM_OMOP_Projection.dbo.care_site c
  left join [PMAP_Analytics].[dbo].[CCDA1067_Care_Site_Map] map on map.pos_id = c.care_site_source_value
  order by care_site_id


  select * from
  [PMAP_Analytics].[dbo].[CCDA_1067_Care_Site_Map]