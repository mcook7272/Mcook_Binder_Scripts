CREATE proc dbo.CCDA2715_Sharp_Sarcoidosis_Census_Tract AS
/**********************************************************************************
Author:  Michael Cook
Date: 7/13/2021
JIRA: CCDA-2715
Description: This populates a table which contains PAT_ID and census_tract for the Sarcoidosis cohort, which was defined in Clarity 
and moved to CCDA.dbo.CCDA2715_Sharp_Sarcoidosis_Cohort. The output of this table is then moved over to Clarity Analytics for use in the main proc stored there.
Example:
    EXEC dbo.[CCDA2715_Sharp_Sarcoidosis_Census_Tract]
     
Revision History:
Date            Author          JIRA            Comment

***********************************************************************************/

SET NOCOUNT ON;

drop table if exists CCDA.dbo.CCDA2715_Sharp_Census_Tract;

SELECT Distinct pat.PatientEpicId "PAT_ID", ad.CensusTract_X "Census_Tract"
into CCDA.dbo.CCDA2715_Sharp_Census_Tract
FROM CDW.FullAccess.PatientDim pat
INNER JOIN CCDA.dbo.CCDA2715_Sharp_Sarcoidosis_Cohort coh on pat.PatientEpicId = coh.PAT_ID
INNER JOIN CDW.FullAccess.AddressDim ad on pat.AddressKey = ad.AddressKey
WHERE 
pat.IsCurrent = 1
AND ad.Status = 'Street'