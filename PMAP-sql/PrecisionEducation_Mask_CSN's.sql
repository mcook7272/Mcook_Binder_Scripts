--Drop tables
drop table if exists PMAP_Staging.dbo.CCDA2205_PrecisionEducation_csn_Mapping;

drop table if exists PrecisionEducation_Projection.EPIC.pe_learner_cohort;
drop table if exists PrecisionEducation_Projection.EPIC.pe_all_learner_enc_map;
drop table if exists PrecisionEducation_Projection.EPIC.pe_inpatient_encounters;
drop table if exists PrecisionEducation_Projection.EPIC.pe_derived_epic_patient;
drop table if exists PrecisionEducation_Projection.EPIC.pe_epic_all_encounters;
drop table if exists PrecisionEducation_Projection.EPIC.pe_hosp_billing_dx;
drop table if exists PrecisionEducation_Projection.EPIC.pe_notes_metadata;
drop table if exists PrecisionEducation_Projection.EPIC.pe_medical_hx;
drop table if exists PrecisionEducation_Projection.EPIC.pe_problem_list;
drop table if exists PrecisionEducation_Projection.EPIC.pe_encounter_dx;
drop table if exists PrecisionEducation_Projection.EPIC.pe_learner_treatment_team_roles;
--drop table if exists PrecisionEducation_Projection.EPIC.pe_lab_results;

--PHI Table
drop table if exists PrecisionEducation_Projection.phi.pe_derived_epic_patient;

--Create mapping table
SELECT 
	a.*
	--,'Pat_'+ cast(ROW_NUMBER() OVER (ORDER BY A.IDENTITY_ID) as varchar) as 'Masked ID'
	,ROW_NUMBER() OVER (ORDER BY A.cohort_id) as 'MaskedCSN'
	into PMAP_Staging.dbo.CCDA2205_PrecisionEducation_csn_Mapping
FROM (
	SELECT DISTINCT
		t.cohort_id, t.pat_enc_csn_id "Identity_ID"
	FROM (
		select distinct [cohort_id], pat_enc_csn_id
		from PMAP_Staging.dbo.pe_epic_all_encounters
		union
		select distinct [cohort_id], pat_enc_csn_id
		from PMAP_Staging.dbo.pe_hosp_billing_dx
		union
		select distinct [cohort_id], pat_enc_csn_id
		from PMAP_Staging.dbo.pe_notes_metadata
		union
		select distinct [cohort_id], hx_lnk_enc_csn
		from PMAP_Staging.dbo.pe_medical_hx
		union
		select distinct [cohort_id], pat_enc_csn_id
		from PMAP_Staging.dbo.pe_all_learner_enc_map
		union
		select distinct [cohort_id], pat_enc_csn_id
		from PMAP_Staging.dbo.pe_inpatient_encounters
		union
		select distinct [cohort_id], pat_enc_csn_id
		from PMAP_Staging.dbo.pe_encounter_dx
		UNION
		select distinct [cohort_id], pat_enc_csn_id
		from PMAP_Staging.dbo.pe_learner_treatment_team_roles
		/*
		union
		select distinct [cohort_id], pat_enc_csn_id
		from PMAP_Staging.dbo.pe_problem_list
		union
		select distinct [cohort_id], pat_enc_csn_id
		from PMAP_Staging.dbo.pe_lab_results
		*/
	) t
 )A;

 --Load tables
  Select firstname,middlename,lastname,jhedid,hopkinsid,department,division,startdate,enddate,epic_prov_id,epic_user_id,provider_name,prov_type,del_status_c,emp_name,emp_prov_id
 into PrecisionEducation_Projection.EPIC.pe_learner_cohort
 FROM PMAP_Staging.dbo.pe_learner_cohort pe;
  
  Select pe.cohort_id, birth_date, pat_status, death_date, gender, first_race, ethnic_group
 into PrecisionEducation_Projection.EPIC.pe_derived_epic_patient
 FROM PMAP_Staging.dbo.pe_derived_epic_patient pe;

  Select pe.cohort_id,encsource,MaskedCSN,hopkinsid,epic_prov_id,epic_user_id,
  facility,department_name,encounter_type,contact_date,hosp_admsn_time,hosp_dischrg_time,effective_dept_id,enc_type_c
 into PrecisionEducation_Projection.EPIC.pe_all_learner_enc_map
 FROM PMAP_Staging.dbo.pe_all_learner_enc_map pe
 inner join PMAP_Staging.dbo.CCDA2205_PrecisionEducation_csn_Mapping mask on pe.pat_enc_csn_id = mask.Identity_ID;

 Select pe.cohort_id,MaskedCSN,adt_pat_class_c,adt_pat_class,adt_patient_stat_c,adt_patient_stat,
 admit_source,delivery_type,labor_status,adt_arrival_time,hosp_admsn_time,hosp_disch_time,
 hosp_admsn_type,department_id,dept_name,dep_speciality,disch_disp_c,disc_disp,contact_date,
 inp_adm_date,ed_departure_time,op_adm_date,emer_adm_date,hospital_service,ed_visit_yn,
 discharge_prov_id,admission_prov_id,transfer_from,disch_destination,level_of_care
 into PrecisionEducation_Projection.EPIC.pe_inpatient_encounters
 FROM PMAP_Staging.dbo.pe_inpatient_encounters pe
 inner join PMAP_Staging.dbo.CCDA2205_PrecisionEducation_csn_Mapping mask on pe.pat_enc_csn_id = mask.Identity_ID;

 Select pe.cohort_id,MaskedCSN,contact_date,enc_type,appt_visit_type,
 appointment_status,sensitive_yn,inpatient_flag,adt_pat_class,hosp_admission_type,
 department_id,department_name,primary_loc_id,primary_location,eff_dept_name,
 visit_prov_id,attending_prov_id,ordering_prov_id,hosp_admission_time,hosp_discharge_time,
 order_proc_count,order_med_count,has_hospital_enc 
 into PrecisionEducation_Projection.EPIC.pe_epic_all_encounters
 FROM PMAP_Staging.dbo.pe_epic_all_encounters pe
 inner join PMAP_Staging.dbo.CCDA2205_PrecisionEducation_csn_Mapping mask on pe.pat_enc_csn_id = mask.Identity_ID;

