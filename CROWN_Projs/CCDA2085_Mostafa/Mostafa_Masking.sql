USE [PMAP_Analytics]
GO

/****** Object:  StoredProcedure [dbo].[CCDA_2085_Mostafa_Masking]    Script Date: 4/24/2023 11:26:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CCDA_2085_Mostafa_Masking] AS

/**********************************************************************************
Author:  mcook49
Date: 2022-01-20
JIRA: CCDA-2085
Description: To run after the projection of CROWNMostafa data, masking the data for the study team
     
Revision History:
Date            Author          JIRA            Comment
2022-01-24     mcook49     CCDA-2085          Added refresh_status table so team can track when data is masked
***********************************************************************************/

SET NOCOUNT ON;

--Drop tables that will be re-loaded
Drop table if exists PMAP_Analytics.dbo.CCDA2085_Mostafa_csn_Mapping;
Drop table if exists PMAP_Analytics.dbo.CCDA2085_Mostafa_osler_id_Mapping;
DROP table if exists CROWNMostafa_Projection.dbo.covid_pmcoe_covid_positive_masked;
DROP table if exists CROWNMostafa_Projection.dbo.curated_covid_immunizations_masked;
DROP table if exists CROWNMostafa_Projection.dbo.curated_elixhauser_comorbidities_masked;
DROP table if exists CROWNMostafa_Projection.dbo.Curated_IPEvents_masked;
DROP table if exists CROWNMostafa_Projection.dbo.derived_epic_patient_masked;
DROP table if exists CROWNMostafa_Projection.dbo.derived_epic_vitals_masked;
DROP table if exists CROWNMostafa_Projection.dbo.derived_inpatient_encounters_masked;
DROP table if exists CROWNMostafa_Projection.dbo.derived_lab_results_masked;
DROP table if exists CROWNMostafa_Projection.dbo.derived_social_history_changes_masked;
DROP table if exists CROWNMostafa_Projection.dbo.curated_AllMed_Doses_masked;
DROP table if exists CROWNMostafa_Projection.dbo.curated_IPVitals_masked;
DROP table if exists CROWNMostafa_Projection.dbo.derived_emr_diagnosis_info_masked;
DROP table if exists CROWNMostafa_Projection.dbo.covid_sequencing_data_masked;

--Create mapping tables

--CSN
SELECT 
	a.*
	--,'Pat_'+ cast(ROW_NUMBER() OVER (ORDER BY A.IDENTITY_ID) as varchar) as 'Masked ID'
	,ROW_NUMBER() OVER (ORDER BY A.IDENTITY_ID) as 'enc_ID'
	into PMAP_Analytics.dbo.CCDA2085_mostafa_csn_Mapping
FROM (
	SELECT DISTINCT
		t.pat_enc_csn_id "Identity_ID"
	FROM (
		select distinct osler_id, pat_enc_csn_id
		from CROWNMostafa_Scratch.dbo.derived_inpatient_encounters
		union 
		select distinct osler_id, pat_enc_csn_id
		from CROWNMostafa_Scratch.dbo.derived_social_history_changes
		union 
		select distinct osler_id, hx_lnk_enc_csn
		from CROWNMostafa_Scratch.dbo.derived_social_history_changes
		union 
		select distinct osler_id, pat_enc_csn_id
		from CROWNMostafa_Scratch.dbo.derived_lab_results
		union 
		select distinct osler_id, jab1_csn "pat_enc_csn_id"
		from CROWNMostafa_Scratch.dbo.curated_covid_immunizations
		union 
		select distinct osler_id, jab2_csn "pat_enc_csn_id"
		from CROWNMostafa_Scratch.dbo.curated_covid_immunizations
	) t
	WHERE t.pat_enc_csn_id is not null
 )a;

 --osler_id
  SELECT 
	a.*
	--,'Pat_'+ cast(ROW_NUMBER() OVER (ORDER BY A.IDENTITY_ID) as varchar) as 'Masked ID'
	,ROW_NUMBER() OVER (ORDER BY A.osler_id) as 'patient_id'
	into PMAP_Analytics.dbo.CCDA2085_mostafa_osler_id_Mapping
FROM (
	SELECT DISTINCT
		osler_id
	FROM CROWNMostafa_Scratch.dbo.derived_epic_patient
 )A;

 --Load tables
 select id.patient_id,pat.pat_status,pat.death_date,
 pat.gender,ethnic_group,last_contact
