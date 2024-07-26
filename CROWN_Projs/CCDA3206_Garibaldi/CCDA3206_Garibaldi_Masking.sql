USE [PMAP_Analytics]

--Drop tables that will be re-loaded
Drop table if exists PMAP_Analytics.dbo.CCDA3206_Garibaldi_csn_Mapping;
Drop table if exists PMAP_Analytics.dbo.CCDA3206_Garibaldi_osler_id_Mapping;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.covid_pmcoe_covid_positive_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.covid_pmcoe_convalescent_plasma_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.curated_covid_immunizationsEAV_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.curated_elixhauser_comorbidities_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.curated_Inflam_Markers_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.curated_ipevents_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.curated_ipvitals_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.curated_who_status_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_adt_location_history_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_ecg_results_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_encounter_dx_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_enroll_info_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_epic_patient_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_flowsheet_data_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_hosp_billing_dx_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_hosp_billing_px_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_image_procedures_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_immunizations_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_infections_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_inpatient_encounters_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_lab_results_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_med_admin_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_med_orders_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_medical_hx_summary_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_micro_sensitivities_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_outpatient_encounters_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_problem_list_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_profee_billing_px_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.curated_Adult_RTAssessment_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_code_status_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_social_history_changes_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_epic_vitals_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.curated_AllMed_Doses_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_emr_diagnosis_info_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.covid_pmcoe_covidzegcohortdict_v5_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.covid_pmcoe_covidzegmasterepisode_v5_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.covid_pmcoe_encounters_v5_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.covid_pmcoe_episodelink_v5_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.covid_pmcoe_ipevents_v5_masked;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_order_questionnaires_masked;


--Create mapping tables

--CSN
SELECT 
	a.*
	--,'Pat_'+ cast(ROW_NUMBER() OVER (ORDER BY A.IDENTITY_ID) as varchar) as 'Masked ID'
	,ROW_NUMBER() OVER (ORDER BY A.IDENTITY_ID) as 'enc_ID'
	into PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping
FROM (
	SELECT DISTINCT
		t.pat_enc_csn_id "Identity_ID"
	FROM (
		select distinct osler_id, pat_enc_csn_id
		from CrownGaribaldiIRB00250975_Projection.dbo.derived_inpatient_encounters
		union 
		select distinct osler_id, pat_enc_csn_id
		from CrownGaribaldiIRB00250975_Projection.dbo.derived_hosp_billing_dx
		union 
		select distinct osler_id, pat_enc_csn_id
		from CrownGaribaldiIRB00250975_Projection.dbo.curated_Inflam_Markers
		union
		select distinct osler_id, pat_enc_csn_id
		from CrownGaribaldiIRB00250975_Projection.dbo.derived_hosp_billing_px	
		union
		select distinct osler_id, init_pat_enc_csn_id
		from CrownGaribaldiIRB00250975_Projection.dbo.Curated_IPEvents
		union
		select distinct osler_id, pat_enc_csn_id
		from CrownGaribaldiIRB00250975_Projection.dbo.derived_outpatient_encounters
		union
		select distinct osler_id, pat_enc_csn_id
		from CrownGaribaldiIRB00250975_Projection.dbo.derived_image_procedures
		union
		select distinct osler_id, pat_enc_csn_id
		from CrownGaribaldiIRB00250975_Projection.dbo.derived_micro_sensitivities
		union
		select distinct osler_id, pat_enc_csn_id
		from CrownGaribaldiIRB00250975_Projection.dbo.derived_lab_results
		union
		select distinct osler_id, jab_csn "pat_enc_csn_id"
		from CrownGaribaldiIRB00250975_Projection.dbo.curated_covid_immunizationsEAV
	) t
	WHERE t.pat_enc_csn_id is not null
 )a;

 --osler_id
  SELECT 
	a.*
	--,'Pat_'+ cast(ROW_NUMBER() OVER (ORDER BY A.IDENTITY_ID) as varchar) as 'Masked ID'
	,ROW_NUMBER() OVER (ORDER BY A.osler_id) as 'patient_id'
	into PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping
FROM (
	SELECT DISTINCT
		osler_id, birth_date
	from CrownGaribaldiIRB00250975_Projection.dbo.derived_epic_patient
 )A;

 --Load tables
 select id.patient_id,pat.birth_date,pat_status,
 death_date,gender,genderabbr,ethnic_group,first_race,racew,raceb,racei,racea,racep,
 raceo,racerf,raceu,racetwo,racedec,raceh,language,first_contact,last_contact,
 next_contact,primaryloc_id,primaryloc_name,intrptr_needed_yn
into CrownGaribaldiIRB00250975_Projection.dbo.derived_epic_patient_masked
from CrownGaribaldiIRB00250975_Projection.dbo.derived_epic_patient pat
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id
order by id.patient_id;

