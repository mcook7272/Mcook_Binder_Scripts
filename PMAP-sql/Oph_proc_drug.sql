Ophthalmology_CAI_IRB00264321_Projection..derived_med_orders
WHERE pat_enc_csn_id = '2200645364076878'

Ophthalmology_CAI_IRB00264321_Projection.phi.csn_mapping_table
WHERE un_masked_pat_enc_csn_id = '1156991211'

Ophthalmology_CAI_IRB00264321_Projection.phi.derived_epic_patient
WHERE emrn = 'E100007822'

[Ophthalmology_CAI_IRB00264321_Projection].[dbo].[derived_profee_billing_px] 
WHERE --code = '67028'
pat_enc_csn_id = '2200645364076878'

[Ophthalmology_CAI_IRB00264321_Projection].[dbo].[derived_epic_all_encounters]
WHERE --pat_enc_csn_id = '2200645364076878'
pat_enc_csn_id = '1932041110421703'

Ophthalmology_CAI_IRB00264321_Projection..derived_med_orders
WHERE cohort_id = 'OCB0nha8t6zg8q'
ORDER BY ordering_dttm

SELECT DISTINCT px.cohort_id, px.pat_enc_csn_id 'proc_csn', med.pat_enc_csn_id 'med_csn', px.proc_date, med.ordering_dttm,
px.code, med.med_display_name, px.modifier_1_name
FROM [Ophthalmology_CAI_IRB00264321_Projection].[dbo].[derived_profee_billing_px] px
join [Ophthalmology_CAI_IRB00264321_Projection].[dbo].[derived_med_orders] med on px.cohort_id = med.cohort_id AND ABS(DATEDIFF(hour, px.proc_date,med.ordering_dttm)) <= 24 --med within 24 hrs of proc
WHERE px.code = '67028'
--AND med filter
ORDER BY cohort_id, px.proc_date