ALTER PROCEDURE dbo.CCDA_3087_Ray_Masking AS

/**********************************************************************************
Author:  mcook49
Date: 2022-02-22
JIRA: CCDA-3087
Description: To run after the projection of CROWNRay data, masking the data for the study team
     
Revision History:
Date            Author          JIRA            Comment
***********************************************************************************/

SET NOCOUNT ON;

--Drop tables that will be re-loaded
Drop table if exists PMAP_Analytics.dbo.CCDA3087_Ray_csn_Mapping;
Drop table if exists PMAP_Analytics.dbo.CCDA3087_Ray_osler_id_Mapping;
Drop table if exists PMAP_Analytics.dbo.CCDA3087_Ray_order_proc_id_Mapping;
DROP table if exists CROWNRay_Projection.dbo.derived_epic_patient_masked;
DROP table if exists CROWNRay_Projection.dbo.covid_pmcoe_covid_positive_masked;
DROP table if exists CROWNRay_Projection.dbo.derived_encounter_dx_masked;
DROP table if exists CROWNRay_Projection.dbo.derived_problem_list_masked;
DROP table if exists CROWNRay_Projection.dbo.derived_hosp_billing_dx_masked;
DROP table if exists CROWNRay_Projection.dbo.derived_infections_masked;
DROP table if exists CROWNRay_Projection.dbo.derived_outpatient_encounters_masked;
DROP table if exists CROWNRay_Projection.dbo.derived_inpatient_encounters_masked;
DROP table if exists CROWNRay_Projection.dbo.derived_lab_results_masked;
DROP table if exists CROWNRay_Projection.dbo.derived_epic_vitals_masked;
DROP table if exists CROWNRay_Projection.dbo.derived_micro_sensitivities_masked;
DROP table if exists CROWNRay_Projection.dbo.Curated_IPEvents_masked;
DROP table if exists CROWNRay_Projection.dbo.derived_med_admin_masked;
DROP table if exists CROWNRay_Projection.dbo.derived_emr_diagnosis_info_masked;
DROP table if exists CROWNRay_Projection.dbo.covid_pmcoe_convalescent_plasma_masked;
DROP table if exists CROWNRay_Projection.dbo.curated_elixhauser_comorbidities_masked;
DROP table if exists CROWNRay_Projection.dbo.curated_who_status_masked;
DROP table if exists CROWNRay_Projection.dbo.derived_med_orders_masked;
DROP table if exists CROWNRay_Projection.dbo.derived_medical_hx_summary_masked;
DROP table if exists CROWNRay_Projection.dbo.derived_order_questionnaires_masked;
DROP table if exists CROWNRay_Projection.dbo.derived_geocode_census_variables_masked;
DROP table if exists CROWNRay_Projection.dbo.derived_epic_all_encounters_masked;
DROP table if exists CROWNRay_Projection.dbo.edw_geocode_patient_visit_masked;

--Create mapping tables

--CSN
SELECT 
	a.*
	--,'Pat_'+ cast(ROW_NUMBER() OVER (ORDER BY A.IDENTITY_ID) as varchar) as 'Masked ID'
	,ROW_NUMBER() OVER (ORDER BY A.IDENTITY_ID) as 'enc_ID'
	into PMAP_Analytics.dbo.CCDA3087_Ray_csn_Mapping
FROM (
	SELECT DISTINCT
		t.pat_enc_csn_id "Identity_ID"
	FROM (
		select distinct osler_id, pat_enc_csn_id
		from CROWNRay_Projection.dbo.derived_inpatient_encounters
		union 
		select distinct osler_id, pat_enc_csn_id
		from CROWNRay_Projection.dbo.derived_lab_results
		union
		select distinct osler_id, pat_enc_csn_id
		from CROWNRay_Projection.dbo.derived_outpatient_encounters
		union
		select distinct osler_id, pat_enc_csn_id
		from CROWNRay_Projection.dbo.derived_hosp_billing_dx
		union
		select distinct osler_id, pat_enc_csn_id
		from CROWNRay_Projection.dbo.derived_epic_vitals
		union
		select distinct osler_id, pat_enc_csn_id
		from CROWNRay_Projection.dbo.derived_med_orders
		union
		select distinct osler_id, pat_enc_csn_id
		from CROWNRay_Projection.dbo.covid_pmcoe_convalescent_plasma
	) t
	WHERE t.pat_enc_csn_id is not null
 )a;

 --osler_id
  SELECT 
	a.*
	--,'Pat_'+ cast(ROW_NUMBER() OVER (ORDER BY A.IDENTITY_ID) as varchar) as 'Masked ID'
	,ROW_NUMBER() OVER (ORDER BY A.osler_id) as 'patient_id'
	into PMAP_Analytics.dbo.CCDA3087_Ray_osler_id_Mapping
