SELECT pat.jhhmrn, inf.*
into CROWNBurd_Scratch.dbo.curated_inflam_markers_mrn
FROM curated_Inflam_Markers inf
inner join derived_epic_patient pat on pat.osler_id = inf.osler_id

SELECT pat.jhhmrn, ipe.*
into CROWNBurd_Scratch.dbo.curated_IPEvents_mrn
FROM Curated_IPEvents ipe
inner join derived_epic_patient pat on pat.osler_id = ipe.osler_id

SELECT pat.jhhmrn, enc.*
into CROWNBurd_Scratch.dbo.derived_inpatient_encounters_mrn
FROM [derived_inpatient_encounters] enc
inner join derived_epic_patient pat on pat.osler_id = enc.osler_id

SELECT pat.jhhmrn, op.osler_id, max(op.contact_date) "Latest_Encounter", op.height, op.[weight]
from derived_outpatient_encounters op
inner join derived_epic_patient pat on pat.osler_id = op.osler_id
where (op.height is not null and op.weight is not null)
group by op.osler_id, pat.jhhmrn, op.height, op.[weight]
having max(op.contact_date) <= CURRENT_TIMESTAMP

SELECT pat.jhhmrn, op.osler_id, op.contact_date, op.height, op.[weight]
from derived_outpatient_encounters op
inner join derived_epic_patient pat on pat.osler_id = op.osler_id
where (op.height is not null and op.weight is not null)
and op.contact_date <= CURRENT_TIMESTAMP
order by pat.jhhmrn, contact_date desc

select op.osler_id, op.contact_date, op.height, op.[weight]
from derived_outpatient_encounters op
inner join (select osler_id, max(contact_date) max_contact_date
            from derived_outpatient_encounters
			where (height is not null and [weight] is not null)
            group by osler_id) t1
        on op.osler_id = t1.osler_id
       and op.contact_date = t1.max_contact_date
order by op.osler_id;

SELECT pat.jhhmrn, vit.[osler_id]
      ,[pat_enc_csn_id]
	  ,[meas_value] "BMI"
      ,[recorded_time]
      ,[entry_time]
      ,[enc_contact_date]
      ,[lastupdate_dttm]
  into CROWNBurd_Scratch.dbo.bmi
  FROM [CROWNBurd_Projection].[dbo].[derived_epic_vitals] vit
  inner join derived_epic_patient pat on pat.osler_id = vit.osler_id	
  where meas_name like '%bmi%'

  SELECT distinct pat_enc_csn_id
  FROM [CROWNBurd_Projection].[dbo].[derived_inpatient_encounters]
  where delivery_type is not null

  SELECT distinct pat.jhhmrn, pos.*,AGE,SEX_C,RACE_C,HISPANIC_C,POSITIVE_TEST_TIME,INIT_PAT_ENC_CSN_ID,ADMIT_TIME,
  ADMIT_SOURCE_C,ADMIT_SOURCE_NAME,TRANSFER_FROM_C,TRANSFER_FROM_NAME,INIT_HOSP_LOC_ABBR,LINKED_CSN,TRANSFER_TIME,
  OXYGEN_RX,INT_DIALYSIS_RX,NIPPV_RX,HIFLOW_RX,VENT_START,IVPRESSOR_RX,CRRT_RX,ECMO_RX,ECMO_END,TRACH_DTM,CHEST_TUBE_DTM,
  convalescent_plasma_dtm,VENT_END,IVPRESSOR_END,HIFLOW_END,NIPPV_END,CRRT_END,INT_DIALYSIS_END,OXYGEN_END,
  INIT_DNR_DNI,FINAL_HOSP_DISCH_TIME,FINAL_DISCH_DISP_C,FINAL_DISCH_DISP_NAME,DEATH_TIME
  into CROWNBurd_Scratch.dbo.covid_positive_ipEvents
  from CROWNBurd_Projection.dbo.derived_epic_patient pat 
  inner join [CROWNBurd_Projection].dbo.covid_pmcoe_covid_positive pos on pat.osler_id = pos.osler_id
  inner join CROWNBurd_Projection.dbo.Curated_IPEvents ipe on ipe.osler_id = pat.osler_id
  order by pos.osler_id, ipe.ADMIT_TIME

  SELECT distinct pat.jhhmrn, vit.*
  into CROWNBurd_Scratch.dbo.curated_ipVitals_mrn
  from CROWNBurd_Projection.dbo.derived_epic_patient pat 
  inner join CROWNBurd_Projection.dbo.curated_IPVitals vit on vit.osler_id = pat.osler_id
  order by vit.osler_id, RECORDED_TIME

  SELECT distinct pat.jhhmrn, pos.*
  into CROWNBurd_Scratch.dbo.covid_positive_mrn
  from CROWNBurd_Projection.dbo.derived_epic_patient pat 
  inner join [CROWNBurd_Projection].dbo.covid_pmcoe_covid_positive pos on pat.osler_id = pos.osler_id
  order by pat.jhhmrn

  -- Below done on 4/14/2021

  SELECT distinct pat.jhhmrn, pos.osler_id, pos.first_race, pos.age_at_positive, pos.initial_dx_date, enc.pat_enc_csn_id, enc.delivery_type, enc.labor_status, enc.hosp_admsn_time, enc.hosp_disch_time
  into CROWNBurd_Scratch.dbo.covid_positive_mrn_2021_03_31
  from CROWNBurd_Projection.dbo.derived_epic_patient pat 
  inner join [CROWNBurd_Projection].dbo.covid_pmcoe_covid_positive pos on pat.osler_id = pos.osler_id
  left join CROWNBurd_Projection.dbo.derived_inpatient_encounters enc on pat.osler_id = enc.osler_id
  where pos.initial_dx_date between '2021-01-14' and '2021-04-01'
  order by pat.jhhmrn, enc.hosp_admsn_time
  
  select mrn.jhhmrn, co.*
  into CROWNBurd_Scratch.dbo.curated_elixhauser_comorbidities_2021_03_31
  from CROWNBurd_Projection.dbo.curated_elixhauser_comorbidities co
  inner join CROWNBurd_Scratch.dbo.covid_positive_mrn_2021_03_31 mrn on co.osler_id = mrn.osler_id

  select mrn.jhhmrn, ipe.*
  into CROWNBurd_Scratch.dbo.curated_IPEvents_2021_03_31
  from CROWNBurd_Projection.dbo.curated_IPEvents ipe
  inner join CROWNBurd_Scratch.dbo.covid_positive_mrn_2021_03_31 mrn on ipe.osler_id = mrn.osler_id

  SELECT distinct pat.jhhmrn, cov.*
  into CROWNBurd_Scratch.dbo.curated_covid_immunizations_mrn
  from CROWNBurd_Projection.dbo.derived_epic_patient pat 
  inner join CROWNBurd_Projection.dbo.curated_covid_immunizations cov on cov.osler_id = pat.osler_id
  order by cov.osler_id, cov.jab1_immune_date
