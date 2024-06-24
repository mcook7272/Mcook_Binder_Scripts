drop table if exists #Tempccpsei

SELECT *
into #Tempccpsei
  FROM [CROWNParikh_Projection].[ccpsei].[custom_specimens]
  where SUBJECT_NUMBER like '%A0060'
  or SUBJECT_NUMBER like '%A0245'
  or SUBJECT_NUMBER like '%A0185';

  select * from
  CROWNParikh_Projection.ccpsei.covid_pmcoe_covid_positive cov
  inner join #Tempccpsei temp on temp.CCPSEI_patient_id = cov.ccpsei_patient_id;

  select * from
  CROWNParikh_Projection.ccpsei.derived_inpatient_encounters enc
  inner join #Tempccpsei temp on temp.CCPSEI_patient_id = enc.ccpsei_patient_id;

  select * from
  CROWNParikh_Projection.ccpsei.derived_outpatient_encounters enc
  inner join #Tempccpsei temp on temp.CCPSEI_patient_id = enc.ccpsei_patient_id;

  SELECT distinct spec.[CCPSEI_patient_id] "Specimen_pat_id",spec.[SUBJECT_NUMBER] "Spec_Subj_Num", enr.subject_number "enrollment_study_id", enr.osler_id, osler.osler_id "Mapped_osler_id", osler.ccpsei_patient_id "Mapped_Pat_ID"
  FROM [CROWNParikh_Projection].[ccpsei].[custom_specimens] spec
  left join CCPSEI_Projection..crms_enrollments enr on enr.subject_number = spec.[SUBJECT_NUMBER]
  left join PMAP_Analytics..CCDA2540_Parihk_osler_id_Mapping osler on osler.ccpsei_patient_id = spec.CCPSEI_patient_id;