Select pe.cohort_id,MaskedCSN,dx_id,dx_name,dx_group,icd10_code,current_icd10_list,
dx_comorbidity_yn,severity_of_illness,risk_of_mortality,present_on_admission,comorbidity_exists,
diagnosis_type,dx_start_dt,dx_end_dt,dx_problem_id,atc_dx_name,cancer_status,dx_documenting_user_id,dx_qualifier
into PrecisionEducation_Projection.EPIC.pe_hosp_billing_dx
FROM PMAP_Staging.dbo.pe_hosp_billing_dx pe
inner join PMAP_Staging.dbo.CCDA2205_PrecisionEducation_csn_Mapping mask on pe.pat_enc_csn_id = mask.Identity_ID;

Select pe.cohort_id,MaskedCSN,department_name,enc_type,note_id,
create_instant_dttm,ip_note_type,hist_doc_type,auth_lnked_prov_id,note_status,
upd_by_auth_dttm,dict_prov_id,authent_stat,text_exists_yn,sensitive_yn
into PrecisionEducation_Projection.EPIC.pe_notes_metadata
FROM PMAP_Staging.dbo.pe_notes_metadata pe
inner join PMAP_Staging.dbo.CCDA2205_PrecisionEducation_csn_Mapping mask on pe.pat_enc_csn_id = mask.Identity_ID;

Select pe.cohort_id,MaskedCSN,medical_hx_date,med_hx_start_dt,med_hx_end_dt,dx_id,
dx_name,dx_group,parent_dx_id,parent_dx_name,icd10_code,current_icd10_list,med_hx_source,med_hx_source_c
into PrecisionEducation_Projection.EPIC.pe_medical_hx
FROM PMAP_Staging.dbo.pe_medical_hx pe
inner join PMAP_Staging.dbo.CCDA2205_PrecisionEducation_csn_Mapping mask on pe.hx_lnk_enc_csn = mask.Identity_ID;

Select *
 into PrecisionEducation_Projection.EPIC.pe_problem_list
 FROM PMAP_Staging.dbo.pe_problem_list pe;

 Select pe.cohort_id,MaskedCSN,line,dx_id,dx_name,dx_group,
 parent_dx_name,icd10_code,current_icd10_list,enc_contact_date,
 dx_qualifier,primary_dx_yn,dx_chronic_yn,dx_unique,dx_ed_yn,dx_link_prob_id
into PrecisionEducation_Projection.EPIC.pe_encounter_dx
FROM PMAP_Staging.dbo.pe_encounter_dx pe
inner join PMAP_Staging.dbo.CCDA2205_PrecisionEducation_csn_Mapping mask on pe.pat_enc_csn_id = mask.Identity_ID;

 Select pe.cohort_id,MaskedCSN,encsource,hopkinsid,epic_prov_id,epic_user_id,
 contact_date,prov_specialty_c,prov_specialty,is_deleted_yn,prov_rel_c,provider_role,
 tr_team_beg_dttm,tr_team_end_dttm,tr_team_ed_yn,tr_team_comment,hosp_admsn_time,
 hosp_dischrg_time,effective_dept_id,department_name,facility,rev_loc_id,enc_type_c,encounter_type
into PrecisionEducation_Projection.EPIC.pe_learner_treatment_team_roles
FROM PMAP_Staging.dbo.pe_learner_treatment_team_roles pe
inner join PMAP_Staging.dbo.CCDA2205_PrecisionEducation_csn_Mapping mask on pe.pat_enc_csn_id = mask.Identity_ID;

--PHI Table
SELECT *
INTO PrecisionEducation_Projection.phi.pe_derived_epic_patient
FROM PMAP_Staging.dbo.pe_derived_epic_patient;

/*
Select * 
into PrecisionEducation_Projection.EPIC.pe_lab_results 
FROM PMAP_Staging.dbo.pe_lab_results pe
inner join PMAP_Staging.dbo.CCDA2205_PrecisionEducation_csn_Mapping mask on pe.pat_enc_csn_id = mask.Identity_ID;

  Select pe.cohort_id, emrn, jhhmrn, bmcmrn, birth_date, pat_status, death_date, gender, first_race, ethnic_group
 into PrecisionEducation_Projection.phi.pe_derived_epic_patient
 FROM PMAP_Staging.dbo.pe_derived_epic_patient pe;
*/



