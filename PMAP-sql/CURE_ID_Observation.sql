SELECT o.*
INTO results.CURE_ID_Observations
FROM observation o
INNER JOIN results.CURE_ID_Cohort coh
	ON o.visit_occurrence_id = coh.visit_occurrence_id
WHERE observation_concept_id IN (
		'432507', '435148', '435174', '436228', '438331', '440925', '441139', '441200', '441413', '442289', 
		'442329', '442338', '442605', '443280', '443281', '443695', '443882', '762498', '762499', '762986', 
		'762990', '762991', '763382', '763383', '763384', '763386', '763387', '763388', '764068', '764069', 
		'764103', '764104', '1314519', '1314522', '1314525', '1314528', '1314532', '3046853', '3185356', 
		'4019847', '4023152', '4024541', '4027679', '4028784', '4028785', '4028786', '4030405', '4034158', 
		'4041511', '4042037', '4044775', '4044776', '4044777', '4044778', '4048142', '4049737', '4052029', 
		'4052030', '4052866', '4052947', '4053707', '4058136', '4058138', '4059646', '4059789', '4060687', 
		'4061268', '4062254', '4063309', '4065742', '4071603', '4073388', '4077917', '4079843', '4079844', 
		'4097521', '4101391', '4102452', '4102691', '4118030', '4122053', '4129846', '4132309', '4135942', 
		'4141787', '4144273', '4145919', '4162707', '4164280', '4167237', '4170711', '4170971', '4171902', 
		'4171903', '4173168', '4177807', '4178604', '4178885', '4178886', '4179191', '4183699', '4187334', 
		'4190316', '4191032', '4192271', '4193123', '4195245', '4195755', '4198985', '4204653', '4206035', 
		'4209006', '4209585', '4210315', '4218686', '4218917', '4220022', '4221284', '4231144', '4233376', 
		'4238527', '4239459', '4239540', '4244279', '4244718', '4246415', '4252573', '4252891', '4253661', 
		'4253799', '4253807', '4259007', '4276526', '4276823', '4277188', '4277909', '4280210', '4282320', 
		'4289171', '4296873', '4297089', '4298794', '4301926', '4302017', '4302158', '4305323', '4306655', 
		'4307303', '4321590', '4337939', '4344630', '36715062', '36717396', '37395454', '37395455', 
		'37395605', '40480476', '40485992', '40492790', '40492796', '42538188', '44784548', '44784549', 
		'46235215'
		)
	AND DATEDIFF(day, coh.visit_start_date, o.observation_datetime) < 3