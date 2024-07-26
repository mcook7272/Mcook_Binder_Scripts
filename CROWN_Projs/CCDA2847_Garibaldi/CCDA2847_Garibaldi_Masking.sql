USE [PMAP_Analytics]

--Drop tables that will be re-loaded
Drop table if exists PMAP_Analytics.dbo.CCDA2847_Garibaldi_csn_Mapping;
Drop table if exists PMAP_Analytics.dbo.CCDA2847_Garibaldi_osler_id_Mapping;
DROP table if exists CROWNGaribaldiIRB00293957_Projection.dbo.covid_pmcoe_convalescent_plasma_masked;
DROP table if exists CROWNGaribaldiIRB00293957_Projection.dbo.covid_pmcoe_covid_positive_masked;
DROP table if exists CROWNGaribaldiIRB00293957_Projection.dbo.curated_covid_immunizations_masked;
DROP table if exists CROWNGaribaldiIRB00293957_Projection.dbo.curated_elixhauser_comorbidities_masked;
DROP table if exists CROWNGaribaldiIRB00293957_Projection.dbo.curated_Inflam_Markers_masked;
DROP table if exists CROWNGaribaldiIRB00293957_Projection.dbo.Curated_IPEvents_masked;
DROP table if exists CROWNGaribaldiIRB00293957_Projection.dbo.curated_who_status_masked;
DROP table if exists CROWNGaribaldiIRB00293957_Projection.dbo.derived_encounter_dx_masked;
DROP table if exists CROWNGaribaldiIRB00293957_Projection.dbo.derived_epic_patient_masked;
DROP table if exists CROWNGaribaldiIRB00293957_Projection.phi.derived_epic_patient_masked;
DROP table if exists CROWNGaribaldiIRB00293957_Projection.dbo.derived_hosp_billing_dx_masked;
DROP table if exists CROWNGaribaldiIRB00293957_Projection.dbo.derived_hosp_billing_px_masked;
DROP table if exists CROWNGaribaldiIRB00293957_Projection.dbo.derived_inpatient_encounters_masked;
DROP table if exists CROWNGaribaldiIRB00293957_Projection.dbo.derived_lab_results_masked;
DROP table if exists CROWNGaribaldiIRB00293957_Projection.dbo.derived_med_admin_masked;
DROP table if exists CROWNGaribaldiIRB00293957_Projection.dbo.derived_med_orders_masked;
DROP table if exists CROWNGaribaldiIRB00293957_Projection.dbo.derived_medical_hx_summary_masked;
DROP table if exists CROWNGaribaldiIRB00293957_Projection.dbo.derived_problem_list_masked;
DROP table if exists CROWNGaribaldiIRB00293957_Projection.dbo.derived_profee_billing_px_masked;


--Create mapping tables

--CSN
SELECT 
	a.*
	--,'Pat_'+ cast(ROW_NUMBER() OVER (ORDER BY A.IDENTITY_ID) as varchar) as 'Masked ID'
	,ROW_NUMBER() OVER (ORDER BY A.IDENTITY_ID) as 'enc_ID'
	into PMAP_Analytics.dbo.CCDA2847_garibaldi_csn_mapping
FROM (
	SELECT DISTINCT
		t.pat_enc_csn_id "Identity_ID"
	FROM (
		select distinct osler_id, pat_enc_csn_id
		from CROWNGaribaldiIRB00293957_Scratch.dbo.derived_inpatient_encounters
		union 
		select distinct osler_id, pat_enc_csn_id
		from CROWNGaribaldiIRB00293957_Scratch.dbo.derived_hosp_billing_dx
		union 
		select distinct osler_id, pat_enc_csn_id
		from CROWNGaribaldiIRB00293957_Scratch.dbo.derived_lab_results
		union 
		select distinct osler_id, jab1_csn "pat_enc_csn_id"
		from CROWNGaribaldiIRB00293957_Scratch.dbo.curated_covid_immunizations
		union 
		select distinct osler_id, jab2_csn "pat_enc_csn_id"
		from CROWNGaribaldiIRB00293957_Scratch.dbo.curated_covid_immunizations
		union 
		select distinct osler_id, pat_enc_csn_id
		from CROWNGaribaldiIRB00293957_Scratch.dbo.curated_Inflam_Markers
		union
		select distinct osler_id, pat_enc_csn_id
		from CROWNGaribaldiIRB00293957_Scratch.dbo.derived_hosp_billing_px	
		union
		select distinct osler_id, pat_enc_csn_id
		from CROWNGaribaldiIRB00293957_Scratch.dbo.derived_med_orders
	) t
	WHERE t.pat_enc_csn_id is not null
 )a;

 --osler_id
  SELECT 
	a.*
	--,'Pat_'+ cast(ROW_NUMBER() OVER (ORDER BY A.IDENTITY_ID) as varchar) as 'Masked ID'
	,ROW_NUMBER() OVER (ORDER BY A.osler_id) as 'patient_id'
	into PMAP_Analytics.dbo.CCDA2847_garibaldi_osler_id_mapping
