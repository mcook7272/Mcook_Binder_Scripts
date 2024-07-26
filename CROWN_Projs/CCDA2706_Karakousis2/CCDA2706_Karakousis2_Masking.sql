USE [PMAP_Analytics]

--Drop tables that will be re-loaded
Drop table if exists PMAP_Analytics.dbo.CCDA2706_Karakousis2_csn_Mapping;
Drop table if exists PMAP_Analytics.dbo.CCDA2706_Karakousis2_osler_id_Mapping;
DROP table if exists CROWNKarakousis2_Projection.dbo.covid_pmcoe_convalescent_plasma_masked;
DROP table if exists CROWNKarakousis2_Projection.dbo.covid_pmcoe_covid_positive_masked;
DROP table if exists CROWNKarakousis2_Projection.dbo.curated_covid_immunizations_masked;
DROP table if exists CROWNKarakousis2_Projection.dbo.curated_elixhauser_comorbidities_masked;
DROP table if exists CROWNKarakousis2_Projection.dbo.curated_Inflam_Markers_masked;
DROP table if exists CROWNKarakousis2_Projection.dbo.Curated_IPEvents_masked;
DROP table if exists CROWNKarakousis2_Projection.dbo.curated_who_status_masked;
DROP table if exists CROWNKarakousis2_Projection.dbo.derived_encounter_dx_masked;
DROP table if exists CROWNKarakousis2_Projection.dbo.derived_epic_patient_masked;
DROP table if exists CROWNKarakousis2_Projection.dbo.derived_hosp_billing_dx_masked;
DROP table if exists CROWNKarakousis2_Projection.dbo.derived_inpatient_encounters_masked;
DROP table if exists CROWNKarakousis2_Projection.dbo.derived_lab_results_masked;
DROP table if exists CROWNKarakousis2_Projection.dbo.derived_med_admin_masked;
DROP table if exists CROWNKarakousis2_Projection.dbo.derived_med_orders_masked;
DROP table if exists CROWNKarakousis2_Projection.dbo.derived_medical_hx_summary_masked;
DROP table if exists CROWNKarakousis2_Projection.dbo.derived_problem_list_masked;
DROP table if exists CROWNKarakousis2_Projection.dbo.curated_Adult_RTAssessment_masked;--
DROP table if exists CROWNKarakousis2_Projection.dbo.curated_IPVitals_masked;
DROP table if exists CROWNKarakousis2_Projection.dbo.derived_code_status_masked;
DROP table if exists CROWNKarakousis2_Projection.dbo.derived_epic_vitals_masked;
DROP table if exists CROWNKarakousis2_Projection.dbo.derived_image_procedures_masked;
DROP table if exists CROWNKarakousis2_Projection.dbo.derived_social_history_changes_masked;


--Create mapping tables

--CSN
SELECT 
	a.*
	--,'Pat_'+ cast(ROW_NUMBER() OVER (ORDER BY A.IDENTITY_ID) as varchar) as 'Masked ID'
	,ROW_NUMBER() OVER (ORDER BY A.IDENTITY_ID) as 'enc_ID'
	into PMAP_Analytics.dbo.CCDA2706_Karakousis2_csn_mapping
FROM (
	SELECT DISTINCT
		t.pat_enc_csn_id "Identity_ID"
	FROM (
		select distinct osler_id, pat_enc_csn_id
		from CROWNKarakousis2_Projection.dbo.derived_inpatient_encounters
		union 
		select distinct osler_id, pat_enc_csn_id
		from CROWNKarakousis2_Projection.dbo.derived_hosp_billing_dx
		union 
		select distinct osler_id, pat_enc_csn_id
		from CROWNKarakousis2_Projection.dbo.derived_lab_results
		union 
		select distinct osler_id, jab1_csn "pat_enc_csn_id"
		from CROWNKarakousis2_Projection.dbo.curated_covid_immunizations
		union 
		select distinct osler_id, jab2_csn "pat_enc_csn_id"
		from CROWNKarakousis2_Projection.dbo.curated_covid_immunizations
		union 
		select distinct osler_id, pat_enc_csn_id
		from CROWNKarakousis2_Projection.dbo.curated_Inflam_Markers
		union
		select distinct osler_id, pat_enc_csn_id
		from CROWNKarakousis2_Projection.dbo.derived_med_orders
		union
		select distinct osler_id, pat_enc_csn_id
		from CROWNKarakousis2_Projection.dbo.derived_social_history_changes
		union
		select distinct osler_id, hx_lnk_enc_csn
		from CROWNKarakousis2_Projection.dbo.derived_social_history_changes
		union
		select distinct osler_id, pat_enc_csn_id
		from CROWNKarakousis2_Projection.dbo.derived_image_procedures
	) t
	WHERE t.pat_enc_csn_id is not null
 )a;

 --osler_id
  SELECT 
	a.*
	--,'Pat_'+ cast(ROW_NUMBER() OVER (ORDER BY A.IDENTITY_ID) as varchar) as 'Masked ID'
	,ROW_NUMBER() OVER (ORDER BY A.osler_id) as 'patient_id'
	into PMAP_Analytics.dbo.CCDA2706_Karakousis2_osler_id_mapping
