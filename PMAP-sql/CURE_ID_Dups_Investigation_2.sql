/*
FDA CURE ID Cohort Script
This script creates a cohort of covid-positive, hospitalized patients.
Run this script first, then create your subsetted tables using the CURE_ID_All_Tables.sql script
Will need to designate the name of your own OMOP database, and schema you want results to be loaded into.
*/
USE [JHCrown_OMOP] --Change database name as appropriate

--Drop all tables
DROP TABLE IF EXISTS results.CURE_ID_Cohort; --Change schema as appropriate
DROP TABLE IF EXISTS #covid_lab_pos;
DROP TABLE IF EXISTS #first_pos;
DROP TABLE IF EXISTS #dx_strong;
DROP TABLE IF EXISTS #dx_weak;
DROP TABLE IF EXISTS #inpat_intermed;
DROP TABLE IF EXISTS #inpat;
DROP TABLE IF EXISTS #inpat_closest_vis;
DROP TABLE IF EXISTS #inpat_first_vis;
DROP TABLE IF EXISTS #los;
DROP TABLE IF EXISTS #closest_vis;
DROP TABLE IF EXISTS #first_vis;
DROP TABLE IF EXISTS #los_max;
DROP TABLE IF EXISTS #Vis_Occ;


--First identify patients (inpatient and outpatient) with covid positive lab results
SELECT DISTINCT person_id
   ,measurement_date
INTO #covid_lab_pos
FROM dbo.MEASUREMENT
WHERE measurement_concept_id IN (
      SELECT concept_id
      FROM dbo.CONCEPT
      -- here we look for the concepts that represent the LOINC codes for SARS-COV-2 nucleic acid test
      WHERE concept_id IN (
            '706169', '706156', '706154', '706170', '706157', '706155', '706173', '706175', '706163', 
            '706167', '706168', '706158', '706161', '706160', '723478', '723476', '723464', '723465', 
            '723466', '723467', '723468', '723469', '723470', '723471', '723463', '586528', '586529', 
            '586524', '586525', '586526', '715272', '586517', '586520', '586519', '715262', '715261', 
            '715260', '757677', '757678', '36661377', '36661378', '36661370', '36661371', '36031238', 
            '36031213', '36031506', '36032061', '36031944', '36032174', '36031652', '36031453', '36032258'
            )
      
      UNION
      
      SELECT c.concept_id
      FROM dbo.CONCEPT c
      INNER JOIN dbo.CONCEPT_ANCESTOR ca ON c.concept_id = ca.descendant_concept_id
         -- Most of the LOINC codes do not have descendants but there is one OMOP Extension code (765055) in use that has descendants which we want to pull
         -- This statement pulls the descendants of that specific code
         AND ca.ancestor_concept_id IN (756055)
         AND c.invalid_reason IS NULL
      )
   -- Here we add a date restriction: after January 1, 2020
   AND measurement_date >= DATEFROMPARTS(2020, 01, 01)
   AND (
      -- The value_as_concept field is where we store standardized qualitative results
      -- The concept ids here represent LOINC or SNOMED codes for standard ways to code a lab that is positive
      value_as_concept_id IN (
         4126681 -- Detected
         , 45877985 -- Detected
         , 45884084 -- Positive
         , 9191 --- Positive 
         , 4181412 -- Present
         , 45879438 -- Present
         , 45881802 -- Reactive
         )
      -- To be exhaustive, we also look for Positive strings in the value_source_value field
      OR value_source_value IN ('Positive', 'Present', 'Detected', 'Reactive')
      );

--Show counts of unique covid-positive labs (not unique patients)
select count(*) "covid_positive_lab_count" from #covid_lab_pos;

--First positive test per patient
SELECT person_id
   ,min(measurement_date) "First_Pos_Date"
INTO #first_pos
FROM #covid_lab_pos
GROUP BY person_id;

--Show count of unique patients so far
select count(distinct person_id) "covid_positive_lab_person_count" from #first_pos;

--Covid-positive patients with inpatient encounters (intermediate table for debugging)
SELECT v.person_id
   ,v.visit_occurrence_id
   ,visit_start_date
   ,visit_end_date
   ,p.First_Pos_Date
   ,DATEDIFF(day, p.First_Pos_Date, v.visit_start_date) "Days_From_First_Pos"
   ,ABS(DATEDIFF(day, p.First_Pos_Date, v.visit_start_date)) "Abs_Days_From_First_Pos"
INTO #inpat_intermed
FROM visit_occurrence v
INNER JOIN #first_pos p ON v.person_id = p.person_id
WHERE visit_concept_id in (9201,262); --Inpatient visit/ED and inpt visit