FROM (
	SELECT DISTINCT
		osler_id
	FROM CROWNRay_Projection.dbo.derived_epic_patient
 )A;

  --order_proc_id
  SELECT 
	A.*
	,ROW_NUMBER() OVER (ORDER BY A.order_proc_id) as 'order_id'
	into PMAP_Analytics.dbo.CCDA3087_Ray_order_proc_id_Mapping
FROM (
	SELECT DISTINCT
	t.order_proc_id
	FROM (
	SELECT distinct order_proc_id
	FROM CROWNRay_Projection.dbo.covid_pmcoe_convalescent_plasma
	union
	SELECT distinct order_proc_id
	FROM CROWNRay_Projection.dbo.derived_lab_results
	union
	SELECT distinct order_proc_id
	FROM CROWNRay_Projection.dbo.derived_micro_sensitivities
	union
	SELECT distinct order_proc_id
	FROM CROWNRay_Projection.dbo.derived_order_questionnaires
	) t
	WHERE t.order_proc_id is not null
 )A;

 --Load tables
 select id.patient_id,pat.birth_date,pat.pat_status,pat.death_date,pat.gender,
genderabbr,ethnic_group,pat.first_race,racew,raceb,racei,racea,
racep,raceo,racerf,raceu,racetwo,racedec,raceh,language,first_contact,last_contact,
next_contact,primaryloc_id,primaryloc_name,intrptr_needed_yn
into CROWNRay_Projection.dbo.derived_epic_patient_masked
from CROWNRay_Projection.dbo.derived_epic_patient pat
inner join PMAP_Analytics.dbo.CCDA3087_Ray_osler_id_Mapping id on id.osler_id = pat.osler_id
order by id.patient_id;

