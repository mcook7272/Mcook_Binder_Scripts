select p.person_id, s.sourcekey as osler_id
--into Results.N3C_CASE_COHORT_Osler
from person p
join stage.SourceIDMapsPerson s on s.id = p.person_id
where s.sourcekey in ('9ad5ada6-3f50-407a-b0fd-6bcb5ef5be23',
'e24e8387-58d9-42e4-91b9-9dfdfee3228b','6458848d-6192-4834-b376-48bbd48a209e','10a3d844-1118-4910-bb1b-38331a0deecb','099def00-de83-4571-9ebf-f2f0b4939124')