SELECT id.patient_id,first_race,gender,age_at_positive,
pat_status,death_date,initial_dx_date,infection_add_date,
positive_collection_date,positive_result_date,rsltdt_infadd_hour_interval,initial_dx_source 
INTO CrownGaribaldiIRB00250975_Projection.dbo.covid_pmcoe_covid_positive_masked
from CrownGaribaldiIRB00250975_Projection.dbo.covid_pmcoe_covid_positive pat
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,el_depress,el_anemdef,el_htn,el_wghtloss,el_lymph,
el_coag,el_alcohol,el_chf,el_renlfail,el_perivasc,el_tumor,el_aids,
el_para,el_pulmcirc,el_htncx,el_ulcer,el_psych,el_obese,el_bldloss,
el_chrnlung,el_drug,el_hypothy,el_mets,el_lytes,el_liver,el_arth,
el_neuro,el_dmcx,el_valve,el_dm,icd10 
INTO CrownGaribaldiIRB00250975_Projection.dbo.curated_elixhauser_comorbidities_masked
from CrownGaribaldiIRB00250975_Projection.dbo.curated_elixhauser_comorbidities pat
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

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
INTO CrownGaribaldiIRB00250975_Projection.dbo.curated_Inflam_Markers_masked
from CrownGaribaldiIRB00250975_Projection.dbo.curated_Inflam_Markers pat
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,map2.enc_ID "linked_enc_ID",[event],[start],
[end],who_score_numeric,who_score_grouped,who_score 
INTO CrownGaribaldiIRB00250975_Projection.dbo.curated_who_status_masked
from CrownGaribaldiIRB00250975_Projection.dbo.curated_who_status pat
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
left join PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map2 on pat.LINKED_CSN = map2.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;


SELECT id.patient_id,map.enc_ID,line,dx_id,dx_name,dx_group,parent_dx_id,
parent_dx_name,icd10_code,icd9_code,current_icd10_list,current_icd9_list,
enc_contact_date,dx_qualifier,dx_qualifier_c,primary_dx_yn,dx_chronic_yn,
dx_unique,dx_ed_yn,dx_link_prob_id 
INTO CrownGaribaldiIRB00250975_Projection.dbo.derived_encounter_dx_masked
from CrownGaribaldiIRB00250975_Projection.dbo.derived_encounter_dx pat
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;


