USE [RW_PROD]

DROP PROCEDURE IF EXISTS omop.[Stage_OMOP_ETL_derived_flowsheet_data__o2devices]

GO
/****** Object:  StoredProcedure [omop].[Stage_OMOP_ETL_derived_flowsheet_data__o2devices]    Script Date: 8/25/2021 8:36:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Report: N/A
Author: Johns Hopkins / Trayson Llano
Date: 02/04/2022
REPOS SQL File Name: OMOP_Stage_ETL_derived_flowsheet_data__o2devices
Original Ticket: Ticket: Staging procedure for OMOP build/schema
Operational Owner: Trayson Llano

Comments: Comments
<CHANGE TICKET NUMBER HERE>: <DESCRIPTION HERE> <USERNAME HERE> <UPDATE DATE HERE>
20220506		dtl19a		DevOps Task 7936		Ported from JH scripts

FROM JH:
-- ===================================================================================
--					Stored Procedure:  OMOP_ETL_derived_flowsheet_data_o2devices
-- Author:				Alan Coltri 
-- Create date:		08-04-2020
-- Parameter:        @truncate bit to indicate true/False.  Defaults to False.  
--                          	If you want to truncate the condition_occurrence table
--					            prior to loading new data, pass the @truncate=1 (true)
--  Description:	   
/*                            The definition of device_exposure focuses on non-medication physical objects which are used by the patient.  
	                            In the case of COVID research we interpreted this to be breathing associated devices:  venilators, ECMO, 
								and other oxygen delivery devices as identified in the flowsheet measures in the 
								Zeger_parameter table:  [COVID_Admin_Projection].[dbo].[Zeger_Covid_Parms].
								
								This procedure uses the Zegar_parameters table to  select flowsheet data from 
								COVID_PROJECTIO..derived_flowsheet into a common table expression named "cte_event".  
								 It unions 3 select statements from cte_event to produce interval rows 
								 with gaps (a gap is 24 hours without flowsheet doucmentation) and 
								 inserts this data as #tempECMO.
								 
								 Using a CTE, a fourth select against the temp table gets the start and stop time of each interval.
								 This final select, along with the vocabulary concept data is then used to insert 
								 rows into the device_exposure table.	
								 
	Changes		2020-09-09		acoltri - revertd to backup copy

				2020-09-11		acoltri - minor change to make Zeger table inclusions positive rather than negative
				2020-12-05		acoltri - converted to new chunking and logging	model
										- note that there is not one specific local code which defines the device
										- in this model the device is implied from a variety of flowsheet documentation entries
				2021-06-09		mcook49	- Fixed Standard CTE to include joins in first half (based on https://github.com/OHDSI/CommonDataModel/blob/master/CodeExcerpts/Vocab_Mapping.sql)
				2021-0702		acoltri	- source data is now from derived_flowsheet_data (filtering down to the selected set hapens in PMAP to reduce the transmission on unused rows)
*/

-- Change History:  
--								  
-- ===================================================================================
*/    

CREATE PROCEDURE omop.[Stage_OMOP_ETL_derived_flowsheet_data__o2devices]
	(@block_total as int = 2, @start_block as int = 0)
AS

SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


--for logging
DECLARE @RC     INT = 0 , @procName VARCHAR(50) ='OMOP_ETL_derived_flowsheet_data__o2devices', @tablename VARCHAR(50)='device_exposure'; 
DECLARE @elapsed_seconds INT = 0 , @comment VARCHAR(255), @start_datetime Datetime = getdate(), 
	@end_datetime Datetime, @block_number INT;


--for dynamic block level processing
Declare @counter INT, @total_persons INT, @begin_range int=0, @end_range int=0, @block_size int, @my_error varchar(250);

select @total_persons = max(person_id) from person;

set @counter = @start_block;
set @block_size = (@total_persons + @block_total) / @block_total;

while (@counter < @block_total)
BEGIN
	set @begin_range = @counter * @block_size;
	set @end_range = @begin_range + @block_size;
	set @start_datetime = getdate();

drop table if exists #tempECMO;

drop table if exists #tempECMO2;

WITH

