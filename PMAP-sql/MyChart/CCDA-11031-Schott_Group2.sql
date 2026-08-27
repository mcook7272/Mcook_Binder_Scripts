/************************************************
*
*       Author:    Michael Cook
*       Date Created:   7/21/2026
*       Inclusion: 
*			Group 2:
*				1.   Age and gender: >= 18 y.o., all genders.
*               2.   Patients seen at certain departments (listed in spec) within past 2 weeks
*               3.   Patients who have a diagnosis from the list in the spec, at any time
*               4.   Patients have LDL-C result >55 within last 2 years (REMOVED)
*				5.	 Initiation or intensification (dose increase) of lipid-lowering therapy within the last 2 weeks (Drugs listed in spec)
*					 (Definition: ordered within -2 weeks for the first time or new order within -2 weeks that has higher dose comparing last same medication order, regardless of when it was.)
*				6.	 Patients have active MyChart Account
*
*
*       Exclusion: 1.   Patients known to be deceased in Epic.
*                  2.   Patients who have opted out of being contacted for MyChart recruitment.
*                  3.   Patients who have opted out of being contacted for any reason.
*                  4.   Hospice Patients
*
************************************************/
/*
* Inclusive diagnosis codes.
*/
IF OBJECT_ID(N'TEMPDB..#CCDA11031_dx') IS NOT NULL
	DROP TABLE #CCDA11031_dx;

SELECT DiagnosisKey
INTO #CCDA11031_dx
FROM fullaccess.diagnosisdim
WHERE (
    currenticd10list_x LIKE 'I20.%'
    OR currenticd10list_x LIKE 'I21.%'
    OR currenticd10list_x LIKE 'I22.%'
    OR currenticd10list_x LIKE 'I23.%'
    OR currenticd10list_x LIKE 'I24.%'
    OR currenticd10list_x LIKE 'I25.%'
    OR currenticd10list_x IN ('Z95.1', 'Z95.5', 'Z86.73')
    OR currenticd10list_x LIKE 'I63.%'
    OR currenticd10list_x LIKE 'I65.%'
    OR currenticd10list_x LIKE 'I66.%'
    OR currenticd10list_x = 'I67.2'
    OR currenticd10list_x LIKE 'G45.%'
    OR currenticd10list_x LIKE 'I70.%'
    OR currenticd10list_x = 'I73.9'
    OR currenticd10list_x LIKE 'I74.%'
    OR currenticd10list_x = 'R93.1'
);

/*
* Inclusive locations
*/
IF OBJECT_ID(N'TEMPDB..#CCDA11031_dep') IS NOT NULL
	DROP TABLE #CCDA11031_dep;

SELECT departmentkey
INTO #CCDA11031_dep
FROM fullaccess.departmentdim
WHERE (DepartmentEpicId IN ('110106508', '110106469', '113000466', '113000461', '110106461'))
	AND isnull(serviceareaepicid, '11') = '11';-- JHM CLINICAL


/*
* LDL-C labs (REMOVED)
*/
/*
IF OBJECT_ID(N'TEMPDB..#CCDA11031_ldl') IS NOT NULL
	DROP TABLE #CCDA11031_ldl;

SELECT LabComponentKey
INTO #CCDA11031_ldl
FROM fullaccess.labcomponentdim
WHERE baseName IN ('LDL', 'LDLDIRECT');
*/

/*
* Lipid-Lowering Therapy
*/
IF OBJECT_ID(N'TEMPDB..#CCDA11031_lip') IS NOT NULL
	DROP TABLE #CCDA11031_lip;

SELECT MedicationKey
INTO #CCDA11031_lip
FROM fullaccess.medicationDim
WHERE simpleGenericName IN (
		'atorvastatin calcium', 'rosuvastatin calcium', 'simvastatin', 'pravastatin sodium', 'lovastatin', 'fluvastatin sodium', 'pitavastatin calcium', 'ezetimibe', 'evolocumab', 'alirocumab', 
		'inclisiran sodium', 'pitavastatin magnesium', 'bempedoic acid'
		);

/*
* Patients with dept inclusion criteria
*/
IF OBJECT_ID(N'TEMPDB..#CCDA11031_dep_inc') IS NOT NULL
	DROP TABLE #CCDA11031_dep_inc;

