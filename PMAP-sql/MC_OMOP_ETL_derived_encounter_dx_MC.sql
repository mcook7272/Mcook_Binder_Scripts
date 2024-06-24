USE [JHM_OMOP_20211001]
GO

/****** Object:  StoredProcedure [stage].[MC_OMOP_ETL_derived_encounter_dx_MC]    Script Date: 10/15/2021 11:34:55 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



 
/*-- ===================================================================================

<Author> Alan Coltri </Author>
      <Created Date> 8-17-2020 </Created Date>
      <Description>
          Adds records to the CDM 'Condition' domain based upon encounter diagnoses.

				All encounter diagnoses in the timeframe of the CDM have been coded with ICD10CM
				and that is used for mapping.

				The concepts returned from the ICD10CM mapping extend beyon 'diagnosis' and 
				target the "condition', 'observation', and 'measurment' domains. 'Observation'
				domain records are processed in a different module.

      </Description>
      <Notes> 'Measurement' domain records are not currently processed (2021-09-22).  Generally, they 
				indicate that a measurement was made, without giving its result. In many cases the 'measurement' 
				has already been recorded - with the result attached - by another process.  An alternative, 
				would be to include these 'measurement occurred' records - and expect that analysts could/would 
				make a choice about their use by examining the measurement_type_concept_id ('lab result' or 
				'EHR encounter record') </Notes>
      <Hardcoded>
          OMOP:condition_type_concept_id:32020:EHR_encounter_diagnosis
		  OMOP:condition_status_concept_id:4230359:Final_diagnosis_(discharge)
      <Hardcoded>
				 
 Change History:  
	12/11/2020	acoltri	logging, rename (from COVID_OMOP_ETL_CONDITIONOCCURRENCE_IP_OP), 
						chunking, synonyms

	06/02/2021	acoltri	changed 'source_value' fro easier tracing to source
						results targeting domain of observation are currently skipped and
						will have their own proc

								
 ===================================================================================*/


CREATE   PROCEDURE [stage].[MC_OMOP_ETL_derived_encounter_dx_MC]   
	(@block_total as int = 3, @start_block as int = 0)
AS

SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

/* ### for logging */
DECLARE @RC     INT  , @procName VARCHAR(50) ='OMOP_ETL_derived_encounter_dx', @tablename VARCHAR(50)='condition_occurrence'; 
DECLARE @elapsed_seconds INT = 0 , @comment VARCHAR(255), @start_datetime Datetime = getdate(), 
	@end_datetime Datetime, @block_number INT;


/* ### for dynamic block level processing */
Declare @counter INT, @total_persons INT, @begin_range int=0, @end_range int=0, @block_size int, @my_error varchar(250);

select @total_persons = max(person_id) from person;

set @counter = @start_block;
set @block_size = (@total_persons + @block_total) / @block_total;

