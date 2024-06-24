select * from
V_SMRTDTA_ELEM_VAL_ALL
where ELEMENT_ID = 'EPIC#0028'
and pat_link_id = 'Z1132690'

select * from
SMRTDTA_ELEM_DATA
where ELEMENT_ID = 'EPIC#0028'
and pat_link_id = 'Z1132690'
--Not an issue with the view, source data has them as two separate hlv_id's. why?