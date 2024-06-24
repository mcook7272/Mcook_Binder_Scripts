/****** Script for SelectTopNRows command from SSMS  ******/
select t.*
FROM
(SELECT distinct subject_id
  FROM [COVID_OMOP].[results].[cohort]
  where cohort_definition_ID = 257
  except
  select distinct subject_id
  from PMAP_Analytics.dbo.Atlas_Prime_Chenyu_Cohort) t
  order by t.subject_id

  /*
  SELECT distinct subject_id, ep.osler_id
  FROM [JHM_OMOP_20210826].[Results].[cohort] p
join jhm_omop_20210826.[stage].[SourceIDMapsPerson] s on s.id=p.subject_id
join jhm_omop_raw_20210826.dbo.derived_epic_patient ep on ep.osler_id = s.sourcekey
  where cohort_definition_ID = 10
  order by ep.osler_id
  */

  SELECT distinct subject_id, ep.osler_id
  FROM [COVID_OMOP].[results].[cohort] p
  join [COVID_OMOP].[stage].[SourceIDMapsPerson] s on s.id=p.subject_id
join [COVID_Projection].dbo.derived_epic_patient ep on ep.osler_id = s.sourcekey
where cohort_definition_ID = 257
order by ep.osler_id