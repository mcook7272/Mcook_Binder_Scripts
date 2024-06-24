select top 100*
from PAT_ENC_6;

select count(*)
from PAT_ENC_6;
--221,934,555

select count(*)
from PAT_ENC_6
where BMI_PERCENTILE IS NOT NULL
--2,453,833

--% populated: 2,453,833 / 221,934,555 = ~1.1%

select count(*)
from PAT_ENC_6 enc
join PATIENT pt on enc.PAT_ID = pt.PAT_ID
where BMI_PERCENTILE IS NOT NULL
AND CAST((DATEDIFF(dd,pt.BIRTH_DATE,enc.CONTACT_DATE) / 365.25) AS INT) < 21
--2,453,808

select distinct top 100 enc.pat_id, pt.BIRTH_DATE, enc.CONTACT_DATE, CAST((DATEDIFF(dd,pt.BIRTH_DATE,enc.CONTACT_DATE) / 365.25) AS INT) as age
from PAT_ENC_6 enc
join PATIENT pt on enc.PAT_ID = pt.PAT_ID
where BMI_PERCENTILE IS NOT NULL
--AND DATEDIFF(dd,pt.BIRTH_DATE,enc.CONTACT_DATE) / 365.25 <= 21