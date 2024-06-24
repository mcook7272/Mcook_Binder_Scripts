--Queries to move Siddiqui covid-pos table and inpatient_enc table (back to 1/1/2019) to PMAP_Analytics
drop table if exists CROWNSiddiqui_Projection.dbo.CCDA2373_Siddiqui_covid_pmcoe_covid_positive;
drop table if exists CROWNSiddiqui_Projection.dbo.CCDA2373_Siddiqui_derived_inpatient_encounters;

Select *
into CROWNSiddiqui_Projection.dbo.CCDA2373_Siddiqui_covid_pmcoe_covid_positive
from CROWNSiddiqui_Projection.dbo.covid_pmcoe_covid_positive;

Select enc.*
into CROWNSiddiqui_Projection.dbo.CCDA2373_Siddiqui_derived_inpatient_encounters
from COVID_Projection.dbo.derived_inpatient_encounters enc
inner join CROWNSiddiqui_Projection.dbo.derived_epic_patient pat on enc.osler_id = pat.osler_id
where hosp_admsn_time >= '2019-01-01'
