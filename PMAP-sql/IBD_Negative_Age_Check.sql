select distinct q.*

from

(

                select p.person_id, year_of_birth, observation_period_start_date, datepart(year,observation_period_start_date) - year_of_birth  AS age

                from JHM_OMOP_NoID..observation_period op

                INNER JOIN JHM_OMOP_NoID..person p

                ON op.person_id = p.person_id

) q

where q.age < 0
