USE [PMAP_Analytics]

--Counts
select count(distinct subject_number) "Final_NoHyphens_distinct_count" from CCDA2046_Cox_Final_NoHyphens --430

select count(distinct subject_number) "Final_Hyphens_distinct_count" from CCDA2046_Cox_Final_Hyphens --84

select count(distinct [study id]) "Old_NoHyphens_distinct_count" from CoxAvailSpecimens_NoHyphens_20210127 --648

select count(distinct [study id]) "Old_Hyphens_distinct_count" from CoxAvailSpecimens_Hyphens_20210127 --648

select count(*) "Final_NoHyphens_row_count" from CCDA2046_Cox_Final_NoHyphens --920

select count(*) "Final_Hyphens_row_count" from CCDA2046_Cox_Final_Hyphens --86

select count(*) "Old_NoHyphens_row_count" from CoxAvailSpecimens_NoHyphens_20210127 --1296

select count(*) "Old_Hyphens_row_count" from CoxAvailSpecimens_Hyphens_20210127 --1296

--Final hyphen and final nohyphen completely exclusive of each other. NoHyphen has 920 total rows, Hyphen has 86
select noh.*, h.SUBJECT_NUMBER from CCDA2046_Cox_Final_NoHyphens noh
  left join CCDA2046_Cox_Final_Hyphens h on noh.SUBJECT_NUMBER = h.SUBJECT_NUMBER
  where h.SUBJECT_NUMBER is null
  order by noh.SUBJECT_NUMBER

--Comparing nohyphen old to nohyphen final; 375 rows don't make it into final table. 114 of these were SE-JH (see below)
  select old.*, fin.SUBJECT_NUMBER from CoxAvailSpecimens_NoHyphens_20210127 old
  left join CCDA2046_Cox_Final_NoHyphens fin on old.[Study ID] = fin.SUBJECT_NUMBER
  where fin.SUBJECT_NUMBER is null
  order by old.[Study ID]

  select count(*) from CoxAvailSpecimens_NoHyphens_20210127 old --114
  left join CCDA2046_Cox_Final_NoHyphens fin on old.[Study ID] = fin.SUBJECT_NUMBER
  where fin.SUBJECT_NUMBER is null
  and old.[Study ID] like'%SE-JH%'

 --Comparing hyphen old to hyphen final; 1210 rows don't make it into final table. 949 of these were SE-JH (see below)
  select old.*, fin.SUBJECT_NUMBER from CoxAvailSpecimens_Hyphens_20210127 old
  left join CCDA2046_Cox_Final_Hyphens fin on old.[Study ID] = fin.SUBJECT_NUMBER
  where fin.SUBJECT_NUMBER is null
  order by old.[Study ID]

  select count(*) from CoxAvailSpecimens_Hyphens_20210127 old --949
  left join CCDA2046_Cox_Final_Hyphens fin on old.[Study ID] = fin.SUBJECT_NUMBER
  where fin.SUBJECT_NUMBER is null
  and old.[Study ID] like'%SE-JH%'