drop table if exists #temp

select n3c.osler_id, pos.initial_dx_date, pos.initial_dx_source,
CASE WHEN ipe.osler_id is not NULL then 'hospitalized' else 'not hospitalized' END AS Hosp_yn
into #temp
from PMAP_Analytics.dbo.OMOP_N3C_CASE_COHORT_Osler n3c
left join COVID_Projection.dbo.covid_pmcoe_covid_positive pos on n3c.osler_id = pos.osler_id
left join COVID_Projection.dbo.covid_pmcoe_ipevents_v5 ipe on n3c.osler_id = ipe.osler_id;

select * from #temp;

select initial_dx_source, count(*)
from #temp
group by initial_dx_source;

select Hosp_yn, count(*)
from #temp
group by Hosp_yn;

select initial_dx_source, Hosp_yn, count(*)
from #temp
group by initial_dx_source,Hosp_yn;