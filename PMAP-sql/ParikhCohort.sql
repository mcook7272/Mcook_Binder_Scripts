WITH ptlist AS
(
select distinct z.osler_id
from
(
select osler_id, max(hosp_admsn_time) as maxenctime
from derived_inpatient_encounters
where cast(department_id as varchar(20)) like '1101%'  
-- or 1108 or 1130....
or cast(department_id as varchar(20)) like '1200%'
and hosp_admsn_time is not null
group by osler_id
having max(hosp_admsn_time) between '03/01/2020' and CURRENT_TIMESTAMP
union 
select osler_id, max(contact_date) as maxenctime
from derived_outpatient_encounters
where cast(department_id as varchar(20)) like '1101%'
or cast(department_id as varchar(20)) like '1200%'
group by osler_id
having max(contact_date) between '03/01/2020' and CURRENT_TIMESTAMP
) z 
join covid_pmcoe_covid_positive cp on cp.osler_id = z.osler_id
where cp.age_at_positive > 17
)


select * from derived_epic_patient t
inner join ptlist pt on t.osler_id = pt.osler_id;


Select department_id, department_name
From derived_outpatient_encounters
group by department_id, department_name
order by department_id

Select department_id, dept_name
From derived_inpatient_encounters
group by department_id, dept_name
order by department_id



110502801-110595802

113000400 - 113000900

113002330 - 113003330

113003530 - 113003702

113003722 - 113004330

113004460 - 113009300

113009461 - 113009570

113009620 - 113014570

113014660 - 113035801