SELECT pd.durablekey --, vf.AppointmentInstant, vf.DepartmentKey
INTO #CCDA11031_dep_inc
FROM fullaccess.patientdim pd
JOIN fullaccess.visitfact vf ON vf.patientdurablekey = pd.durablekey
JOIN #CCDA11031_dep depd ON depd.departmentkey = vf.departmentkey
WHERE vf.appointmentInstant >= DATEADD(WEEK, - 2, GETDATE())
	AND vf.AppointmentStatus IN ('Completed', 'Confirmed', 'Present', 'Arrived')
	AND vf.IsFaceToFace = 1;

/*
* Patients with dx inclusion criteria
*/
IF OBJECT_ID(N'TEMPDB..#CCDA11031_dx_inc') IS NOT NULL
	DROP TABLE #CCDA11031_dx_inc;

SELECT pd.durablekey
INTO #CCDA11031_dx_inc
FROM fullaccess.patientdim pd
JOIN fullaccess.diagnosiseventfact def ON def.patientdurablekey = pd.durablekey
JOIN #CCDA11031_dx dd ON def.diagnosiskey = dd.diagnosiskey
WHERE def.StartDateKey > 0 -- omit -1, -2, -3 caboodle values
	--AND def.STATUS = 'Active' -- active diagnosis status
	;

/*
* Patients with ldl result criteria (REMOVED)
*/
/*
IF OBJECT_ID(N'TEMPDB..#CCDA11031_ldl_inc') IS NOT NULL
	DROP TABLE #CCDA11031_ldl_inc;

SELECT pd.durablekey --, res.NumericValue, res.ResultInstant
INTO #CCDA11031_ldl_inc
FROM fullaccess.patientdim pd
JOIN fullaccess.LabComponentResultFact res ON res.patientdurablekey = pd.durablekey
JOIN #CCDA11031_ldl ldl ON res.LabComponentKey = ldl.LabComponentKey
WHERE res.NumericValue > 100
	AND res.ResultStatus IN ('Edited', 'Final result', 'Edited Result - FINAL')
	AND res.ResultInstant >= DATEADD(YEAR, - 2, GETDATE());
	*/

/*
* Patients with lip-lowering result criteria
*/
IF OBJECT_ID(N'TEMPDB..#CCDA11031_lip_inc') IS NOT NULL
	DROP TABLE #CCDA11031_lip_inc;

WITH lipid_orders
AS (
	SELECT o.PatientDurableKey
		,o.OrderedInstant
		,o.MedicationKey
		,o.Quantity
		,o.DiscreteDose_X
		,ROW_NUMBER() OVER (
			PARTITION BY o.PatientDurableKey
			,o.MedicationKey ORDER BY o.OrderedInstant
			) AS rn
		,LAG(o.Quantity) OVER (
			PARTITION BY o.PatientDurableKey
			,o.MedicationKey ORDER BY o.OrderedInstant
			) AS prev_quant_amount
		,LAG(o.DiscreteDose_X) OVER (
			PARTITION BY o.PatientDurableKey
			,o.MedicationKey ORDER BY o.OrderedInstant
			) AS prev_dose_amount
	FROM FullAccess.MedicationOrderFact o
	INNER JOIN #CCDA11031_lip l ON o.MedicationKey = l.MedicationKey
	)
	,recent_lipid_orders
AS (
	SELECT *
	FROM lipid_orders
	WHERE OrderedInstant >= DATEADD(WEEK, - 2, GETDATE())
	)
SELECT r.PatientDurableKey
	,CASE WHEN MAX(CASE WHEN r.rn = 1 THEN 1 ELSE 0 END) = 1
			OR MAX(CASE WHEN r.prev_dose_amount IS NOT NULL
						AND r.DiscreteDose_X > r.prev_dose_amount THEN 1 ELSE 0 END) = 1
			OR MAX(CASE WHEN r.prev_quant_amount IS NOT NULL
						AND r.Quantity > r.prev_quant_amount THEN 1 ELSE 0 END) = 1 THEN 1 ELSE 0 END AS lipid_therapy_initiation_or_intensification_flag
INTO #CCDA11031_lip_inc
FROM recent_lipid_orders r
GROUP BY r.PatientDurableKey;

/*
* Patients with all inclusion criteria
*/
IF OBJECT_ID(N'TEMPDB..#CCDA11031_inc') IS NOT NULL
	DROP TABLE #CCDA11031_inc;

