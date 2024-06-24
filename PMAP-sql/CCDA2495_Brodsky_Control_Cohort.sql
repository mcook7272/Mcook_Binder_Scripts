USE [CLARITY];

with ARDS_Dx as (
    select distinct dx_id, CURRENT_ICD10_LIST
    from clarity_edg as edg
    where edg.CURRENT_ICD10_LIST like '%J80%'
)

Select distinct pat.PAT_MRN_ID, pat.PAT_NAME, pat.PAT_ID, IDXS.CURRENT_ICD10_LIST, IDXS_TWO.CURRENT_ICD10_LIST
from PATIENT pat
    join PAT_ENC_HSP hsp on pat.PAT_ID = hsp.PAT_ID
        join IP_FLWSHT_REC rec on hsp.INPATIENT_DATA_ID = rec.INPATIENT_DATA_ID
            join IP_FLWSHT_MEAS meas on rec.FSD_ID = meas.FSD_ID
        join ORDER_PROC ord on hsp.PAT_ENC_CSN_ID = ord.PAT_ENC_CSN_ID
        LEFT OUTER JOIN PAT_ENC_DX encDX on hsp.PAT_ENC_CSN_ID = encDX.PAT_ENC_CSN_ID
            left join ARDS_Dx AS IDXS on encDX.DX_ID = IDXS.DX_ID
        LEFT OUTER JOIN HSP_DISCH_DIAG dischDX on hsp.PAT_ENC_CSN_ID = dischDX.PAT_ENC_CSN_ID
            left join ARDS_Dx AS IDXS_TWO on dischDX.DX_ID = IDXS_TWO.DX_ID
where hsp.ADT_PAT_CLASS_C = 101 --Inpatient
and hsp.department_id like '1101%' --Seen at JHH
and hsp.HOSP_ADMSN_TIME >= '2019-01-01' --On/after 1/1/2019
and CAST((DATEDIFF(DAY, pat.BIRTH_DATE, CURRENT_TIMESTAMP)/365.25) AS INT) >= 18 --Adult
and meas.FLO_MEAS_ID in ('3040102626','304064511','304064676','304064678','304064679',
'304064698','304064699','304064700','304064868','304064869','304065011','3040656900',
'30440106113','600645','7070176','7070177','7070178','7070179','7070180') --Intubated or having tracheostomy
and ord.PROC_ID = 3042000103 --SLP Consult
and (IDXS.DX_ID is not null or IDXS_TWO.DX_ID is not null) --ARDS dx during enc or disch dx