FROM (
	SELECT DISTINCT
		osler_id, birth_date
	from CROWNKarakousis2_Projection.dbo.derived_epic_patient
 )A;

 --Load tables
 select id.patient_id,pat.birth_date,pat_status,
 death_date,gender,genderabbr,ethnic_group,first_race,racew,raceb,racei,racea,racep,
 raceo,racerf,raceu,racetwo,racedec,raceh,language,first_contact,last_contact,
 next_contact,primaryloc_id,primaryloc_name,intrptr_needed_yn
into CROWNKarakousis2_Projection.dbo.derived_epic_patient_masked
from CROWNKarakousis2_Projection.dbo.derived_epic_patient pat
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_osler_id_mapping id on id.osler_id = pat.osler_id
order by id.patient_id;

SELECT id.patient_id,map.enc_ID,result_sub_idn,proc_id,proc_name,
blood_unit_num,blood_product_code,blood_start_instant,blood_end_instant,result_time,
issue_time,lab_blood_status,lab_blood_type,lab_product_type,trans_or_prep_order_amt,
trans_or_prep_order_units,authorizing_prov_id,enc_department_id,
enc_department,primary_loc_id,enc_primary_location,serv_area_id,enc_type,
enc_contact_date,instance_status,row_type,study_enrollments 
INTO CROWNKarakousis2_Projection.dbo.covid_pmcoe_convalescent_plasma_masked
from CROWNKarakousis2_Projection.dbo.covid_pmcoe_convalescent_plasma pat
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_osler_id_mapping id on id.osler_id = pat.osler_id;


