Drop table if exists PMAP_Analytics.dbo.derived_notes_text_neuro
Select t.*
into PMAP_Analytics.dbo.derived_notes_text_neuro
from
(select *
from PMAP_Analytics.dbo.derived_notes_text_neuro_1
union
select *
from PMAP_Analytics.dbo.derived_notes_text_neuro_2
union
select *
from PMAP_Analytics.dbo.derived_notes_text_neuro_3) t
inner join CROWNVenkatasan_Scratch.dbo.stratified_patient_sample sam on t.pat_enc_csn_id = sam.CSN
order by t.osler_id, t.create_instant_dttm;

--7/2/2021

Drop table if exists PMAP_Analytics.dbo.derived_notes_text_neuro_2021_07_21;

WITH NEURO_NOTES AS

(select *
from PMAP_Analytics.dbo.derived_notes_text_neuro_20210628_1
union
select *
from PMAP_Analytics.dbo.derived_notes_text_neuro_20210628_2
union
select *
from PMAP_Analytics.dbo.derived_notes_text_neuro_20210628_3)

Select t.*
into PMAP_Analytics.dbo.derived_notes_text_neuro_2021_07_21
from(
 select neuro.*
 from CROWNVenkatasan_scratch.dbo.Venkatesan_inpatient_covidpositive_cohort coh
 join NEURO_NOTES neuro on coh.csn1 = neuro.pat_enc_csn_id
 union
 select neuro.*
 from CROWNVenkatasan_scratch.dbo.Venkatesan_inpatient_covidpositive_cohort coh
 join NEURO_NOTES neuro on coh.csn2 = neuro.pat_enc_csn_id
 )t
order by t.osler_id, t.create_instant_dttm

--Radiology 1) trigger Covid_Admin_Radiology Projection 2) Run this query 3) Niteesh adds identifier 4) Send to Masoud for NLP
drop table if exists PMAP_Analytics.dbo.CCDA2010_Venkatesan_custom_radiology_results;

WITH ENCS AS (
select distinct coh.csn1 "csn"
 from CROWNVenkatasan_scratch.dbo.Venkatesan_inpatient_covidpositive_cohort coh
 where coh.csn1 is NOT NULL
 union
 select distinct coh.csn2 "csn"
 from CROWNVenkatasan_scratch.dbo.Venkatesan_inpatient_covidpositive_cohort coh
 where coh.csn2 is NOT NULL
),

PROCS AS (
Select distinct order_proc_id
FROM COVID_Admin_Projection.[dbo].[covid_pmcoe_radiology_narratives] narr
inner join ENCS enc on enc.csn = narr.pat_enc_csn_id 
union
Select distinct order_proc_id
FROM COVID_Admin_Projection.[dbo].[covid_pmcoe_radiology_impression] imp
inner join ENCS enc on enc.csn = imp.pat_enc_csn_id 
)

select narr.*, imp.impression
  into PMAP_Analytics.dbo.CCDA2010_Venkatesan_custom_radiology_results
  from COVID_Admin_Projection.[dbo].[covid_pmcoe_radiology_narratives] narr  
  inner join PROCS prc on prc.order_proc_id = narr.order_proc_id 
  inner join COVID_Admin_Projection.[dbo].[covid_pmcoe_radiology_impression] imp on prc.order_proc_id = imp.order_proc_id
  where narr.proc_code in ('IMG4020','IMG208','IMG209','IMG207','IMG4001','IMG182','IMG183','IMG181','IMG4025',
  'IMG214','IMG215','IMG213','IMG1238','IMG1240','IMG1236','IMG3233','IMG4022','IMG211','IMG212','IMG210',
  'IMG3259','IMG786','IMG3261','IMG4107','IMG2600','IMG734','IMG736','IMG1554','IMG735','IMG837','IMG853',
  'IMG483','IMG900','IMG250','IMG4521','IMG264','IMG265','IMG263','IMG3343','IMG3344','IMG1917','IMG1916', 
  'IMG1912','IMG3269','IMG3376','IMG4517','IMG4197','IMG4397','IMG3270','IMG3310','IMG4225','IMG3311','IMG4524',
  'IMG3004','IMG270','IMG3274','IMG271','IMG6099','IMG3600','IMG3272','IMG3273','IMG269','IMG3003','IMG3322', 
  'IMG3321','IMG280','IMG285','IMG279','IMG3281','IMG3280','IMG3285','IMG3284','IMG284','IMG287','IMG283',
  'IMG3373','IMG3372','IMG1256','IMG1686','IMG195','IMG198','IMG3183','IMG3184','IMG4565','IMG4569','IMG282', 
  'IMG286','IMG281','IMG3317','IMG338','IMG2623','IMG448','IMG447','IMG453','IMG457','IMG455','IMG456',  
  'IMG6041','IMG6042','IMG3315','IMG3314','IMG3305','IMG3177')

  --Radiology, osler_id only

drop table if exists PMAP_Analytics.dbo.CCDA2010_Venkatesan_custom_radiology_results_osler;

select narr.*, imp.impression
--select distinct narr.osler_id, imp.osler_id, narr.pat_enc_csn_id, imp.pat_enc_csn_id, narr.order_proc_id, imp.order_proc_id, narr.proc_code, imp.proc_code, narr.narrative, imp.impression
  into PMAP_Analytics.dbo.CCDA2010_Venkatesan_custom_radiology_results_osler
  from COVID_Admin_Projection.[dbo].[covid_pmcoe_radiology_narratives] narr  
  inner join CROWNVenkatasan_Projection.dbo.covid_pmcoe_covid_positive pos on pos.osler_id = narr.osler_id 
  inner join COVID_Admin_Projection.[dbo].[covid_pmcoe_radiology_impression] imp on narr.order_proc_id = imp.order_proc_id
  --inner join PROCS prc on narr.order_proc_id = prc.order_proc_id
  --inner join COVID_Admin_Projection.[dbo].[covid_pmcoe_radiology_impression] imp on prc.order_proc_id = imp.order_proc_id
  where narr.proc_code in ('IMG4020','IMG208','IMG209','IMG207','IMG4001','IMG182','IMG183','IMG181','IMG4025',
  'IMG214','IMG215','IMG213','IMG1238','IMG1240','IMG1236','IMG3233','IMG4022','IMG211','IMG212','IMG210',
  'IMG3259','IMG786','IMG3261','IMG4107','IMG2600','IMG734','IMG736','IMG1554','IMG735','IMG837','IMG853',
  'IMG483','IMG900','IMG250','IMG4521','IMG264','IMG265','IMG263','IMG3343','IMG3344','IMG1917','IMG1916', 
  'IMG1912','IMG3269','IMG3376','IMG4517','IMG4197','IMG4397','IMG3270','IMG3310','IMG4225','IMG3311','IMG4524',
  'IMG3004','IMG270','IMG3274','IMG271','IMG6099','IMG3600','IMG3272','IMG3273','IMG269','IMG3003','IMG3322', 
  'IMG3321','IMG280','IMG285','IMG279','IMG3281','IMG3280','IMG3285','IMG3284','IMG284','IMG287','IMG283',
  'IMG3373','IMG3372','IMG1256','IMG1686','IMG195','IMG198','IMG3183','IMG3184','IMG4565','IMG4569','IMG282', 
  'IMG286','IMG281','IMG3317','IMG338','IMG2623','IMG448','IMG447','IMG453','IMG457','IMG455','IMG456',  
  'IMG6041','IMG6042','IMG3315','IMG3314','IMG3305','IMG3177')