SELECT id.patient_id,first_race,gender,age_at_positive,
pat_status,death_date,initial_dx_date,infection_add_date,
positive_collection_date,positive_result_date,rsltdt_infadd_hour_interval,initial_dx_source 
into CROWNRay_Projection.dbo.covid_pmcoe_covid_positive_masked
from CROWNRay_Projection.dbo.covid_pmcoe_covid_positive pat
inner join PMAP_Analytics.dbo.CCDA3087_Ray_osler_id_Mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,pat_enc_date_real,map.enc_ID,
adt_pat_class_c,adt_pat_class,adt_patient_stat_c,adt_patient_stat,
pending_disch_time,exp_admission_time,exp_len_of_stay,admit_source_c,
admit_source,delivery_type_c,delivery_type,labor_status_c,labor_status,
adt_arrival_time,hosp_admsn_time,hosp_disch_time,hosp_admsn_type_c,
hosp_admsn_type,department_id,dept_name,dept_abbreviation,dep_speciality,
dep_rpt_grp_ten,disch_disp_c,disc_disp,contact_date,inp_adm_date,ed_departure_time,
op_adm_date,emer_adm_date,hospital_service,ed_visit_yn,serv_area_name 
into CROWNRay_Projection.dbo.derived_inpatient_encounters_masked
from CROWNRay_Projection.dbo.derived_inpatient_encounters pat
inner join PMAP_Analytics.dbo.CCDA3087_Ray_csn_Mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3087_Ray_osler_id_Mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,
line,dx_id,dx_name,dx_group,parent_dx_id,parent_dx_name,
icd10_code,icd9_code,current_icd10_list,current_icd9_list,
enc_contact_date,annotation,dx_qualifier,dx_qualifier_c,
primary_dx_yn,comments,dx_chronic_yn,
dx_unique,dx_ed_yn,dx_link_prob_id
into CROWNRay_Projection.dbo.derived_encounter_dx_masked
from CROWNRay_Projection.dbo.derived_encounter_dx pat
inner join PMAP_Analytics.dbo.CCDA3087_Ray_csn_Mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3087_Ray_osler_id_Mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,problem_list_id,dx_id,dx_name,dx_group,parent_dx_id,
parent_dx_name,icd10_code,icd9_code,problem_status,class_of_problem,
[priority],treat_summ_stat,noted_date,noted_end_date,resolved_date,
date_of_entry,chronic_yn,principal_pl_yn,overview_note_id,creating_order_id,
problem_status_c,class_of_problem_c,priority_c,treat_summ_status_c,
current_icd10_list,current_icd9_list
into CROWNRay_Projection.dbo.derived_problem_list_masked
from CROWNRay_Projection.dbo.derived_problem_list pat
inner join PMAP_Analytics.dbo.CCDA3087_Ray_osler_id_Mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,hsp_account_id,line,map.enc_ID,dx_id,dx_name,
dx_group,icd10_code,icd9_code,current_icd10_list,current_icd9_list,
dx_affects_drg_yn,dx_comorbidity_yn,final_dx_soi_c,severity_of_illness,
final_dx_rom_c,risk_of_mortality,final_dx_excld_yn,fnl_dx_afct_soi_yn,
fnl_dx_afct_rom_yn,final_dx_poa_c,present_on_admission,dx_comorbidity_c,
comorbidity_exists,dx_hac_yn,dx_type_c,diagnosis_type,dx_start_dt,
dx_end_dt,dx_problem_id,dx_chronic_flag_yn,dx_supp_atc_code_c,atc_dx_name,
dx_hsp_prob_flag_yn,dx_overridden_dx_id,dx_disproven_yn,dk_cancer_status_c,
cancer_status,fnl_dx_qualifier_c,dx_qualifier,term_dx_id,adm_date_time
into CROWNRay_Projection.dbo.derived_hosp_billing_dx_masked
from CROWNRay_Projection.dbo.derived_hosp_billing_dx pat
inner join PMAP_Analytics.dbo.CCDA3087_Ray_csn_Mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3087_Ray_osler_id_Mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,infection_id,infection_record_type,infection_type,infection_status,
how_added,add_utc_dttm,resolve_utc_dttm,expiration_date,doesnt_expire_yn,onset_date,
specimen_type,specimen_source,record_creation_date,infection_type_c,inf_status_c,
how_added_c,specimen_type_c,specimen_source_c
into CROWNRay_Projection.dbo.derived_infections_masked
from CROWNRay_Projection.dbo.derived_infections pat
inner join PMAP_Analytics.dbo.CCDA3087_Ray_osler_id_Mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,pat_enc_date_real,map.enc_ID,contact_date,enc_type_c,enc_type,
department_id,department_name,dept_specialty,dept_rpt_grp_ten,dept_rev_loc_id,
eff_dept_id,eff_dept_name,eff_dept_specialty,eff_dept_rpt_grp_ten,eff_dept_rev_loc_id,
appt_time,appt_status_c,appointment_status,appt_prc_id,appt_visit_type,appt_visit_abbr,
appt_cancel_date,los_proc_code,los_proc_name,lmp_date,lmp_other,
hsp_account_id,referral_id,referral_source_id,bp_systolic,bp_diastolic,temperature,
pulse,[weight],height,respirations,bmi,bsa,inpatient_data_id,update_date,sensitive_yn,
facility,is_historical,has_vitals,contact_year
into CROWNRay_Projection.dbo.derived_outpatient_encounters_masked
from CROWNRay_Projection.dbo.derived_outpatient_encounters pat
inner join PMAP_Analytics.dbo.CCDA3087_Ray_csn_Mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3087_Ray_osler_id_Mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,ord.order_id,proc_code,proc_name,proc_cat_id,
proc_cat_name,sensitive_yn,order_type,lab_group,resulting_lab,order_time,
result_time,specimen_taken_time,specimen_recv_time,order_results_line,
component_id,component_name,component_base_name,component_type,
component_subtype,component_lab_subtype,result_flag,order_status,
result_status,lab_status,ord_value,ord_num_value,reference_low,
reference_high,reference_unit,result_sub_idn,result_in_range_yn,
ref_normal_vals,lrr_based_organ_id,data_type,numeric_precision,
comp_obs_inst_tm,comp_anl_inst_tm,loinc_code,loinc_desc,external_ord_id,
result_instant_tm 
into CROWNRay_Projection.dbo.derived_lab_results_masked
from CROWNRay_Projection.dbo.derived_lab_results pat
inner join PMAP_Analytics.dbo.CCDA3087_Ray_csn_Mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3087_Ray_order_proc_id_Mapping ord on pat.order_proc_id = ord.order_proc_id
inner join PMAP_Analytics.dbo.CCDA3087_Ray_osler_id_Mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,inpatient_data_id,recorded_time,
entry_time,meas_value,meas_name,meas_disp_name,meas_id,meas_row_type,
meas_val_type,meas_row_type_c,meas_val_type_c,meas_template_id,
template_display_name,meas_line,enc_contact_date,enc_dept_id,enc_type,
enc_type_c,lastupdate_dttm 
into CROWNRay_Projection.dbo.derived_epic_vitals_masked
from CROWNRay_Projection.dbo.derived_epic_vitals pat
inner join PMAP_Analytics.dbo.CCDA3087_Ray_csn_Mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3087_Ray_osler_id_Mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,ord.order_id,line,specimen_taken_time,specimen_recv_time,
organism_name,antibiotic,susceptibility,sensitivity_value,sensitivity_units,
sens_organism_sid,sens_obs_inst_tm,sens_anl_inst_tm,result_detail,ordered_lab,
component_name,specimen_source,specimen_type,order_type,result_status,result_flag,
lab_status,antibiotic_loinc_code,method_loinc_code,sens_method_name,proc_id,
map.enc_ID,order_type_c,specimen_source_c,specimen_type_c,organism_id,antibiotic_c,
suscept_c,lab_status_c,sens_status_c,sens_method_id,antibio_lnc_id,method_lnc_id,
component_id,result_flag_c
into CROWNRay_Projection.dbo.derived_micro_sensitivities_masked
from CROWNRay_Projection.dbo.derived_micro_sensitivities pat
inner join PMAP_Analytics.dbo.CCDA3087_Ray_csn_Mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3087_Ray_order_proc_id_Mapping ord on pat.order_proc_id = ord.order_proc_id
inner join PMAP_Analytics.dbo.CCDA3087_Ray_osler_id_Mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,AGE,SEX_C,RACE_C,HISPANIC_C,POSITIVE_TEST_TIME,
map.enc_ID "INIT_ENC_ID",ADMIT_TIME,ADMIT_SOURCE_C,ADMIT_SOURCE_NAME,
TRANSFER_FROM_C,TRANSFER_FROM_NAME,INIT_HOSP_LOC_ABBR,map2.enc_ID "LINKED_ENC_ID",
TRANSFER_TIME,OXYGEN_RX,INT_DIALYSIS_RX,NIPPV_RX,HIFLOW_RX,VENT_START,
IVPRESSOR_RX,CRRT_RX,ECMO_RX,ECMO_END,TRACH_DTM,CHEST_TUBE_DTM,
convalescent_plasma_dtm,VENT_END,IVPRESSOR_END,HIFLOW_END,NIPPV_END,
CRRT_END,INT_DIALYSIS_END,OXYGEN_END,INIT_DNR_DNI,FINAL_HOSP_DISCH_TIME,
FINAL_DISCH_DISP_C,FINAL_DISCH_DISP_NAME,DEATH_TIME 
into CROWNRay_Projection.dbo.Curated_IPEvents_masked
from CROWNRay_Projection.dbo.Curated_IPEvents pat
inner join PMAP_Analytics.dbo.CCDA3087_Ray_csn_Mapping map on pat.INIT_PAT_ENC_CSN_ID = map.Identity_ID
left join PMAP_Analytics.dbo.CCDA3087_Ray_csn_Mapping map2 on pat.LINKED_CSN = map2.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3087_Ray_osler_id_Mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,order_med_id,line,hosp_admsn_time,hosp_disch_time,
medication_name,generic_name,medication_id,thera_classname,pharm_classname,pharm_subclassname
,taken_time,ordering_date,order_end_time,scheduled_time,saved_time,mar_time_source,
mar_action,route,sig,site,dose_unit,infusion_rate,mar_inf_rate_unit,mar_duration,
duration_unit,frequency,freq_period,freq_type,number_of_times,time_unit,now_yn,
reason,mar_imm_link_id,mar_admin_dept,mar_ord_dat,
pat_supplied_yn,sensitive_yn,mar_action_c
into CROWNRay_Projection.dbo.derived_med_admin_masked
from CROWNRay_Projection.dbo.derived_med_admin pat
inner join PMAP_Analytics.dbo.CCDA3087_Ray_csn_Mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3087_Ray_osler_id_Mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,dx_id,source_seq,dx_name,dx_group,parent_dx_id,
icd9list,icd10list,num_instances_source,last_date,first_date,sensitive_yn,build_date,dxsource
into CROWNRay_Projection.dbo.derived_emr_diagnosis_info_masked
from CROWNRay_Projection.dbo.derived_emr_diagnosis_info pat
inner join PMAP_Analytics.dbo.CCDA3087_Ray_osler_id_Mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,ord.order_id,result_sub_idn,proc_id,proc_name,blood_unit_num,
blood_product_code,blood_start_instant,blood_end_instant,result_time,issue_time,
lab_blood_status,lab_blood_type,lab_product_type,trans_or_prep_order_amt,
trans_or_prep_order_units,authorizing_prov_id,enc_department_id,enc_department,
serv_area_id,enc_type,enc_contact_date,
instance_status,row_type,study_enrollments
into CROWNRay_Projection.dbo.covid_pmcoe_convalescent_plasma_masked
from CROWNRay_Projection.dbo.covid_pmcoe_convalescent_plasma pat
inner join PMAP_Analytics.dbo.CCDA3087_Ray_csn_Mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3087_Ray_order_proc_id_Mapping ord on pat.order_proc_id = ord.order_proc_id
inner join PMAP_Analytics.dbo.CCDA3087_Ray_osler_id_Mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,el_depress,el_anemdef,el_htn,el_wghtloss,el_lymph,
el_coag,el_alcohol,el_chf,el_renlfail,el_perivasc,el_tumor,el_aids,
el_para,el_pulmcirc,el_htncx,el_ulcer,el_psych,el_obese,el_bldloss,
el_chrnlung,el_drug,el_hypothy,el_mets,el_lytes,el_liver,el_arth,
el_neuro,el_dmcx,el_valve,el_dm,icd10 
into CROWNRay_Projection.dbo.curated_elixhauser_comorbidities_masked
from CROWNRay_Projection.dbo.curated_elixhauser_comorbidities pat
inner join PMAP_Analytics.dbo.CCDA3087_Ray_osler_id_Mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,map2.enc_ID "linked_csn",[event],
[start],[end],who_score_numeric,who_score_grouped,who_score
into CROWNRay_Projection.dbo.curated_who_status_masked
from CROWNRay_Projection.dbo.curated_who_status pat
inner join PMAP_Analytics.dbo.CCDA3087_Ray_csn_Mapping map on pat.pat_enc_csn_id = map.Identity_ID
left join PMAP_Analytics.dbo.CCDA3087_Ray_csn_Mapping map2 on pat.LINKED_CSN = map2.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3087_Ray_osler_id_Mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,MedName,MedDisplayName,Dose,Frequency,Sig,OrderingDate,
OrderType,StartDate,EndDate,DiscontinuationReason,TheraClass,PharmClass,PharmSubClass,CurrentMed
into CROWNRay_Projection.dbo.derived_med_orders_masked
from CROWNRay_Projection.dbo.derived_med_orders pat
inner join PMAP_Analytics.dbo.CCDA3087_Ray_csn_Mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3087_Ray_osler_id_Mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,medical_hx_date,med_hx_start_dt,med_hx_end_dt,dx_id,
dx_name,dx_group,parent_dx_name,icd10_code,icd9_code
into CROWNRay_Projection.dbo.derived_medical_hx_summary_masked
from CROWNRay_Projection.dbo.derived_medical_hx_summary pat
inner join PMAP_Analytics.dbo.CCDA3087_Ray_osler_id_Mapping id on id.osler_id = pat.osler_id;


