Select distinct map.MAPPING_ID, map.CONCEPT_ID, ex.ENTITY_INI, ex.ENTITY_ITEM, ex.ENTITY_VALUE_NUM, ex.MAPPED_VALUE_NAME, smrt.ELEMENT_ID, smrt.SMRTDTA_ELEM_DESC, smrt.INTERNAL_ID, dat.CUR_VALUE_SOURCE, pat.PAT_ID, pat.PAT_NAME, val.SMRTDTA_ELEM_VALUE
from concept_mapped map
join EXTERNAL_CNCPT_MAP ex on map.MAPPING_ID = ex.MAPPING_ID
join SMRTDTA_ELEM_DESC smrt on smrt.INTERNAL_ID = ex.ENTITY_VALUE_NUM
join SMRTDTA_ELEM_DATA dat on smrt.ELEMENT_ID = dat.ELEMENT_ID
join SMRTDTA_ELEM_VALUE val on dat.HLV_ID = val.HLV_ID
join PATIENT pat on dat.PAT_LINK_ID = pat.PAT_ID
WHERE smrt.ELEMENT_ID = 'JHM#19279'
and ex.ENTITY_INI = 'HLX'
and ex.ENTITY_ITEM = '0.1';

Select top 100 *
from concept_mapped map
join EXTERNAL_CNCPT_MAP ex on map.MAPPING_ID = ex.MAPPING_ID
join SMRTDTA_ELEM_DESC smrt on smrt.INTERNAL_ID = ex.ENTITY_VALUE_NUM
where CONCEPT_ID = 'SNOMED#4002142'

select top 100 *
from EXTERNAL_CNCPT_MAP;

select top 100 *--smrt.ELEMENT_ID, smrt.CONTACT_SERIAL_NUM, smrt.PAT_LINK_ID 
from V_SMRTDTA_ELEM_VAL_ALL smrt
where HLV_ID = 454941512

select top 100 * 
from SNOMED_CONCEPT

Select top 100 *
from concept_mapped map
join EXTERNAL_CNCPT_MAP ex on map.MAPPING_ID = ex.MAPPING_ID
join SMRTDTA_ELEM_DESC smrt on smrt.INTERNAL_ID = ex.ENTITY_VALUE_NUM
where ELEMENT_ID like 'JHM#%'