USE [CLARITY];

with ARDS_Dx as (
    select distinct dx_id, CURRENT_ICD10_LIST
    from clarity_edg as edg
    where edg.CURRENT_ICD10_LIST like '%J80%'
),

	Pats_Dx as (
	select distinct t.PAT_ENC_CSN_ID, t.dx_id
	from(
	select enc.PAT_ENC_CSN_ID, dx.DX_ID
	from PAT_ENC_DX enc
	join ARDS_DX dx on enc.DX_ID = dx.DX_ID
	union
	select enc.PAT_ENC_CSN_ID, dx.DX_ID
	from HSP_DISCH_DIAG enc
	join ARDS_DX dx on enc.DX_ID = dx.DX_ID
	) t

)


Select distinct pat.PAT_MRN_ID, pat.PAT_NAME, pat.PAT_ID
from PATIENT pat
join PAT_ENC_HSP hsp on pat.PAT_ID = hsp.PAT_ID
--join PAT_ENC_DX dx on hsp.PAT_ENC_CSN_ID = dx.PAT_ENC_CSN_ID
join IP_FLWSHT_REC rec on hsp.INPATIENT_DATA_ID = rec.INPATIENT_DATA_ID
join IP_FLWSHT_MEAS meas on rec.FSD_ID = meas.FSD_ID
join ORDER_PROC ord on hsp.PAT_ENC_CSN_ID = ord.PAT_ENC_CSN_ID
join Pats_Dx pt_dx on hsp.PAT_ENC_CSN_ID = pt_dx.PAT_ENC_CSN_ID
where hsp.ADT_PAT_CLASS_C = 101 --Inpatient
and hsp.department_id like '1101%' --Seen at JHH
and hsp.HOSP_ADMSN_TIME >= '2019-01-01' --On/after 1/1/2019
and CAST((DATEDIFF(DAY, pat.BIRTH_DATE, CURRENT_TIMESTAMP)/365.25) AS INT) >= 18 --Adult
and meas.FLO_MEAS_ID in ('3040102626','304064511','304064676','304064678','304064679',
'304064698','304064699','304064700','304064868','304064869','304065011','3040656900',
'30440106113','600645','7070176','7070177','7070178','7070179','7070180') --Intubated or having tracheostomy
and ord.PROC_ID = 3042000103 --SLP Consult


