WITH MyMeas AS
(select distinct ept_csn from 
IP_DATA_STORE ipds 
JOIN IP_FLWSHT_REC fr on fr.INPATIENT_DATA_ID = ipds.INPATIENT_DATA_ID
JOIN IP_FLWSHT_MEAS m on m.fsd_id = fr.fsd_id
WHERE m.flo_meas_id in ('3040102626','304064511','304064676','304064678','304064679',
'304064698','304064699','304064700','304064868','304064869','304065011','3040656900',
'30440106113','600645','7070176','7070177','7070178','7070179','7070180') 
),
SLPConsult AS
(select distinct pat_enc_csn_id from
ORDER_PROC op where
op.proc_id = 3042000103
and op.order_status_c in (2,5) -- note 4 is cancelled
and op.future_or_stand is null    -- Future/Standing Orders did not change this probably they are the same encounter
),
ARDS_Dx as (
    select distinct dx_id
    from edg_current_icd10 where code like 'J80%'
) 
SELECT distinct p.pat_id
FROM PATIENT p
JOIN PAT_ENC_HSP hsp on hsp.pat_id = p.pat_id
JOIN 
(
SELECT distinct pat_enc_csn_id from PAT_ENC_DX pex
JOIN ARDS_Dx ards1 on pex.dx_id = ards1.dx_id
UNION
SELECT distinct h1.pat_enc_csn_id from PAT_ENC_HSP h1
JOIN hsp_acct_dx_list hadx on hadx.HSP_ACCOUNT_ID = h1.HSP_ACCOUNT_ID
JOIN ARDS_Dx ards2 on hadx.dx_id = ards2.dx_id
) dxlist on dxlist.pat_enc_csn_id = hsp.pat_enc_csn_id
JOIN SLPConsult on SLPConsult.PAT_ENC_CSN_ID = hsp.PAT_ENC_CSN_ID
JOIN  MyMeas on MyMeas.EPT_CSN = hsp.pat_enc_csn_id
WHERE hsp.ADT_PAT_CLASS_C = 101
AND convert(varchar(18),hsp.DEPARTMENT_ID) like '1101%'
AND hsp.HOSP_ADMSN_TIME >= '01/01/2019'
AND CAST((DATEDIFF(DAY, p.BIRTH_DATE, hsp.HOSP_ADMSN_TIME)/365.25) AS INT) >= 18 --Adult
