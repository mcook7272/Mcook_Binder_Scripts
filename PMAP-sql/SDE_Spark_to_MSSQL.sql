WITH LQF AS (
SELECT distinct CUR_VALUE_DATETIME, 
CUR_VALUE_SOURCE, 
dt.PAT_LINK_ID, 
dt.CUR_SOURCE_LQF_ID,
ELEMENT_ID,
HLV_ID
FROM CLARITY..SMRTDTA_ELEM_DATA dt
where dt.CUR_SOURCE_LQF_ID = '116000505'
),

evp_count as
 (SELECT 
 HLV_ID
 ,MAX(LINE) as PREV_VAL_LINE
 FROM CLARITY..ELEM_VAL_PREV
 GROUP BY HLV_ID),

V_SMRTDTA_ELEM_VAL_ALL_T AS (

--First, compile all historical values for each SDE
(SELECT
 sld.HLV_ID
,evp.LINE AS UPDATE_NUM -- the number of contacts for the SDE, higher = more recent
,CASE WHEN (evpv_value.LINE - evpv_line.LINE) IS NULL THEN 1 ELSE (evpv_value.LINE - evpv_line.LINE) END as LINE -- HLV_ID + EVENT_NUM + LINE is the PK
,sld.CM_PHY_OWNER_ID as CM_PHY_OWNER_ID
,sld.CM_LOG_OWNER_ID as CM_LOG_OWNER_ID 
,sld.ELEMENT_ID
,evpv_value.PREV_VALUES as SMRTDTA_ELEM_VALUE
,'N' as LATEST_VALUE_YN -- indicates this is a historical value
,evp.PREV_INSTANT_DTTM as VALUE_UPDATE_DTTM
,sld.CONTEXT_NAME as CONTEXT_NAME
,sld.CONTACT_SERIAL_NUM as CONTACT_SERIAL_NUM
,sld.RECORD_ID_VARCHAR as RECORD_ID_VARCHAR
,sld.RECORD_ID_NUMERIC as RECORD_ID_NUMERIC
,sld.UPDATE_DATE as UPDATE_DATE
,sld.PAT_LINK_ID as PAT_LINK_ID
FROM
CLARITY..SMRTDTA_ELEM_DATA sld
INNER JOIN
 (select 
 HLV_ID
 ,LINE
 ,PREV_INSTANT_DTTM
 ,CAST(PREV_VAL_POINTER AS INT) as PREV_VAL_POINTER -- needed because the string 'null' can be stored to PREV_VAL_POINTER
 from CLARITY..ELEM_VAL_PREV) evp 
ON sld.HLV_ID=evp.HLV_ID
LEFT OUTER JOIN
 (SELECT
 HLV_ID
 ,LINE
 ,CAST(PREV_VALUES AS INT) as EVENT_LINES -- this is a varchar column, but we only want the integer pointers
 FROM CLARITY..ELEM_VAL_PREV_VAL) evpv_line
 ON evp.HLV_ID = evpv_line.HLV_ID 
 AND evp.PREV_VAL_POINTER = evpv_line.LINE
 LEFT OUTER JOIN CLARITY..ELEM_VAL_PREV_VAL evpv_value
 ON evpv_line.HLV_ID = evpv_value.HLV_ID
 AND evpv_line.LINE + evpv_line.EVENT_LINES >= evpv_value.LINE 
 AND evpv_Line.LINE < evpv_value.LINE)
UNION ALL --rows will be distinct between queries, so union all is fine and avoids a sort
--then, include the current value for each SDE
(SELECT 
 sld.HLV_ID
,coalesce(evp_count.PREV_VAL_LINE,0) + 1 as UPDATE_NUM --this makes UPDATE_NUM one more than the biggest historical value, or '1' if there are no historical values
,CASE WHEN slv.LINE is NULL THEN 1 ELSE slv.LINE END as LINE
,sld.CM_PHY_OWNER_ID as CM_PHY_OWNER_ID
,sld.CM_LOG_OWNER_ID as CM_LOG_OWNER_ID 
,sld.ELEMENT_ID
,slv.SMRTDTA_ELEM_VALUE as SMRTDTA_ELEM_VALUE
,'Y' as LATEST_VALUE_YN --indicates this is a current value
,sld.CUR_VALUE_DATETIME as VALUE_UPDATE_DTTM
,sld.CONTEXT_NAME as CONTEXT_NAME
,sld.CONTACT_SERIAL_NUM as CONTACT_SERIAL_NUM
,sld.RECORD_ID_VARCHAR as RECORD_ID_VARCHAR
,sld.RECORD_ID_NUMERIC as RECORD_ID_NUMERIC
,sld.UPDATE_DATE as UPDATE_DATE
,sld.PAT_LINK_ID as PAT_LINK_ID
FROM
CLARITY..SMRTDTA_ELEM_DATA sld
LEFT OUTER JOIN evp_count
ON sld.HLV_ID = evp_count.HLV_ID
LEFT OUTER JOIN CLARITY..SMRTDTA_ELEM_VALUE slv
ON sld.HLV_ID = slv.HLV_ID
where sld.PAT_LINK_ID = 'Z1132690')
)

SELECT 
 val.pat_link_id,
val.contact_serial_num,
con.concept_id, 
val.context_name,
con.name as SDEName, 
zc.name as DataType, 
val.SMRTDTA_ELEM_VALUE, 
val.LINE, 
con.parent_concept, 
con.internal_id, 
val.hlv_id, 
val.context_name,
dt.CUR_VALUE_DATETIME, 
dt.CUR_VALUE_SOURCE, 
dt.CUR_SOURCE_LQF_ID,
val.update_num,
val.latest_value_yn,
val.value_update_dttm


from CLARITY..CLARITY_CONCEPT con
left join LQF dt
on dt.ELEMENT_ID = con.CONCEPT_ID

inner join ZC_DATA_TYPE zc
on con.DATA_TYPE_C = zc.DATA_TYPE_C

inner join V_SMRTDTA_ELEM_VAL_ALL_T val
on dt.hlv_id = val.hlv_id

inner join CLARITY..patient pat
on pat.pat_id = val.pat_link_id
--INNER JOIN osler.id_map m ON m.altid = val.pat_link_id AND m.altid_type = 'pat_id'
	--INNER JOIN osler.patientlists l ON m.oslerid = l.member_id
WHERE  1 = 1
--l.list_name = 'PSQVTE_Patients'
--and val.PAT_LINK_ID = 'Z1132690'
--and dt.CUR_VALUE_DATETIME >= '2021-04-01'
order by concept_id, val.PAT_LINK_ID, val.contact_serial_num, val.value_update_dttm

/*
CL_QANSWER_QA
join CL_QANSWER on CL_QANSWER_QA.ANSWER_ID = CL_QANSWER.ANSWER_ID
where form_id = '116000505'
*/