SELECT id.patient_id,line,map.enc_ID,dx_id,dx_name,dx_group,icd10_code,
icd9_code,current_icd10_list,current_icd9_list,dx_affects_drg_yn,dx_comorbidity_yn,
final_dx_soi_c,severity_of_illness,final_dx_rom_c,risk_of_mortality,final_dx_excld_yn,
fnl_dx_afct_soi_yn,fnl_dx_afct_rom_yn,final_dx_poa_c,present_on_admission,
dx_comorbidity_c,comorbidity_exists,dx_hac_yn,dx_type_c,diagnosis_type,dx_start_dt,
dx_end_dt,dx_problem_id,dx_chronic_flag_yn,dx_supp_atc_code_c,atc_dx_name,
dx_hsp_prob_flag_yn,dx_overridden_dx_id,dx_disproven_yn,dk_cancer_status_c,
cancer_status,dx_documenting_user_id,fnl_dx_qualifier_c,dx_qualifier,term_dx_id,adm_date_time 
INTO CrownGaribaldiIRB00250975_Projection.dbo.derived_hosp_billing_dx_masked
from CrownGaribaldiIRB00250975_Projection.dbo.derived_hosp_billing_dx pat
left join PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,proc_name,code_set_c,code_set_name,code,
proc_date,proc_perf_prov_id,px_cpt_modifiers,modifier_1_ext_code,
modifier_1_name,modifier_2_ext_code,modifier_2_name,modifier_3_ext_code,
modifier_3_name,modifier_4_ext_code,modifier_4_name,px_cpt_quantity,icd_px_id,
source_key,source_name,line,coding_info_cpt_line,exclude_yn,affects_soi_yn,
affects_rom_yn,event_number  
INTO CrownGaribaldiIRB00250975_Projection.dbo.derived_hosp_billing_px_masked
from CrownGaribaldiIRB00250975_Projection.dbo.derived_hosp_billing_px pat
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,pat_enc_date_real,map.enc_ID,
adt_pat_class_c,adt_pat_class,adt_patient_stat_c,adt_patient_stat,
pending_disch_time,exp_admission_time,exp_len_of_stay,admit_source_c,
admit_source,delivery_type_c,delivery_type,labor_status_c,labor_status,
adt_arrival_time,hosp_admsn_time,hosp_disch_time,hosp_admsn_type_c,
hosp_admsn_type,department_id,dept_name,dept_abbreviation,dep_speciality,
dep_rpt_grp_ten,disch_disp_c,disc_disp,contact_date,inp_adm_date,ed_departure_time,
op_adm_date,emer_adm_date,hospital_service,ed_visit_yn,serv_area_name 
INTO CrownGaribaldiIRB00250975_Projection.dbo.derived_inpatient_encounters_masked
from CrownGaribaldiIRB00250975_Projection.dbo.derived_inpatient_encounters pat
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,medical_hx_date,med_hx_start_dt,med_hx_end_dt,
dx_id,dx_name,dx_group,parent_dx_name,icd10_code,icd9_code 
INTO CrownGaribaldiIRB00250975_Projection.dbo.derived_medical_hx_summary_masked
from CrownGaribaldiIRB00250975_Projection.dbo.derived_medical_hx_summary pat
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,problem_list_id,dx_id,dx_name,dx_group,parent_dx_id,
parent_dx_name,icd10_code,icd9_code,problem_status,class_of_problem,
[priority],treat_summ_stat,noted_date,noted_end_date,resolved_date,
date_of_entry,chronic_yn,principal_pl_yn,problem_status_c,class_of_problem_c,
priority_c,treat_summ_status_c,current_icd10_list,current_icd9_list 
INTO CrownGaribaldiIRB00250975_Projection.dbo.derived_problem_list_masked
from CrownGaribaldiIRB00250975_Projection.dbo.derived_problem_list pat
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,proc_name,code_set_c,code_set_name,code,
proc_date,proc_perf_prov_id,px_cpt_modifiers,modifier_1_ext_code,modifier_1_name,
modifier_2_ext_code,modifier_2_name,modifier_3_ext_code,modifier_3_name,
modifier_4_ext_code,modifier_4_name,px_cpt_quantity,proc_id,source_key,source_name,
tx_id,service_area_id,loc_id,location_name,pos_id,place_of_service,department_id,
department,void_date,panel_id,enc_type_c,appt_status_c 
INTO CrownGaribaldiIRB00250975_Projection.dbo.derived_profee_billing_px_masked
from CrownGaribaldiIRB00250975_Projection.dbo.derived_profee_billing_px pat
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,recorded_time,template_id,template_name,template_facility,meas_value_raw,
meas_value,meas_id,meas_name,meas_disp_name,meas_row_type,meas_val_type,meas_fsd_id,meas_line,inpatient_data_id,
group_id,group_disp_name,occurance,ip_lda_id,lda_removal_instant,lda_placement_instant,lda_description,
lda_properties,lda_site,map2.enc_ID "initial_lda_csn",lda_initial_date,concept,pivot_column
INTO CrownGaribaldiIRB00250975_Projection.dbo.curated_Adult_RTAssessment_masked
from CrownGaribaldiIRB00250975_Projection.dbo.curated_Adult_RTAssessment pat
left join PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map on pat.PAT_ENC_CSN_ID = map.Identity_ID
left join PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map2 on pat.lda_initial_csn = map2.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,order_id,activated_inst,inactivated_inst,code_status,code_status_context,
ocs_id,code_status_c,code_status_context_c,proc_id,proc_code,proc_name,enc_contact_date,enc_type,enc_type_c
INTO CrownGaribaldiIRB00250975_Projection.dbo.derived_code_status_masked
from CrownGaribaldiIRB00250975_Projection.dbo.derived_code_status pat
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map on pat.PAT_ENC_CSN_ID = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;


SELECT id.patient_id,map.enc_ID,pat_enc_date_real,contact_date,map2.enc_ID "hx_link_csn",unknown_fam_hx_yn,
tobacco_pak_per_dy,tobacco_used_years,smoking_quit_date,cigarettes_yn,pipes_yn,cigars_yn,snuff_yn,
chew_yn,tobacco_user,smokeless_tobacco_use,smokeless_quit_date,smoking_tobacco_use,smoking_start_date,
tob_src,alcohol_use,alcohol_oz_per_wk,alcohol_src,alcohol_freq,alc_freq_src,alcohol_drinks_per_day,
alc_std_drink_src,alcohol_binge,alc_binge_src,ill_drug_user,iv_drug_user_yn,illicit_drug_freq,
drug_src,female_partner_yn,male_partner_yn,condom_yn,pill_yn,diaphragm_yn,iud_yn,surgical_yn,
spermicide_yn,implant_yn,rhythm_yn,injection_yn,sponge_yn,inserts_yn,abstinence_yn,sex_src,
sexually_active,years_education,education_level,edu_level_src,fin_resource_strain,fin_resource_src,
ipv_emotional_abuse,ipv_emotional_src,ipv_fear,ipv_fear_src,ipv_sexual_abuse,ipv_sexabuse_src,
ipv_physical_abuse,ipv_physabuse_src,living_w_spouse,soc_living_src,daily_stress,daily_stress_src,
phone_communication,phone_comm_src,socialization_freq,social_freq_src,church_attendance,
church_att_src,clubmtg_attendance,clubmtg_att_src,club_member,club_member_src,phys_act_days_per_week,
phys_act_dpw_src,phys_act_mins_per_sess,phys_act_mps_src,food_insecurity_scarce,food_scarcity_src,
food_insecurity_worry,food_worry_src,med_transport_needs,trans_med_src,other_transport_needs,trans_nonmed_src
INTO CrownGaribaldiIRB00250975_Projection.dbo.derived_social_history_changes_masked
from CrownGaribaldiIRB00250975_Projection.dbo.derived_social_history_changes pat
left join PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map on pat.PAT_ENC_CSN_ID = map.Identity_ID
left join PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map2 on pat.hx_lnk_enc_csn = map2.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;


