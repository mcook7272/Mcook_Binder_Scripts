drop table if exists Analytics.dbo.CCDA2339_result_table;

create table Analytics.dbo.CCDA2339_result_table(
proc_id varchar(250),
accession varchar(250)
);

insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D21305960%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D21708688%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D21709429%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D21707972%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D21606111%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D21905197%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D21905664%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D21903164%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D22004799%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D22003411%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D22006610%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D22005634%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D22009018%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D22203226%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D22205635%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D22408862%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D22307134%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D22306055%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D22305627%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D22604085%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D22703810%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D22704856%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D23010514%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D30202975%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D30205593%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D30207281%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D30205706%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D30308702%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D30710869%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D30310450%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D30709204%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D30610111%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D30708871%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D30603934%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D30910506%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D30905585%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D30906535%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D30811679%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D30809941%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D30809581%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D30809131%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D30808244%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D30803631%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D30908632%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D31003661%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D31309448%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D31308376%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D31309638%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D31009401%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D31007808%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D31006811%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D31006582%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D31005371%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D31306217%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D32108832%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D32207945%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D32105888%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D31506951%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D31803445%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D31706099%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D32205058%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D32309106%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D32308419%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D32307913%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D32307691 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D32403580 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D32403455 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D32406930 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D32410247 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D32310871 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D32205771 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D32309818 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D32405448 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D32404039 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D32404751 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D32405795 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D32809560 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D32706970 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D32708366 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D32806186 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D32808500 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D40609055 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D32906441 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D33008225 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D33009219 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D40303655 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D33106382 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D33103866 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D40310577 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D33110119 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D33005131 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D40310750 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D32904526 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D32906864 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D40405911 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D32905401 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D33105525 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D40704502 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D40906297 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D40803274 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D40705256 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D40704921 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D40703965 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D40703711 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D40703406 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D40702753 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D41110005 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D41003156 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D41005969 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D41009989 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D41008172 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D41106806 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D41106149 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D41304659 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D41306645 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D41307442 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D41405829 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D41406893 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D41404373 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D41406844 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D41502759 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D21705924 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D21606254 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D22304360 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D21910441 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D22305452 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D21804680 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D31709331 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D31705460 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D23106851 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D22708879 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D30907780 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D30907360 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D31003646 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D31008368 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D31608730 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D31710661 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like ' D32102978 %'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D51207781%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D51908063%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D53003425%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D53005932%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D61406444%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D61306875%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D60806911%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D60305619%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D51306226%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D61403500%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D60606133%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D51308725%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D51306659%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D60105229%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D60804776%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D60603080%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D51208360%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D51705172%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D51307062%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D52503508%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D52003718%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D60602993%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D62405029%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D71603234%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D71309792%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D71403799%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D71404756%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D70806888%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D62006038%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D70808870%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D61805299%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D62207105%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D63007188%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D70107675%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D70707647%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D70305436%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D70504863%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D70305892%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D70506909%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D71603353%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D62405682%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D62405684%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D70103933%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D70108381%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D71404440%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D71106786%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D62804872%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D70206579%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D70106244%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D70105115%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D70406139%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D71108383%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D71007403%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D62307784%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D81706438%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D72204829%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D72204847%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D72503362%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D72605632%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D72604358%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D80201152%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D72904532%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D72704973%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D81904008%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D81903458%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D81905193%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D81904046%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D81807362%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D81709662%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D82106769%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D91004723%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D90606316%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D90707942%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D91805298%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D91702613%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D91505849%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D91708015%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D92403024%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D91707993%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D90905331%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D91003927%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D92407168%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D92204565%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D92203760%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D92202583%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D92003427%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D92007495%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D92005961%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D92404751%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D91403560%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D91310752%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D92902812%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D92903990%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D92905022%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D93105044%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E00302950%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E00303839%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D93107877%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D92906938%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D93002610%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D92704689%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E00102608%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E00303925%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D92707339%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E00304494%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E00305708%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D92708501%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E11605254%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E11605848%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E11606756%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E11607200%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E11605002%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E11603744%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E11602603%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E12104566%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E12105391%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E12107088%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E12108380%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E12303486%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E12506723%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E12507833%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E12903935%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E12905331%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E12903429%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E12903629%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E13005286%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D91804785%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D91707310%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D91706803%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D81806013%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D90910055%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D90609999%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D92902800%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E00307937%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E00503285%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E00604437%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E11904408%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E12105850%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E12203070%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E12308432%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E12305009%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E12505887%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E12902829%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E13008049%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E13007008%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E13007292%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E20105321%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E12703670%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E12306141%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E11607900%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'D92402922%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E31305365%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E31609188%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E31608151%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E31607272%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E31603732%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E32007354%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E32004715%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E32003553%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E31903560%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E32403776%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E32308699%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E32309778%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E32303393%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E32304410%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E32302898%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E32407266%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E32306641%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E32703482%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E32506342%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E32705345%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E32704828%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E32502889%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E40106340%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E33007980%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E40603238%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E40709325%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E40709278%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E41109243%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E41304440%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E41906128%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E41807074%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E41809148%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E41604058%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E41606299%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E41805645%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E41803780%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E41804550%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E42108516%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E42110078%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E42107855%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E42104137%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E42210272%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E42210477%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E42109898%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E42504221%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E42405107%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E42309124%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E42306412%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E42306996%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E42307558%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E42604752%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E43003390%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E42805360%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E42802942%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E43006277%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E43004441%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E43003777%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E51003030%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E51203686%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E51106168%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E51103227%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E51309417%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E51503404%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E51505406%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E51305460%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E51703014%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E52105668%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E52106732%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E52209172%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E52510495%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E52509138%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E60209717%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E60104007%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E52908340%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E52907413%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E53005075%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E60304485%'
order by ord.order_proc_id;


insert into Analytics.dbo.CCDA2339_result_table(
proc_id, accession)
select ord.order_proc_id, acc.ACC_NUM "accession"
from order_proc ord
inner join ORDER_RAD_ACC_NUM acc
on ord.order_proc_id = acc.order_proc_id
inner join clarity_eap eap
on eap.proc_id = ord.proc_id
where ord.proc_id = '106158' and acc.ACC_NUM like 'E60309850%'
order by ord.order_proc_id;

