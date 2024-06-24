drop table CoxAvailSpecimens_Current;

select *
into PMAP_Analytics.dbo.CoxAvailSpecimens_Current
from CoxSpecimens_20210420

exec CCDA2046_Cox_NoHyphens