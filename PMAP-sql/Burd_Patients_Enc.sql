WITH ptlist AS
(
select distinct z.osler_id
from
(
select enc.osler_id, max(enc.hosp_admsn_time) as maxenctime
from COVID_Projection..derived_inpatient_encounters enc
inner join COVID_Projection..derived_encounter_dx dx on enc.pat_enc_csn_id = dx.pat_enc_csn_id
where hosp_admsn_time is not null and (dx.icd10_code like '%O26.89%' or dx.icd10_code like '%O26.9%' or dx.icd10_code like '%O26.9%'
  or dx.icd10_code like '%O35%' or dx.icd10_code like '%O36%' or dx.icd10_code like '%O09.90%')
group by enc.osler_id
having max(hosp_admsn_time) between '03/15/2020' and '08/15/2020'
union 
select op.osler_id, max(op.contact_date) as maxenctime
from COVID_Projection..derived_outpatient_encounters op
inner join COVID_Projection..derived_encounter_dx dx on op.pat_enc_csn_id = dx.pat_enc_csn_id
where (contact_date between '03/15/2020' and '08/15/2020') and (dx.icd10_code like '%O26.89%' or dx.icd10_code like '%O26.9%' or dx.icd10_code like '%O26.9%'
  or dx.icd10_code like '%O35%' or dx.icd10_code like '%O36%' or dx.icd10_code like '%O09.90%')
group by op.osler_id
union
select bill.osler_id, max(bill.adm_date_time) as maxenctime
from COVID_Projection..derived_hosp_billing_dx bill
inner join COVID_Projection..derived_encounter_dx dx on bill.osler_id = dx.osler_id
where (bill.adm_date_time between '03/15/2020' and '08/15/2020') and (dx.icd10_code like '%O26.89%' or dx.icd10_code like '%O26.9%' or dx.icd10_code like '%O26.9%'
  or dx.icd10_code like '%O35%' or dx.icd10_code like '%O36%' or dx.icd10_code like '%O09.90%')
group by bill.osler_id
) z 
join COVID_Projection..covid_pmcoe_covid_positive cp on cp.osler_id = z.osler_id
where cp.age_at_positive > 17
)
select pat.osler_id,birth_date,pat.pat_status,pat.death_date,pat.gender,
genderabbr,ethnic_group,pat.first_race,racew,raceb,racei,racea,
racep,raceo,racerf,raceu,racetwo,racedec,raceh,language,zipcode,first_contact,last_contact,
next_contact,primarycare_prov_id,primarycare_prov_name,primaryloc_id,primaryloc_name,intrptr_needed_yn
--into CROWNBurd_Projection.dbo.derived_epic_patient
from COVID_Projection..derived_epic_patient pat
inner join ptlist pt on pat.osler_id = pt.osler_id;