WITH MED_IDS AS 
(
SELECT distinct COALESCE(info.ERX_ID, med.DISP_MED_ID, ndc.MEDICATION_ID) "Med_ID", fda.medication_id, fda.medication_name
FROM ANALYTICS.dbo.CCDA2644_FDA_CROWN_Missing_Drugs fda
LEFT JOIN CLARITY..ORDER_DISP_MEDS med on fda.medication_id = med.DISP_MED_ID AND fda.medication_id is not null
LEFT JOIN CLARITY..ORD_DISPENSE_PREP disp on med.ORDER_MED_ID = disp.ORDER_ID
LEFT JOIN CLARITY..RX_NDC_STATUS ndc on disp.NDC_CSN = ndc.CNCT_SERIAL_NUM
LEFT JOIN CLARITY..MAR_ADDL_INFO info on disp.ORDER_ID = info.ORDER_ID )

SELECT distinct med.Med_ID, med.medication_name, rx.MEDICATION_ID, rx.RXNORM_CODE, rx.RXNORM_CODE_LEVEL_C
FROM RXNORM_CODES rx 
JOIN MED_IDS AS med on med.Med_ID = rx.MEDICATION_ID and med.Med_ID is not null