into CROWNMostafa_Projection.dbo.derived_epic_patient_masked
from CROWNMostafa_Scratch.dbo.derived_epic_patient pat
inner join PMAP_Analytics.dbo.CCDA2085_mostafa_osler_id_Mapping id on id.osler_id = pat.osler_id
order by id.patient_id;


SELECT id.patient_id,first_race,gender,age_at_positive,
pat_status,death_date,initial_dx_date,infection_add_date,
positive_collection_date,positive_result_date,rsltdt_infadd_hour_interval,initial_dx_source 
into CROWNMostafa_Projection.dbo.covid_pmcoe_covid_positive_masked
from CROWNMostafa_Scratch.dbo.covid_pmcoe_covid_positive pat
inner join PMAP_Analytics.dbo.CCDA2085_mostafa_osler_id_Mapping id on id.osler_id = pat.osler_id;

SELECT distinct id.patient_id,jab1_immune_id,jab1_immune_date,jab1_immunzatn_id,jab1_immune_type,
jab1_imm_historic_adm_yn,jab2_immune_id,jab2_immune_date,jab2_immunzatn_id,jab2_immune_type,
jab2_imm_historic_adm_yn,jab1_jab2_interval_days,map.enc_ID "jab1_enc_ID",jab1_entry_date,jab1_update_date,
jab2_entry_date,jab2_update_date,map2.enc_ID "jab2_enc_ID",jab1_contact_date_real,jab1_line,jab2_contact_date_real,jab2_line
into CROWNMostafa_Projection.dbo.curated_covid_immunizations_masked
from CROWNMostafa_Scratch.dbo.curated_covid_immunizations pat
left join PMAP_Analytics.dbo.CCDA2085_mostafa_csn_Mapping map on pat.jab1_csn = map.Identity_ID
left join PMAP_Analytics.dbo.CCDA2085_mostafa_csn_Mapping map2 on pat.jab2_csn = map2.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2085_mostafa_osler_id_Mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,el_depress,el_anemdef,el_htn,el_wghtloss,el_lymph,
el_coag,el_alcohol,el_chf,el_renlfail,el_perivasc,el_tumor,el_aids,
el_para,el_pulmcirc,el_htncx,el_ulcer,el_psych,el_obese,el_bldloss,
el_chrnlung,el_drug,el_hypothy,el_mets,el_lytes,el_liver,el_arth,
el_neuro,el_dmcx,el_valve,el_dm,icd10 
into CROWNMostafa_Projection.dbo.curated_elixhauser_comorbidities_masked
from CROWNMostafa_Scratch.dbo.curated_elixhauser_comorbidities pat
inner join PMAP_Analytics.dbo.CCDA2085_mostafa_osler_id_Mapping id on id.osler_id = pat.osler_id;


SELECT id.patient_id,AGE,SEX_C,RACE_C,HISPANIC_C,POSITIVE_TEST_TIME,
map.enc_ID "INIT_ENC_ID",ADMIT_TIME,ADMIT_SOURCE_C,ADMIT_SOURCE_NAME,
TRANSFER_FROM_C,TRANSFER_FROM_NAME,INIT_HOSP_LOC_ABBR,map2.enc_ID "LINKED_ENC_ID",
TRANSFER_TIME,OXYGEN_RX,INT_DIALYSIS_RX,NIPPV_RX,HIFLOW_RX,VENT_START,
IVPRESSOR_RX,CRRT_RX,ECMO_RX,ECMO_END,TRACH_DTM,CHEST_TUBE_DTM,
convalescent_plasma_dtm,VENT_END,IVPRESSOR_END,HIFLOW_END,NIPPV_END,
CRRT_END,INT_DIALYSIS_END,OXYGEN_END,INIT_DNR_DNI,FINAL_HOSP_DISCH_TIME,
FINAL_DISCH_DISP_C,FINAL_DISCH_DISP_NAME,DEATH_TIME 
into CROWNMostafa_Projection.dbo.Curated_IPEvents_masked
from CROWNMostafa_Scratch.dbo.Curated_IPEvents pat
inner join PMAP_Analytics.dbo.CCDA2085_mostafa_csn_Mapping map on pat.INIT_PAT_ENC_CSN_ID = map.Identity_ID
left join PMAP_Analytics.dbo.CCDA2085_mostafa_csn_Mapping map2 on pat.LINKED_CSN = map2.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2085_mostafa_osler_id_Mapping id on id.osler_id = pat.osler_id;


