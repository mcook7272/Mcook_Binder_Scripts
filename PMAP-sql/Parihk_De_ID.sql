CREATE PROCEDURE dbo.CCDA2154_Parikh_De_ID AS

/**********************************************************************************
Author:  mcook49
Date: 2022-01-20
JIRA: CCDA-2154
Description: To run after the projection of CROWNParikh data, masking the data for the study team
     
Revision History:
Date            Author          JIRA            Comment
[date]      [your name]     CCDA-xxx            [Comments about what was changed and why]
***********************************************************************************/

SET NOCOUNT ON;

/*
--Backup custom load table
Select *
into PMAP_Analytics.dbo.CCDA2154_ccpsei_custom_specimens_2021_05_03 --Change
from CROWNParikh_Projection.ccpsei.custom_specimens
*/

--Drop tables that will be re-loaded
Drop table if exists PMAP_Analytics.dbo.CCDA2540_Parihk_csn_Mapping;
Drop table if exists PMAP_Analytics.dbo.CCDA2540_Parihk_ord_proc_Mapping;
Drop table if exists PMAP_Analytics.dbo.CCDA2540_Parihk_order_med_Mapping;
Drop table if exists PMAP_Analytics.dbo.CCDA2540_Parihk_osler_id_Mapping;
Drop table if exists CROWNParikh_Projection.ccpsei.custom_specimens;
Drop table if exists CROWNParikh_Projection.waste.custom_specimens;

--Create mapping tables
SELECT 
	a.*
	--,'Pat_'+ cast(ROW_NUMBER() OVER (ORDER BY A.IDENTITY_ID) as varchar) as 'Masked ID'
	,ROW_NUMBER() OVER (ORDER BY A.IDENTITY_ID) as 'waste_enc_ID'
	,ROW_NUMBER() OVER (ORDER BY A.IDENTITY_ID desc) as 'ccpsei_enc_ID'
	into PMAP_Analytics.dbo.CCDA2540_Parihk_csn_Mapping
FROM (
	SELECT DISTINCT
		t.pat_enc_csn_id "Identity_ID"
	FROM (
		select distinct osler_id, pat_enc_csn_id
		from PMAP_Staging.dbo.derived_inpatient_encounters_Parikh
		union
		select distinct osler_id, pat_enc_csn_id
		from PMAP_Staging.dbo.derived_outpatient_encounters_Parikh
		union 
		select distinct osler_id, pat_enc_csn_id
		from PMAP_Staging.dbo.derived_social_history_changes_Parikh
		union 
		select distinct osler_id, pat_enc_csn_id
		from PMAP_Staging.dbo.derived_hosp_billing_dx_Parikh
		union 
		select distinct osler_id, pat_enc_csn_id
		from PMAP_Staging.dbo.derived_lab_results_Parikh
		union 
		select distinct osler_id, pat_enc_csn_id
		from PMAP_Staging.dbo.derived_image_procedures_Parikh
		union
		select distinct osler_id, pat_enc_csn_id
		from PMAP_Staging.dbo.derived_flowsheet_data_Parikh
	) t
 )A;

 SELECT 
	a.*
	--,'Pat_'+ cast(ROW_NUMBER() OVER (ORDER BY A.IDENTITY_ID) as varchar) as 'Masked ID'
	,ROW_NUMBER() OVER (ORDER BY A.order_proc_id) as 'waste_ord_proc_ID'
	,ROW_NUMBER() OVER (ORDER BY A.order_proc_id desc) as 'ccpsei_ord_proc_ID'
	into PMAP_Analytics.dbo.CCDA2540_Parihk_ord_proc_Mapping
FROM (
	SELECT DISTINCT
		order_proc_id
	FROM PMAP_Staging.dbo.derived_lab_results_Parikh	
	union
	select distinct order_proc_id
	FROM PMAP_Staging.dbo.derived_image_procedures_Parikh
	union
	SELECT DISTINCT
		creating_order_id
	FROM PMAP_Staging.dbo.derived_problem_list_Parikh
 )A;

 SELECT 
	a.*
	--,'Pat_'+ cast(ROW_NUMBER() OVER (ORDER BY A.IDENTITY_ID) as varchar) as 'Masked ID'
	,ROW_NUMBER() OVER (ORDER BY A.order_med_id) as 'waste_ord_med_id'
	,ROW_NUMBER() OVER (ORDER BY A.order_med_id desc) as 'ccpsei_ord_med_id'
	into PMAP_Analytics.dbo.CCDA2540_Parihk_order_med_Mapping
