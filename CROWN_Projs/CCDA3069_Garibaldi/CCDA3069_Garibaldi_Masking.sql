USE [PMAP_Analytics]

--Drop tables that will be re-loaded
Drop table if exists PMAP_Analytics.dbo.CCDA3069_Garibaldi_csn_Mapping;
Drop table if exists PMAP_Analytics.dbo.CCDA3069_Garibaldi_osler_id_Mapping;
DROP table if exists CrownGaribaldiIRB00281488_Projection.dbo.covid_pmcoe_covid_positive_masked;
DROP table if exists CrownGaribaldiIRB00281488_Projection.dbo.curated_elixhauser_comorbidities_masked;
DROP table if exists CrownGaribaldiIRB00281488_Projection.dbo.curated_Inflam_Markers_masked;
DROP table if exists CrownGaribaldiIRB00281488_Projection.dbo.curated_who_status_masked;
DROP table if exists CrownGaribaldiIRB00281488_Projection.dbo.derived_encounter_dx_masked;
DROP table if exists CrownGaribaldiIRB00281488_Projection.dbo.derived_epic_patient_masked;
DROP table if exists CrownGaribaldiIRB00281488_Projection.dbo.derived_hosp_billing_dx_masked;
DROP table if exists CrownGaribaldiIRB00281488_Projection.dbo.derived_hosp_billing_px_masked;
DROP table if exists CrownGaribaldiIRB00281488_Projection.dbo.derived_inpatient_encounters_masked;
DROP table if exists CrownGaribaldiIRB00281488_Projection.dbo.derived_medical_hx_summary_masked;
DROP table if exists CrownGaribaldiIRB00281488_Projection.dbo.derived_problem_list_masked;
DROP table if exists CrownGaribaldiIRB00281488_Projection.dbo.derived_profee_billing_px_masked;
DROP table if exists CrownGaribaldiIRB00281488_Projection.dbo.covid_pmcoe_covidzegcohortdict_v5_masked;
DROP table if exists CrownGaribaldiIRB00281488_Projection.dbo.covid_pmcoe_covidzegmasterepisode_v5_masked;
DROP table if exists CrownGaribaldiIRB00281488_Projection.dbo.covid_pmcoe_encounters_v5_masked;
DROP table if exists CrownGaribaldiIRB00281488_Projection.dbo.covid_pmcoe_episodelink_v5_masked;
DROP table if exists CrownGaribaldiIRB00281488_Projection.dbo.covid_pmcoe_ipevents_v5_masked;
DROP table if exists CrownGaribaldiIRB00281488_Projection.dbo.curated_Adult_RTAssessment_masked;
DROP table if exists CrownGaribaldiIRB00281488_Projection.dbo.derived_code_status_masked;
DROP table if exists CrownGaribaldiIRB00281488_Projection.dbo.derived_emr_diagnosis_info_masked;
DROP table if exists CrownGaribaldiIRB00281488_Projection.dbo.derived_encounter_coverage_masked;
DROP table if exists CrownGaribaldiIRB00281488_Projection.dbo.derived_epic_vitals_masked;
DROP table if exists CrownGaribaldiIRB00281488_Projection.dbo.derived_social_history_changes_masked;
DROP TABLE IF EXISTS CrownGaribaldiIRB00281488_Projection.dbo.edw_geocode_patient_masked;
DROP TABLE IF EXISTS CrownGaribaldiIRB00281488_Projection.dbo.edw_geocode_patient_visit_masked;

--Create mapping tables

--CSN
SELECT 
	a.*
	--,'Pat_'+ cast(ROW_NUMBER() OVER (ORDER BY A.IDENTITY_ID) as varchar) as 'Masked ID'
	,ROW_NUMBER() OVER (ORDER BY A.IDENTITY_ID) as 'enc_ID'
	into PMAP_Analytics.dbo.CCDA3069_garibaldi_csn_mapping