SELECT id.patient_id,map.enc_ID,order_proc_id,result_sub_idn,proc_id,proc_name,blood_unit_num,
blood_product_code,blood_start_instant,blood_end_instant,result_time,issue_time,lab_blood_status,
lab_blood_type,lab_product_type,trans_or_prep_order_amt,trans_or_prep_order_units,
authorizing_prov_id,authorizing_prov_name,enc_department_id,enc_department,
serv_area_id,enc_type,enc_contact_date,instance_status,row_type,study_enrollments
INTO CrownGaribaldiIRB00250975_Projection.dbo.covid_pmcoe_convalescent_plasma_masked
from CrownGaribaldiIRB00250975_Projection.dbo.covid_pmcoe_convalescent_plasma pat
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map on pat.PAT_ENC_CSN_ID = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id, [jab_num], [jab_date], [jab_source], [jab_immune_id], [jab_immunzatn_id], 
   [jab_immune_type], [jab_given_by_user_id], [jab_imm_historic_adm_yn], [prior_jab_interval_days], 
   [jab_order_id], map.enc_ID, [jab_entry_date], [jab_update_date], [jab_document_id], 
   [jab_contact_date_real], [jab_line], [lot], [physical_site], [external_admin_c]
INTO CrownGaribaldiIRB00250975_Projection.dbo.curated_covid_immunizationsEAV_masked
FROM CrownGaribaldiIRB00250975_Projection.dbo.curated_covid_immunizationsEAV pat
LEFT JOIN PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map ON pat.jab_csn = map.Identity_ID
INNER JOIN PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id ON id.osler_id = pat.osler_id;

--curated_ipevents
SELECT id.patient_id,AGE,SEX_C,RACE_C,HISPANIC_C,POSITIVE_TEST_TIME,
map.enc_ID,ADMIT_TIME,ADMIT_SOURCE_C,ADMIT_SOURCE_NAME,TRANSFER_FROM_C,
TRANSFER_FROM_NAME,INIT_HOSP_LOC_ABBR,map2.enc_ID "linked_enc_ID",TRANSFER_TIME,OXYGEN_RX,
INT_DIALYSIS_RX,NIPPV_RX,HIFLOW_RX,VENT_START,IVPRESSOR_RX,CRRT_RX,ECMO_RX,
ECMO_END,TRACH_DTM,CHEST_TUBE_DTM,convalescent_plasma_dtm,VENT_END,IVPRESSOR_END,
HIFLOW_END,NIPPV_END,CRRT_END,INT_DIALYSIS_END,OXYGEN_END,INIT_DNR_DNI,
FINAL_HOSP_DISCH_TIME,FINAL_DISCH_DISP_C,FINAL_DISCH_DISP_NAME,DEATH_TIME
INTO CrownGaribaldiIRB00250975_Projection.dbo.curated_ipevents_masked
from CrownGaribaldiIRB00250975_Projection.dbo.curated_ipevents pat
left join PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map on pat.INIT_PAT_ENC_CSN_ID = map.Identity_ID
left join PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map2 on pat.LINKED_CSN = map2.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;


SELECT id.patient_id,RECORDED_TIME,RECORD_TYPE,Pulse,RHYTHM,SBP_cuff,DBP_cuff,MAP_cuff,
SBP_aline,DBP_aline,MAP_aline,Resp_rate,Temp_c,Temp_src,Pulse_ox_sat,O2_device,FiO2_pct,Flow_Lmin,PEEP_cmH2O
INTO CrownGaribaldiIRB00250975_Projection.dbo.curated_ipvitals_masked
from CrownGaribaldiIRB00250975_Projection.dbo.curated_ipvitals pat
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,contact_date,event_id,event_type_c,event_type,in_dttm,out_dttm,
adt_department_id,adt_department_name,adt_room_id,adt_room_csn,adt_room_name,adt_bed_id,
adt_bed_csn,adt_bed_label,adt_loc_id,adt_loc_name,adt_serv_area_id,adt_serv_area_name,pat_out_dttm
INTO CrownGaribaldiIRB00250975_Projection.dbo.derived_adt_location_history_masked
from CrownGaribaldiIRB00250975_Projection.dbo.derived_adt_location_history pat
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map on pat.PAT_ENC_CSN_ID = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;


