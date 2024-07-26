WITH LQF AS (
SELECT distinct CUR_VALUE_DATETIME, 
CUR_VALUE_SOURCE, 
dt.PAT_LINK_ID, 
CUR_SOURCE_LQF_ID,
ELEMENT_ID,
HLV_ID
FROM CLARITY..SMRTDTA_ELEM_DATA dt
WHERE dt.CUR_SOURCE_LQF_ID in ('159','165','234','2416','245','262','2636','2640',
'3046006501','3249','40025','40382','40395','430','48000','48001','48002','48004',
'48023','48024','48025','48026','48053','48075','49808','49809','49810','49811',
'49814','49815','49816','49817','49825','49826','49827','49828','49840','49843',
'49852','49855','49861','49862','49870','49871','49874','49875','49880','49885',
'49886','49891','49933','49934','49969','50007','50013','50018','50387','50388',
'50389','50923','51530','53251','53252','53253','53254','533','534','53859','540',
'56068','569','56936','56948','60065','60360','60378','60379','60805','826','89000',
'89001','89013','89019','93054','93055','93370','93371','93413','95005','99001','99900','99907')
)

SELECT con.concept_id, 
val.context_name,
con.name as SDEName, 
zc.name as DataType, 
val.SMRTDTA_ELEM_VALUE, 
val.LINE, 
con.parent_concept, 
con.internal_id, 
val.hlv_id, 
dt.CUR_VALUE_DATETIME, 
dt.CUR_VALUE_SOURCE, 
dt.CUR_SOURCE_LQF_ID,
val.update_num,
val.latest_value_yn,
val.value_update_dttm,
val.contact_serial_num


from CLARITY_CONCEPT con
left join LQF dt
on dt.ELEMENT_ID = con.CONCEPT_ID

inner join ZC_DATA_TYPE zc
on con.DATA_TYPE_C = zc.DATA_TYPE_C

inner join V_SMRTDTA_ELEM_VAL_ALL val
on dt.hlv_id = val.hlv_id

inner join patient pat
on pat.pat_id = val.pat_link_id

  
where 
cur_source_lqf_id = '2640'
AND
val.latest_value_yn = 'Y'
and 
val.pat_link_id = 'Z7216385' --join to osler, listname, etc
--and dt.CUR_VALUE_DATETIME >= '2021-4-01'
order by concept_id --osler, csn(masked), value_update, concept_id