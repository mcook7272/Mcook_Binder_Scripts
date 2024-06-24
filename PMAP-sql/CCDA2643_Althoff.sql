

CREATE PROC CCDA2643_Althoff_MissedDoseReason_sp AS 
/**********************************************************************************
Author:  Michael Cook
Date: 2021-05-28
JIRA: CCDA-2643
Description: Gets list of patients vaccinated by study team (based on department ID 110400336 and given date range), and reasons for not getting second vaccination, if available.
Uses Clarity, CovidImmuinz table created by David Thiemann, and a spreadsheet from the study team imported into Analytics.dbo.CCDA2643AlthoffMissedDoseReasons)
Example:
    EXEC dbo.[CCDA2643_Althoff_MissedDoseReason_sp] [include any parameters and sample values]
     
Revision History:
Date            Author          JIRA            Comment
[date]      [your name]     CCDA-xxx            [Comments about what was changed and why]
***********************************************************************************/
BEGIN

SET NOCOUNT ON;


drop table if exists #tempTab;
drop table if exists [Analytics].[dbo].[CCDA2643_Althoff_MissedDoseReason];

select distinct pat.PAT_ID, CAST((DATEDIFF(DAY, pat.BIRTH_DATE, CURRENT_TIMESTAMP)/365.25) AS INT) "Age", 
sex.[NAME] "Legal_Sex", gen.[NAME] "Preferred_Gender", zc_race.[NAME] "Race", ethn.[NAME] "Hispanic", pat.ZIP, lan.[NAME] "Language", pat.INTRPTR_NEEDED_YN,
imm.JAB1_IMMUNE_TYPE, imm.JAB1_IMMUNE_DATE, imm.JAB2_IMMUNE_TYPE, imm.JAB2_IMMUNE_DATE, zcliv.[NAME] "PAT_STATUS", pat.DEATH_DATE, 
sheet.[Summary - Reason for missed appointment] "Summary_Reason", sheet.[Summary - Disposition] "Summary_Disp",
CASE when pat.PAT_ID in (select distinct pat_id from CLARITY.dbo.pat_enc where contact_date is not null and contact_date < '2021-01-27') then 'Yes' else 'No' END AS "Previous_Encounter_pat_id"
 --pat.PAT_MRN_ID, pat.ADD_LINE_1, pat.ADD_LINE_2
into #tempTab
from CLARITY.dbo.PATIENT pat
left join CLARITY.dbo.ZC_LANGUAGE lan on pat.LANGUAGE_C = lan.LANGUAGE_C
left join CLARITY.dbo.PATIENT_4 pat4 on pat.PAT_ID = pat4.PAT_ID
left join CLARITY.dbo.ZC_GENDER_IDENTITY gen on pat4.GENDER_IDENTITY_C = gen.GENDER_IDENTITY_C
left join CLARITY.dbo.ZC_SEX_ASGN_AT_BIRTH sex on pat4.SEX_ASGN_AT_BIRTH_C = sex.SEX_ASGN_AT_BIRTH_C
left join CLARITY.dbo.PATIENT_RACE race on pat.PAT_ID = race.PAT_ID
left join CLARITY.dbo.ZC_PATIENT_RACE zc_race on race.PATIENT_RACE_C = zc_race.PATIENT_RACE_C
left join CLARITY.dbo.ZC_ETHNIC_GROUP ethn on pat.ETHNIC_GROUP_C = ethn.ETHNIC_GROUP_C
join Analytics.dbo.CovidImmuniz imm on pat.PAT_ID = imm.PAT_ID
join CLARITY.dbo.PAT_ENC enc on pat.PAT_ID = enc.PAT_ID
join CLARITY.dbo.CLARITY_DEP dep on enc.DEPARTMENT_ID = dep.DEPARTMENT_ID
join CLARITY.dbo.ZC_PAT_LIVING_STAT zcliv on pat4.PAT_LIVING_STAT_C = zcliv.PAT_LIVING_STAT_C
left join Analytics.dbo.CCDA2643AlthoffMissedDoseReasons sheet on pat.PAT_NAME = sheet.[Location & Patient Names]
where enc.DEPARTMENT_ID = 110400336
and enc.contact_date between '2021-01-27' and '2021-03-09'
order by pat.PAT_ID;

Select ROW_NUMBER() OVER (ORDER BY tmp.PAT_ID) as 'Patient_ID', tmp.Age, tmp.Legal_Sex, tmp.Preferred_Gender, tmp.Race, tmp.Hispanic,
tmp.ZIP, tmp.[Language], tmp.INTRPTR_NEEDED_YN, tmp.JAB1_IMMUNE_TYPE, tmp.JAB1_IMMUNE_DATE, tmp.JAB2_IMMUNE_TYPE, tmp.JAB2_IMMUNE_DATE,
tmp.PAT_STATUS, tmp.DEATH_DATE, tmp.Previous_Encounter_pat_id, 
CASE WHEN tmp.Summary_Reason = '' then NULL else tmp.Summary_Reason END AS "Summ_Reas",
CASE WHEN tmp.Summary_Disp = '' then NULL else tmp.Summary_Disp END AS "Summ_Disp"
into Analytics.dbo.CCDA2643_Althoff_MissedDoseReason
from #tempTab tmp
order by Summ_Reas desc;

ALTER TABLE [Analytics].[dbo].[CCDA2643_Althoff_MissedDoseReason] REBUILD PARTITION = ALL  WITH (DATA_COMPRESSION = Page)

END

GO