FROM (
	SELECT DISTINCT
		t.order_med_id
	FROM (
		select distinct osler_id, order_med_id
		from PMAP_Staging.dbo.derived_med_admin_Parikh
		union
		select distinct osler_id, order_med_id
		from PMAP_Staging.dbo.derived_med_orders_Parikh
	) t
 )A;

 SELECT 
	a.*
	--,'Pat_'+ cast(ROW_NUMBER() OVER (ORDER BY A.IDENTITY_ID) as varchar) as 'Masked ID'
	,ROW_NUMBER() OVER (ORDER BY A.osler_id) as 'waste_patient_id'
	,ROW_NUMBER() OVER (ORDER BY A.birth_date) as 'ccpsei_patient_id'
	into PMAP_Analytics.dbo.CCDA2540_Parihk_osler_id_Mapping
FROM (
	SELECT DISTINCT
		osler_id, birth_date
	FROM PMAP_Staging.dbo.derived_epic_patient_Parikh	
 )A;

 --Refresh urine table
exec [PMAP_Analytics].[dbo].[CCDA2154_Parikh_urine_specimens];

--drop table if exists CROWNParikh_Projection.ccpsei.[covidparikhurine_final];

--Refresh cox nohyphens table

exec [PMAP_Analytics].[dbo].CCDA2046_Cox_NoHyphens


--Update ccpsei custom spec table

Select osler.ccpsei_patient_id, cox.SUBJECT_NUMBER, cox.[Date of Blood Draw] "Date_Of_Blood_Draw"
into CROWNParikh_Projection.ccpsei.custom_specimens
from PMAP_Analytics.dbo.CCDA2046_Cox_Final_NoHyphens cox
inner join PMAP_Analytics.dbo.CCDA2540_Parihk_osler_id_Mapping osler on osler.osler_id = cox.osler_id
order by cox.SUBJECT_NUMBER

--Update waste custom spec table

Select osler.waste_patient_id,SPECIMEN_CCDA_IDN,BSI_DATE_DRAWN,
SPEC_CRS_COLLECT_DTM,BSI_DATE_RECEIVED,BSI_FREEZE_DATE,BSI_DATE_COMPLETED,
BSI_PROCESSING_START_DATE,BSI_VOLUME,BSI_VOLUME_UNIT,EPIC_SPECIMN_TAKEN_TIME,EPIC_SPECIMEN_RECV_TIME
into CROWNParikh_Projection.waste.custom_specimens
FROM PMAP_Analytics.dbo.CovidWasteSpecData_v2_osler_id waste
inner join PMAP_Analytics.dbo.CCDA2540_Parihk_osler_id_Mapping osler on osler.osler_id = waste.osler_id

--Refresh all other tables
exec [CCDA2154_Parikh_mask_IDs]

--Update log table
INSERT INTO CROWNParikh_Projection.dbo.refresh_status([status], refresh_date) VALUES ('SUCCESS', CURRENT_TIMESTAMP)

 /*
  SELECT 
	a.*
	--,'Pat_'+ cast(ROW_NUMBER() OVER (ORDER BY A.IDENTITY_ID) as varchar) as 'Masked ID'
	,ROW_NUMBER() OVER (ORDER BY A.creating_order_id) as 'waste_create_ord_proc_ID'
	,ROW_NUMBER() OVER (ORDER BY A.creating_order_id desc) as 'ccpsei_create_ord_proc_ID'
	into PMAP_Analytics.dbo.CCDA2540_Parihk_create_ord_proc_Mapping
FROM (
	SELECT DISTINCT
		creating_order_id
	FROM CROWNParikh_Projection.dbo.derived_problem_list	
 )A;
 */