cte_vent AS (
select sm.id as person_id, pat_enc_csn_id, recorded_time, MEAS_VALUE as device_source_value,
case when MEAS_VALUE in ('ETT (Vented)','Trach (Vented)') then 45768198
	  when MEAS_VALUE in ('Vapotherm (HHFNC)','Heated high flow nasal cannula','High flow nasal cannula','Airvo (HHFNC)') then 4139525
	  when MEAS_VALUE in ('Bubble CPAP','Bipap','CPAP') then 40217672
	  when MEAS_VALUE in ('nasal cannula') then 4224038 --Trayson update with your meas_value here
	  when MEAS_VALUE in ('oxygen mask') then  4222966 --Trayson update with your meas_value here
	  when MEAS_VALUE in ('face tent oxygen') then  4138487 --Trayson update with your meas_value here
else 0
end as device_concept_id,
ROW_NUMBER() OVER( ORDER BY sm.id, pat_enc_csn_id, MEAS_VALUE, RECORDED_TIME) AS ROWTime
from [derived_flowsheet_data] fd
--join [Zeger_Covid_Parms] zp on fd.meas_id = zp.varchar_parm_value
join omop.[Stage_SourceIDMapsPerson] sm on sm.sourcekey = fd.pat_id 
where sm.domain = 'person'
	and fd.MEAS_NAME = 'R CORE OXYGEN DEVICE'
	and fd.MEAS_VALUE in ('ETT (Vented)','Trach (Vented)'
						,'Bubble CPAP','Vapotherm (HHFNC)','Heated high flow nasal cannula','High flow nasal cannula','Airvo (HHFNC)','Bipap','CPAP'
						) --Trayson Update with meas_values added above
	and sm.id >  @begin_range and sm.id <= @end_range

	UNION
	--Add in Dialysis
	SELECT sm.id AS person_id
      ,pat_enc_csn_id
      ,recorded_time
      ,'Dialysis_flowsheet' AS device_source_value
      ,4281167 AS device_concept_id
      ,ROW_NUMBER() OVER (
         ORDER BY sm.id
            ,pat_enc_csn_id
            ,MEAS_VALUE
            ,RECORDED_TIME
         ) AS ROWTime
   FROM [derived_flowsheet_data] fd
   --join [Zeger_Covid_Parms] zp on fd.meas_id = zp.varchar_parm_value
   JOIN omop.[Stage_SourceIDMapsPerson] sm ON sm.sourcekey = fd.pat_id
   WHERE sm.domain = 'person'
      AND fd.MEAS_NAME IN (
         'R HD INTAKE', 'R HD OUTPUT', 'R HEMODIALYSIS ACCESS CHECKED', 
         'R HEMODIALYSIS DIALYZER CLEARANCE', 'R IP HD DIALYSATE CA', 'R IP HD DIALYSATE K', 
         'R IP HD DIALYSATE NA', 'R IP HD PRIME/RINSE'
         )
      AND sm.id > @begin_range
      AND sm.id <= @end_range
	)

--first select generates a row with the first recorded time for each encounter and parameter
select * into #tempECMO from
(select person_id, pat_enc_csn_id , null as T1, min(recorded_time) as T2, 0 as RowA,
0 as RwB, 0 as dtime_hrs, ct1.device_source_value,ct1.device_concept_id
from cte_vent ct1
group by person_id, pat_enc_csn_id, device_concept_id

--second select generates a row with the last recorded time for each encounter and parameter
union
select person_id, pat_enc_csn_id , max(recorded_time) as T1, null as T2, 0 as RowA,
0 as RwB, 0 as dtime_hrs, ct2.device_source_value,ct2.device_concept_id
from cte_vent ct2
group by person_id, pat_enc_csn_id, device_concept_id

--third select creates a row for each gap in recorded times greater than the DATEDIFF clause
union
SELECT ct1.person_ID, ct1.pat_enc_csn_id, ct1.recorded_time as T1, ct2.recorded_time as T2
, ct1.RowTime as RowB, ct2.ROWTime as RowA,
DATEDIFF(HOUR,ct1.recorded_time,ct2.recorded_time) as dtime_hrs, ct1.device_source_value, ct1.device_concept_id
FROM cte_Vent ct1
join cte_vent ct2 on ct1.person_id = ct2.person_id and ct1.pat_enc_csn_id = ct2.pat_enc_csn_id
and ct1.device_concept_id = ct2.device_concept_id
and ct1.RowTime+1 = ct2.rowtime
where
DATEDIFF(HOUR,ct1.recorded_time,ct2.recorded_time) > 24) as cc
;