--Intermediate count of Covid-positive patients with inpatient encounters
select count(distinct person_id) "covid_pos_inpatients_count" from #inpat_intermed;

--Count of patients after temporal constraints applied
Select count(distinct person_id) "covid_pos_inpatients_date_filtered_count"
from #inpat_intermed
WHERE visit_start_date >= '2020-01-01'
   AND (
      DATEDIFF(day, First_Pos_Date, visit_start_date) > - 7
      AND DATEDIFF(day, First_Pos_Date, visit_start_date) < 21
      )

--Apply all incl/excl criteria to identify all patients hospitalized with symptomatic covid-19 up to 21 days after a positive SARS-CoV-2 test or up to 7 days prior to a positive SARS-CoV-2 test
SELECT v.person_id
   ,v.visit_occurrence_id
   ,visit_start_date
   ,visit_end_date
   ,p.First_Pos_Date
   ,DATEDIFF(MINUTE, v.visit_start_datetime, v.visit_end_datetime) "Length_Of_Stay"
   ,DATEDIFF(day, p.First_Pos_Date, v.visit_start_date) "Days_From_First_Pos"
   ,ABS(DATEDIFF(day, p.First_Pos_Date, v.visit_start_date)) "Abs_Days_From_First_Pos"
   ,CASE 
      WHEN DATEDIFF(day, p.First_Pos_Date, v.visit_start_date) < 0
         THEN - 1
      ELSE 1
      END AS Before_Or_After
INTO #inpat
FROM visit_occurrence v
INNER JOIN #first_pos p ON v.person_id = p.person_id
WHERE visit_concept_id in (9201,262) --Inpatient visit/ED and inpt visit
   AND v.visit_start_date >= '2020-01-01'
   AND (
      DATEDIFF(day, p.First_Pos_Date, v.visit_start_date) > - 7
      AND DATEDIFF(day, p.First_Pos_Date, v.visit_start_date) < 21
      );

--Count of patients and encounters that meet the criteria
SELECT count(DISTINCT person_id) "covid_pos_inpatients", 
count(DISTINCT visit_occurrence_id) "covid_pos_inpatient_visits"
FROM #inpat;

--Finds closest encounter to first positive SARS-COV-2 test (for patients hospitalized more than once)
SELECT person_id
   ,min(Abs_Days_From_First_Pos) "Closest_Vis"
INTO #inpat_closest_vis
FROM #inpat
GROUP BY person_id;

--Account for edge cases where patients have two hospitalizations same number of absolute days from SARS-COV-2 test
--Ex: Patient hospitalized separately 3 days before and 3 days after SARS-COV-2 test
SELECT i.person_id
   ,max(Before_Or_After) "Flag"
INTO #inpat_first_vis
FROM #inpat i
INNER JOIN #inpat_closest_vis v ON i.person_id = v.person_id
   AND i.Abs_Days_From_First_Pos = v.Closest_Vis
GROUP BY i.person_id;

--Create flag for longest LOs per person per visit_start_date
SELECT i.person_id, visit_start_date
   ,max(Length_Of_Stay) "max_los"
INTO #los
FROM #inpat i
GROUP BY i.person_id, i.visit_start_date;

--Apply criteria in sequence
SELECT i.*
INTO #closest_vis
FROM #inpat i
INNER JOIN #inpat_closest_vis c ON i.person_id = c.person_id
   AND i.Abs_Days_From_First_Pos = c.Closest_Vis;

SELECT i.*
INTO #first_vis
FROM #closest_vis i
INNER JOIN #inpat_first_vis v ON i.person_id = v.person_id
   AND i.Before_Or_After = v.Flag;

SELECT i.*
INTO #los_max
FROM #first_vis i
INNER JOIN #los los ON i.person_id = los.person_id
   AND i.visit_start_date = los.visit_start_date
   AND i.Length_Of_Stay = los.max_los;

--Make cohort table
SELECT v.*, p.birth_datetime, d.death_datetime
INTO #Vis_Occ
FROM #los_max v
INNER JOIN person p ON v.person_id = p.person_id
LEFT JOIN death d ON v.person_id = d.person_id;

DROP TABLE IF EXISTS #CURE_ID_Cohort

SELECT *
INTO #CURE_ID_Cohort
FROM #Vis_Occ;



