from PATIENT pat
    join PAT_ENC_HSP hsp on pat.PAT_ID = hsp.PAT_ID
        join IP_FLWSHT_REC rec on hsp.INPATIENT_DATA_ID = rec.INPATIENT_DATA_ID
            join IP_FLWSHT_MEAS meas on rec.FSD_ID = meas.FSD_ID
        join ORDER_PROC ord on hsp.PAT_ENC_CSN_ID = ord.PAT_ENC_CSN_ID
        LEFT OUTER JOIN PAT_ENC_DX encDX on hsp.PAT_ENC_CSN_ID = encDX.PAT_ENC_CSN_ID
            left join interestingDXs AS IDXS on encDX.DX_ID = IDXS.DX_ID
        LEFT OUTER JOIN HSP_DISCH_DIAG dischDX on hsp.PAT_ENC_CSN_ID = dischDX.PAT_ENC_CSN_ID
            left join interestingDXs AS IDXS_TWO on dischDX.DX_ID = IDXS_TWO.DX_ID
-