SELECT pd.durablekey
INTO #CCDA11031_inc
FROM fullaccess.patientdim pd
JOIN fullaccess.portalaccountdim pad ON pad.patientdurablekey = pd.durablekey
JOIN fullaccess.patientattributevaluedim pavd ON pavd.patientdurablekey = pd.durablekey
JOIN #CCDA11031_dep_inc dep ON pd.DurableKey = dep.durablekey
JOIN #CCDA11031_dx_inc dx ON pd.DurableKey = dx.durablekey
--JOIN #CCDA11031_ldl_inc ldl ON pd.DurableKey = ldl.durablekey
JOIN #CCDA11031_lip_inc lip ON pd.DurableKey = lip.PatientDurableKey
	AND lipid_therapy_initiation_or_intensification_flag = 1
WHERE pd.iscurrent = 1 -- current information
	AND pad.iscurrent = 1 -- current information
	AND pavd.iscurrent = 1 -- current information
	AND pd.birthdate IS NOT NULL -- valid birthdate
	AND pd.ageinyears >= 18 -- Age 18+
	AND pd.deathdate IS NULL -- excludes deceased patients
	AND ISNULL(pd.STATUS, '') <> 'Deceased' -- excludes deceased patients
	AND (
		pd.mychartstatus = 'Activated'
		OR pad.mychartstatus_x = 'Activated'
		) -- have mychart account
	AND pavd.attributekey = '1032606' -- JHM IsOutreachYN
	AND pavd.value = 'Y' -- opted in for contact
	;

/*
* Exclude patients who are hospice patients
*/
IF OBJECT_ID(N'TEMPDB..#CCDA11031_exc') IS NOT NULL
	DROP TABLE #CCDA11031_exc;

WITH EDG
AS (
	SELECT DISTINCT dx.CurrentICD10List_X
		,dx.Name AS DX_Name
		,ds.Name AS Grouper_Name
		,dx.DiagnosisEpicId AS DX_ID
		,dx.DiagnosisKey
	FROM CDW.FullAccess.DiagnosisSetDim ds
	JOIN CDW.FullAccess.DiagnosisDim dx ON ds.DiagnosisKey = dx.DiagnosisKey
	WHERE ds.ValueSetEpicID = '101394'
		AND ds.DiagnosisSetKey > 0
	)
SELECT PT.durableKey
INTO #CCDA11031_exc
FROM CDW.FullAccess.PatientDim PT
INNER JOIN CDW.FullAccess.ProblemListFact PL ON PL.PatientDurableKey = PT.DurableKey
INNER JOIN EDG EDG ON EDG.DiagnosisKey = PL.DiagnosisKey
UNION ALL
SELECT PT.durableKey
FROM CDW.FullAccess.PatientDim PT
INNER JOIN CDW.FullAccess.AdtEventFact adt ON PT.DurableKey = adt.PatientDurableKey
WHERE adt.PatientClass = 'Inpatient Hospice' --ADT_PAT_CLASS_C = 150
UNION ALL
SELECT PT.durableKey
FROM CDW.FullAccess.PatientDim PT
INNER JOIN HospiceEpisodeFact H ON PT.DurableKey = H.PatientDurableKey;

/*
* Removed excluded patients
*/
SELECT DISTINCT pd.patientepicid AS ID
FROM fullaccess.patientdim pd
JOIN #CCDA11031_inc i ON i.durablekey = pd.durablekey
LEFT JOIN #CCDA11031_exc e ON i.durablekey = e.durablekey
WHERE pd.iscurrent = 1 -- current information
	AND e.durablekey IS NULL -- exclude hospice pts
	AND isnull(pd.ResearchContactPreference, '') <> 'Do Not Contact' --ok to contact
	;

DROP TABLE IF EXISTS #CCDA11031_exc;
DROP TABLE IF EXISTS #CCDA11031_inc;
DROP TABLE IF EXISTS #CCDA11031_dep;
DROP TABLE IF EXISTS #CCDA11031_dx;
DROP TABLE IF EXISTS #CCDA11031_lip;
--DROP TABLE IF EXISTS #CCDA11031_ldl;
DROP TABLE IF EXISTS #CCDA11031_dep_inc;
DROP TABLE IF EXISTS #CCDA11031_dx_inc; 
--DROP TABLE IF EXISTS #CCDA11031_ldl_inc;
DROP TABLE IF EXISTS #CCDA11031_lip_inc;