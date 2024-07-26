ALTER proc dbo.[CCDA2715_Sharp_Sarcoidosis_Demographics_sp] AS
/**********************************************************************************
Author:  Michael Cook
Date: 7/6/2021
JIRA: CCDA-2715
Description: A one-time extract of Adult patients residing in MD seen at the Johns Hopkins Sarcoidosis Clinic. 
This proc creates the demographics table.
Example:
    EXEC dbo.[CCDA2715_Sharp_Sarcoidosis_Demographics_sp]
     
Revision History:
Date            Author          JIRA            Comment
[date]      [your name]     CCDA-xxx            [Comments about what was changed and why]
***********************************************************************************/

SET NOCOUNT ON;

drop table if exists Analytics.dbo.CCDA2715_Sharp_Demographics;


WITH COH AS (
SELECT DISTINCT PAT_ID
FROM CLARITY..PAT_LIST
where LIST_ID = '630939'
),

PCR AS (
SELECT PAT_ID, min(RESULT_DTM) "First_Positive_PCR"
FROM [Analytics].[dbo].[CovidAllTests_v4]
WHERE POSITIVE_YN = 'Y'
GROUP BY PAT_ID
),

CCI AS (
SELECT NETWORKED_ID
                    ,METRICS_ID, CCR.RULE_NAME
                    ,cast(RDM.METRIC_STRING_VALUE as varchar) "CCI_Score"
                    ,cast(RDM.METRIC_LAST_UPD_TM as varchar) "Date"
                from CLARITY.dbo.REG_DATA_METRICS RDM 
                INNER JOIN    CLARITY.dbo.CL_CHRG_EDIT_RULE CCR ON CCR.RULE_ID = RDM.METRICS_ID
                INNER JOIN    CLARITY.dbo.REGISTRY_DATA_INFO RDI ON RDI.RECORD_ID = RDM.RECORD_ID
                INNER JOIN    CLARITY..PATIENT pat1 on rdi.networked_id=pat1.pat_id
                WHERE RDM.METRICS_ID IN ('2101500001')
                AND cast(RDM.METRIC_STRING_VALUE as NUMERIC) in (0,1)
)

Select II.IDENTITY_ID "EMRN", PT.PAT_MRN_ID "Preferred_MRN", zps.[NAME] "Status",
pt.DEATH_DATE "Death_Date", CCI.CCI_Score, PCR.First_Positive_PCR
INTO Analytics.dbo.CCDA2715_Sharp_Demographics
FROM Clarity..PATIENT PT
INNER JOIN COH ON COH.PAT_ID = Pt.PAT_ID
INNER JOIN CLARITY..IDENTITY_ID II ON II.PAT_ID = PT.PAT_ID and II.IDENTITY_TYPE_ID = 0
LEFT JOIN CLARITY..PATIENT_4 PT4 on PT.PAT_ID = PT4.PAT_ID
LEFT JOIN CLARITY..ZC_SEX ZS ON ZS.RCPT_MEM_SEX_C = PT.SEX_C
LEFT JOIN CLARITY..ZC_ETHNIC_GROUP ETG ON ETG.ETHNIC_GROUP_C = PT.ETHNIC_GROUP_C
left JOIN CLARITY.dbo.ZC_MARITAL_STATUS zms on PT.MARITAL_STATUS_C = zms.MARITAL_STATUS_C
LEFT JOIN CLARITY..ZC_PAT_LIVING_STAT zps on pt4.PAT_LIVING_STAT_C = zps.PAT_LIVING_STAT_C
LEFT JOIN PCR on PT.PAT_ID = PCR.PAT_ID
LEFT JOIN CCI ON CCI.NETWORKED_ID = PT.PAT_ID;

ALTER TABLE [Analytics].[dbo].[CCDA2715_Sharp_Demographics] REBUILD PARTITION = ALL  WITH (DATA_COMPRESSION = Page)


