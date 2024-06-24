select DATEPART(year, row_insert_dtm) "year", DATEPART(month, row_insert_dtm) "month", count(distinct osler_id)
from covid_projection.dbo.covid_pmcoe_ipevents_v5
group by DATEPART(year, row_insert_dtm), DATEPART(month, row_insert_dtm) 
order by [year], [month]

  select DATEPART(year, [initial_dx_date]) "year", DATEPART(month, [initial_dx_date]) "month", count(distinct osler_id)
from [COVID_Projection].[dbo].[covid_pmcoe_covid_positive]
group by DATEPART(year, [initial_dx_date]), DATEPART(month, [initial_dx_date]) 
order by [year], [month]

select distinct DATEPART(year, [initial_dx_date]) "year", DATEPART(month, [initial_dx_date]) "month", osler_id
from [COVID_Projection].[dbo].[covid_pmcoe_covid_positive]
where DATEPART(year, [initial_dx_date]) = 2021 AND DATEPART(month, [initial_dx_date]) = 4 --14383

select count(distinct osler_id)
from [COVID_Projection].[dbo].[covid_pmcoe_covid_positive]