while (@counter < @block_total)
BEGIN
	set @begin_range = @counter * @block_size;
	set @end_range = @begin_range + @block_size;
	set @start_datetime = getdate();

	
 
	WITH CTE_VOCAB_MAP AS (
       SELECT c.concept_code AS SOURCE_CODE, c.concept_id AS SOURCE_CONCEPT_ID, c.concept_name AS SOURCE_CODE_DESCRIPTION, c.vocabulary_id AS SOURCE_VOCABULARY_ID, 
			c.domain_id AS SOURCE_DOMAIN_ID, c.CONCEPT_CLASS_ID AS SOURCE_CONCEPT_CLASS_ID, 
			c.VALID_START_DATE AS SOURCE_VALID_START_DATE, c.VALID_END_DATE AS SOURCE_VALID_END_DATE, c.INVALID_REASON AS SOURCE_INVALID_REASON, 
			c1.concept_id AS TARGET_CONCEPT_ID, c1.concept_name AS TARGET_CONCEPT_NAME, c1.VOCABULARY_ID AS TARGET_VOCABULARY_ID, c1.domain_id AS TARGET_DOMAIN_ID, c1.concept_class_id AS TARGET_CONCEPT_CLASS_ID, 
			c1.INVALID_REASON AS TARGET_INVALID_REASON, c1.standard_concept AS TARGET_STANDARD_CONCEPT
       FROM CONCEPT C
             JOIN CONCEPT_RELATIONSHIP CR
                        ON C.CONCEPT_ID = CR.CONCEPT_ID_1
                        AND CR.invalid_reason IS NULL
                        AND lower(cr.relationship_id) = 'maps to'
              JOIN CONCEPT C1
                        ON CR.CONCEPT_ID_2 = C1.CONCEPT_ID
                        AND C1.INVALID_REASON IS NULL
       UNION  
       SELECT source_code, SOURCE_CONCEPT_ID, SOURCE_CODE_DESCRIPTION, source_vocabulary_id, c1.domain_id AS SOURCE_DOMAIN_ID, c2.CONCEPT_CLASS_ID AS SOURCE_CONCEPT_CLASS_ID,
			c1.VALID_START_DATE AS SOURCE_VALID_START_DATE, c1.VALID_END_DATE AS SOURCE_VALID_END_DATE, 
			stcm.INVALID_REASON AS SOURCE_INVALID_REASON,target_concept_id, c2.CONCEPT_NAME AS TARGET_CONCEPT_NAME, target_vocabulary_id, c2.domain_id AS TARGET_DOMAIN_ID, c2.concept_class_id AS TARGET_CONCEPT_CLASS_ID, 
			c2.INVALID_REASON AS TARGET_INVALID_REASON, c2.standard_concept AS TARGET_STANDARD_CONCEPT
       FROM source_to_concept_map stcm
              LEFT OUTER JOIN CONCEPT c1
                     ON c1.concept_id = stcm.source_concept_id
              LEFT OUTER JOIN CONCEPT c2
                     ON c2.CONCEPT_ID = stcm.target_concept_id
       WHERE stcm.INVALID_REASON IS NULL
)

	------------------------------------------------------------
 
				INSERT INTO  [condition_occurrence]
				(  
					[person_id]
					,[condition_concept_id]
					,[condition_start_date]
					,[condition_start_datetime]
					,[condition_end_date]
					,[condition_end_datetime]
					,[condition_type_concept_id]
					,[stop_reason]
					,[provider_id]
					,[visit_occurrence_id]
					,[visit_detail_id]
					,[condition_source_value]
					,[condition_source_concept_id]
					,[condition_status_source_value]
					,[condition_status_concept_id]
				)
				SELECT 
					pe.person_id  
					, cte1.TARGET_CONCEPT_ID as condition_concept_id	 --let unmapped elements through per some guidance
					, vo.visit_start_date as condition_start_date
					, null as visit_start_datetime		 --has no time in the field present
					, vo.visit_end_date as condition_end_date --condition is considered to have ended?
					, null as condition_end_datetime --has no time in the field present
					, 32020 as condition_type_concept_id -- EHR Encounter Diagnosis
					, LEFT(vo.discharge_to_source_value,20) as stop_reason --usually discharged or resolved- not populated?
					, vo.provider_id as provider_id -- no provider in this source
					, vo.visit_occurrence_id as visit_occurrence_id
					, null as visit_detail_id --no visit detail populated for now
					,left(concat(dx.icd10_code, ' dx_id=',dx.dx_id,'|encounter_dx|',dx.dx_name),50) as condition_source_value  -- changed  -- changed acoltri 8-10-2020
					, cte1.SOURCE_CONCEPT_ID as condition_source_concept_id 
					, null as condition_status_source_value --no vocabulay for condition status in 2018. now?
					, 4230359 as condition_status_concept_id -- using code for final diagnosis (as opposed to admitting or preliminary)
				FROM 
					[derived_encounter_dx] dx
				JOIN	[stage].[SourceIDMapsPerson] sm on sm.sourcekey =  dx.osler_id and sm.domain = 'person'
				JOIN	[person] pe on pe.person_id = sm.id 
				LEFT JOIN  
					[stage].[SourceIDMapsVisit] lvis on lvis.sourcekey = dx.pat_enc_csn_id and lvis.domain = 'visit'
								LEFT JOIN  
					[visit_occurrence] vo on lvis.id = vo.visit_occurrence_id
				join CTE_VOCAB_MAP cte1 on cte1.SOURCE_CODE = dx.icd10_code 
					
				WHERE 
					vo.visit_start_date is not null
					and cte1.SOURCE_VOCABULARY_ID = 'ICD10CM' 
					and cte1.TARGET_STANDARD_CONCEPT = 's'
					and cte1.TARGET_INVALID_REASON is null
					and cte1.target_domain_id = 'Condition'
					and pe.person_id >  @begin_range and pe.person_id <= @end_range
				

/* ###  Update log table: */
SET @RC = @@ROWCOUNT;
set @end_datetime = getdate();
set @elapsed_seconds = DATEDIFF(second,@start_datetime,@end_datetime);

 INSERT INTO stage.OMOP_ETL_runlog (table_name, start_datetime, end_datetime, elapsed_seconds, count_of_rows, 
	[block_number], [procedure_name], comment)
	VALUES (  @tablename, @start_datetime, @end_datetime, @elapsed_seconds,@RC, @counter, @procName, null );
	
set @counter = @counter + 1;

END;

GO


