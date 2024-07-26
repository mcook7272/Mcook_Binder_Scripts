USE [PMAP_Analytics]

--Drop tables that will be re-loaded
Drop table if exists PMAP_Analytics.dbo.CCDA2614_McAdams_csn_Mapping;
Drop table if exists PMAP_Analytics.dbo.CCDA2614_McAdams_osler_id_Mapping;
DROP table if exists CROWNMcAdams_Projection.dbo.covid_pmcoe_covid_positive_masked;
DROP table if exists CROWNMcAdams_Projection.dbo.curated_elixhauser_comorbidities_masked;
DROP table if exists CROWNMcAdams_Projection.dbo.Curated_IPEvents_masked;
DROP table if exists CROWNMcAdams_Projection.dbo.derived_encounter_dx_masked;
DROP table if exists CROWNMcAdams_Projection.dbo.derived_epic_patient_masked;
DROP table if exists CROWNMcAdams_Projection.dbo.derived_medical_hx_summary_masked;
DROP table if exists CROWNMcAdams_Projection.dbo.derived_problem_list_masked;
DROP table if exists CROWNMcAdams_Projection.dbo.derived_emr_diagnosis_info_masked;


--Create mapping tables

--CSN
SELECT 
	a.*
	--,'Pat_'+ cast(ROW_NUMBER() OVER (ORDER BY A.IDENTITY_ID) as varchar) as 'Masked ID'
	,ROW_NUMBER() OVER (ORDER BY A.IDENTITY_ID) as 'enc_ID'
	into PMAP_Analytics.dbo.CCDA2614_McAdams_csn_mapping
FROM (
	SELECT DISTINCT
		t.pat_enc_csn_id "Identity_ID"
	FROM (
		select distinct osler_id, pat_enc_csn_id
		from CROWNMcAdams_Projection.dbo.derived_encounter_dx
		union
		select distinct osler_id, INIT_PAT_ENC_CSN_ID
		from CROWNMcAdams_Projection.dbo.Curated_IPEvents
		union
		select distinct osler_id, LINKED_CSN
		from CROWNMcAdams_Projection.dbo.Curated_IPEvents
	) t
	WHERE t.pat_enc_csn_id is not null
 )a;

 --osler_id
  SELECT 
	a.*
	--,'Pat_'+ cast(ROW_NUMBER() OVER (ORDER BY A.IDENTITY_ID) as varchar) as 'Masked ID'
	,ROW_NUMBER() OVER (ORDER BY A.osler_id) as 'patient_id'
	into PMAP_Analytics.dbo.CCDA2614_McAdams_osler_id_mapping
FROM (
	SELECT DISTINCT
		osler_id, birth_date
	from CROWNMcAdams_Projection.dbo.derived_epic_patient
 )A;

 --Load tables
 select id.patient_id,pat.emrn,jhhmrn,bmcmrn,pat.hcgmrn,pat.smhmrn,pat.shmrn,
 pat.birth_date,pat_status,
 death_date,gender,genderabbr,ethnic_group,first_race,racew,raceb,racei,racea,racep,
 raceo,racerf,raceu,racetwo,racedec,raceh,language,first_contact,last_contact,
 next_contact,primaryloc_id,primaryloc_name,intrptr_needed_yn
into CROWNMcAdams_Projection.dbo.derived_epic_patient_masked
from CROWNMcAdams_Projection.dbo.derived_epic_patient pat
inner join PMAP_Analytics.dbo.CCDA2614_McAdams_osler_id_mapping id on id.osler_id = pat.osler_id
order by id.patient_id;