SELECT id.patient_id,order_proc_id,performed_date,accession_number,resulting_time,lab_status,
resulting_lab,p_duration,pr_interval,qrs_duration,qt_interval,qtc_interval,p_axis,qrs_axis,t_axis,
ventricular_rate,atrial_rate,interpretation,lab_status_c,resulting_lab_c,data_source
INTO CrownGaribaldiIRB00250975_Projection.dbo.derived_ecg_results_masked
from CrownGaribaldiIRB00250975_Projection.dbo.derived_ecg_results pat
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,enroll_id,research_study_id,enroll_status_c,enroll_status,study_alias,
enroll_start_dt,enroll_end_dt,enroll_cmt_note_id,last_mod_dttm,record_creation_dt,
last_mod_source_c,last_mod_source,rsh_myc_status_c,rsh_myc_status,myc_viewed_utc_dttm,
study_code,research_name,irb_approval_num,study_status,study_create_date,study_update_time
INTO CrownGaribaldiIRB00250975_Projection.dbo.derived_enroll_info_masked
from CrownGaribaldiIRB00250975_Projection.dbo.derived_enroll_info pat
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,inpatient_data_id,recorded_time,meas_value,meas_name,meas_disp_name,
rw_meas_name,rw_disp_name,rw_row_name,meas_id,meas_row_type,meas_val_type,meas_row_type_c,
meas_val_type_c,meas_template_id,meas_fsd_id,meas_line,meas_occurance,rw_meas_id,ip_lda_id,
rw_row_type,rw_val_type,rw_row_type_c,rw_val_type_c,ipds_template_id,ipds_rec_status_c,capture_device_id
INTO CrownGaribaldiIRB00250975_Projection.dbo.derived_flowsheet_data_masked
from CrownGaribaldiIRB00250975_Projection.dbo.derived_flowsheet_data pat
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map on pat.PAT_ENC_CSN_ID = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;


SELECT id.patient_id,map.enc_ID,order_proc_id,proc_code,proc_name,proc_category,
order_status,resulting_lab,order_time,result_time,review_time,result_status,
accession,authrzing_prov_id,authorizing_provider,specimen_taken_date,study_instance
,images_avail_yn,image_avail_dttm,image_location,department_name,specimen_type,specimen_src
INTO CrownGaribaldiIRB00250975_Projection.dbo.derived_image_procedures_masked
from CrownGaribaldiIRB00250975_Projection.dbo.derived_image_procedures pat
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map on pat.PAT_ENC_CSN_ID = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;


SELECT id.patient_id,map.enc_ID,order_id,med_or_proc_order,immune_id,immune_date,entry_date,
immunization_status,vaccine_name,vaccine_abbr,route,site,dose,dose_amount,dose_unit,
manufacturer,lot,imm_product,historic_yn,vaccine_target,vaccine_in_use,
vaccine_record_status,defer_reason,cancel_reason,imm_answer_id,immnztn_status_c,
immnztn_dose_unit_c,immunzatn_id,enc_type_c,enc_contact_date,enc_department_id,
enc_location_id,service_area_id,mar_admin_line,ordering_date,order_status,proc_or_med_id,
ordering_description
INTO CrownGaribaldiIRB00250975_Projection.dbo.derived_immunizations_masked
from CrownGaribaldiIRB00250975_Projection.dbo.derived_immunizations pat
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map on pat.PAT_ENC_CSN_ID = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;


SELECT id.patient_id,infection_id,infection_record_type,infection_type,infection_status,
how_added,add_utc_dttm,resolve_utc_dttm,expiration_date,doesnt_expire_yn,onset_date,specimen_type,
specimen_source,record_creation_date,infection_type_c,inf_status_c,how_added_c,
specimen_type_c,specimen_source_c
INTO CrownGaribaldiIRB00250975_Projection.dbo.derived_infections_masked
from CrownGaribaldiIRB00250975_Projection.dbo.derived_infections pat
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;


SELECT id.patient_id,map.enc_ID,order_proc_id,proc_id,proc_code,proc_name,proc_cat_id,
proc_cat_name,sensitive_yn,order_type,lab_group,resulting_lab,order_time,result_time,
authorizing_prov_id,authorizing_provider,specimen_taken_time,specimen_recv_time,
order_results_line,component_id,component_name,component_base_name,component_type,
component_subtype,component_lab_subtype,component_freetext_loinc_code,result_flag,
order_status,result_status,lab_status,ord_value,ord_num_value,reference_low,reference_high,
reference_unit,result_sub_idn,component_comment_phiflag,result_in_range_yn,ref_normal_vals,
lrr_based_organ_id,data_type,numeric_precision,comp_obs_inst_tm,comp_anl_inst_tm,loinc_code,
loinc_desc,external_ord_id,result_instant_tm
INTO CrownGaribaldiIRB00250975_Projection.dbo.derived_lab_results_masked
from CrownGaribaldiIRB00250975_Projection.dbo.derived_lab_results pat
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map on pat.PAT_ENC_CSN_ID = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;