FROM (
	SELECT DISTINCT
		osler_id, birth_date
	from CROWNGaribaldiIRB00293957_Scratch.dbo.derived_epic_patient
 )A;

 --Load tables
 select id.patient_id,emrn,jhhmrn,bmcmrn,hcgmrn,smhmrn,shmrn,pat.birth_date,pat_status,
 death_date,gender,genderabbr,ethnic_group,first_race,racew,raceb,racei,racea,racep,
 raceo,racerf,raceu,racetwo,racedec,raceh,language,first_contact,last_contact,
 next_contact,primaryloc_id,primaryloc_name,intrptr_needed_yn
into CROWNGaribaldiIRB00293957_Projection.phi.derived_epic_patient_masked
from CROWNGaribaldiIRB00293957_Scratch.dbo.derived_epic_patient pat
inner join PMAP_Analytics.dbo.CCDA2847_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id
order by id.patient_id;

 select id.patient_id,pat.birth_date,pat_status,
 death_date,gender,genderabbr,ethnic_group,first_race,racew,raceb,racei,racea,racep,
 raceo,racerf,raceu,racetwo,racedec,raceh,language,first_contact,last_contact,
 next_contact,primaryloc_id,primaryloc_name,intrptr_needed_yn
into CROWNGaribaldiIRB00293957_Projection.dbo.derived_epic_patient_masked
from CROWNGaribaldiIRB00293957_Scratch.dbo.derived_epic_patient pat
inner join PMAP_Analytics.dbo.CCDA2847_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id
order by id.patient_id;

SELECT id.patient_id,map.enc_ID,result_sub_idn,proc_id,proc_name,
blood_unit_num,blood_product_code,blood_start_instant,blood_end_instant,result_time,
issue_time,lab_blood_status,lab_blood_type,lab_product_type,trans_or_prep_order_amt,
trans_or_prep_order_units,authorizing_prov_id,enc_department_id,
enc_department,primary_loc_id,enc_primary_location,serv_area_id,enc_type,
enc_contact_date,instance_status,row_type,study_enrollments 
INTO CROWNGaribaldiIRB00293957_Projection.dbo.covid_pmcoe_convalescent_plasma_masked
from CROWNGaribaldiIRB00293957_Scratch.dbo.covid_pmcoe_convalescent_plasma pat
inner join PMAP_Analytics.dbo.CCDA2847_garibaldi_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2847_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;