SELECT id.patient_id,first_race,gender,age_at_positive,
pat_status,death_date,initial_dx_date,infection_add_date,
positive_collection_date,positive_result_date,rsltdt_infadd_hour_interval,initial_dx_source 
INTO CROWNKarakousis2_Projection.dbo.covid_pmcoe_covid_positive_masked
from CROWNKarakousis2_Projection.dbo.covid_pmcoe_covid_positive pat
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT distinct id.patient_id,jab1_immune_id,jab1_immune_date,jab1_immunzatn_id,jab1_immune_type,
jab1_imm_historic_adm_yn,jab2_immune_id,jab2_immune_date,jab2_immunzatn_id,jab2_immune_type,
jab2_imm_historic_adm_yn,jab1_jab2_interval_days,map.enc_ID "jab1_enc_ID",jab1_entry_date,jab1_update_date,
jab2_entry_date,jab2_update_date,map2.enc_ID "jab2_enc_ID",jab1_contact_date_real,jab1_line,jab2_contact_date_real,jab2_line
INTO CROWNKarakousis2_Projection.dbo.curated_covid_immunizations_masked
from CROWNKarakousis2_Projection.dbo.curated_covid_immunizations pat
left join PMAP_Analytics.dbo.CCDA2706_Karakousis2_csn_mapping map on pat.jab1_csn = map.Identity_ID
left join PMAP_Analytics.dbo.CCDA2706_Karakousis2_csn_mapping map2 on pat.jab2_csn = map2.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,el_depress,el_anemdef,el_htn,el_wghtloss,el_lymph,
el_coag,el_alcohol,el_chf,el_renlfail,el_perivasc,el_tumor,el_aids,
el_para,el_pulmcirc,el_htncx,el_ulcer,el_psych,el_obese,el_bldloss,
el_chrnlung,el_drug,el_hypothy,el_mets,el_lytes,el_liver,el_arth,
el_neuro,el_dmcx,el_valve,el_dm,icd10 
INTO CROWNKarakousis2_Projection.dbo.curated_elixhauser_comorbidities_masked
from CROWNKarakousis2_Projection.dbo.curated_elixhauser_comorbidities pat
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_osler_id_mapping id on id.osler_id = pat.osler_id;

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
INTO CROWNKarakousis2_Projection.dbo.curated_Inflam_Markers_masked
from CROWNKarakousis2_Projection.dbo.curated_Inflam_Markers pat
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,AGE,SEX_C,RACE_C,HISPANIC_C,POSITIVE_TEST_TIME,
map.enc_ID "INIT_ENC_ID",ADMIT_TIME,ADMIT_SOURCE_C,ADMIT_SOURCE_NAME,
TRANSFER_FROM_C,TRANSFER_FROM_NAME,INIT_HOSP_LOC_ABBR,map2.enc_ID "LINKED_ENC_ID",
TRANSFER_TIME,OXYGEN_RX,INT_DIALYSIS_RX,NIPPV_RX,HIFLOW_RX,VENT_START,
IVPRESSOR_RX,CRRT_RX,ECMO_RX,ECMO_END,TRACH_DTM,CHEST_TUBE_DTM,
convalescent_plasma_dtm,VENT_END,IVPRESSOR_END,HIFLOW_END,NIPPV_END,
CRRT_END,INT_DIALYSIS_END,OXYGEN_END,INIT_DNR_DNI,FINAL_HOSP_DISCH_TIME,
FINAL_DISCH_DISP_C,FINAL_DISCH_DISP_NAME,DEATH_TIME 
INTO CROWNKarakousis2_Projection.dbo.Curated_IPEvents_masked
from CROWNKarakousis2_Projection.dbo.Curated_IPEvents pat
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_csn_mapping map on pat.INIT_PAT_ENC_CSN_ID = map.Identity_ID
left join PMAP_Analytics.dbo.CCDA2706_Karakousis2_csn_mapping map2 on pat.LINKED_CSN = map2.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,map2.enc_ID "linked_enc_ID",[event],[start],
[end],who_score_numeric,who_score_grouped,who_score 
INTO CROWNKarakousis2_Projection.dbo.curated_who_status_masked
from CROWNKarakousis2_Projection.dbo.curated_who_status pat
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
left join PMAP_Analytics.dbo.CCDA2706_Karakousis2_csn_mapping map2 on pat.LINKED_CSN = map2.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_osler_id_mapping id on id.osler_id = pat.osler_id;


SELECT id.patient_id,map.enc_ID,line,dx_id,dx_name,dx_group,parent_dx_id,
parent_dx_name,icd10_code,icd9_code,current_icd10_list,current_icd9_list,
enc_contact_date,dx_qualifier,dx_qualifier_c,primary_dx_yn,dx_chronic_yn,
dx_unique,dx_ed_yn,dx_link_prob_id 
INTO CROWNKarakousis2_Projection.dbo.derived_encounter_dx_masked
from CROWNKarakousis2_Projection.dbo.derived_encounter_dx pat
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_osler_id_mapping id on id.osler_id = pat.osler_id;