with cte_device AS (
select person_ID, pat_enc_csn_id, T1, T2,
ROW_NUMBER() OVER( ORDER BY person_id, pat_enc_csn_id, tv1.device_source_value, T1 asc) AS ROWOrder, tv1.device_source_value, tv1.device_concept_id
from #tempECMO tv1)

--fourth select with a different cte combines rows to give the start and stop time of each interval
select * into #tempECMO2 from
(select cd1.person_id, cd1.pat_enc_csn_id, cd1.t2 as startDT, cd2.T1 as stopDT, cd1.device_source_value, cd1.device_concept_id
from cte_device cd1
join cte_device cd2 on cd1.person_id = cd2.person_id
and cd1.pat_enc_csn_id = cd2.pat_enc_csn_id
and cd1.device_concept_id = cd2.device_concept_id
and cd1.RowOrder + 1= cd2.RowOrder) as aa
;


WITH CTE_VOCAB_MAP AS

(

SELECT c.concept_code AS SOURCE_CODE, c.concept_id AS SOURCE_CONCEPT_ID, c.CONCEPT_NAME AS SOURCE_CODE_DESCRIPTION,
c.vocabulary_id AS SOURCE_VOCABULARY_ID, c.domain_id AS SOURCE_DOMAIN_ID, c.concept_class_id AS SOURCE_CONCEPT_CLASS_ID,
c.VALID_START_DATE AS SOURCE_VALID_START_DATE, c.VALID_END_DATE AS SOURCE_VALID_END_DATE, c.invalid_reason AS SOURCE_INVALID_REASON,
c.concept_ID as TARGET_CONCEPT_ID, c.concept_name AS TARGET_CONCEPT_NAME, c.vocabulary_id AS TARGET_VOCABULARY_ID, c.domain_id AS TARGET_DOMAIN_ID,
c.concept_class_id AS TARGET_CONCEPT_CLASS_ID, c.INVALID_REASON AS TARGET_INVALID_REASON,
c.STANDARD_CONCEPT AS TARGET_STANDARD_CONCEPT
FROM CONCEPT c
JOIN CONCEPT_RELATIONSHIP CR
                        ON C.CONCEPT_ID = CR.CONCEPT_ID_1
                        AND CR.invalid_reason IS NULL
                        AND cr.relationship_id = 'Maps To'
              JOIN CONCEPT C1
                        ON CR.CONCEPT_ID_2 = C1.CONCEPT_ID
                        AND C1.INVALID_REASON IS NULL

UNION
SELECT source_code, SOURCE_CONCEPT_ID, SOURCE_CODE_DESCRIPTION, source_vocabulary_id,
c1.domain_id AS SOURCE_DOMAIN_ID, c2.CONCEPT_CLASS_ID AS SOURCE_CONCEPT_CLASS_ID,
c1.VALID_START_DATE AS SOURCE_VALID_START_DATE,
c1.VALID_END_DATE AS SOURCE_VALID_END_DATE,stcm.INVALID_REASON AS SOURCE_INVALID_REASON,
target_concept_id, c2.CONCEPT_NAME AS TARGET_CONCEPT_NAME, target_vocabulary_id, c2.domain_id AS TARGET_DOMAIN_ID, c2.concept_class_id AS TARGET_CONCEPT_CLASS_ID,
c2.INVALID_REASON AS TARGET_INVALID_REASON, c2.standard_concept AS TARGET_STANDARD_CONCEPT
FROM source_to_concept_map stcm
LEFT OUTER JOIN CONCEPT c1 ON c1.concept_id = stcm.source_concept_id
LEFT OUTER JOIN CONCEPT c2 ON c2.CONCEPT_ID = stcm.target_concept_id
WHERE stcm.INVALID_REASON IS NULL

)

INSERT INTO [device_exposure] (
[person_id]
,[device_concept_id]
,[device_exposure_start_date]
,[device_exposure_start_datetime]
,[device_exposure_end_date]
,[device_exposure_end_datetime]
,[device_type_concept_id]
,[unique_device_id]
,[quantity]
,[provider_id]
,[visit_occurrence_id]
,[visit_detail_id]
,[device_source_value]
,[device_source_concept_id])

----------------test query
----------------*******************************************************************
--------------select count(*) as instances, device_source_value, avg(datediff(hour,startDT,stopDT)) as avg_hr
--------------, min(datediff(hour,startDT,stopDT)) as min_hr, max(datediff(hour,startDT,stopDT)) as max_hr
--------------,pat_enc_csn_id

----------------*******************************************************************
select pe.person_id
,device_concept_id
,startDT as device_exposure_start_date
,startDT as device_exposure_start_datetime
,stopDT as device_exposure_stop_date
,stopDT as device_exposure_stop_datetime
,44818707 as device_type_concept_id
, null as unique_device_id
, null as quantity
, null as provider_id --not a singular provider
, vo.visit_occurrence_id as visit_occurrence_id
, null as visit_detail_id
, lr.device_source_value as source_value
, 0 as device_source_concept_id
from #tempECMO2 lr
JOIN [person] pe on pe.person_id = lr.person_id
--Get the visit occurrence id's
LEFT JOIN omop.Stage_SourceIDMapsVisit vm on lr.pat_enc_csn_id = vm.sourcekey
LEFT JOIN visit_occurrence vo on vo.visit_occurrence_id = vm.id

---------------- test query grouper
----------------*******************************************************************
--------------where datediff(hour,startDT,stopDT) > 5000
--------------group by device_source_value, pat_enc_csn_id
--------------order by device_source_value
----------------*******************************************************************
 
	--  Update log table:
SET @RC = @@ROWCOUNT;
set @end_datetime = getdate();
set @elapsed_seconds = DATEDIFF(second,@start_datetime,@end_datetime);

 INSERT INTO omop.Stage_OMOP_ETL_runlog (table_name, start_datetime, end_datetime, elapsed_seconds, count_of_rows, 
	[block_number], [procedure_name], comment)
	VALUES (  @tablename, @start_datetime, @end_datetime, @elapsed_seconds,@RC, @counter, @procName, null );
	
set @counter = @counter + 1;

END;

GO