/******* OVERVIEW *******/
--Step 1) Subset your data
--Step 2) Run the DDL for the deidentified tables
--Step 3) Use find and replace to set source and target DB and Schema names
--Step 4) Run this file to generate a deidentified copy of your target data
--Step 5) Run the DE ID Quality Checks (Optional)
USE [JHCrown_OMOP];
/******* VARIABLES *******/
--SOURCE_DB: [JHM_OMOP_20220203]
--SOURCE_SCHEMA: [dbo]
--TARGET_DB: [JHM_OMOP_TEST]
--TARGET_SCHEMA: [deident]
DECLARE @START_DATE DATE = CAST('2016-01-01' AS DATE)
DECLARE @END_DATE DATE = CAST('2029-12-31' AS DATE)


/******* GENERATE MAP TABLES *******/

--Tables are dropped and created in a separate script.
--Please run that script first.




/******* GENERATE MAP TABLES *******/
select 
p.person_id as sourceKey, 
row_number() over(order by p.gender_concept_id, p.person_id desc) as id, 
(FLOOR(RAND(convert(varbinary,newid()))*367))-183 as date_shift,
CAST((DATEPART(YEAR,GETDATE()) - 90 - (FLOOR(RAND(convert(varbinary,newid()))*10))) AS INT) as over_89_birth_year --If a person is > 89, then assign them a random age between 90 - 99
into #source_id_person
from [JHCrown_OMOP].[dbo].[person] p
join #CURE_ID_Cohort coh on p.person_id = coh.person_id
;


DECLARE @START_DATE DATE = CAST('2016-01-01' AS DATE)
DECLARE @END_DATE DATE = CAST('2029-12-31' AS DATE)
select p.visit_occurrence_id as sourceKey, row_number() over(order by p.visit_occurrence_id) as new_id
into #source_id_visit
from [JHCrown_OMOP].[dbo].[visit_occurrence] p
inner join #source_id_person s on s.sourceKey = p.person_id
join #CURE_ID_Cohort coh on p.visit_occurrence_id = coh.visit_occurrence_id
--left join [JHM_OMOP_TEST].[deident].[source_id_visit] v on v.sourceKey = p.visit_occurrence_id
where 1 = 1 --v.new_id is null and 
AND (DATEADD(DAY, s.date_shift, p.visit_start_date) >= @START_DATE 
and DATEADD(DAY, s.date_shift, p.visit_end_date) <= @END_DATE) 
order by p.person_id, p.visit_start_date
;

/******* PERSON *******/
select s.id as person_id 
,gender_concept_id 
,CASE 
	WHEN DATEDIFF(DAY,p.birth_datetime,GETDATE())/365.25 > 89 THEN s.over_89_birth_year
	ELSE DATEPART(YEAR,DATEADD(DAY,s.date_shift, p.birth_datetime)) 
 END AS year_of_birth
,DATEPART(MONTH,DATEADD(DAY, s.date_shift, p.birth_datetime)) as month_of_birth
,1 as day_of_birth 
,DATEFROMPARTS(
	CASE WHEN DATEDIFF(DAY,p.birth_datetime,GETDATE())/365.25 > 89 THEN s.over_89_birth_year ELSE DATEPART(YEAR,DATEADD(DAY,s.date_shift, p.birth_datetime)) END,
	DATEPART(MONTH,DATEADD(DAY,s.date_shift, p.birth_datetime))
	,1
) as birth_datetime 
,race_concept_id, ethnicity_concept_id, 1 as location_id, 1 as provider_id, 1 as care_site_id 
,person_source_value 
,gender_source_value 
,gender_source_concept_id 
,race_source_value 
,race_source_concept_id 
,ethnicity_source_value 
,ethnicity_source_concept_id 
into #deid_person
from JHCROWN_OMOP.[dbo].[person] p
inner join #source_id_person s on s.sourceKey = p.person_id
;

DECLARE @START_DATE DATE = CAST('2016-01-01' AS DATE)
DECLARE @END_DATE DATE = CAST('2029-12-31' AS DATE)
/******* VISIT *******/
select 
v.new_id as visit_occurrence_id
,s.id as person_id
,visit_concept_id
,DATEADD(DAY, s.date_shift, visit_start_date) as visit_start_date
,DATEADD(DAY, s.date_shift, visit_start_datetime) as visit_start_datetime
,DATEADD(DAY, s.date_shift, visit_end_date) as visit_end_date
,DATEADD(DAY, s.date_shift, visit_end_datetime) as visit_end_datetime
,visit_type_concept_id
,1 as provider_id
,1 as care_site_id
,visit_source_value
,visit_source_concept_id
--,admitting_source_concept_id
--,admitting_source_value
--,discharge_to_concept_id
--,discharge_to_source_value
,preceding_visit_occurrence_id
into #deid_visit_occurrence
from JHCROWN_OMOP.[dbo].[visit_occurrence] p
inner join #source_id_person s on s.sourceKey = p.person_id 
join #source_id_visit v on v.sourceKey = p.visit_occurrence_id
where (DATEADD(DAY, s.date_shift, visit_start_date) >= @START_DATE and DATEADD(DAY, s.date_shift, visit_end_date) <= @END_DATE) 
;

