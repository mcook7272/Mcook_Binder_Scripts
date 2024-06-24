SELECT p.*
--into results.CURE_ID_Device_Exposure
FROM device_exposure p
INNER JOIN results.CURE_ID_Cohort coh
	ON p.visit_occurrence_id = coh.visit_occurrence_id
WHERE device_concept_id IN (
		'4139525','45762541','4281167','40217672','4044008','45768198')
	--AND DATEDIFF(day, coh.visit_start_date, p.device_exposure_start_datetime) < 3

	--where meas_id IN ('301030', '3040655027')