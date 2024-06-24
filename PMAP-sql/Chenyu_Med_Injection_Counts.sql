drop table if exists #3plus_count;

/*1. select patients with 3 plus anti-VEGF medication within 121 days from first medication */
select person_id, count(person_id) as med_count, drug_concept_id, min(drug_exposure_start_date) as d_startdate
into #3plus_count
from drug_exposure de
join concept c100 on c100.concept_id = de.drug_concept_id
where de.drug_concept_id in (select distinct c2.concept_id
from concept c1 -- the specified SPL drug
join concept_relationship cr on cr.concept_id_1 = c1.concept_id --the RXNorm equivalent
join concept_ancestor ca on cr.concept_id_2 = ca.descendant_concept_id
join concept c2 on c2.concept_id = ca.ancestor_concept_id
where cr.relationship_id = 'SPL - RxNorm'
and c2.vocabulary_id = 'RxNorm'
and c2.standard_concept = 's'
and c2.concept_class_id !=  'ingredient'
and c1.concept_code in ( '220f1049-67db-48a0-b8d3-63080f7cee37',
'9813ea16-272c-4a66-b8aa-5b6d6d0765bf',
'939b5d1f-9fb2-4499-80ef-0607aa6b114e',
'f96cfd69-da34-41ee-90a9-610a4655cd1c',
'de4e66cc-ca05-4dc9-8262-e00e9b41c36d',
'16cc39b1-60b4-47c2-8d88-89d5f0beacac',
'1ec9a553-f2bc-4e05-9586-896c829a187c'))
--and de.person_id = 6589
--order by de.person_id
group by de.person_id,drug_concept_id  
having count(*) >= 3
order by de.person_id

--drop table #med_injection_days
select #3plus_count.person_id as person_id,#3plus_count.drug_concept_id as med_concept_id, #3plus_count.med_count as medication_count, #3plus_count.d_startdate as d_startdate, procedure_concept_id,
       procedure_date as p_date, visit_occurrence_id,datediff(day,#3plus_count.d_startdate,procedure_date) as days_from_first_med
into #med_injection_days
from #3plus_count
left join (select * from [JHM_OMOP_20211108].[dbo].[procedure_occurrence] 
		   where procedure_concept_id = 2111025 ) po /*injection concept*/
on #3plus_count.person_id = po.person_id 
where procedure_date > = d_startdate
order by  #3plus_count.person_id,#3plus_count.drug_concept_id

select * from #med_injection_days

/*procedure count from first medication*/
select person_id, med_concept_id, medication_count, d_startdate, procedure_concept_id,
       count(*) as p_count
into #injection_count
from #med_injection_days 
where p_date> = d_startdate
group by person_id, med_concept_id, medication_count, d_startdate,procedure_concept_id
order by person_id

/**patient medication records from first medication within 121 days **/
select #3plus_count.person_id, med_count, #3plus_count.drug_concept_id, d_startdate,drug_exposure_start_date,DATEDIFF(day,d_startdate,drug_exposure_start_date) as days_from_first_med
into #drug_exposure_within121
from #3plus_count
left join drug_exposure de
on #3plus_count.person_id = de.person_id 
and #3plus_count.drug_concept_id = de.drug_concept_id
where DATEDIFF(day,d_startdate,drug_exposure_start_date) <121 
order by #3plus_count.person_id,days_from_first_med
select * from #drug_exposure_within121

/** patient injection records from first medication within 121 days **/
select * 
into #injection_within121
from #med_injection_days
where days_from_first_med<121
order by person_id , days_from_first_med
select * from #injection_within121
select * from #injection_count

/**results to compare : 
table #drug_exposure_within121 and #injection_within121 

unique person_id in #drug_exposure_within121 and #drug_exposure_within121
person_id in #injection_count table where p_count<medication_count**/

select distinct p.person_id, s.sourcekey as osler_id, 'drug_exposure_within121' "name"
from #drug_exposure_within121  p
join stage.SourceIDMapsPerson s on s.id = p.person_id
union all
select distinct p.person_id, s.sourcekey as osler_id, 'injection_within121' "name"
from #injection_within121  p
join stage.SourceIDMapsPerson s on s.id = p.person_id
union all
select distinct p.person_id, s.sourcekey as osler_id, 'injection_count' "name"
from #injection_count  p
join stage.SourceIDMapsPerson s on s.id = p.person_id
WHERE p.p_count < p.medication_count
union all
select distinct p.SUBJECT_ID, s.sourcekey as osler_id, 'Atlas_Cohort' "name"
from Results.cohort  p
join stage.SourceIDMapsPerson s on s.id = p.SUBJECT_ID
WHERE p.COHORT_DEFINITION_ID = 30

Select * from #injection_within121
