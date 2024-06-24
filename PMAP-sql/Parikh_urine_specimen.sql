drop table if exists CROWNParikh_Projection.waste.[covidparikhurine_final];
drop table if exists CROWNParikh_Projection.ccpsei.[covidparikhurine_final];

select waste_patient_id, ur.[Biorepository Patient ID] "Biorepository_Patient_ID", ur.proc_id, ur.acc_num_mod "acc_num"
into CROWNParikh_Projection.waste.[covidparikhurine_final]
from [PMAP_Analytics].[dbo].[covidparikhurine_final] ur
inner join PMAP_Analytics.dbo.CCDA2450_Parihk_osler_id_Mapping id on id.osler_id = ur.osler_id;

select ccpsei_patient_id, ur.[Biorepository Patient ID] "Biorepository_Patient_ID", ur.proc_id, ur.acc_num_mod "acc_num"
into CROWNParikh_Projection.ccpsei.[covidparikhurine_final]
from [PMAP_Analytics].[dbo].[covidparikhurine_final] ur
inner join PMAP_Analytics.dbo.CCDA2450_Parihk_osler_id_Mapping id on id.osler_id = ur.osler_id;