FROM (
	SELECT DISTINCT
		t.pat_enc_csn_id "Identity_ID"
	FROM (
		select distinct osler_id, pat_enc_csn_id
		from CrownGaribaldiIRB00281488_Projection.dbo.derived_inpatient_encounters
		union 
		select distinct osler_id, pat_enc_csn_id
		from CrownGaribaldiIRB00281488_Projection.dbo.derived_hosp_billing_dx
		union 
		select distinct osler_id, pat_enc_csn_id
		from CrownGaribaldiIRB00281488_Projection.dbo.curated_Inflam_Markers
		union
		select distinct osler_id, pat_enc_csn_id
		from CrownGaribaldiIRB00281488_Projection.dbo.derived_hosp_billing_px	
		union
		select distinct osler_id, init_inpt_pat_enc_csn_id
		from CrownGaribaldiIRB00281488_Projection.dbo.covid_pmcoe_ipevents_v5
		union
		select distinct osler_id, ED_PAT_ENC_CSN_ID
		from CrownGaribaldiIRB00281488_Projection.dbo.covid_pmcoe_ipevents_v5
		union
		select distinct osler_id, FINAL_PAT_ENC_CSN_ID
		from CrownGaribaldiIRB00281488_Projection.dbo.covid_pmcoe_ipevents_v5
		union
		select distinct osler_id, pat_enc_csn_id
		from CrownGaribaldiIRB00281488_Projection.dbo.covid_pmcoe_encounters_v5	
	) t
	WHERE t.pat_enc_csn_id is not null
 )a;
 
 --Temporary code to add in csn for social_hx w/out refreshing data and changing mappings
drop table if exists #temp;

select a.*
into #temp
from (
	select Identity_ID, enc_id
	from PMAP_Analytics.dbo.CCDA3069_garibaldi_csn_mapping
	union
	select distinct pat_enc_csn_id, NULL
	from CrownGaribaldiIRB00281488_Projection.dbo.derived_social_history_changes
	union
	select distinct hx_lnk_enc_csn, NULL
	from CrownGaribaldiIRB00281488_Projection.dbo.derived_social_history_changes
) a

