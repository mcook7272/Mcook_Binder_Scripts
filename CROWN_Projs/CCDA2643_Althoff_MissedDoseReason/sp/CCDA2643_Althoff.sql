

ALTER PROC CCDA2643_Althoff_MissedDoseReason_sp AS 
/**********************************************************************************
Author:  Michael Cook
Date: 2021-05-28
JIRA: CCDA-2643
Description: Gets list of patients vaccinated by study team (based on department ID 110400336 and given date range), and reasons for not getting second vaccination, if available.
Uses Clarity, CovidImmuinz table created by David Thiemann, and a spreadsheet from the study team imported into Analytics.dbo.CCDA2643AlthoffMissedDoseReasons)
Example:
    EXEC dbo.[CCDA2643_Althoff_MissedDoseReason_sp] 
     
Revision History:
Date            Author          JIRA            Comment
[date]      [your name]     CCDA-xxx            [Comments about what was changed and why]
***********************************************************************************/
BEGIN

SET NOCOUNT ON;

drop table if exists [Analytics].[dbo].[CCDA2643_Althoff_MissedDoseReason_Unmasked];
drop table if exists [Analytics].[dbo].[CCDA2643_Althoff_MissedDoseReason_Master];
drop table if exists [Analytics].[dbo].[CCDA2643_Althoff_MissedDoseReason];

select distinct pat.PAT_ID, CAST((DATEDIFF(DAY, pat.BIRTH_DATE, CURRENT_TIMESTAMP)/365.25) AS INT) "Age", 
sex.[NAME] "Legal_Sex", ISNULL(gen.[NAME], sex.[NAME]) "Preferred_Gender", zc_race.[NAME] "Race", ethn.[NAME] "Hispanic", pat.ZIP, lan.[NAME] "Language", pat.INTRPTR_NEEDED_YN,
imm.JAB1_IMMUNE_TYPE, imm.JAB1_IMMUNE_DATE, imm.JAB2_IMMUNE_TYPE, imm.JAB2_IMMUNE_DATE, zcliv.[NAME] "PAT_STATUS", pat.DEATH_DATE, 
sheet.[Summary - Reason for missed appointment] "Summary_Reason", sheet.[Summary - Disposition] "Summary_Disp",
CASE when pat.PAT_ID in (select distinct pat_id from CLARITY.dbo.pat_enc where contact_date is not null and contact_date < '2021-01-27' and APPT_STATUS_C = 2) then 'Yes' else 'No' END AS "Previous_Encounter"
into [Analytics].[dbo].[CCDA2643_Althoff_MissedDoseReason_Unmasked]
from CLARITY.dbo.PATIENT pat
left join CLARITY.dbo.ZC_LANGUAGE lan on ISNULL(pat.LANG_CARE_C,pat.LANGUAGE_C)  = lan.LANGUAGE_C
left join CLARITY.dbo.PATIENT_4 pat4 on pat.PAT_ID = pat4.PAT_ID
left join CLARITY.dbo.ZC_GENDER_IDENTITY gen on pat4.GENDER_IDENTITY_C = gen.GENDER_IDENTITY_C
left join CLARITY.dbo.ZC_SEX sex on pat.SEX_C = sex.RCPT_MEM_SEX_C
left join CLARITY.dbo.PATIENT_RACE race on pat.PAT_ID = race.PAT_ID AND race.LINE = 1
left join CLARITY.dbo.ZC_PATIENT_RACE zc_race on race.PATIENT_RACE_C = zc_race.PATIENT_RACE_C
left join CLARITY.dbo.ZC_ETHNIC_GROUP ethn on pat.ETHNIC_GROUP_C = ethn.ETHNIC_GROUP_C
join Analytics.dbo.CovidImmuniz imm on pat.PAT_ID = imm.PAT_ID
join CLARITY.dbo.PAT_ENC enc on pat.PAT_ID = enc.PAT_ID
join CLARITY.dbo.CLARITY_DEP dep on enc.EFFECTIVE_DEPT_ID = dep.DEPARTMENT_ID
join CLARITY.dbo.ZC_PAT_LIVING_STAT zcliv on pat4.PAT_LIVING_STAT_C = zcliv.PAT_LIVING_STAT_C
left join Analytics.dbo.CCDA2643AlthoffMissedDoseReasons sheet on pat.PAT_NAME = sheet.[Location & Patient Names]
where enc.EFFECTIVE_DEPT_ID = 110400336
and enc.EFFECTIVE_DATE_DT between '2021-01-27' and '2021-03-09';

Select coh.PAT_ID, ROW_NUMBER() OVER (ORDER BY coh.PAT_ID) as 'Patient_ID'
into [Analytics].[dbo].[CCDA2643_Althoff_MissedDoseReason_Master]
from (select distinct PAT_ID from [CCDA2643_Althoff_MissedDoseReason_Unmasked] ) coh;

Select mas.Patient_ID, tmp.Age, tmp.Legal_Sex, tmp.Preferred_Gender, tmp.Race, tmp.Hispanic,
tmp.ZIP, tmp.[Language], tmp.INTRPTR_NEEDED_YN, tmp.JAB1_IMMUNE_TYPE, tmp.JAB1_IMMUNE_DATE, tmp.JAB2_IMMUNE_TYPE, tmp.JAB2_IMMUNE_DATE,
tmp.PAT_STATUS, tmp.DEATH_DATE, tmp.Previous_Encounter,
CASE WHEN tmp.Summary_Reason = '' then NULL else tmp.Summary_Reason END AS "Summ_Reas",
CASE WHEN tmp.Summary_Disp = '' then NULL else tmp.Summary_Disp END AS "Summ_Disp"
into Analytics.dbo.CCDA2643_Althoff_MissedDoseReason
from [CCDA2643_Althoff_MissedDoseReason_Unmasked] tmp
join [Analytics].[dbo].[CCDA2643_Althoff_MissedDoseReason_Master] mas on tmp.PAT_ID = mas.PAT_ID
order by Summ_Reas desc;

ALTER TABLE [Analytics].[dbo].[CCDA2643_Althoff_MissedDoseReason_Unmasked] REBUILD PARTITION = ALL  WITH (DATA_COMPRESSION = Page);
ALTER TABLE [Analytics].[dbo].[CCDA2643_Althoff_MissedDoseReason_Master] REBUILD PARTITION = ALL  WITH (DATA_COMPRESSION = Page);
ALTER TABLE [Analytics].[dbo].[CCDA2643_Althoff_MissedDoseReason] REBUILD PARTITION = ALL  WITH (DATA_COMPRESSION = Page);

END

GO