SELECT id.patient_id,first_race,gender,age_at_positive,
pat_status,death_date,initial_dx_date,infection_add_date,
positive_collection_date,positive_result_date,rsltdt_infadd_hour_interval,initial_dx_source 
INTO CROWNMcAdams_Projection.dbo.covid_pmcoe_covid_positive_masked
from CROWNMcAdams_Projection.dbo.covid_pmcoe_covid_positive pat
inner join PMAP_Analytics.dbo.CCDA2614_McAdams_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,el_depress,el_anemdef,el_htn,el_wghtloss,el_lymph,
el_coag,el_alcohol,el_chf,el_renlfail,el_perivasc,el_tumor,el_aids,
el_para,el_pulmcirc,el_htncx,el_ulcer,el_psych,el_obese,el_bldloss,
el_chrnlung,el_drug,el_hypothy,el_mets,el_lytes,el_liver,el_arth,
el_neuro,el_dmcx,el_valve,el_dm,icd10 
INTO CROWNMcAdams_Projection.dbo.curated_elixhauser_comorbidities_masked
from CROWNMcAdams_Projection.dbo.curated_elixhauser_comorbidities pat
inner join PMAP_Analytics.dbo.CCDA2614_McAdams_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,AGE,SEX_C,RACE_C,HISPANIC_C,POSITIVE_TEST_TIME,
map.enc_ID "INIT_ENC_ID",ADMIT_TIME,ADMIT_SOURCE_C,ADMIT_SOURCE_NAME,
TRANSFER_FROM_C,TRANSFER_FROM_NAME,INIT_HOSP_LOC_ABBR,map2.enc_ID "LINKED_ENC_ID",
TRANSFER_TIME,OXYGEN_RX,INT_DIALYSIS_RX,NIPPV_RX,HIFLOW_RX,VENT_START,
IVPRESSOR_RX,CRRT_RX,ECMO_RX,ECMO_END,TRACH_DTM,CHEST_TUBE_DTM,
convalescent_plasma_dtm,VENT_END,IVPRESSOR_END,HIFLOW_END,NIPPV_END,
CRRT_END,INT_DIALYSIS_END,OXYGEN_END,INIT_DNR_DNI,FINAL_HOSP_DISCH_TIME,
FINAL_DISCH_DISP_C,FINAL_DISCH_DISP_NAME,DEATH_TIME 
INTO CROWNMcAdams_Projection.dbo.Curated_IPEvents_masked
from CROWNMcAdams_Projection.dbo.Curated_IPEvents pat
inner join PMAP_Analytics.dbo.CCDA2614_McAdams_csn_mapping map on pat.INIT_PAT_ENC_CSN_ID = map.Identity_ID
left join PMAP_Analytics.dbo.CCDA2614_McAdams_csn_mapping map2 on pat.LINKED_CSN = map2.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2614_McAdams_osler_id_mapping id on id.osler_id = pat.osler_id;



SELECT id.patient_id,map.enc_ID,line,dx_id,dx_name,dx_group,parent_dx_id,
parent_dx_name,icd10_code,icd9_code,current_icd10_list,current_icd9_list,
enc_contact_date,dx_qualifier,dx_qualifier_c,primary_dx_yn,dx_chronic_yn,
dx_unique,dx_ed_yn,dx_link_prob_id 
INTO CROWNMcAdams_Projection.dbo.derived_encounter_dx_masked
from CROWNMcAdams_Projection.dbo.derived_encounter_dx pat
inner join PMAP_Analytics.dbo.CCDA2614_McAdams_csn_mapping map on pat.pat_enc_csn_id = map.Identity_ID
inner join PMAP_Analytics.dbo.CCDA2614_McAdams_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,medical_hx_date,med_hx_start_dt,med_hx_end_dt,
dx_id,dx_name,dx_group,parent_dx_name,icd10_code,icd9_code 
INTO CROWNMcAdams_Projection.dbo.derived_medical_hx_summary_masked
from CROWNMcAdams_Projection.dbo.derived_medical_hx_summary pat
inner join PMAP_Analytics.dbo.CCDA2614_McAdams_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,problem_list_id,dx_id,dx_name,dx_group,parent_dx_id,
parent_dx_name,icd10_code,icd9_code,problem_status,class_of_problem,
[priority],treat_summ_stat,noted_date,noted_end_date,resolved_date,
date_of_entry,chronic_yn,principal_pl_yn,problem_status_c,class_of_problem_c,
priority_c,treat_summ_status_c,current_icd10_list,current_icd9_list 
INTO CROWNMcAdams_Projection.dbo.derived_problem_list_masked
from CROWNMcAdams_Projection.dbo.derived_problem_list pat
inner join PMAP_Analytics.dbo.CCDA2614_McAdams_osler_id_mapping id on id.osler_id = pat.osler_id;

SELECT id.patient_id,dx_id,source_seq,dx_name,dx_group,parent_dx_id,
icd9list,icd10list,num_instances_source,last_date,first_date,sensitive_yn,
build_date,dxsource
INTO CROWNMcAdams_Projection.dbo.derived_emr_diagnosis_info_masked
from CROWNMcAdams_Projection.dbo.derived_emr_diagnosis_info pat
inner join PMAP_Analytics.dbo.CCDA2614_McAdams_osler_id_mapping id on id.osler_id = pat.osler_id;