SELECT id.patient_id,first_race,gender,age_at_positive,
pat_status,death_date,initial_dx_date,infection_add_date,
positive_collection_date,positive_result_date,rsltdt_infadd_hour_interval,initial_dx_source 
INTO CROWNGaribaldiIRB00293957_Projection.dbo.covid_pmcoe_covid_positive_masked
from CROWNGaribaldiIRB00293957_Scratch.dbo.covid_pmcoe_covid_positive pat
inner join PMAP_Analytics.dbo.CCDA2847_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT distinct id.patient_id,jab1_immune_id,jab1_immune_date,jab1_immunzatn_id,jab1_immune_type,
jab1_imm_historic_adm_yn,jab2_immune_id,jab2_immune_date,jab2_immunzatn_id,jab2_immune_type,
jab2_imm_historic_adm_yn,jab1_jab2_interval_days,map.enc_ID "jab1_enc_ID",jab1_entry_date,jab1_update_date,
jab2_entry_date,jab2_update_date,map2.enc_ID "jab2_enc_ID",jab1_contact_date_real,jab1_line,jab2_contact_date_real,jab2_line
INTO CROWNGaribaldiIRB00293957_Projection.dbo.curated_covid_immunizations_masked
from CROWNGaribaldiIRB00293957_Scratch.dbo.curated_covid_immunizations pat
left join PMAP_Analytics.dbo.CCDA2847_garibaldi_csn_mapping map on pat.jab1_csn = map.Identity_ID
left join PMAP_Analytics.dbo.CCDA2847_garibaldi_csn_mapping map2 on pat.jab2_csn = map2.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2847_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,el_depress,el_anemdef,el_htn,el_wghtloss,el_lymph,
el_coag,el_alcohol,el_chf,el_renlfail,el_perivasc,el_tumor,el_aids,
el_para,el_pulmcirc,el_htncx,el_ulcer,el_psych,el_obese,el_bldloss,
el_chrnlung,el_drug,el_hypothy,el_mets,el_lytes,el_liver,el_arth,
el_neuro,el_dmcx,el_valve,el_dm,icd10 
INTO CROWNGaribaldiIRB00293957_Projection.dbo.curated_elixhauser_comorbidities_masked
from CROWNGaribaldiIRB00293957_Scratch.dbo.curated_elixhauser_comorbidities pat
inner join PMAP_Analytics.dbo.CCDA2847_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,specimen_taken_time,specimen_recv_time,
specimen_id,CRP_ord_value,CRP_ord_num_value,CRP_rslt_flag,ESR_ord_value,
ESR_ord_num_value,ESR_rslt_flag,Ferritin_ord_value,Ferritin_ord_num_value,
Ferritin_rslt_flag,DDimer_ord_value,DDimer_ord_num_value,DDimer_rslt_flag,
Fibrinogen_ord_value,Fibrinogen_ord_num_value,Fibrinogen_rslt_flag,TroponinI_ord_value,
TroponinI_ord_num_value,TroponinI_rslt_flag,TroponinT_ord_value,TroponinT_ord_num_value,
TroponinT_rslt_flag,LDH_ord_value,LDH_ord_num_value,LDH_rslt_flag,Il6_ord_value,
Il6_ord_num_value,Il6_rslt_flag,WBC_ord_value,WBC_ord_num_value,WBC_rslt_flag,
Lymphabs_ord_value,Lymphabs_ord_num_value,Lymphabs_rslt_flag,Platelets_ord_value,
Platelets_ord_num_value,Platelets_rslt_flag,INR_ord_value,INR_ord_num_value,INR_rslt_flag,
ProtCActiv_ord_value,ProtCActiv_ord_num_value,ProtCActiv_rslt_flag,ProtSActiv_Ord_value,
ProtSActiv_ord_num_value,ProtSActiv_rslt_flag,AT3Activ_ord_value,AT3Activ_ord_num_value,
AT3Activ_rslt_flag,VWFRIST_ord_value,VWFRIST_ord_num_value,VWFRIST_rslt_flag,AntiXaHep_ord_value,
AntiXaHep_ord_num_value,AntiXaHep_rslt_flag,AntiXaLMWH_ord_value,AntiXaLMWH_ord_num_value,AntiXaLMWH_rslt_flag 
INTO CROWNGaribaldiIRB00293957_Projection.dbo.curated_Inflam_Markers_masked
from CROWNGaribaldiIRB00293957_Scratch.dbo.curated_Inflam_Markers pat
inner join PMAP_Analytics.dbo.CCDA2847_garibaldi_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2847_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,AGE,SEX_C,RACE_C,HISPANIC_C,POSITIVE_TEST_TIME,
map.enc_ID "INIT_ENC_ID",ADMIT_TIME,ADMIT_SOURCE_C,ADMIT_SOURCE_NAME,
TRANSFER_FROM_C,TRANSFER_FROM_NAME,INIT_HOSP_LOC_ABBR,map2.enc_ID "LINKED_ENC_ID",
TRANSFER_TIME,OXYGEN_RX,INT_DIALYSIS_RX,NIPPV_RX,HIFLOW_RX,VENT_START,
IVPRESSOR_RX,CRRT_RX,ECMO_RX,ECMO_END,TRACH_DTM,CHEST_TUBE_DTM,
convalescent_plasma_dtm,VENT_END,IVPRESSOR_END,HIFLOW_END,NIPPV_END,
CRRT_END,INT_DIALYSIS_END,OXYGEN_END,INIT_DNR_DNI,FINAL_HOSP_DISCH_TIME,
FINAL_DISCH_DISP_C,FINAL_DISCH_DISP_NAME,DEATH_TIME 
INTO CROWNGaribaldiIRB00293957_Projection.dbo.Curated_IPEvents_masked
from CROWNGaribaldiIRB00293957_Scratch.dbo.Curated_IPEvents pat
inner join PMAP_Analytics.dbo.CCDA2847_garibaldi_csn_mapping map on pat.INIT_PAT_ENC_CSN_ID = map.Identity_ID
left join PMAP_Analytics.dbo.CCDA2847_garibaldi_csn_mapping map2 on pat.LINKED_CSN = map2.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2847_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,map2.enc_ID "linked_enc_ID",[event],[start],
[end],who_score_numeric,who_score_grouped,who_score 
INTO CROWNGaribaldiIRB00293957_Projection.dbo.curated_who_status_masked
from CROWNGaribaldiIRB00293957_Scratch.dbo.curated_who_status pat
inner join PMAP_Analytics.dbo.CCDA2847_garibaldi_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
left join PMAP_Analytics.dbo.CCDA2847_garibaldi_csn_mapping map2 on pat.LINKED_CSN = map2.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2847_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;


