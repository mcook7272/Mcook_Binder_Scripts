
SELECT mar.taken_time, 
--mar.mar_enc_csn,
--mar.ORDER_MED_ID,
disp.line, med.MEDICATION_ID, med.name as med_name, med.GENERIC_NAME, disp.disp_qty, 
disp.DISP_QTYUNIT_C,mar.DOSE_UNIT_C,om.HV_DOSE_UNIT_C, zc.name, med.FORM, med.ROUTE,
om.QUANTITY, mar.SIG
FROM ORDER_DISP_MEDS disp
join ORDER_MED om on disp.order_med_id = om.order_med_id
join MAR_ADMIN_INFO mar on om.order_med_id = mar.order_med_id
join CLARITY_MEDICATION med on om.medication_id = med.medication_id
join [CCDA_Stage].[mcook49_OMOP_Drug_Mappings2] omop on CAST(med.MEDICATION_ID AS varchar(max)) = CAST(omop.source_code AS varchar(max)) 
	AND om.PAT_ID = omop.pat_id
	AND omop.pat_enc_csn_id = mar.mar_enc_csn
left join ZC_MED_UNIT zc on disp.DISP_QTYUNIT_C = zc.DISP_QTYUNIT_C
order by om.pat_id, mar.mar_enc_csn, med.medication_id, mar.taken_time, disp.line

/*
MAYBE when problematic, calculate from SIG (standing in for quantity) [CONCAT?] DOSE_UNIT_C
Ex: DOSE_UNIT_C = 41 (mL/hr), SIG = 42; ergo quantity = 42 mL/hr
*/


select count(*) FROM (
select ORDER_MED_ID, count(disp_qty) as qty_count, count(DISP_QTYUNIT_C) as unit_count
from ORDER_DISP_MEDS
group by ORDER_MED_ID
having count(disp_qty) > 1 OR count(DISP_QTYUNIT_C) > 1
) t
UNION
SELECT count(distinct order_med_id)
FROM ORDER_DISP_MEDS
