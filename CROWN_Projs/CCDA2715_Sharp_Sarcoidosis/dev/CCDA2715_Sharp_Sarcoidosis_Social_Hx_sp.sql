ALTER proc dbo.[CCDA2715_Sharp_Sarcoidosis_Social_Hx_sp] AS
/**********************************************************************************
Author:  Michael Cook
Date: 7/8/2021
JIRA: CCDA-2715
Description: A one-time extract of Adult patients residing in MD seen at the Johns Hopkins Sarcoidosis Clinic. 
This proc creates the Social_Hx table.
Example:
    EXEC dbo.[CCDA2715_Sharp_Sarcoidosis_Social_Hx_sp]
     
Revision History:
Date            Author          JIRA            Comment
[date]      [your name]     CCDA-xxx            [Comments about what was changed and why]
***********************************************************************************/

SET NOCOUNT ON;

drop table if exists Analytics.dbo.CCDA2715_Sharp_Sarcoidosis_Social_Hx;


WITH COH AS (
SELECT DISTINCT PAT_ID
FROM CLARITY..PAT_LIST
where LIST_ID = '630939'
),

ENC AS (
SELECT DISTINCT PAT_ID, PAT_ENC_CSN_ID
FROM CLARITY..PAT_ENC
WHERE ENC_TYPE_C IN ( '1000', '1001', '1003', '1004', '101', '108', '1199', 
'1200', '1201', '121', '1214', '2', '200', '210', '2100', '2101',
'2501', '2502', '2508', '2520', '2521', '2522', '2525', '2526', '2529',
'2531', '50', '62', '76', '81', '91', '20', '55')
AND EFFECTIVE_DATE_DTTM >= '2017-01-01'
)

Select DISTINCT enc.PAT_ENC_CSN_ID, zs.[NAME] "Smoking_Status", soc.TOBACCO_PAK_PER_DY "Packs_Per_Day",
soc.SMOKING_QUIT_DATE, za.[NAME] "Alcohol_Use", zi.[NAME] "Illicit_Drug_Use"
--INTO Analytics.dbo.CCDA2715_Sharp_Sarcoidosis_Social_Hx
FROM Clarity..SOCIAL_HX soc
INNER JOIN COH ON COH.PAT_ID = soc.PAT_ID
INNER JOIN ENC enc on COH.PAT_ID = enc.PAT_ID
LEFT JOIN CLARITY..ZC_SMOKING_TOB_USE zs on soc.SMOKING_TOB_USE_C = zs.SMOKING_TOB_USE_C
LEFT JOIN CLARITY..ZC_ALCOHOL_USE za on soc.ALCOHOL_USE_C = za.ALCOHOL_USE_C
LEFT JOIN CLARITY..ZC_ILL_DRUG_USER zi on soc.ILL_DRUG_USER_C = zi.ILL_DRUG_USER_C
WHERE 1 = 1
ORDER BY enc.PAT_ENC_CSN_ID;

ALTER TABLE [Analytics].[dbo].[CCDA2715_Sharp_Sarcoidosis_Social_Hx] REBUILD PARTITION = ALL  WITH (DATA_COMPRESSION = Page)