SELECT id.patient_id,map.enc_ID,order_med_id,line,hosp_admsn_time,hosp_disch_time,
medication_name,generic_name,medication_id,thera_classname,pharm_classname,
pharm_subclassname,taken_time,ordering_date,order_end_time,scheduled_time,
saved_time,mar_time_source,mar_action,route,sig,site,dose_unit,infusion_rate,
mar_inf_rate_unit,mar_duration,duration_unit,frequency,freq_period,freq_type,
number_of_times,time_unit,now_yn,reason,mar_imm_link_id,mar_admin_dept,
mar_ord_dat,pat_supplied_yn,sensitive_yn,mar_action_c
INTO CrownGaribaldiIRB00250975_Projection.dbo.derived_med_admin_masked
from CrownGaribaldiIRB00250975_Projection.dbo.derived_med_admin pat
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map on pat.PAT_ENC_CSN_ID = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,start_date,end_date,med_display_name,med_name,
order_mode,dose,unit,sig,frequency,therapeutic_class,pharmaceutical_class,
pharmaceutical_subclass,ordering_dttm,auth_prov,discon_time,discon_rsn,
current_med_yn,discont_med_yn,order_med_id,medication_id,ord_status,
rxnorm_codes,sensitive_yn,extract_dttm
INTO CrownGaribaldiIRB00250975_Projection.dbo.derived_med_orders_masked
from CrownGaribaldiIRB00250975_Projection.dbo.derived_med_orders pat
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map on pat.PAT_ENC_CSN_ID = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;


SELECT id.patient_id,map.enc_ID,order_proc_id,line,specimen_taken_time,specimen_recv_time,
organism_name,antibiotic,susceptibility,sensitivity_value,sensitivity_units,sens_organism_sid,
sens_obs_inst_tm,sens_anl_inst_tm,result_detail,ordered_lab,component_name,specimen_source,
specimen_type,order_type,result_status,result_flag,lab_status,antibiotic_loinc_code,
method_loinc_code,sens_method_name,proc_id,order_type_c,specimen_source_c,specimen_type_c,
organism_id,antibiotic_c,suscept_c,lab_status_c,sens_status_c,sens_method_id,antibio_lnc_id,
method_lnc_id,component_id,result_flag_c
INTO CrownGaribaldiIRB00250975_Projection.dbo.derived_micro_sensitivities_masked
from CrownGaribaldiIRB00250975_Projection.dbo.derived_micro_sensitivities pat
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map on pat.PAT_ENC_CSN_ID = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;


SELECT id.patient_id,map.enc_ID,pat_enc_date_real,contact_date,enc_type_c,enc_type,visit_prov_id,
visit_provider,department_id,department_name,dept_specialty,dept_rpt_grp_ten,dept_rev_loc_id,
eff_dept_id,eff_dept_name,eff_dept_specialty,eff_dept_rpt_grp_ten,eff_dept_rev_loc_id,appt_time,
appt_status_c,appointment_status,appt_prc_id,appt_visit_type,appt_visit_abbr,appt_cancel_date,
los_proc_code,los_proc_name,lmp_date,lmp_other,hsp_account_id,referral_id,referral_source_id,
bp_systolic,bp_diastolic,temperature,pulse,weight,height,respirations,bmi,bsa,inpatient_data_id,
update_date,sensitive_yn,facility,is_historical,has_vitals,contact_year
INTO CrownGaribaldiIRB00250975_Projection.dbo.derived_outpatient_encounters_masked
from CrownGaribaldiIRB00250975_Projection.dbo.derived_outpatient_encounters pat
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map on pat.PAT_ENC_CSN_ID = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,inpatient_data_id,recorded_time,entry_time,meas_value,meas_name,
meas_disp_name,meas_id,meas_row_type,meas_val_type,meas_row_type_c,meas_val_type_c,meas_template_id,
template_display_name,meas_fsd_id,meas_line,enc_contact_date,enc_dept_id,enc_type,enc_type_c,lastupdate_dttm
INTO CrownGaribaldiIRB00250975_Projection.dbo.derived_epic_vitals_masked
from CrownGaribaldiIRB00250975_Projection.dbo.derived_epic_vitals pat
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map on pat.PAT_ENC_CSN_ID = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id, map.enc_ID, pat.order_med_id, pat.mar_taken_time, pat.medication_id, pat.
   medication_name, pat.epic_generic_name, pat.synth_generic_name, pat.RxCUI, pat.synth_med_class, pat.
   synth_route, pat.mar_route, pat.mar_dose_value, pat.dose_num_value, pat.mar_dose_unit, pat.mar_action, 
   pat.mar_frequency, pat.pharm_subclassname
INTO CrownGaribaldiIRB00250975_Projection.dbo.curated_AllMed_Doses_masked
FROM CrownGaribaldiIRB00250975_Projection.dbo.curated_AllMed_Doses pat
INNER JOIN PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map ON pat.PAT_ENC_CSN_ID = map.Identity_ID
INNER JOIN PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id ON id.osler_id = pat.osler_id;

