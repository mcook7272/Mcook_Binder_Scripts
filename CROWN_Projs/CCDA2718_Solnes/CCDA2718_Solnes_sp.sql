ALTER PROCEDURE [dbo].[CCDA2718_Solnes_sp]
AS 
/**********************************************************************************
Author:  Michael Cook
Date: 2021-10-06
JIRA: CCDA-2718
Description: One-time flat-file delivery for Dr. Lilja Solnes for the Brain FDG-Positron-emission tomography findings in COVID-19 study.
Example:
    EXEC dbo.[name of stored proc] [include any parameters and sample values]
     
Revision History:
Date            Author          JIRA            Comment
2021-10-06      mcook49     CCDA-2718          created stored procedure
2021-10-07      mcook49     CCDA-2718          Added DEP CTE
***********************************************************************************/
SET NOCOUNT ON;

DROP TABLE IF EXISTS PMAP_Analytics.dbo.CCDA2718_Solnes_Demographics;

WITH DEP AS (
select distinct pat_enc_csn_id
from COVID_Projection.dbo.derived_inpatient_encounters
where department_id like '1101%' 
union
select distinct pat_enc_csn_id
from COVID_Projection.dbo.derived_outpatient_encounters
where department_id like '1101%'
)

select 
distinct pat.osler_id,pat.emrn,jhhmrn,birth_date, 
pat.pat_name,pat.pat_status,pat.death_date,pat.gender,
genderabbr,ethnic_group,pat.first_race,racew,raceb,racei,racea,
racep,raceo,racerf,raceu,racetwo,racedec,raceh,img.proc_name,img.proc_category,img.result_time
into  PMAP_Analytics.dbo.CCDA2718_Solnes_Demographics
from COVID_Projection.dbo.derived_image_procedures img
inner join COVID_Projection.dbo.derived_epic_patient pat on img.osler_id = pat.osler_id
inner join COVID_Projection.dbo.covid_pmcoe_covid_positive pos on img.osler_id = pos.osler_id --Covid positive
inner join DEP on img.pat_enc_csn_id = DEP.pat_enc_csn_id --JHH only
where img.proc_category like '%pet%' --Had a PET scan
and img.order_time > pos.initial_dx_date --PET scan after Covid positive date


ALTER TABLE PMAP_Analytics.dbo.CCDA2718_Solnes_Demographics REBUILD PARTITION = ALL  WITH (DATA_COMPRESSION = Page);
