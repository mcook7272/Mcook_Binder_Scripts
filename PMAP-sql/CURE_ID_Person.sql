Select p.*
into Results.CURE_ID_Person
from Results.CURE_ID_Cohort coh
inner join person p on coh.person_id = p.person_id