SELECT id.patient_id, pat.dx_id, pat.source_seq, pat.dx_name, pat.dx_group, pat.parent_dx_id, pat.icd9list, 
   pat.icd10list, pat.num_instances_source, pat.last_date, pat.first_date, pat.sensitive_yn, pat.
   build_date, pat.dxsource
INTO CrownGaribaldiIRB00250975_Projection.dbo.derived_emr_diagnosis_info_masked
FROM CrownGaribaldiIRB00250975_Projection.dbo.derived_emr_diagnosis_info pat
INNER JOIN PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id ON id.osler_id = pat.osler_id;

SELECT *
INTO [CrownGaribaldiIRB00250975_Projection].[dbo].[covid_pmcoe_covidzegcohortdict_v5_masked]
FROM [CrownGaribaldiIRB00250975_Projection].[dbo].[covid_pmcoe_covidzegcohortdict_v5];

SELECT id.patient_id, map.enc_id, episode_idn, pat_episode_seq_num, episode_csn_seq_num, hosp_admsn_time, 
   hosp_disch_time, adt_pat_class_c, hospital_area_id, hosp_loc_abbr, new_episode_flag, pat_num, 
   row_insert_dtm
INTO CrownGaribaldiIRB00250975_Projection.dbo.covid_pmcoe_covidzegmasterepisode_v5_masked
FROM CrownGaribaldiIRB00250975_Projection.dbo.covid_pmcoe_covidzegmasterepisode_v5 pat
INNER JOIN PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map ON pat.PAT_ENC_CSN_ID = map.Identity_ID
INNER JOIN PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id ON id.osler_id = pat.osler_id;

SELECT id.patient_id, map.enc_ID, insert_trigger, adt_pat_class_c, adt_pat_class_name, hospital_area_id, 
   hosp_loc_abbr, admit_source_c, admit_source_name, transfer_from_c, transfer_from_name, means_of_arrv_c
   , arrv_means_name, acuity_level_c, acuity_level_name, adt_arrival_time, ed_disp_time, ed_disposition_c, 
   ed_disposition_name, ed_episode_id, hosp_admsn_time, hosp_admsn_type_c, hosp_admsn_type_name, 
   hosp_serv_c, hosp_serv_name, op_adm_date, inpatient_data_id, inp_adm_date, inp_adm_event_date, 
   emer_adm_date, ob_ld_laboring_yn, covid_pos_test_dtm, infection_id, heic_104_add_utc_dttm, 
   heic_104_resolve_utc_dttm, heic_104_duration_dd, init_dnr_dni, level_of_care_c, lvl_of_care_name, 
   hosp_disch_time, los_days, department_id, dep_name, disch_disp_c, 
   disch_disp_name, disch_dest_c, disch_dest_name, hsp_account_id, coding_status_c, coding_status_name, 
   coding_datetime, inclcriteria_pos_test, inclcriteria_heic104, inclcriteria_dischcode, 
   disch_dx_line1_icd, disch_dx_line1_name, disch_dx_line2_icd, disch_dx_line2_name, disch_dx_u07_1_line
   , valid_yn, omit_row_flag, omit_row_reason, row_insert_dtm, row_update_dtm, 
   acct_billsts_ha_c, acct_billsts_ha_name, acct_billed_date
INTO CrownGaribaldiIRB00250975_Projection.dbo.covid_pmcoe_encounters_v5_masked
FROM CrownGaribaldiIRB00250975_Projection.dbo.covid_pmcoe_encounters_v5 pat
INNER JOIN PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map ON pat.PAT_ENC_CSN_ID = map.Identity_ID
INNER JOIN PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id ON id.osler_id = pat.osler_id;

SELECT id.patient_id,cohort_id,episode_idn,insert_dtm,onset_dtm,offset_dtm,remove_flag,remove_flag_dtm
INTO CrownGaribaldiIRB00250975_Projection.dbo.covid_pmcoe_episodelink_v5_masked
FROM CrownGaribaldiIRB00250975_Projection.dbo.covid_pmcoe_episodelink_v5 pat
INNER JOIN PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id ON id.osler_id = pat.osler_id;

SELECT id.patient_id, map.enc_ID, order_proc_id, order_status_c, order_status, lab_status_c, lab_status, 
   order_inst, result_time, enc_type, proc_name, proc_code, line, ord_quest_id, ord_quest_date, quest_name, 
   question, ord_quest_resp, is_answr_byproc_yn, ord_quest_cmt, question_type_c, question_type, 
   record_state, lastupdate_dttm
INTO CrownGaribaldiIRB00250975_Projection.dbo.derived_order_questionnaires_masked
FROM CrownGaribaldiIRB00250975_Projection.dbo.derived_order_questionnaires pat
INNER JOIN PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map ON pat.PAT_ENC_CSN_ID = map.Identity_ID
INNER JOIN PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id ON id.osler_id = pat.osler_id;

