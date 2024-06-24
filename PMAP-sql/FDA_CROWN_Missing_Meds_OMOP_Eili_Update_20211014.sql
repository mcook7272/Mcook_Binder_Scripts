
select 
	missingdrugorders.PAT_ENC_CSN_ID, -- Link to patient
	missingdrugorders.ORDER_MED_ID, -- associated order num
	coalesce( MAR_ADDL_INFO.ERX_ID, OrderPreppedNdcStatus.MEDICATION_ID, ORDER_DISP_MEDS.DISP_MED_ID, ORDER_MEDINFO.DISPENSABLE_MED_ID) as Medication_id,
	RXNORM_CODES.RXNORM_CODE,
	CLARITY_MEDICATION.*
from CLARITY..MAR_ADMIN_INFO with(nolock) 
	inner join (
		select OM.ORDER_MED_ID, OM.PAT_ENC_CSN_ID from ANALYTICS.dbo.CCDA2644_FDA_CROWN_Missing_Drugs fda 
			inner join CLARITY..ORDER_MED OM on fda.medication_id = OM.MEDICATION_ID
		-- This line is restricting to a single drug order to show the way they match
		--where fda.medication_id = 470504 and OM.order_med_id = 252517523
	) missingdrugorders on missingdrugorders.ORDER_MED_ID = MAR_ADMIN_INFO.ORDER_MED_ID
	
	--- Additional info table first
	LEFT JOIN CLARITY..MAR_ADDL_INFO 
        ON MAR_ADMIN_INFO.ORDER_MED_ID = MAR_ADDL_INFO.ORDER_ID
            AND (121531 - MAR_ADMIN_INFO.MAR_ORD_DAT) = MAR_ADDL_INFO.CONTACT_DATE_REAL
	
	--- Dispense prep Meds next
	LEFT JOIN CLARITY..ORD_DISPENSE_PREP 
        ON MAR_ADMIN_INFO.ORDER_MED_ID = ORD_DISPENSE_PREP.ORDER_ID
            AND (121531 - MAR_ADMIN_INFO.MAR_ORD_DAT) = ORD_DISPENSE_PREP.CONTACT_DATE_REAL
	LEFT JOIN CLARITY..RX_NDC_STATUS OrderPreppedNdcStatus
        ON ORD_DISPENSE_PREP.NDC_CSN = OrderPreppedNdcStatus.CNCT_SERIAL_NUM
	-- third dispense med info
	LEFT JOIN CLARITY..ORDER_DISP_INFO 
        ON MAR_ADMIN_INFO.ORDER_MED_ID = ORDER_DISP_INFO.ORDER_MED_ID
            AND (121531 - MAR_ADMIN_INFO.MAR_ORD_DAT) = ORDER_DISP_INFO.CONTACT_DATE_REAL
        LEFT JOIN CLARITY..ORDER_DISP_MEDS
        ON MAR_ADMIN_INFO.ORDER_MED_ID = ORDER_DISP_MEDS.ORDER_MED_ID
            AND ORDER_DISP_INFO.DISP_MED_CNTCT_ID = ORDER_DISP_MEDS.CONTACT_DATE_REAL

	-- Finally Order med info
	LEFT JOIN CLARITY..ORDER_MEDINFO
      ON MAR_ADMIN_INFO.ORDER_MED_ID = ORDER_MEDINFO.ORDER_MED_ID

	-- Not certain these are needed, but assume it guarantees admin in some way, so left in for now (query works with or without, but didn't check potential edge cases this may fix
    LEFT JOIN CLARITY..RX_NDC_STATUS ScannedNdcStatus 
        ON MAR_ADDL_INFO.NDC_CSN_ID = ScannedNdcStatus.CNCT_SERIAL_NUM
    LEFT JOIN CLARITY..RX_NDC ScannedNdc
        ON ScannedNdcStatus.NDC_ID = ScannedNdc.NDC_ID
    LEFT JOIN CLARITY..RX_MED_THREE ScannedMeds
        ON MAR_ADDL_INFO.ERX_ID = ScannedMeds.MEDICATION_ID

	-- Gets the RX Norm Codes
	LEFT JOIN CLARITY..RXNORM_CODES 
		ON RXNORM_CODES.MEDICATION_ID = coalesce( MAR_ADDL_INFO.ERX_ID, OrderPreppedNdcStatus.MEDICATION_ID, ORDER_DISP_MEDS.DISP_MED_ID, ORDER_MEDINFO.DISPENSABLE_MED_ID)
	
	LEFT JOIN CLARITY..CLARITY_MEDICATION 
		ON CLARITY_MEDICATION.MEDICATION_ID = coalesce( MAR_ADDL_INFO.ERX_ID, OrderPreppedNdcStatus.MEDICATION_ID, ORDER_DISP_MEDS.DISP_MED_ID, ORDER_MEDINFO.DISPENSABLE_MED_ID)
where 
-- This restricts the results only to administrations -- see ZC_EDIT_MAR_RSLT
MAR_ADMIN_INFO.MAR_ACTION_C IN ( '1', '102', '105', '113', '114', '115', '117', '12', '120', '124', '127', '128', '13', '131', '210001', '210002', '210003', '304102', '6' )
-- This restricts to ingredients only 
and RXNORM_CODES.RXNORM_TERM_TYPE_C in (1,2,3)
