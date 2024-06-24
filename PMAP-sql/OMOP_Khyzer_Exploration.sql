--Visits
select v.visit_concept_id, count(*)
from JHM_OMOP_20210826.Results.cohort p
inner join JHM_OMOP_20210826.dbo.visit_occurrence v on p.SUBJECT_ID = v.person_id
where p.COHORT_DEFINITION_ID = 20
group by v.visit_concept_id

--Labs
select count(*)
from JHM_OMOP_20210826.Results.cohort p
inner join JHM_OMOP_20210826.dbo.measurement m on p.SUBJECT_ID = m.person_id
where p.COHORT_DEFINITION_ID = 20
order by count(*) desc

--Meds
select count(*)
from JHM_OMOP_20210826.Results.cohort p
inner join JHM_OMOP_20210826.dbo.drug_exposure d on p.SUBJECT_ID = d.person_id
where p.COHORT_DEFINITION_ID = 20
--group by m.measurement_concept_id

--Number of images by proc code
select count(*)
from JHM_OMOP_20210826.Results.cohort p
inner join JHM_OMOP_20210826.dbo.procedure_occurrence m on p.SUBJECT_ID = m.person_id
where p.COHORT_DEFINITION_ID = 20
and substring(m.procedure_source_value, 7, 1) = '7'
order by count(*) desc;

--Num imaging studies
select count(*)
from JHM_OMOP_20210826.Results.cohort p
inner join JHM_OMOP_20210826.dbo.procedure_occurrence m on p.SUBJECT_ID = m.person_id
where p.COHORT_DEFINITION_ID = 20
and substring(m.procedure_source_value, 7, 1) = '7'
order by count(*) desc

--CT scans
select count(*)
from JHM_OMOP_20210826.Results.cohort p
inner join JHM_OMOP_20210826.dbo.procedure_occurrence m on p.SUBJECT_ID = m.person_id
inner join concept c on m.procedure_source_concept_id = c.concept_id
where p.COHORT_DEFINITION_ID = 20
and substring(c.concept_name, 1, 19) = 'Computed tomography'

--Magnetic resonator
select count(*)
from JHM_OMOP_20210826.Results.cohort p
inner join JHM_OMOP_20210826.dbo.procedure_occurrence m on p.SUBJECT_ID = m.person_id
inner join concept c on m.procedure_source_concept_id = c.concept_id
where p.COHORT_DEFINITION_ID = 20
and substring(c.concept_name, 1, 19) = 'Magnetic resonance'
and substring(m.procedure_source_value, 7, 1) = '7'

--Ultrasound
select count(*)
from JHM_OMOP_20210826.Results.cohort p
inner join JHM_OMOP_20210826.dbo.procedure_occurrence m on p.SUBJECT_ID = m.person_id
inner join concept c on m.procedure_source_concept_id = c.concept_id
where p.COHORT_DEFINITION_ID = 20
and substring(c.concept_name, 1, 10) = 'Ultrasound'
and substring(m.procedure_source_value, 7, 1) = '7'

--X-Ray
select count(*)
from JHM_OMOP_20210826.Results.cohort p
inner join JHM_OMOP_20210826.dbo.procedure_occurrence m on p.SUBJECT_ID = m.person_id
inner join concept c on m.procedure_source_concept_id = c.concept_id
where p.COHORT_DEFINITION_ID = 20
and substring(m.procedure_source_value, 7, 1) = '7'
and substring(c.concept_name, 1, 10) = 'Radiologic'