DECLARE @id BIGINT 
SET @id = (select max(enc_id) from #temp) --45554
UPDATE #temp
SET @id = enc_id = @id + 1 
where enc_id is NULL
GO 

--select * from #temp order by enc_id


 --osler_id
  SELECT 
	a.*
	--,'Pat_'+ cast(ROW_NUMBER() OVER (ORDER BY A.IDENTITY_ID) as varchar) as 'Masked ID'
	,ROW_NUMBER() OVER (ORDER BY A.osler_id) as 'patient_id'
	into PMAP_Analytics.dbo.CCDA3069_garibaldi_osler_id_mapping
FROM (
	SELECT DISTINCT
		osler_id, birth_date
	from CrownGaribaldiIRB00281488_Projection.dbo.derived_epic_patient
 )A;

 --Load tables
 select id.patient_id,pat.birth_date,pat_status,
 death_date,gender,genderabbr,ethnic_group,first_race,racew,raceb,racei,racea,racep,
 raceo,racerf,raceu,racetwo,racedec,raceh,language,first_contact,last_contact,
 next_contact,primaryloc_id,primaryloc_name,intrptr_needed_yn,zipcode
into CrownGaribaldiIRB00281488_Projection.dbo.derived_epic_patient_masked
from CrownGaribaldiIRB00281488_Projection.dbo.derived_epic_patient pat
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id
order by id.patient_id;

SELECT id.patient_id,first_race,gender,age_at_positive,
pat_status,death_date,initial_dx_date,infection_add_date,
positive_collection_date,positive_result_date,rsltdt_infadd_hour_interval,initial_dx_source 
INTO CrownGaribaldiIRB00281488_Projection.dbo.covid_pmcoe_covid_positive_masked
from CrownGaribaldiIRB00281488_Projection.dbo.covid_pmcoe_covid_positive pat
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,el_depress,el_anemdef,el_htn,el_wghtloss,el_lymph,
el_coag,el_alcohol,el_chf,el_renlfail,el_perivasc,el_tumor,el_aids,
el_para,el_pulmcirc,el_htncx,el_ulcer,el_psych,el_obese,el_bldloss,
el_chrnlung,el_drug,el_hypothy,el_mets,el_lytes,el_liver,el_arth,
el_neuro,el_dmcx,el_valve,el_dm,icd10 
INTO CrownGaribaldiIRB00281488_Projection.dbo.curated_elixhauser_comorbidities_masked
from CrownGaribaldiIRB00281488_Projection.dbo.curated_elixhauser_comorbidities pat
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

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
INTO CrownGaribaldiIRB00281488_Projection.dbo.curated_Inflam_Markers_masked
from CrownGaribaldiIRB00281488_Projection.dbo.curated_Inflam_Markers pat
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,map2.enc_ID "linked_enc_ID",[event],[start],
[end],who_score_numeric,who_score_grouped,who_score 
INTO CrownGaribaldiIRB00281488_Projection.dbo.curated_who_status_masked
from CrownGaribaldiIRB00281488_Projection.dbo.curated_who_status pat
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
left join PMAP_Analytics.dbo.CCDA3069_garibaldi_csn_mapping map2 on pat.LINKED_CSN = map2.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;


SELECT id.patient_id,map.enc_ID,line,dx_id,dx_name,dx_group,parent_dx_id,
parent_dx_name,icd10_code,icd9_code,current_icd10_list,current_icd9_list,
enc_contact_date,dx_qualifier,dx_qualifier_c,primary_dx_yn,dx_chronic_yn,
dx_unique,dx_ed_yn,dx_link_prob_id 
INTO CrownGaribaldiIRB00281488_Projection.dbo.derived_encounter_dx_masked
from CrownGaribaldiIRB00281488_Projection.dbo.derived_encounter_dx pat
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;


SELECT id.patient_id,line,map.enc_ID,dx_id,dx_name,dx_group,icd10_code,
icd9_code,current_icd10_list,current_icd9_list,dx_affects_drg_yn,dx_comorbidity_yn,
final_dx_soi_c,severity_of_illness,final_dx_rom_c,risk_of_mortality,final_dx_excld_yn,
fnl_dx_afct_soi_yn,fnl_dx_afct_rom_yn,final_dx_poa_c,present_on_admission,
dx_comorbidity_c,comorbidity_exists,dx_hac_yn,dx_type_c,diagnosis_type,dx_start_dt,
dx_end_dt,dx_problem_id,dx_chronic_flag_yn,dx_supp_atc_code_c,atc_dx_name,
dx_hsp_prob_flag_yn,dx_overridden_dx_id,dx_disproven_yn,dk_cancer_status_c,
cancer_status,dx_documenting_user_id,fnl_dx_qualifier_c,dx_qualifier,term_dx_id,adm_date_time 
INTO CrownGaribaldiIRB00281488_Projection.dbo.derived_hosp_billing_dx_masked
from CrownGaribaldiIRB00281488_Projection.dbo.derived_hosp_billing_dx pat
left join PMAP_Analytics.dbo.CCDA3069_garibaldi_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,proc_name,code_set_c,code_set_name,code,
proc_date,proc_perf_prov_id,px_cpt_modifiers,modifier_1_ext_code,
modifier_1_name,modifier_2_ext_code,modifier_2_name,modifier_3_ext_code,
modifier_3_name,modifier_4_ext_code,modifier_4_name,px_cpt_quantity,icd_px_id,
source_key,source_name,line,coding_info_cpt_line,exclude_yn,affects_soi_yn,
affects_rom_yn,event_number  
INTO CrownGaribaldiIRB00281488_Projection.dbo.derived_hosp_billing_px_masked
from CrownGaribaldiIRB00281488_Projection.dbo.derived_hosp_billing_px pat
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,pat_enc_date_real,map.enc_ID,
adt_pat_class_c,adt_pat_class,adt_patient_stat_c,adt_patient_stat,
pending_disch_time,exp_admission_time,exp_len_of_stay,admit_source_c,
admit_source,delivery_type_c,delivery_type,labor_status_c,labor_status,
adt_arrival_time,hosp_admsn_time,hosp_disch_time,hosp_admsn_type_c,
hosp_admsn_type,department_id,dept_name,dept_abbreviation,dep_speciality,
dep_rpt_grp_ten,disch_disp_c,disc_disp,contact_date,inp_adm_date,ed_departure_time,
op_adm_date,emer_adm_date,hospital_service,ed_visit_yn,serv_area_name 
INTO CrownGaribaldiIRB00281488_Projection.dbo.derived_inpatient_encounters_masked
from CrownGaribaldiIRB00281488_Projection.dbo.derived_inpatient_encounters pat
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,medical_hx_date,med_hx_start_dt,med_hx_end_dt,
dx_id,dx_name,dx_group,parent_dx_name,icd10_code,icd9_code 
INTO CrownGaribaldiIRB00281488_Projection.dbo.derived_medical_hx_summary_masked
from CrownGaribaldiIRB00281488_Projection.dbo.derived_medical_hx_summary pat
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,problem_list_id,dx_id,dx_name,dx_group,parent_dx_id,
parent_dx_name,icd10_code,icd9_code,problem_status,class_of_problem,
[priority],treat_summ_stat,noted_date,noted_end_date,resolved_date,
date_of_entry,chronic_yn,principal_pl_yn,problem_status_c,class_of_problem_c,
priority_c,treat_summ_status_c,current_icd10_list,current_icd9_list 
INTO CrownGaribaldiIRB00281488_Projection.dbo.derived_problem_list_masked
from CrownGaribaldiIRB00281488_Projection.dbo.derived_problem_list pat
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,proc_name,code_set_c,code_set_name,code,
proc_date,proc_perf_prov_id,px_cpt_modifiers,modifier_1_ext_code,modifier_1_name,
modifier_2_ext_code,modifier_2_name,modifier_3_ext_code,modifier_3_name,
modifier_4_ext_code,modifier_4_name,px_cpt_quantity,proc_id,source_key,source_name,
tx_id,service_area_id,loc_id,location_name,pos_id,place_of_service,department_id,
department,void_date,panel_id,enc_type_c,appt_status_c 
INTO CrownGaribaldiIRB00281488_Projection.dbo.derived_profee_billing_px_masked
from CrownGaribaldiIRB00281488_Projection.dbo.derived_profee_billing_px pat
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT COHORT_NAME,COHORT_DESC,COHORT_SQL_SCRIPT,COHORT_USP,
COHORT_SCOPE,COHORT_TYPE,ROW_ENTRY_DTM,DEPENDENCIES
INTO CrownGaribaldiIRB00281488_Projection.dbo.covid_pmcoe_covidzegcohortdict_v5_masked
from CrownGaribaldiIRB00281488_Projection.dbo.covid_pmcoe_covidzegcohortdict_v5 pat;

SELECT id.patient_id,EPISODE_IDN,PAT_EPISODE_SEQ_NUM,map.enc_ID,EPISODE_CSN_SEQ_NUM,
HOSP_ADMSN_TIME,HOSP_DISCH_TIME,ADT_PAT_CLASS_C,HOSPITAL_AREA_ID,HOSP_LOC_ABBR,
NEW_EPISODE_FLAG,PAT_NUM,ROW_INSERT_DTM
INTO CrownGaribaldiIRB00281488_Projection.dbo.covid_pmcoe_covidzegmasterepisode_v5_masked
from CrownGaribaldiIRB00281488_Projection.dbo.covid_pmcoe_covidzegmasterepisode_v5 pat
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_csn_mapping map on pat.PAT_ENC_CSN_ID = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,INSERT_TRIGGER,ADT_PAT_CLASS_C,ADT_PAT_CLASS_NAME,
HOSPITAL_AREA_ID,HOSP_LOC_ABBR,ADMIT_SOURCE_C,ADMIT_SOURCE_NAME,TRANSFER_FROM_C,TRANSFER_FROM_NAME,
MEANS_OF_ARRV_C,ARRV_MEANS_NAME,ACUITY_LEVEL_C,ACUITY_LEVEL_NAME,ADT_ARRIVAL_TIME,ED_DISP_TIME,
ED_DISPOSITION_C,ED_DISPOSITION_NAME,ED_EPISODE_ID,HOSP_ADMSN_TIME,HOSP_ADMSN_TYPE_C,HOSP_ADMSN_TYPE_NAME,
HOSP_SERV_C,HOSP_SERV_NAME,OP_ADM_DATE,INPATIENT_DATA_ID,INP_ADM_DATE,INP_ADM_EVENT_DATE,EMER_ADM_DATE,
OB_LD_LABORING_YN,COVID_POS_TEST_DTM,INFECTION_ID,HEIC_104_ADD_UTC_DTTM,HEIC_104_RESOLVE_UTC_DTTM,
HEIC_104_DURATION_DD,INIT_DNR_DNI,LEVEL_OF_CARE_C,LVL_OF_CARE_NAME,HOSP_DISCH_TIME,LOS_DAYS,DISCHARGE_PROV_ID,
ADMISSION_PROV_ID,DEPARTMENT_ID,DEP_NAME,DISCH_DISP_C,DISCH_DISP_NAME,DISCH_DEST_C,DISCH_DEST_NAME,
CODING_STATUS_C,CODING_STATUS_NAME,CODING_DATETIME,INCLCRITERIA_POS_TEST,INCLCRITERIA_HEIC104,INCLCRITERIA_DISCHCODE,
DISCH_DX_LINE1_ICD,DISCH_DX_LINE1_NAME,DISCH_DX_LINE2_ICD,DISCH_DX_LINE2_NAME,DISCH_DX_U07_1_LINE,VALID_YN,OMIT_ROW_FLAG,
OMIT_ROW_REASON,ROW_INSERT_DTM,ROW_UPDATE_DTM,ACCT_BILLSTS_HA_C,ACCT_BILLSTS_HA_NAME,ACCT_BILLED_DATE
INTO CrownGaribaldiIRB00281488_Projection.dbo.covid_pmcoe_encounters_v5_masked
from CrownGaribaldiIRB00281488_Projection.dbo.covid_pmcoe_encounters_v5 pat
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_csn_mapping map on pat.PAT_ENC_CSN_ID = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,COHORT_ID,EPISODE_IDN,INSERT_DTM,ONSET_DTM,OFFSET_DTM,REMOVE_FLAG,REMOVE_FLAG_DTM
INTO CrownGaribaldiIRB00281488_Projection.dbo.covid_pmcoe_episodelink_v5_masked
from CrownGaribaldiIRB00281488_Projection.dbo.covid_pmcoe_episodelink_v5 pat
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,EPISODE_IDN,pat.BIRTH_DATE,AGE_YEARS,SEX_C,SEX_DESC,RACE_C,RACE_DESC,
HISPANIC_C,HISPANIC_DESC,POSITIVE_TEST_TIME,ED_TRIAGE_TIME,ED_DEPARTURE_TIME,ED_HOSPITAL_AREA_ID,
ED_HOSP_LOC_ABBR,map.enc_ID "ED_Encounter_ID",INIT_INPT_HOSPITAL_AREA_ID,INIT_INPT_HOSP_LOC_ABBR,
map2.enc_ID "Init_inpt_encounter_ID",INIT_ADT_PAT_CLASS_C,INIT_INPT_HOSP_ADMSN_TIME,INPT_ADMIT_TIME,
INIT_ADMIT_SOURCE_C,INIT_ADMIT_SOURCE_NAME,INIT_TRANSFER_FROM_C,INIT_TRANSFER_FROM_NAME,
INIT_INTRA_JHM_TRANSFER_HOSP_ADMSN_TIME,FINAL_HOSPITAL_AREA_ID,FINAL_HOSP_LOC_ABBR,
map3.enc_ID "Final_Encounter_ID",ED_OXYGEN_RX,ED_NIPPV_RX,ED_HIFLOW_RX,ED_VENT_START,ED_IVPRESSOR_RX,OXYGEN_RX,
INT_DIALYSIS_RX,NIPPV_RX,HIFLOW_RX,VENT_START,IVPRESSOR_RX,CRRT_RX,ECMO_RX,ECMO_END,
TRACH_DTM,CHEST_TUBE_DTM,CONVALESCENT_PLASMA_DTM,VENT_END,IVPRESSOR_END,HIFLOW_END,NIPPV_END,
CRRT_END,INT_DIALYSIS_END,OXYGEN_END,INIT_DNR_DNI,FINAL_HOSP_DISCH_TIME,FINAL_DISCH_DISP_C,
FINAL_DISCH_DISP_NAME,DEATH_TIME,CODE_COMPLETN_STS_HA_C,CODE_COMPLETN_STS_NAME,CODE_COMPLETN_STS_DTM,
ACCT_BILLSTS_HA_C,ACCT_BILLSTS_HA_NAME,ACCT_BILLED_DATE,POS_TEST_FLAG_YN,HEIC_FLAG_YN,ICD10_FLAG_YN,
ALTERNATE_U07_ICD10_FLAG_YN,ROW_INSERT_DTM,ROW_LOCK_FLAG_YN,ROW_LOCK_DTM
INTO CrownGaribaldiIRB00281488_Projection.dbo.covid_pmcoe_ipevents_v5_masked
from CrownGaribaldiIRB00281488_Projection.dbo.covid_pmcoe_ipevents_v5 pat
left join PMAP_Analytics.dbo.CCDA3069_garibaldi_csn_mapping map on pat.ED_PAT_ENC_CSN_ID = map.Identity_ID
left join PMAP_Analytics.dbo.CCDA3069_garibaldi_csn_mapping map2 on pat.INIT_INPT_PAT_ENC_CSN_ID = map2.Identity_ID
left join PMAP_Analytics.dbo.CCDA3069_garibaldi_csn_mapping map3 on pat.FINAL_PAT_ENC_CSN_ID = map3.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,recorded_time,template_id,template_name,template_facility,meas_value_raw,
meas_value,meas_id,meas_name,meas_disp_name,meas_row_type,meas_val_type,meas_fsd_id,meas_line,inpatient_data_id,
group_id,group_disp_name,occurance,ip_lda_id,lda_removal_instant,lda_placement_instant,lda_description,
lda_properties,lda_site,map2.enc_ID "initial_lda_csn",lda_initial_date,concept,pivot_column
INTO CrownGaribaldiIRB00281488_Projection.dbo.curated_Adult_RTAssessment_masked
from CrownGaribaldiIRB00281488_Projection.dbo.curated_Adult_RTAssessment pat
left join PMAP_Analytics.dbo.CCDA3069_garibaldi_csn_mapping map on pat.PAT_ENC_CSN_ID = map.Identity_ID
left join PMAP_Analytics.dbo.CCDA3069_garibaldi_csn_mapping map2 on pat.lda_initial_csn = map2.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,order_id,activated_inst,inactivated_inst,code_status,code_status_context,
ocs_id,code_status_c,code_status_context_c,proc_id,proc_code,proc_name,enc_contact_date,enc_type,enc_type_c
INTO CrownGaribaldiIRB00281488_Projection.dbo.derived_code_status_masked
from CrownGaribaldiIRB00281488_Projection.dbo.derived_code_status pat
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_csn_mapping map on pat.PAT_ENC_CSN_ID = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,dx_id,source_seq,dx_name,dx_group,parent_dx_id,icd9list,icd10list,
num_instances_source,last_date,first_date,sensitive_yn,build_date,dxsource
INTO CrownGaribaldiIRB00281488_Projection.dbo.derived_emr_diagnosis_info_masked
from CrownGaribaldiIRB00281488_Projection.dbo.derived_emr_diagnosis_info pat
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,contact_date,payor,fin_class,account_type,department_name,
guarantor_pat_rel,guarantor_zip,account_id,hsp_account_id
INTO CrownGaribaldiIRB00281488_Projection.dbo.derived_encounter_coverage_masked
from CrownGaribaldiIRB00281488_Projection.dbo.derived_encounter_coverage pat
left join PMAP_Analytics.dbo.CCDA3069_garibaldi_csn_mapping map on pat.PAT_ENC_CSN_ID = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,map.enc_ID,inpatient_data_id,recorded_time,entry_time,meas_value,meas_name,
meas_disp_name,meas_id,meas_row_type,meas_val_type,meas_row_type_c,meas_val_type_c,meas_template_id,
template_display_name,meas_fsd_id,meas_line,enc_contact_date,enc_dept_id,enc_type,enc_type_c,lastupdate_dttm
INTO CrownGaribaldiIRB00281488_Projection.dbo.derived_epic_vitals_masked
from CrownGaribaldiIRB00281488_Projection.dbo.derived_epic_vitals pat
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_csn_mapping map on pat.PAT_ENC_CSN_ID = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

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
INTO CrownGaribaldiIRB00281488_Projection.dbo.derived_social_history_changes_masked
from CrownGaribaldiIRB00281488_Projection.dbo.derived_social_history_changes pat
left join #temp map on pat.PAT_ENC_CSN_ID = map.Identity_ID
left join #temp map2 on pat.hx_lnk_enc_csn = map2.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,city,state_or_province,postalcode,latitude,latitude_char,
longitude,longitude_char,zip_plus4_x,census_tract_x,last_update_dttm
INTO CrownGaribaldiIRB00281488_Projection.dbo.edw_geocode_patient_masked
from CrownGaribaldiIRB00281488_Projection.dbo.edw_geocode_patient pat
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,encounter_date,pat_enc_csn_id,enc_type,city,state_or_province,postal_code,latitude,
latitude_char,longitude,longitude_char,zip_plus4_x,census_tract_x,last_update_dttm
INTO CrownGaribaldiIRB00281488_Projection.dbo.edw_geocode_patient_visit_masked
from CrownGaribaldiIRB00281488_Projection.dbo.edw_geocode_patient_visit pat
left join PMAP_Analytics.dbo.CCDA3069_garibaldi_csn_mapping map on pat.PAT_ENC_CSN_ID = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA3069_garibaldi_osler_id_mapping id on id.osler_id = pat.osler_id;

--Drop original tables
DROP TABLE IF EXISTS CrownGaribaldiIRB00281488_Projection.dbo.covid_pmcoe_covid_positive;
DROP TABLE IF EXISTS CrownGaribaldiIRB00281488_Projection.dbo.covid_pmcoe_covidzegcohortdict_v5;
DROP TABLE IF EXISTS CrownGaribaldiIRB00281488_Projection.dbo.covid_pmcoe_covidzegmasterepisode_v5;
DROP TABLE IF EXISTS CrownGaribaldiIRB00281488_Projection.dbo.covid_pmcoe_encounters_v5;
DROP TABLE IF EXISTS CrownGaribaldiIRB00281488_Projection.dbo.covid_pmcoe_episodelink_v5;
DROP TABLE IF EXISTS CrownGaribaldiIRB00281488_Projection.dbo.covid_pmcoe_ipevents_v5;
DROP TABLE IF EXISTS CrownGaribaldiIRB00281488_Projection.dbo.curated_adult_rtassessment;
DROP TABLE IF EXISTS CrownGaribaldiIRB00281488_Projection.dbo.curated_elixhauser_comorbidities;
DROP TABLE IF EXISTS CrownGaribaldiIRB00281488_Projection.dbo.curated_inflam_markers;
DROP TABLE IF EXISTS CrownGaribaldiIRB00281488_Projection.dbo.curated_who_status;
DROP TABLE IF EXISTS CrownGaribaldiIRB00281488_Projection.dbo.derived_code_status;
DROP TABLE IF EXISTS CrownGaribaldiIRB00281488_Projection.dbo.derived_emr_diagnosis_info;
DROP TABLE IF EXISTS CrownGaribaldiIRB00281488_Projection.dbo.derived_encounter_coverage;
DROP TABLE IF EXISTS CrownGaribaldiIRB00281488_Projection.dbo.derived_encounter_dx;
DROP TABLE IF EXISTS CrownGaribaldiIRB00281488_Projection.dbo.derived_epic_patient;
DROP TABLE IF EXISTS CrownGaribaldiIRB00281488_Projection.dbo.derived_epic_vitals;
DROP TABLE IF EXISTS CrownGaribaldiIRB00281488_Projection.dbo.derived_hosp_billing_dx;
DROP TABLE IF EXISTS CrownGaribaldiIRB00281488_Projection.dbo.derived_hosp_billing_px;
DROP TABLE IF EXISTS CrownGaribaldiIRB00281488_Projection.dbo.derived_inpatient_encounters;
DROP TABLE IF EXISTS CrownGaribaldiIRB00281488_Projection.dbo.derived_medical_hx_summary;
DROP TABLE IF EXISTS CrownGaribaldiIRB00281488_Projection.dbo.derived_problem_list;
DROP TABLE IF EXISTS CrownGaribaldiIRB00281488_Projection.dbo.derived_profee_billing_px;
DROP TABLE IF EXISTS CrownGaribaldiIRB00281488_Projection.dbo.derived_social_history_changes;
DROP TABLE IF EXISTS CrownGaribaldiIRB00281488_Projection.dbo.edw_geocode_patient;
DROP TABLE IF EXISTS CrownGaribaldiIRB00281488_Projection.dbo.edw_geocode_patient_visit;