--works now
select person_id, visit_start_date, count(*)
from #deid_visit_occurrence
group by person_id, visit_start_date
having count(*) > 1
/******* CONDITION OCCURENCE *******/
insert into [JHM_OMOP_TEST].[deident].[condition_occurrence]
select condition_occurrence_id
,s.id as person_id
,condition_concept_id
,DATEADD(DAY, s.date_shift, condition_start_date) as condition_start_date
,DATEADD(DAY, s.date_shift, condition_start_datetime) as condition_start_datetime
,DATEADD(DAY, s.date_shift, condition_end_date) as condition_end_date
,DATEADD(DAY, s.date_shift, condition_end_datetime) as condition_end_datetime
,condition_type_concept_id
,stop_reason
,1 as provider_id
,v.new_id as visit_occurrence_id
,visit_detail_id
,condition_source_value
,condition_source_concept_id
,condition_status_source_value
,condition_status_concept_id
from [JHM_OMOP_20220203].[dbo].[condition_occurrence] p
inner join [JHM_OMOP_TEST].[deident].[source_id_person] s on s.sourceKey = p.person_id 
left join [JHM_OMOP_TEST].[deident].[source_id_visit] v on v.sourceKey = p.visit_occurrence_id 
where (DATEADD(DAY, s.date_shift, condition_start_date) < @END_DATE 
and DATEADD(DAY, s.date_shift, condition_end_date) > @START_DATE)
;
/******* PROCEDURE OCCURENCE *******/
insert into [JHM_OMOP_TEST].[deident].[procedure_occurrence]
SELECT procedure_occurrence_id
      ,s.id as person_id
      ,procedure_concept_id
      ,DATEADD(DAY, s.date_shift, procedure_date) as procedure_date
      ,DATEADD(DAY, s.date_shift, procedure_date) as procedure_datetime
      ,procedure_type_concept_id
      ,modifier_concept_id
      ,quantity
      ,1 as provider_id
      ,v.new_id as visit_occurrence_id
      ,visit_detail_id
      ,procedure_source_value
      ,procedure_source_concept_id
      ,modifier_source_value
from [JHM_OMOP_20220203].[dbo].[procedure_occurrence] p
inner join [JHM_OMOP_TEST].[deident].[source_id_person] s on s.sourceKey = p.person_id 
left join [JHM_OMOP_TEST].[deident].[source_id_visit] v on v.sourceKey = p.visit_occurrence_id 
where (DATEADD(DAY, s.date_shift, procedure_date) < @END_DATE 
and DATEADD(DAY, s.date_shift, procedure_date) > @START_DATE) 
;

/******* DRUG EXPOSURE *******/
insert into [JHM_OMOP_TEST].[deident].[drug_exposure]
SELECT  drug_exposure_id
      ,s.id as person_id
      ,drug_concept_id
      ,DATEADD(DAY, s.date_shift, drug_exposure_start_date) as drug_exposure_start_date
      ,DATEADD(DAY, s.date_shift, drug_exposure_start_date) as drug_exposure_start_datetime
      ,DATEADD(DAY, s.date_shift, drug_exposure_end_date) as drug_exposure_end_date
      ,DATEADD(DAY, s.date_shift, drug_exposure_end_date) as drug_exposure_end_datetime
      ,DATEADD(DAY, s.date_shift, verbatim_end_date) as verbatim_end_date
      ,drug_type_concept_id
      ,stop_reason
      ,refills
      ,quantity
      ,days_supply
      ,sig
      ,route_concept_id
      ,lot_number
      ,1 as provider_id
      ,v.new_id as visit_occurrence_id
      ,visit_detail_id
      ,drug_source_value
      ,drug_source_concept_id
      ,route_source_value
      ,dose_unit_source_value