SELECT id.patient_id,line,map.enc_ID,dx_id,dx_name,dx_group,icd10_code,
icd9_code,current_icd10_list,current_icd9_list,dx_affects_drg_yn,dx_comorbidity_yn,
final_dx_soi_c,severity_of_illness,final_dx_rom_c,risk_of_mortality,final_dx_excld_yn,
fnl_dx_afct_soi_yn,fnl_dx_afct_rom_yn,final_dx_poa_c,present_on_admission,
dx_comorbidity_c,comorbidity_exists,dx_hac_yn,dx_type_c,diagnosis_type,dx_start_dt,
dx_end_dt,dx_problem_id,dx_chronic_flag_yn,dx_supp_atc_code_c,atc_dx_name,
dx_hsp_prob_flag_yn,dx_overridden_dx_id,dx_disproven_yn,dk_cancer_status_c,
cancer_status,dx_documenting_user_id,fnl_dx_qualifier_c,dx_qualifier,term_dx_id,adm_date_time 
INTO CROWNKarakousis2_Projection.dbo.derived_hosp_billing_dx_masked
from CROWNKarakousis2_Projection.dbo.derived_hosp_billing_dx pat
left join PMAP_Analytics.dbo.CCDA2706_Karakousis2_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,pat_enc_date_real,map.enc_ID,
adt_pat_class_c,adt_pat_class,adt_patient_stat_c,adt_patient_stat,
pending_disch_time,exp_admission_time,exp_len_of_stay,admit_source_c,
admit_source,delivery_type_c,delivery_type,labor_status_c,labor_status,
adt_arrival_time,hosp_admsn_time,hosp_disch_time,hosp_admsn_type_c,
hosp_admsn_type,department_id,dept_name,dept_abbreviation,dep_speciality,
dep_rpt_grp_ten,disch_disp_c,disc_disp,contact_date,inp_adm_date,ed_departure_time,
op_adm_date,emer_adm_date,hospital_service,ed_visit_yn,serv_area_name 
INTO CROWNKarakousis2_Projection.dbo.derived_inpatient_encounters_masked
from CROWNKarakousis2_Projection.dbo.derived_inpatient_encounters pat
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_osler_id_mapping id on id.osler_id = pat.osler_id;

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
INTO CROWNKarakousis2_Projection.dbo.derived_lab_results_masked
from CROWNKarakousis2_Projection.dbo.derived_lab_results pat
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,line,hosp_admsn_time,
hosp_disch_time,medication_name,generic_name,medication_id,
thera_classname,pharm_classname,pharm_subclassname,taken_time,
ordering_date,order_end_time,scheduled_time,saved_time,
mar_time_source,mar_action,route,sig,site,dose_unit,
infusion_rate,mar_inf_rate_unit,mar_duration,duration_unit,
frequency,freq_period,freq_type,number_of_times,time_unit,
now_yn,reason,mar_imm_link_id,mar_admin_dept,mar_ord_dat,
pat_supplied_yn,sensitive_yn,mar_action_c 
INTO CROWNKarakousis2_Projection.dbo.derived_med_admin_masked
from CROWNKarakousis2_Projection.dbo.derived_med_admin pat
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,medical_hx_date,med_hx_start_dt,med_hx_end_dt,
dx_id,dx_name,dx_group,parent_dx_name,icd10_code,icd9_code 
INTO CROWNKarakousis2_Projection.dbo.derived_medical_hx_summary_masked
from CROWNKarakousis2_Projection.dbo.derived_medical_hx_summary pat
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,problem_list_id,dx_id,dx_name,dx_group,parent_dx_id,
parent_dx_name,icd10_code,icd9_code,problem_status,class_of_problem,
[priority],treat_summ_stat,noted_date,noted_end_date,resolved_date,
date_of_entry,chronic_yn,principal_pl_yn,problem_status_c,class_of_problem_c,
priority_c,treat_summ_status_c,current_icd10_list,current_icd9_list 
INTO CROWNKarakousis2_Projection.dbo.derived_problem_list_masked
from CROWNKarakousis2_Projection.dbo.derived_problem_list pat
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,MedName,MedDisplayName,Dose,Frequency,Sig,OrderingDate,
OrderType,StartDate,EndDate,DiscontinuationReason,TheraClass,PharmClass,PharmSubClass,CurrentMed
INTO CROWNKarakousis2_Projection.dbo.derived_med_orders_masked
from CROWNKarakousis2_Projection.dbo.derived_med_orders pat
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,recorded_time,template_id,template_name,template_facility,
meas_value_raw,meas_value,meas_id,meas_name,meas_disp_name,meas_row_type,
meas_val_type,meas_fsd_id,meas_line,inpatient_data_id,group_id,group_disp_name,occurance,
ip_lda_id,lda_removal_instant,lda_placement_instant,lda_description,lda_properties,lda_site,
map2.enc_ID "lda_inital_enc_ID",lda_initial_date,concept,pivot_column
INTO CROWNKarakousis2_Projection.dbo.curated_Adult_RTAssessment_masked
from CROWNKarakousis2_Projection.dbo.curated_Adult_RTAssessment pat
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
left join PMAP_Analytics.dbo.CCDA2706_Karakousis2_csn_mapping map2 on pat.lda_initial_csn = map2.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,RECORDED_TIME,RECORD_TYPE,Pulse,RHYTHM,SBP_cuff,DBP_cuff,
MAP_cuff,SBP_aline,DBP_aline,MAP_aline,Resp_rate,Temp_c,Temp_src,Pulse_ox_sat,
Fentanyl_gtt,Midazolam_gtt,Propofol_gtt,Dexmedetomidine_gtt,Hydromorphone_gtt,Ketamine_gtt,
Norepinephrine_gtt,Epinephrine_gtt,Phenylephrine_gtt,Dobutamine_gtt,Vasopressin_gtt,
Cisatracurium_gtt,Vecuronium_gtt,Nicardipine_gtt,Nitroglycerin_gtt,Heparin_gtt,
O2_device,FiO2_pct,Flow_Lmin,PEEP_cmH2O
INTO CROWNKarakousis2_Projection.dbo.curated_IPVitals_masked
from CROWNKarakousis2_Projection.dbo.curated_IPVitals pat
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,activated_inst,inactivated_inst,code_status,
code_status_context,ocs_id,code_status_c,code_status_context_c,
proc_id,proc_code,proc_name,enc_contact_date,enc_type,enc_type_c
INTO CROWNKarakousis2_Projection.dbo.derived_code_status_masked
from CROWNKarakousis2_Projection.dbo.derived_code_status pat
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,inpatient_data_id,recorded_time,entry_time,meas_value,meas_name,
meas_disp_name,meas_id,meas_row_type,meas_val_type,meas_row_type_c,meas_val_type_c,
meas_template_id,template_display_name,meas_fsd_id,meas_line,enc_contact_date,enc_dept_id,
enc_type,enc_type_c,lastupdate_dttm
INTO CROWNKarakousis2_Projection.dbo.derived_epic_vitals_masked
from CROWNKarakousis2_Projection.dbo.derived_epic_vitals pat
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,pat_enc_date_real,contact_date,map2.enc_ID "hx_lnk_enc_ID",unknown_fam_hx_yn,tobacco_pak_per_dy,
tobacco_used_years,smoking_quit_date,cigarettes_yn,pipes_yn,cigars_yn,snuff_yn,chew_yn,tobacco_user,smokeless_tobacco_use,
smokeless_quit_date,smoking_tobacco_use,smoking_start_date,tob_src,alcohol_use,alcohol_oz_per_wk,alcohol_src,
alcohol_freq,alc_freq_src,alcohol_drinks_per_day,alc_std_drink_src,alcohol_binge,alc_binge_src,ill_drug_user,
iv_drug_user_yn,illicit_drug_freq,drug_src,female_partner_yn,male_partner_yn,condom_yn,pill_yn,diaphragm_yn,
iud_yn,surgical_yn,spermicide_yn,implant_yn,rhythm_yn,injection_yn,sponge_yn,inserts_yn,abstinence_yn,sex_src,
sexually_active,years_education,education_level,edu_level_src,fin_resource_strain,fin_resource_src,ipv_emotional_abuse,
ipv_emotional_src,ipv_fear,ipv_fear_src,ipv_sexual_abuse,ipv_sexabuse_src,ipv_physical_abuse,ipv_physabuse_src,
living_w_spouse,soc_living_src,daily_stress,daily_stress_src,phone_communication,phone_comm_src,socialization_freq,
social_freq_src,church_attendance,church_att_src,clubmtg_attendance,clubmtg_att_src,club_member,club_member_src,
phys_act_days_per_week,phys_act_dpw_src,phys_act_mins_per_sess,phys_act_mps_src,food_insecurity_scarce,food_scarcity_src,
food_insecurity_worry,food_worry_src,med_transport_needs,trans_med_src,other_transport_needs,trans_nonmed_src
INTO CROWNKarakousis2_Projection.dbo.derived_social_history_changes_masked
from CROWNKarakousis2_Projection.dbo.derived_social_history_changes pat
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
left join PMAP_Analytics.dbo.CCDA2706_Karakousis2_csn_mapping map2 on pat.hx_lnk_enc_csn = map2.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,proc_code,proc_name,proc_category,order_status,
resulting_lab,order_time,result_time,review_time,result_status,
specimen_taken_date,study_instance,images_avail_yn,image_avail_dttm,
image_location,department_name,specimen_type,specimen_src
INTO CROWNKarakousis2_Projection.dbo.derived_image_procedures_masked
from CROWNKarakousis2_Projection.dbo.derived_image_procedures pat
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2706_Karakousis2_osler_id_mapping id on id.osler_id = pat.osler_id;