SELECT id.patient_id,map.enc_ID,ord.order_id,order_status_c,order_status,lab_status_c,
lab_status,order_inst,result_time,enc_type,proc_name,proc_code,line,ord_quest_id,
ord_quest_date,quest_name,question,ord_quest_resp,is_answr_byproc_yn,ord_quest_cmt,
question_type_c,question_type,record_state,lastupdate_dttm
into CROWNRay_Projection.dbo.derived_order_questionnaires_masked
from CROWNRay_Projection.dbo.derived_order_questionnaires pat
inner join PMAP_Analytics.dbo.CCDA3087_Ray_csn_Mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3087_Ray_order_proc_id_Mapping ord on pat.order_proc_id = ord.order_proc_id
inner join PMAP_Analytics.dbo.CCDA3087_Ray_osler_id_Mapping id on id.osler_id = pat.osler_id;


SELECT id.patient_id,postal_code,block_group,variable_name,
variable_name_clean,estimate_value,last_updated
into CROWNRay_Projection.dbo.derived_geocode_census_variables_masked
from CROWNRay_Projection.dbo.derived_geocode_census_variables pat
inner join PMAP_Analytics.dbo.CCDA3087_Ray_osler_id_Mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,contact_date,pat_enc_date_real,enc_type_c,enc_type,appt_visit_type_id,
appt_visit_type,appt_status_c,appointment_status,sensitive_yn,is_historical,inpatient_flag,
adt_pat_class_c,adt_pat_class,hosp_admission_type_c,hosp_admission_type,department_id,
department_name,visit_pos_id,place_of_service,serv_area_id,eff_dept_id,eff_dept_name,referral_source_id,
referral_source_name,appt_time,appt_status_date,hosp_admission_time,hosp_discharge_time,
effective_date_dttm,inpatient_data_id,appt_serial_no,ip_episode_id,primary_team_id,research_study_id,
referral_id,order_proc_count,order_med_count,has_hospital_enc,facility
into CROWNRay_Projection.dbo.derived_epic_all_encounters_masked
from CROWNRay_Projection.dbo.derived_epic_all_encounters pat
inner join PMAP_Analytics.dbo.CCDA3087_Ray_csn_Mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3087_Ray_osler_id_Mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,encounter_date,enc_type,city,state_or_province,
postal_code,zip_plus4_x,block_group,HHI,last_update_dttm
into CROWNRay_Projection.dbo.edw_geocode_patient_visit_masked
from CROWNRay_Projection.dbo.edw_geocode_patient_visit pat
inner join PMAP_Analytics.dbo.CCDA3087_Ray_csn_Mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3087_Ray_osler_id_Mapping id on id.osler_id = pat.osler_id;