SELECT id.patient_id,map.enc_ID,inpatient_data_id,recorded_time,
entry_time,meas_value,meas_name,meas_disp_name,meas_id,meas_row_type,
meas_val_type,meas_row_type_c,meas_val_type_c,meas_template_id,
template_display_name,meas_line,enc_contact_date,enc_dept_id,enc_type,
enc_type_c,lastupdate_dttm 
into CROWNMostafa_Projection.dbo.derived_epic_vitals_masked
from CROWNMostafa_Scratch.dbo.derived_epic_vitals pat
inner join PMAP_Analytics.dbo.CCDA2085_mostafa_csn_Mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2085_mostafa_osler_id_Mapping id on id.osler_id = pat.osler_id;


SELECT id.patient_id,pat_enc_date_real,map.enc_ID,
adt_pat_class_c,adt_pat_class,adt_patient_stat_c,adt_patient_stat,
pending_disch_time,exp_admission_time,exp_len_of_stay,admit_source_c,
admit_source,delivery_type_c,delivery_type,labor_status_c,labor_status,
adt_arrival_time,hosp_admsn_time,hosp_disch_time,hosp_admsn_type_c,
hosp_admsn_type,department_id,dept_name,dept_abbreviation,dep_speciality,
dep_rpt_grp_ten,disch_disp_c,disc_disp,contact_date,inp_adm_date,ed_departure_time,
op_adm_date,emer_adm_date,hospital_service,ed_visit_yn,serv_area_name 
into CROWNMostafa_Projection.dbo.derived_inpatient_encounters_masked
from CROWNMostafa_Scratch.dbo.derived_inpatient_encounters pat
inner join PMAP_Analytics.dbo.CCDA2085_mostafa_csn_Mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2085_mostafa_osler_id_Mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,proc_code,proc_name,proc_cat_id,
proc_cat_name,sensitive_yn,order_type,lab_group,resulting_lab,order_time,
result_time,specimen_taken_time,specimen_recv_time,order_results_line,
component_id,component_name,component_base_name,component_type,
component_subtype,component_lab_subtype,result_flag,order_status,
result_status,lab_status,ord_value,ord_num_value,reference_low,
reference_high,reference_unit,result_sub_idn,result_in_range_yn,
ref_normal_vals,lrr_based_organ_id,data_type,numeric_precision,
comp_obs_inst_tm,comp_anl_inst_tm,loinc_code,loinc_desc,external_ord_id,
result_instant_tm 
into CROWNMostafa_Projection.dbo.derived_lab_results_masked
from CROWNMostafa_Scratch.dbo.derived_lab_results pat
inner join PMAP_Analytics.dbo.CCDA2085_mostafa_csn_Mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2085_mostafa_osler_id_Mapping id on id.osler_id = pat.osler_id;


