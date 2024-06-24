SELECT coh.person_id,
	m.measurement_concept_id,
	con.concept_name,
	coh.visit_start_date,
	coh.visit_end_date,
	m.measurement_datetime,
	DATEDIFF(day, coh.visit_start_date, m.measurement_datetime) "Start_Diff",
	DATEDIFF(day, coh.visit_end_date, m.measurement_datetime) "End_Diff"
INTO results.CURE_ID_Measurements
FROM measurement m
INNER JOIN Results.CURE_ID_Cohort coh
	ON m.visit_occurrence_id = coh.visit_occurrence_id
INNER JOIN concept con
	ON con.concept_id = m.measurement_concept_id
WHERE measurement_concept_id IN (
		'703443', '1616298', '3000285', '3000483', '3000905', '3000963', '3001122', '3001604', '3001657', 
		'3002385', '3002888', '3002937', '3003215', '3003282', '3004077', '3004144', '3004249', '3004295', 
		'3004327', '3004501', '3005225', '3005456', '3005755', '3005949', '3006315', '3006898', '3006923', 
		'3007220', '3007328', '3007461', '3007760', '3007858', '3008037', '3008766', '3008791', '3009347', 
		'3009542', '3009932', '3010335', '3010424', '3010813', '3010834', '3011424', '3012481', '3012888', 
		'3013115', '3013429', '3013650', '3013682', '3013721', '3013752', '3014053', '3014111', '3015182', 
		'3015242', '3016407', '3016436', '3016502', '3016723', '3017501', '3017732', '3018198', '3018405', 
		'3018677', '3018928', '3019198', '3019550', '3019897', '3019909', '3020460', '3020891', '3021337', 
		'3022217', '3022250', '3022893', '3023091', '3023103', '3023314', '3023361', '3023919', '3024128', 
		'3024171', '3024830', '3024929', '3025315', '3026238', '3026617', '3027018', '3027219', '3027388', 
		'3027651', '3027801', '3028271', '3028615', '3028833', '3029829', '3031219', '3031266', '3031579', 
		'3031586', '3032393', '3032971', '3033408', '3033575', '3033641', '3034022', '3034107', '3034426', 
		'3034962', '3036277', '3038425', '3038547', '3038553', '3038668', '3038702', '3039283', '3040598', 
		'3040623', '3040681', '3040743', '3040750', '3040893', '3041232', '3041354', '3041473', '3041944', 
		'3041974', '3042294', '3042436', '3042449', '3042634', '3043409', '3043706', '3045262', '3045524', 
		'3045961', '3046279', '3046900', '3047181', '3049187', '3049516', '3050746', '3051714', '3051825', 
		'3052648', '3052964', '3052968', '3053283', '4353936', '21492791', '36033639', '36303797', 
		'36304114', '36306105', '36306178', '37032427', '37037425', '37041261', '37041593', '37042222', 
		'37043992', '37051715', '37063873', '37070108', '37070654', '40652525', '40652709', '40652870', 
		'40653085', '40653238', '40653596', '40653762', '40653900', '40654045', '40654069', '40654088', 
		'40762499', '40762888', '40762889', '40764999', '40771922', '42869588', '44816672', '46235078', 
		'46235106', '46235784', '46236949'
		)
	AND (
		DATEDIFF(day, coh.visit_start_date, m.measurement_datetime) > - 3
		AND DATEDIFF(day, coh.visit_end_date, m.measurement_datetime) < 2
		)
ORDER BY coh.person_id,
	m.measurement_datetime