--Update log table
INSERT INTO [CROWNRay_Projection].[dbo].[refresh_status]([status], refresh_date) VALUES ('SUCCESS', CURRENT_TIMESTAMP)

--Drop base tables

DROP table if exists CROWNRay_Projection.dbo.derived_epic_patient;
DROP table if exists CROWNRay_Projection.dbo.covid_pmcoe_covid_positive;
DROP table if exists CROWNRay_Projection.dbo.derived_encounter_dx;
DROP table if exists CROWNRay_Projection.dbo.derived_problem_list;
DROP table if exists CROWNRay_Projection.dbo.derived_hosp_billing_dx;
DROP table if exists CROWNRay_Projection.dbo.derived_infections;
DROP table if exists CROWNRay_Projection.dbo.derived_outpatient_encounters;
DROP table if exists CROWNRay_Projection.dbo.derived_inpatient_encounters;
DROP table if exists CROWNRay_Projection.dbo.derived_lab_results;
DROP table if exists CROWNRay_Projection.dbo.derived_epic_vitals;
DROP table if exists CROWNRay_Projection.dbo.derived_micro_sensitivities;
DROP table if exists CROWNRay_Projection.dbo.Curated_IPEvents;
DROP table if exists CROWNRay_Projection.dbo.derived_med_admin;
DROP table if exists CROWNRay_Projection.dbo.derived_emr_diagnosis_info;
DROP table if exists CROWNRay_Projection.dbo.covid_pmcoe_convalescent_plasma;
DROP table if exists CROWNRay_Projection.dbo.curated_elixhauser_comorbidities;
DROP table if exists CROWNRay_Projection.dbo.curated_who_status;
DROP table if exists CROWNRay_Projection.dbo.derived_med_orders;
DROP table if exists CROWNRay_Projection.dbo.derived_medical_hx_summary;
DROP table if exists CROWNRay_Projection.dbo.derived_reason_for_testing;
DROP table if exists CROWNRay_Projection.dbo.derived_geocode_census_variables;
DROP table if exists CROWNRay_Projection.dbo.derived_order_questionnaires;
DROP table if exists CROWNRay_Projection.dbo.derived_epic_all_encounters;
DROP table if exists CROWNRay_Projection.dbo.edw_geocode_patient_visit;
