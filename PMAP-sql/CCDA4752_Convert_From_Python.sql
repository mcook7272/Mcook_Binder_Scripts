WITH cefepime_medication_ids AS (
SELECT distinct medication_id
FROM [ACCM_Fackler_IRB00361235_Projection]..derived_medorder_components 
where simple_generic_name like '%cefepime%'
), cefepime_med_orders AS (
SELECT med.* 
FROM derived_med_orders med
join cefepime_medication_ids id on med.medication_id = id.medication_id
), blood_cult_orders as (
SELECT * 
FROM derived_lab_results 
where component_name like '%BLOOD CULTURE%'
)

Select * from cefepime_med_orders

select * from derived_med_orders where order_med_id in(
2432645118672762
,1184058909956722
,1174131105656644
,3762453030398505
,961787235617
,3719087773563960
,3365866326130773
,893193237183728
,551087337989093
,2138763086916561
,987424433602315
,2218408317768129
,2433865210155508)
