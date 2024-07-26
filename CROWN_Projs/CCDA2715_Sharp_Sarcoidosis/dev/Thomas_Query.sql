-- Sarcoidosis SmartForm metadata (3381 and 3354)

/* SDE Data Catalog
-- Tab 1: SDE Forms, elements, and categories

select distinct con.concept_id, 
con.name as SDEName, 
con.PARENT_CONCEPT,
zc.name as DataType, 
con.CONCEPT_TYPE_C,
cat.CATEGORIES, 
cat.CATEGORY_NUMBER, 
cat.line,
con.internal_id
--con.MASTER_FILE_ITEM,
--con.MASTER_FILE_LINK,
--con.CONCEPT_HIERARCHY,
--frm.form_id,
--frm.line

from clarity_concept con
inner join ZC_DATA_TYPE zc
on con.DATA_TYPE_C = zc.DATA_TYPE_C

inner join smartform_concept frm
on frm.CONCEPT_ID = con.CONCEPT_ID

left join CONCEPT_CATEGORY cat
on con.CONCEPT_ID = cat.CONCEPT_ID

where frm.form_id = '3354'
order by con.concept_id, cat.CATEGORY_NUMBER


/* Tab 2: SmartGrid relationships
Shows only SDEs organized in SmartGrids, along with their related concepts (rows)
*/
select distinct con.concept_id, 
con.name as SDEName, 
zc.name as DataType, 
grp.RELATED_CONCEPT,
relcon.name as RelConceptName,
con.internal_id,
frm.form_id,
frm.LINE


from clarity_concept con
inner join ZC_DATA_TYPE zc
on con.DATA_TYPE_C = zc.DATA_TYPE_C

inner join CONCEPT_GROUP grp
on grp.CONCEPT_ID = con.CONCEPT_ID

inner join clarity_concept relcon
on relcon.CONCept_id = grp.RELATED_CONCEPT

inner join smartform_concept frm
on frm.CONCEPT_ID = con.CONCEPT_ID

where frm.form_id = '3354'
order by concept_id

/* Tab 3: Example patient-level SDEs with Encounter and Patient contexts and current/previous values
*/
*/

SELECT con.concept_id, 
val.context_name,
con.name as SDEName, 
zc.name as DataType, 
val.SMRTDTA_ELEM_VALUE, 
val.LINE, 
parent_concept, 
con.internal_id, 
val.hlv_id, 
CUR_VALUE_DATETIME, 
CUR_VALUE_SOURCE, 
dt.PAT_LINK_ID, 
CUR_SOURCE_LQF_ID,
val.update_num,
val.latest_value_yn,
val.value_update_dttm,

val.contact_serial_num,
val.pat_link_id


from CLARITY_CONCEPT con
left join SMRTDTA_ELEM_DATA dt
on dt.ELEMENT_ID = con.CONCEPT_ID

inner join ZC_DATA_TYPE zc
on con.DATA_TYPE_C = zc.DATA_TYPE_C

inner join V_SMRTDTA_ELEM_VAL_ALL val
on dt.hlv_id = val.hlv_id

inner join patient pat
on pat.pat_id = val.pat_link_id

  
where 
cur_source_lqf_id in ('3354', '3381')
--and val.pat_link_id = 'Z1973592'
and val.pat_link_id in ('Z1973592','Z5194077','Z6689704')
--and CUR_VALUE_DATETIME >= '2021-4-01'
--and concept_id = 'RHU#499'
order by concept_id