from [JHM_OMOP_20220203].[dbo].[drug_exposure] p
inner join [JHM_OMOP_TEST].[deident].[source_id_person] s on s.sourceKey = p.person_id 
left join [JHM_OMOP_TEST].[deident].[source_id_visit] v on v.sourceKey = p.visit_occurrence_id 
where (DATEADD(DAY, s.date_shift, drug_exposure_start_date) < @END_DATE 
and DATEADD(DAY, s.date_shift, drug_exposure_end_date) > @START_DATE)
;
/******* OBSERVATION *******/
insert into [JHM_OMOP_TEST].[deident].[observation]
SELECT observation_id
      ,s.id as person_id
      ,observation_concept_id
      ,DATEADD(DAY, s.date_shift, observation_date) as observation_date
      ,DATEADD(DAY, s.date_shift, observation_date) as observation_datetime
      ,observation_type_concept_id
      ,value_as_number
      ,value_as_string
      ,value_as_concept_id
      ,qualifier_concept_id
      ,unit_concept_id
      ,1 as provider_id
      ,v.new_id as visit_occurrence_id
      ,visit_detail_id
      ,observation_source_value
      ,observation_source_concept_id
      ,unit_source_value
      ,qualifier_source_value
from [JHM_OMOP_20220203].[dbo].[observation] p
inner join [JHM_OMOP_TEST].[deident].[source_id_person] s on s.sourceKey = p.person_id 
left join [JHM_OMOP_TEST].[deident].[source_id_visit] v on v.sourceKey = p.visit_occurrence_id 
where (DATEADD(DAY, s.date_shift, observation_date) < @END_DATE 
and DATEADD(DAY, s.date_shift, observation_date) > @START_DATE) 
;
/******* DEATH *******/
insert into [JHM_OMOP_TEST].[deident].[death]
select s.id as person_id
      ,DATEADD(DAY, s.date_shift, death_date) as death_date
      ,DATEADD(DAY, s.date_shift, death_date) as death_datetime
      ,death_type_concept_id
      ,cause_concept_id
      ,cause_source_value
      ,cause_source_concept_id
from [JHM_OMOP_20220203].[dbo].[death] p
inner join [JHM_OMOP_TEST].[deident].[source_id_person] s on s.sourceKey = p.person_id 
;
/******* DEVICE EXPOSURE *******/
insert into [JHM_OMOP_TEST].[deident].[device_exposure]
SELECT device_exposure_id
      ,s.id as person_id
      ,device_concept_id
      ,DATEADD(DAY, s.date_shift, device_exposure_start_date)  as device_exposure_start_date
      ,DATEADD(DAY, s.date_shift, device_exposure_start_date)  as device_exposure_start_datetime
      ,DATEADD(DAY, s.date_shift, device_exposure_end_date)  as device_exposure_end_date
      ,DATEADD(DAY, s.date_shift, device_exposure_end_date)  as device_exposure_end_datetime
      ,device_type_concept_id
      ,unique_device_id
      ,quantity
      ,1 provider_id
      ,v.new_id as visit_occurrence_id
      ,visit_detail_id
      ,device_source_value
      ,device_source_concept_id
from [JHM_OMOP_20220203].[dbo].[device_exposure] p
inner join [JHM_OMOP_TEST].[deident].[source_id_person] s on s.sourceKey = p.person_id 
left join [JHM_OMOP_TEST].[deident].[source_id_visit] v on v.sourceKey = p.visit_occurrence_id 
where (DATEADD(DAY, s.date_shift, device_exposure_start_date) < @END_DATE 
and DATEADD(DAY, s.date_shift, device_exposure_end_date) > @START_DATE)
;

/******* MEASUREMENT *******/
insert into [JHM_OMOP_TEST].[deident].[measurement]
select measurement_id
      ,s.id as person_id
      ,measurement_concept_id
      ,DATEADD(DAY, s.date_shift, measurement_date) as measurement_date
      ,DATEADD(DAY, s.date_shift, measurement_date) measurement_datetime
      ,measurement_time
      ,measurement_type_concept_id
      ,operator_concept_id
      ,value_as_number
      ,value_as_concept_id
      ,unit_concept_id
      ,range_low
      ,range_high
      ,1 as provider_id
      ,v.new_id as visit_occurrence_id
      ,visit_detail_id
      ,measurement_source_value
      ,measurement_source_concept_id
      ,unit_source_value
      ,value_source_value
from [JHM_OMOP_20220203].[dbo].[measurement] p
inner join [JHM_OMOP_TEST].[deident].[source_id_person] s on s.sourceKey = p.person_id 
left join [JHM_OMOP_TEST].[deident].[source_id_visit] v on v.sourceKey = p.visit_occurrence_id 
where (DATEADD(DAY, s.date_shift, measurement_date) < @END_DATE 
and DATEADD(DAY, s.date_shift, measurement_date) > @START_DATE) 
;