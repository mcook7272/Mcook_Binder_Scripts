drop table if exists PMAP_Analytics.dbo.Parikh_Biospecimen_PHI
Select distinct [SUBJECT_NUMBER],pat.jhhmrn, pat.emrn, pat.birth_date,pat.gender
into PMAP_Analytics.dbo.Parikh_Biospecimen_PHI
from CROWNParikh_Projection..derived_epic_patient pat
inner join PMAP_Analytics..[CCDA2046_Cox_Final_Hyphens_NoHyphens] noh on noh.osler_id = pat.osler_id 
order by SUBJECT_NUMBER


