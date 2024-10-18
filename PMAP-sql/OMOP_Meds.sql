
SELECT mar.taken_time, 
--mar.mar_enc_csn,
disp.line, med.MEDICATION_ID, med.name as med_name, med.GENERIC_NAME, disp.disp_qty, disp.DISP_QTYUNIT_C, zc.name, med.FORM, med.ROUTE
FROM ORDER_DISP_MEDS disp
join ORDER_MED om on disp.order_med_id = om.order_med_id
join MAR_ADMIN_INFO mar on om.order_med_id = mar.order_med_id
join CLARITY_MEDICATION med on om.medication_id = med.medication_id
join [CCDA_Stage].[mcook49_OMOP_Drug_Mappings2] omop on CAST(med.MEDICATION_ID AS varchar(max)) = CAST(omop.source_code AS varchar(max)) 
	AND om.PAT_ID = omop.pat_id
	AND omop.pat_enc_csn_id = mar.mar_enc_csn
left join ZC_MED_UNIT zc on disp.DISP_QTYUNIT_C = zc.DISP_QTYUNIT_C
order by om.pat_id, mar.mar_enc_csn, med.medication_id, mar.taken_time, disp.line