SELECT id.patient_id,map.enc_ID,line,dx_id,dx_name,dx_group,parent_dx_id,
parent_dx_name,icd10_code,icd9_code,current_icd10_list,current_icd9_list,
enc_contact_date,dx_qualifier,dx_qualifier_c,primary_dx_yn,dx_chronic_yn,
dx_unique,dx_ed_yn,dx_link_prob_id 
INTO CROWNGaribaldiIRB00293957_Projection.dbo.derived_encounter_dx_masked
from CROWNGaribaldiIRB00293957_Scratch.dbo.derived_encounter_dx pat
inner join PMAP_Analytics.dbo.CCDA2847_garibaldi_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2847_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;


SELECT id.patient_id,line,map.enc_ID,dx_id,dx_name,dx_group,icd10_code,
icd9_code,current_icd10_list,current_icd9_list,dx_affects_drg_yn,dx_comorbidity_yn,
final_dx_soi_c,severity_of_illness,final_dx_rom_c,risk_of_mortality,final_dx_excld_yn,
fnl_dx_afct_soi_yn,fnl_dx_afct_rom_yn,final_dx_poa_c,present_on_admission,
dx_comorbidity_c,comorbidity_exists,dx_hac_yn,dx_type_c,diagnosis_type,dx_start_dt,
dx_end_dt,dx_problem_id,dx_chronic_flag_yn,dx_supp_atc_code_c,atc_dx_name,
dx_hsp_prob_flag_yn,dx_overridden_dx_id,dx_disproven_yn,dk_cancer_status_c,
cancer_status,dx_documenting_user_id,fnl_dx_qualifier_c,dx_qualifier,term_dx_id,adm_date_time 
INTO CROWNGaribaldiIRB00293957_Projection.dbo.derived_hosp_billing_dx_masked
from CROWNGaribaldiIRB00293957_Scratch.dbo.derived_hosp_billing_dx pat
left join PMAP_Analytics.dbo.CCDA2847_garibaldi_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2847_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,proc_name,code_set_c,code_set_name,code,
proc_date,proc_perf_prov_id,px_cpt_modifiers,modifier_1_ext_code,
modifier_1_name,modifier_2_ext_code,modifier_2_name,modifier_3_ext_code,
modifier_3_name,modifier_4_ext_code,modifier_4_name,px_cpt_quantity,icd_px_id,
source_key,source_name,line,coding_info_cpt_line,exclude_yn,affects_soi_yn,
affects_rom_yn,event_number  
INTO CROWNGaribaldiIRB00293957_Projection.dbo.derived_hosp_billing_px_masked
from CROWNGaribaldiIRB00293957_Scratch.dbo.derived_hosp_billing_px pat
inner join PMAP_Analytics.dbo.CCDA2847_garibaldi_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2847_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,pat_enc_date_real,map.enc_ID,
adt_pat_class_c,adt_pat_class,adt_patient_stat_c,adt_patient_stat,
pending_disch_time,exp_admission_time,exp_len_of_stay,admit_source_c,
admit_source,delivery_type_c,delivery_type,labor_status_c,labor_status,
adt_arrival_time,hosp_admsn_time,hosp_disch_time,hosp_admsn_type_c,
hosp_admsn_type,department_id,dept_name,dept_abbreviation,dep_speciality,
dep_rpt_grp_ten,disch_disp_c,disc_disp,contact_date,inp_adm_date,ed_departure_time,
op_adm_date,emer_adm_date,hospital_service,ed_visit_yn,serv_area_name 
INTO CROWNGaribaldiIRB00293957_Projection.dbo.derived_inpatient_encounters_masked
from CROWNGaribaldiIRB00293957_Scratch.dbo.derived_inpatient_encounters pat
inner join PMAP_Analytics.dbo.CCDA2847_garibaldi_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2847_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

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
INTO CROWNGaribaldiIRB00293957_Projection.dbo.derived_lab_results_masked
from CROWNGaribaldiIRB00293957_Scratch.dbo.derived_lab_results pat
inner join PMAP_Analytics.dbo.CCDA2847_garibaldi_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2847_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,line,hosp_admsn_time,
hosp_disch_time,medication_name,generic_name,medication_id,
thera_classname,pharm_classname,pharm_subclassname,taken_time,
ordering_date,order_end_time,scheduled_time,saved_time,
mar_time_source,mar_action,route,sig,site,dose_unit,
infusion_rate,mar_inf_rate_unit,mar_duration,duration_unit,
frequency,freq_period,freq_type,number_of_times,time_unit,
now_yn,reason,mar_imm_link_id,mar_admin_dept,mar_ord_dat,
pat_supplied_yn,sensitive_yn,mar_action_c 
INTO CROWNGaribaldiIRB00293957_Projection.dbo.derived_med_admin_masked
from CROWNGaribaldiIRB00293957_Scratch.dbo.derived_med_admin pat
inner join PMAP_Analytics.dbo.CCDA2847_garibaldi_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2847_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,medical_hx_date,med_hx_start_dt,med_hx_end_dt,
dx_id,dx_name,dx_group,parent_dx_name,icd10_code,icd9_code 
INTO CROWNGaribaldiIRB00293957_Projection.dbo.derived_medical_hx_summary_masked
from CROWNGaribaldiIRB00293957_Scratch.dbo.derived_medical_hx_summary pat
inner join PMAP_Analytics.dbo.CCDA2847_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,problem_list_id,dx_id,dx_name,dx_group,parent_dx_id,
parent_dx_name,icd10_code,icd9_code,problem_status,class_of_problem,
[priority],treat_summ_stat,noted_date,noted_end_date,resolved_date,
date_of_entry,chronic_yn,principal_pl_yn,problem_status_c,class_of_problem_c,
priority_c,treat_summ_status_c,current_icd10_list,current_icd9_list 
INTO CROWNGaribaldiIRB00293957_Projection.dbo.derived_problem_list_masked
from CROWNGaribaldiIRB00293957_Scratch.dbo.derived_problem_list pat
inner join PMAP_Analytics.dbo.CCDA2847_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,proc_name,code_set_c,code_set_name,code,
proc_date,proc_perf_prov_id,px_cpt_modifiers,modifier_1_ext_code,modifier_1_name,
modifier_2_ext_code,modifier_2_name,modifier_3_ext_code,modifier_3_name,
modifier_4_ext_code,modifier_4_name,px_cpt_quantity,proc_id,source_key,source_name,
tx_id,service_area_id,loc_id,location_name,pos_id,place_of_service,department_id,
department,void_date,panel_id,enc_type_c,appt_status_c 
INTO CROWNGaribaldiIRB00293957_Projection.dbo.derived_profee_billing_px_masked
from CROWNGaribaldiIRB00293957_Scratch.dbo.derived_profee_billing_px pat
inner join PMAP_Analytics.dbo.CCDA2847_garibaldi_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2847_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,MedName,MedDisplayName,Dose,Frequency,Sig,OrderingDate,
OrderType,StartDate,EndDate,DiscontinuationReason,TheraClass,PharmClass,PharmSubClass,CurrentMed
INTO CROWNGaribaldiIRB00293957_Projection.dbo.derived_med_orders_masked
from CROWNGaribaldiIRB00293957_Scratch.dbo.derived_med_orders pat
inner join PMAP_Analytics.dbo.CCDA2847_garibaldi_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2847_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;
