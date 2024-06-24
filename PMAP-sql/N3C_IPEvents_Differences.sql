USE [COVID_Projection]

select distinct ipe.*
from covid_pmcoe_ipevents_v5 ipe
left join PMAP_Analytics.dbo.N3C_Osler_Mapping map on ipe.osler_id = map.osler_id
where INIT_INPT_HOSP_ADMSN_TIME >= '2020-04-01'
and map.osler_id is NULL;

select distinct map.*
from PMAP_Analytics.dbo.N3C_Osler_Mapping map 
left join covid_pmcoe_ipevents_v5 ipe on ipe.osler_id = map.osler_id
where ipe.osler_id is NULL;

select *
from derived_lab_results
where osler_id = 'd7df4329-6d9e-4179-974b-1264432a6438'
and component_base_name like '%COV%'

select *
from derived_encounter_dx
where pat_enc_csn_id = '1323284371'