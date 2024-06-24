/****** Script for SelectTopNRows command from SSMS  ******/
SELECT distinct [care_site_id]
      ,[care_site_name]
      ,[place_of_service_source_value]
	  ,care_site_source_value
  FROM [JHM_OMOP_20211203].[dbo].[care_site]
  where care_site_source_value in ('110106', '113027', '110101', '113002',
  '113030', '113085', '110401', '113042', '110107',
  '110204', '110500', '113070', '113043', '113095',
  '113028', '110306', '113000', '113041', '113035',
  '110205', '113039', '113034', '113022', '113038',
  '113062', '113063', '113096', '113031', '113023',
  '113025', '113004', '110200', '113024', '113029')
   /*
   care_site_id in ('25','30','31','46','49','50','51','57','58','61',
   '65','66','73','97','103','105','107','112','117','126',
   '127','128','130','131','132','133','134','137','138','141',
   '142','144','145','146','165','166','188','196','197')
   */

   select distinct coh.subject_id, s.sourcekey as osler_id
from results.Cohort coh
join stage.SourceIDMapsPerson s on s.id = coh.subject_id
join visit_occurrence v on coh.subject_id = v.person_id
where  cohort_definition_id = 33
and s.domain = 'person'
and v.care_site_id in ('25','30','31','46','50','51','61',
'66','73','103','105','107','125','126','127','128','130',
'131','132','133','134','137','138','141','142','144',
'145','146','165','166','173','188','196','197')

select count(distinct person_id) --1,521,869
from visit_occurrence
where care_site_id in ('25','30','31','46','50','51','61',
'66','73','103','105','107','125','126','127','128','130',
'131','132','133','134','137','138','141','142','144',
'145','146','165','166','173','188','196','197')

select count(distinct v.visit_occurrence_id) --191,503
from results.Cohort coh
join stage.SourceIDMapsPerson s on s.id = coh.subject_id
join visit_occurrence v on coh.subject_id = v.person_id
where  cohort_definition_id = 33
and s.domain = 'person'
and v.care_site_id in ('25','30','31','46','50','51','61',
'66','73','103','105','107','125','126','127','128','130',
'131','132','133','134','137','138','141','142','144',
'145','146','165','166','173','188','196','197')


select v.care_site_id, [care_site_name], count(distinct person_id) 
from visit_occurrence v
join care_site c on v.care_site_id = c.care_site_id
where v.care_site_id in ('25','30','31','46','50','51','61',
'66','73','103','105','107','125','126','127','128','130',
'131','132','133','134','137','138','141','142','144',
'145','146','165','166','173','188','196','197')
group by v.care_site_id,[care_site_name]
order by count(distinct person_id) desc