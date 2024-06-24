select distinct cox.osler_id, spec.bsi_spec_type, cox.[Date of Blood Draw] "collection_time", cox.positive_test_time
from PMAP_Analytics.dbo.CCDA2046_Cox_Final_NoHyphens_04_02_2021 cox
inner join PMAP_Analytics.dbo.covid_pmcoe_covidwastespecdataR spec on spec.oslerid = cox.osler_id;

select *
from PMAP_Analytics.dbo.CCDA2046_Cox_Final_NoHyphens_04_02_2021 cox
left join PMAP_Analytics.dbo.covid_pmcoe_covidwastespecdataR spec on spec.oslerid = cox.osler_id;

select distinct cox.osler_id, spec.bsi_spec_type, cox.[Date of Blood Draw] "collection_time", cox.positive_test_time
from PMAP_Analytics.dbo.CCDA2046_Cox_Final_NoHyphens_04_02_2021 cox
inner join PMAP_Analytics.dbo.covid_pmcoe_covidwastespecdataR spec on spec.oslerid = cox.osler_id and cox.[Date of Blood Draw] = spec.epic_specimen_recv_time;

select osler_id, gender "type", [Date of Blood Draw] "collection_date", positive_test_time, 'CCPSEI'  AS "cohort_flag"
from PMAP_Analytics.dbo.CCDA2046_Cox_Final_NoHyphens_04_02_2021
union
select oslerid "osler_id", bsi_spec_type "type", cox.[Date of Blood Draw] "collection_date", cox.positive_test_time, 'Waste' AS "cohort_flag"
from PMAP_Analytics.dbo.covid_pmcoe_covidwastespecdataR waste
inner join PMAP_Analytics.dbo.CCDA2046_Cox_Final_NoHyphens_04_02_2021 cox on cox.osler_id = waste.oslerid