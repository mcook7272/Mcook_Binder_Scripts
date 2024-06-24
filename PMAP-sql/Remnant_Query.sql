drop table if exists Analytics.dbo.covidparikhurine_linked_20210319;

select 

ord.order_proc_id,
coh.[Biorepository Patient ID],
ord.PAT_ID,
eap.proc_id,
acc.acc_num,
acc.acc_num_mod,
idn.spm_specimen_idn,
spec.specimen_container,
ord.ORDERING_DATE

into Analytics.dbo.covidparikhurine_linked_20210319

from order_proc ord
inner join (select *, substring(ACC_NUM, 0, CHARINDEX(':', ACC_NUM)) "acc_num_mod" from ORDER_RAD_ACC_NUM where acc_num like '%:%') acc
on ord.order_proc_id = acc.order_proc_id

left join SPM_SPECIMEN_IDN idn
on idn.order_id = ord.order_proc_id

left join ord_specimen_containers spec
on spec.order_id = ord.order_proc_id

inner join clarity_eap eap
on eap.proc_id = ord.proc_id

inner join Analytics.dbo.covidparikhurine_20210318 coh
on coh.order_number = acc.acc_num_mod
--Add cov num, pat_id, tell Bob to match to osler_id