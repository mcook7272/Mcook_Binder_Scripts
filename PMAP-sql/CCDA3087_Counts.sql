select  ord_value,result_flag, count(distinct osler_id) --Pos crisp labs + other covid labs
from derived_lab_results
where component_base_name in('COVID19ANTI','COVID19BAL','COVID19ET','COVID19EX','COVID19INT','COVID19LORES','COVID19N','COVID19NP','COVID19OP','COVID19SLV','COVID19SPT','COVID19THR','COVIDANTIGEN','EXTCOVID') 
--and result_flag like 'abnormal'
group by ord_value,result_flag
order by count(distinct osler_id) desc

select  count(distinct osler_id) 
from derived_lab_results
where component_base_name in('COVID19ANTI','COVID19BAL','COVID19ET','COVID19EX','COVID19INT','COVID19LORES','COVID19N','COVID19NP','COVID19OP','COVID19SLV','COVID19SPT','COVID19THR','COVIDANTIGEN','EXTCOVID') 
--and ord_value in ('No RNA Detected','Not Detected','RNA NOT Detected','Negative','Antigen Negative','Neg / Not Detected','No RNA Detected @BCH1No RNA Detect','RNA NOT Detected','Not DetectedA','RNA NOT Detected','No RNA Detected @NPAN','Not Detected','No RNA DNo RNA Detected','Not DetectedN','No RNA Detected @','No RNA DetectedNo RNA Detected','No RNA Detected BCH1','No RNA Detected @BNo RNA Detected','NEGATIVENo RNA Detected','Not DetectedA.','Not Detected','NegativNo RNA Detected')

361,087
531,728
179,855
331,100

select count(distinct osler_id)
from covid_pmcoe_covid_positive

select  count(*) 
from (
select distinct osler_id
from derived_lab_results
where component_base_name in('COVID19ANTI','COVID19BAL','COVID19ET','COVID19EX','COVID19INT','COVID19LORES','COVID19N','COVID19NP','COVID19OP','COVID19SLV','COVID19SPT','COVID19THR','COVIDANTIGEN','EXTCOVID') 
and ord_value in ('No RNA Detected','Not Detected','RNA NOT Detected','Negative','Antigen Negative','Neg / Not Detected','No RNA Detected @BCH1No RNA Detect','RNA NOT Detected','Not DetectedA','RNA NOT Detected','No RNA Detected @NPAN','Not Detected','No RNA DNo RNA Detected','Not DetectedN','No RNA Detected @','No RNA DetectedNo RNA Detected','No RNA Detected BCH1','No RNA Detected @BNo RNA Detected','NEGATIVENo RNA Detected','Not DetectedA.','Not Detected','NegativNo RNA Detected')
except
select distinct osler_id
from covid_pmcoe_covid_positive
) t

select  count(distinct osler_id) 
from derived_lab_results
where component_base_name in('COVID19BAL','COVID19ET','COVID19EX','COVID19INT','COVID19LORES',
'COVID19N','COVID19NOR','COVID19NP','COVID19OP','COVID19SE','COVID19SLV','COVID19SPT',
'COVID19THR','COVIDNATNP','EXTCOVID','OARSLSARCOV2','SARSCOV2','SARSCOV2RNA') 
and order_time between '2020-03-01' and '2020-12-31'

250,000
