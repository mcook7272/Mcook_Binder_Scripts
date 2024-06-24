;with tab as (select ROW_NUMBER() over (partition by osler_id order by osler_id, contact_date desc)line, *
from  COVID_Projection..derived_outpatient_encounters where contact_date >= '03/01/2020')
select a.*
from tab a
--join (select distinct osler_id from tab where line > 1) b on a.osler_id = b.osler_id
where line = 1