SELECT id.patient_id, EPISODE_IDN, pat.BIRTH_DATE, AGE_YEARS, SEX_C, SEX_DESC, RACE_C, RACE_DESC, 
   HISPANIC_C, HISPANIC_DESC, POSITIVE_TEST_TIME, ED_TRIAGE_TIME, ED_DEPARTURE_TIME, ED_HOSPITAL_AREA_ID, 
   ED_HOSP_LOC_ABBR, map2.enc_ID "ED_Enc_ID", INIT_INPT_HOSPITAL_AREA_ID, INIT_INPT_HOSP_LOC_ABBR, 
   map.enc_ID "Init_Enc_ID", INIT_ADT_PAT_CLASS_C, INIT_INPT_HOSP_ADMSN_TIME, INPT_ADMIT_TIME, 
   INIT_ADMIT_SOURCE_C, INIT_ADMIT_SOURCE_NAME, INIT_TRANSFER_FROM_C, INIT_TRANSFER_FROM_NAME, 
   INIT_INTRA_JHM_TRANSFER_HOSP_ADMSN_TIME, FINAL_HOSPITAL_AREA_ID, FINAL_HOSP_LOC_ABBR, 
   map3.enc_ID "Final_Enc_Id", ED_OXYGEN_RX, ED_NIPPV_RX, ED_HIFLOW_RX, ED_VENT_START, ED_IVPRESSOR_RX, 
   OXYGEN_RX, INT_DIALYSIS_RX, NIPPV_RX, HIFLOW_RX, VENT_START, IVPRESSOR_RX, CRRT_RX, ECMO_RX, ECMO_END, 
   TRACH_DTM, CHEST_TUBE_DTM, CONVALESCENT_PLASMA_DTM, VENT_END, IVPRESSOR_END, HIFLOW_END, NIPPV_END, 
   CRRT_END, INT_DIALYSIS_END, OXYGEN_END, INIT_DNR_DNI, FINAL_HOSP_DISCH_TIME, FINAL_DISCH_DISP_C, 
   FINAL_DISCH_DISP_NAME, DEATH_TIME, CODE_COMPLETN_STS_HA_C, CODE_COMPLETN_STS_NAME, 
   CODE_COMPLETN_STS_DTM, ACCT_BILLSTS_HA_C, ACCT_BILLSTS_HA_NAME, ACCT_BILLED_DATE, POS_TEST_FLAG_YN, 
   HEIC_FLAG_YN, ICD10_FLAG_YN, ALTERNATE_U07_ICD10_FLAG_YN, ROW_INSERT_DTM, ROW_LOCK_FLAG_YN, 
   ROW_LOCK_DTM record_state
INTO CrownGaribaldiIRB00250975_Projection.dbo.covid_pmcoe_ipevents_v5_masked
FROM CrownGaribaldiIRB00250975_Projection.dbo.covid_pmcoe_ipevents_v5 pat
INNER JOIN PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map ON pat.INIT_INPT_PAT_ENC_CSN_ID = map.Identity_ID
INNER JOIN PMAP_Analytics.dbo.CCDA3206_garibaldi_osler_id_mapping id ON id.osler_id = pat.osler_id
LEFT JOIN PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map2 ON pat.ED_PAT_ENC_CSN_ID = map2.Identity_ID
LEFT JOIN PMAP_Analytics.dbo.CCDA3206_garibaldi_csn_mapping map3 ON pat.FINAL_PAT_ENC_CSN_ID = map3.Identity_ID;

--Drop original tables
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.covid_pmcoe_covid_positive;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.covid_pmcoe_convalescent_plasma;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.curated_covid_immunizations;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.curated_elixhauser_comorbidities;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.curated_Inflam_Markers;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.curated_ipevents;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.curated_ipvitals;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.curated_who_status;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_adt_location_history;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_ecg_results;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_encounter_dx;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_enroll_info;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_epic_patient;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_flowsheet_data;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_hosp_billing_dx;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_hosp_billing_px;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_image_procedures;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_immunizations;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_infections;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_inpatient_encounters;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_lab_results;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_med_admin;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_med_orders;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_medical_hx_summary;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_micro_sensitivities;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_outpatient_encounters;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_problem_list;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_profee_billing_px;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.curated_Adult_RTAssessment;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_code_status;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_social_history_changes;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_epic_vitals;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.curated_AllMed_Doses;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_emr_diagnosis_info;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.covid_pmcoe_covidzegcohortdict_v5;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.covid_pmcoe_covidzegmasterepisode_v5;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.covid_pmcoe_encounters_v5;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.covid_pmcoe_episodelink_v5;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.covid_pmcoe_ipevents_v5;
DROP table if exists CrownGaribaldiIRB00250975_Projection.dbo.derived_order_questionnaires;