SELECT distinct id.patient_id,map.enc_ID,pat_enc_date_real,contact_date,map2.enc_ID "hx_link_enc_ID",unknown_fam_hx_yn,
tobacco_pak_per_dy,tobacco_used_years,smoking_quit_date,cigarettes_yn,pipes_yn,cigars_yn,snuff_yn,chew_yn,
tobacco_user,smokeless_tobacco_use,smokeless_quit_date,smoking_tobacco_use,smoking_start_date,tob_src,
alcohol_use,alcohol_oz_per_wk,alcohol_src,alcohol_freq,alc_freq_src,alcohol_drinks_per_day,
alc_std_drink_src,alcohol_binge,alc_binge_src,ill_drug_user,iv_drug_user_yn,illicit_drug_freq,drug_src,
female_partner_yn,male_partner_yn,condom_yn,pill_yn,diaphragm_yn,iud_yn,surgical_yn,spermicide_yn,implant_yn,
rhythm_yn,injection_yn,sponge_yn,inserts_yn,abstinence_yn,sex_src,sexually_active,years_education,
education_level,edu_level_src,fin_resource_strain,fin_resource_src,ipv_emotional_abuse,ipv_emotional_src,
ipv_fear,ipv_fear_src,ipv_sexual_abuse,ipv_sexabuse_src,ipv_physical_abuse,ipv_physabuse_src,living_w_spouse,
soc_living_src,daily_stress,daily_stress_src,phone_communication,phone_comm_src,socialization_freq,
social_freq_src,church_attendance,church_att_src,clubmtg_attendance,clubmtg_att_src,club_member,club_member_src,
phys_act_days_per_week,phys_act_dpw_src,phys_act_mins_per_sess,phys_act_mps_src,food_insecurity_scarce,
food_scarcity_src,food_insecurity_worry,food_worry_src,med_transport_needs,trans_med_src,other_transport_needs,
trans_nonmed_src
into CROWNMostafa_Projection.dbo.derived_social_history_changes_masked
from CROWNMostafa_Scratch.dbo.derived_social_history_changes pat
inner join PMAP_Analytics.dbo.CCDA2085_mostafa_csn_Mapping map on pat.pat_enc_csn_id = map.Identity_ID
left join PMAP_Analytics.dbo.CCDA2085_mostafa_csn_Mapping map2 on pat.hx_lnk_enc_csn = map2.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2085_mostafa_osler_id_Mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,mar_taken_time,medication_id,medication_name,
epic_generic_name,synth_generic_name,RxCUI,synth_med_class,synth_route,mar_route,mar_dose_value,
dose_num_value,mar_dose_unit,mar_action,mar_frequency,pharm_subclassname
into CROWNMostafa_Projection.dbo.curated_allmed_doses_masked
from CROWNMostafa_Scratch.dbo.curated_allmed_doses pat
inner join PMAP_Analytics.dbo.CCDA2085_mostafa_csn_Mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2085_mostafa_osler_id_Mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,RECORDED_TIME,Pulse,RHYTHM,SBP_cuff,DBP_cuff,
MAP_cuff,SBP_aline,DBP_aline,MAP_aline,Resp_rate,Temp_c,Temp_src,Pulse_ox_sat,Fentanyl_gtt,
Midazolam_gtt,Propofol_gtt,Dexmedetomidine_gtt,Hydromorphone_gtt,Ketamine_gtt,
Norepinephrine_gtt,Epinephrine_gtt,Phenylephrine_gtt,Dobutamine_gtt,Vasopressin_gtt,
Cisatracurium_gtt,Vecuronium_gtt,Nicardipine_gtt,Nitroglycerin_gtt,Heparin_gtt,O2_device,
FiO2_pct,Flow_Lmin,PEEP_cmH2O
into CROWNMostafa_Projection.dbo.curated_IPVitals_masked
from CROWNMostafa_Scratch.dbo.curated_IPVitals pat
inner join PMAP_Analytics.dbo.CCDA2085_mostafa_osler_id_Mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,dx_id,source_seq,dx_name,dx_group,parent_dx_id,icd9list,
icd10list,num_instances_source,last_date,first_date,sensitive_yn,build_date,dxsource
into CROWNMostafa_Projection.dbo.derived_emr_diagnosis_info_masked
from CROWNMostafa_Scratch.dbo.derived_emr_diagnosis_info pat
inner join PMAP_Analytics.dbo.CCDA2085_mostafa_osler_id_Mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,hpid,dob,[order],barcode,coldate, fuzzy_date,epi_isl,
lineage,clade,coverage,depth,quality_statement,substitutions,
deletions,missing,aa_substitutions,aa_deletions, matchstatus, confidence,
matchresults, in_crown_cohort, in_covid_positive, date_projected
into CROWNMostafa_Projection.dbo.covid_sequencing_data_masked
from [COVID_Projection].[dbo].[covid_sequence_data_linked] pat
inner join PMAP_Analytics.dbo.CCDA2085_mostafa_osler_id_Mapping id on id.osler_id = pat.osler_id;

--Update log table
INSERT INTO [CROWNMostafa_Projection].[dbo].[refresh_status]([status], refresh_date) VALUES ('SUCCESS', CURRENT_TIMESTAMP)

--Drop tables in Scratch

DROP table if exists CROWNMostafa_Scratch.dbo.covid_pmcoe_covid_positive;
DROP table if exists CROWNMostafa_Scratch.dbo.curated_covid_immunizations;
DROP table if exists CROWNMostafa_Scratch.dbo.curated_elixhauser_comorbidities;
DROP table if exists CROWNMostafa_Scratch.dbo.Curated_IPEvents;
DROP table if exists CROWNMostafa_Scratch.dbo.derived_epic_patient;
DROP table if exists CROWNMostafa_Scratch.dbo.derived_epic_vitals;
DROP table if exists CROWNMostafa_Scratch.dbo.derived_inpatient_encounters;
DROP table if exists CROWNMostafa_Scratch.dbo.derived_lab_results;
DROP table if exists CROWNMostafa_Scratch.dbo.derived_social_history_changes;
DROP table if exists CROWNMostafa_Scratch.dbo.curated_AllMed_Doses;
DROP table if exists CROWNMostafa_Scratch.dbo.curated_IPVitals;
DROP table if exists CROWNMostafa_Scratch.dbo.derived_emr_diagnosis_info;

/*
curated_elixhauser_comorbidities
*/
GO


