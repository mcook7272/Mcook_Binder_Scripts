USE [JHM_OMOP_20211021]
GO

/****** Object:  StoredProcedure [stage].[OMOP_INS_SrcToConcept_JHMImmCVX]    Script Date: 11/2/2021 3:13:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [stage].[OMOP_INS_SrcToConcept_JHMImmCVX]  
AS
/* =================================================================================== 
 <Author> tbd </Author>
      <Created Date> unknown </Created Date>
      <Description>
      </Description>
      <Notes> 
	  </Notes>
      <Hardcoded>
epic:source_concept_id:01:DTP maps_to OMOP:target_concept_id:40213291:diphtheria, tetanus toxoids and pertussis vaccine
epic:source_concept_id:02:OPV maps_to OMOP:target_concept_id:40213190:trivalent poliovirus vaccine, live, oral
epic:source_concept_id:03:MMR (MMR II) maps_to OMOP:target_concept_id:40213183:measles, mumps and rubella virus vaccine
epic:source_concept_id:05:MEASLES maps_to OMOP:target_concept_id:40213170:measles virus vaccine
epic:source_concept_id:06:RUBELLA maps_to OMOP:target_concept_id:40213223:rubella virus vaccine
epic:source_concept_id:07:MUMPS maps_to OMOP:target_concept_id:40213185:mumps virus vaccine
epic:source_concept_id:08:HEPATITIS B PEDIATRIC maps_to OMOP:target_concept_id:40213304:hepatitis B vaccine, pediatric or pediatric/adolescent dosage
epic:source_concept_id:10:IPV (IPOL) maps_to OMOP:target_concept_id:40213160:poliovirus vaccine, inactivated
epic:source_concept_id:16:INFLUENZA (WHOLE) maps_to OMOP:target_concept_id:40213159:influenza virus vaccine, whole virus
epic:source_concept_id:17:HIB maps_to OMOP:target_concept_id:40213316:Haemophilus influenzae type b vaccine, conjugate unspecified formulation
epic:source_concept_id:18:RABIES-INTRAMUSCULAR maps_to OMOP:target_concept_id:40213208:rabies vaccine, for intramuscular injection RETIRED CODE
epic:source_concept_id:19:BCG maps_to OMOP:target_concept_id:40213271:Bacillus Calmette-Guerin vaccine
epic:source_concept_id:20:DTAP maps_to OMOP:target_concept_id:40213281:diphtheria, tetanus toxoids and acellular pertussis vaccine
epic:source_concept_id:21:VARICELLA (VARIVAX) maps_to OMOP:target_concept_id:40213251:varicella virus vaccine
epic:source_concept_id:22:DTP / HIB maps_to OMOP:target_concept_id:40213292:DTP-Haemophilus influenzae type b conjugate vaccine
epic:source_concept_id:23:PLAGUE maps_to OMOP:target_concept_id:40213197:plague vaccine
epic:source_concept_id:24:ANTHRAX maps_to OMOP:target_concept_id:40213268:anthrax vaccine
epic:source_concept_id:25:TYPHOID LIVE maps_to OMOP:target_concept_id:40213242:typhoid vaccine, live, oral
epic:source_concept_id:26:CHOLERA maps_to OMOP:target_concept_id:40213275:cholera vaccine, unspecified formulation
epic:source_concept_id:28:DT maps_to OMOP:target_concept_id:40213280:diphtheria and tetanus toxoids, adsorbed for pediatric use
epic:source_concept_id:31:HEP A (PEDIATRIC, UNSPECIFIED FORMULATION) maps_to OMOP:target_concept_id:40213301:hepatitis A vaccine, pediatric dosage, unspecified formulation
epic:source_concept_id:33:PNEUMOCOCCAL POLYSACCHARIDE (PNEUMOVAX 23) maps_to OMOP:target_concept_id:40213201:pneumococcal polysaccharide vaccine, 23 valent
epic:source_concept_id:37:YELLOW FEVER maps_to OMOP:target_concept_id:40213257:yellow fever vaccine
epic:source_concept_id:37:YELLOW FEVER (STAMARIL) maps_to OMOP:target_concept_id:40213257:yellow fever vaccine
epic:source_concept_id:41:TYPHOID (INACTIVATED) maps_to OMOP:target_concept_id:40213243:typhoid vaccine, parenteral, other than acetone-killed, dried
epic:source_concept_id:43:HEP B (ADULT) maps_to OMOP:target_concept_id:40213306:hepatitis B vaccine, adult dosage
epic:source_concept_id:43:HEP B (ADULT) maps_to OMOP:target_concept_id:40213306:hepatitis B vaccine, adult dosage
epic:source_concept_id:44:HEP B (DIALYSIS DOSE) maps_to OMOP:target_concept_id:40213307:hepatitis B vaccine, dialysis patient dosage
epic:source_concept_id:45:HEP B (UNSPECIFIED FORMULATION) maps_to OMOP:target_concept_id:40213308:hepatitis B vaccine, unspecified formulation
epic:source_concept_id:46:HIB (PRP-D) maps_to OMOP:target_concept_id:40213313:Haemophilus influenzae type b vaccine, PRP-D conjugate
epic:source_concept_id:47:HIB (HBOC) maps_to OMOP:target_concept_id:40213312:Haemophilus influenzae type b vaccine, HbOC conjugate
epic:source_concept_id:48:HIB (PRP-T) maps_to OMOP:target_concept_id:40213315:Haemophilus influenzae type b vaccine, PRP-T conjugate
epic:source_concept_id:49:HIB, PRP-OMP (PEDVAX HIB) maps_to OMOP:target_concept_id:40213314:Haemophilus influenzae type b vaccine, PRP-OMP conjugate
epic:source_concept_id:50:DTAP / HIB maps_to OMOP:target_concept_id:40213287:DTaP-Haemophilus influenzae type b conjugate vaccine
epic:source_concept_id:51:HEP B / HIB maps_to OMOP:target_concept_id:40213317:Haemophilus influenzae type b conjugate and Hepatitis B vaccine
epic:source_concept_id:52:HEP A ADULT maps_to OMOP:target_concept_id:40213296:hepatitis A vaccine, adult dosage
epic:source_concept_id:62:HPV (QUADRIVALENT) maps_to OMOP:target_concept_id:40213320:human papilloma virus vaccine, quadrivalent
epic:source_concept_id:66:LYME DISEASE maps_to OMOP:target_concept_id:40213167:Lyme disease vaccine
epic:source_concept_id:66:LYME VACCINE maps_to OMOP:target_concept_id:40213167:Lyme disease vaccine
epic:source_concept_id:75:SMALLPOX maps_to OMOP:target_concept_id:40213248:vaccinia (smallpox) vaccine
epic:source_concept_id:82:ADENOVIRUS maps_to OMOP:target_concept_id:40213267:Lyme disease vaccine
epic:source_concept_id:84:HEPATITIS A PEDS/ADOLESCENT maps_to OMOP:target_concept_id:40213300:hepatitis A vaccine, pediatric/adolescent dosage, 3 dose schedule
epic:source_concept_id:85:HEP A (UNSPECIFIED FORMULATION) maps_to OMOP:target_concept_id:40213302:hepatitis A vaccine, unspecified formulation
epic:source_concept_id:88:INFLUENZA H1N1 maps_to OMOP:target_concept_id:40213158:influenza virus vaccine, unspecified formulation
epic:source_concept_id:89:POLIO (UNSPECIFIED FORMULATION) maps_to OMOP:target_concept_id:40213203:poliovirus vaccine, unspecified formulation
epic:source_concept_id:90:RABIES maps_to OMOP:target_concept_id:40213209:rabies vaccine, unspecified formulation
epic:source_concept_id:94:MMR / VARICELLA (PROQUAD) maps_to OMOP:target_concept_id:40213184:measles, mumps, rubella, and varicella virus vaccine
epic:source_concept_id:100:PNEUMOCOCCAL CONJUGATE 7-VALENT maps_to OMOP:target_concept_id:40213199:pneumococcal conjugate vaccine, 7 valent
epic:source_concept_id:101:TYPHOID (VICPS) maps_to OMOP:target_concept_id:40213246:typhoid Vi capsular polysaccharide vaccine
epic:source_concept_id:103:MENINGOCOCCAL C CONJUGATE VACCINE maps_to OMOP:target_concept_id:40213176:meningococcal C conjugate vaccine
epic:source_concept_id:106:DTAP, 5 PERTUSSIS ANTIGENS maps_to OMOP:target_concept_id:40213282:diphtheria, tetanus toxoids and acellular pertussis vaccine, 5 pertussis antigens
epic:source_concept_id:107:DTAP, UNSPECIFIED FORMULATION maps_to OMOP:target_concept_id:40213283:diphtheria, tetanus toxoids and acellular pertussis vaccine, unspecified formulation
epic:source_concept_id:108:MENINGOCOCCAL (UNSPECIFIED FORMULATION) maps_to OMOP:target_concept_id:40213172:meningococcal ACWY vaccine, unspecified formulation
epic:source_concept_id:110:DTAP / HEP B / IPV (PEDIARIX) maps_to OMOP:target_concept_id:40213286:DTaP-hepatitis B and poliovirus vaccine
epic:source_concept_id:111:INFLUENZA H1N1 (NASAL) maps_to OMOP:target_concept_id:40213149:influenza virus vaccine, live, attenuated, for intranasal use
epic:source_concept_id:114:MENINGOCOCCAL-MCV4P(MENACTRA) maps_to OMOP:target_concept_id:40213180:meningococcal polysaccharide (groups A, C, Y and W-135) diphtheria toxoid conjugate vaccine (MCV4P)
epic:source_concept_id:115:TDAP maps_to OMOP:target_concept_id:40213230:tetanus toxoid, reduced diphtheria toxoid, and acellular pertussis vaccine, adsorbed
epic:source_concept_id:116:ROTAVIRUS, PENTAVALENT (ROTATEQ) maps_to OMOP:target_concept_id:40213217:rotavirus, live, pentavalent vaccine
epic:source_concept_id:118:HPV BIVALENT maps_to OMOP:target_concept_id:40213319:human papilloma virus vaccine, bivalent
epic:source_concept_id:119:ROTAVIRUS MONOVALENT (ROTARIX) maps_to OMOP:target_concept_id:40213216:rotavirus, live, monovalent vaccine
epic:source_concept_id:120:DTAP / HIB / IPV (PENTACEL) maps_to OMOP:target_concept_id:40213288:diphtheria, tetanus toxoids and acellular pertussis vaccine, Haemophilus influenzae type b conjugate, and poliovirus vaccine, inactivated (DTaP-Hib-IPV)
epic:source_concept_id:121:ZOSTAVAX (ZOSTER) maps_to OMOP:target_concept_id:40213260:zoster vaccine, live
epic:source_concept_id:122:ROTAVIRUS (UNSPECIFIED FORMULATION) maps_to OMOP:target_concept_id:40213219:rotavirus vaccine, unspecified formulation
epic:source_concept_id:129:JAPANESE ENCEPHALITIS maps_to OMOP:target_concept_id:40213163:Japanese Encephalitis vaccine, unspecified formulation
epic:source_concept_id:130:DTAP / IPV (KINRIX) maps_to OMOP:target_concept_id:40213289:Diphtheria, tetanus toxoids and acellular pertussis vaccine, and poliovirus vaccine, inactivated
epic:source_concept_id:133:PNEUMOCOCCAL CONJUGATE 13-VALENT (PREVNAR 13) maps_to OMOP:target_concept_id:40213198:pneumococcal conjugate vaccine, 13 valent
epic:source_concept_id:135:INFLUENZA, HIGH DOSE, SEASONAL maps_to OMOP:target_concept_id:40213141:influenza, high dose seasonal, preservative-free
epic:source_concept_id:135:INFLUENZA, HIGH DOSE SEASONAL maps_to OMOP:target_concept_id:40213141:influenza, high dose seasonal, preservative-free
epic:source_concept_id:136:MENINGOCOCCAL-MCV4O(MENVEO) maps_to OMOP:target_concept_id:40213179:meningococcal oligosaccharide (groups A, C, Y and W-135) diphtheria toxoid conjugate vaccine (MCV4O)
epic:source_concept_id:136:MENINGOCOCCAL-MCV40 (MENVEO) maps_to OMOP:target_concept_id:40213179:meningococcal oligosaccharide (groups A, C, Y and W-135) diphtheria toxoid conjugate vaccine (MCV4O)
epic:source_concept_id:137:HPV (UNSPECIFIED FORMULATION) maps_to OMOP:target_concept_id:40213321:HPV, unspecified formulation
epic:source_concept_id:138:TD ADULT maps_to OMOP:target_concept_id:40213226:tetanus and diphtheria toxoids, not adsorbed, for adult use
epic:source_concept_id:139:TET/DIP maps_to OMOP:target_concept_id:40213229:Td(adult) unspecified formulation
epic:source_concept_id:139:TD (UNSPECIFIED FORMULATION) maps_to OMOP:target_concept_id:40213229:Td(adult) unspecified formulation
epic:source_concept_id:140:INFLUENZA, SEASONAL, INJ, PRESERV FREE maps_to OMOP:target_concept_id:40213154:Influenza, seasonal, injectable, preservative free
epic:source_concept_id:140:INFLUENZA, SEASONAL, INJECTABLE, PRESERVATIVE FREE maps_to OMOP:target_concept_id:40213154:Influenza, seasonal, injectable, preservative free
epic:source_concept_id:141:INFLUENZA, SEASONAL (INJECTABLE) maps_to OMOP:target_concept_id:40213153:Influenza, seasonal, injectable
epic:source_concept_id:141:INFLUENZA H1N1 (UNSPECIFIED FORMULATION) maps_to OMOP:target_concept_id:40213153:Influenza, seasonal, injectable
epic:source_concept_id:141:INFLUENZA, SEASONAL (UNSPECIFIED FORMULATION) maps_to OMOP:target_concept_id:40213153:Influenza, seasonal, injectable
epic:source_concept_id:141:INFLUENZA, SEASONAL (INJECTABLE) maps_to OMOP:target_concept_id:40213153:Influenza, seasonal, injectable
epic:source_concept_id:149:INFLUENZA, QUADRIVALENT (NASAL) maps_to OMOP:target_concept_id:40213150:influenza, live, intranasal, quadrivalent
epic:source_concept_id:149:FLUMIST INFLUENZA, LIVE, INTRANASAL, QUADRIVALENT maps_to OMOP:target_concept_id:40213150:influenza, live, intranasal, quadrivalent
epic:source_concept_id:150:INFLUENZA, INJ, QUADRIVALENT, PRESERVATIVE FREE maps_to OMOP:target_concept_id:40213146:Influenza, injectable, quadrivalent, preservative free
epic:source_concept_id:150:FLUBLOK INFLUENZA, QUADRIVALENT,INJECTABLE, PRESERVATIVE FREE maps_to OMOP:target_concept_id:40213146:Influenza, injectable, quadrivalent, preservative free
epic:source_concept_id:150:INFLUENZA, HIGH DOSE QUADRIVALENT, PRESERVATIVE FREE maps_to OMOP:target_concept_id:40213146:Influenza, injectable, quadrivalent, preservative free
epic:source_concept_id:150:INFLUENZA, INJECTABLE, QUADRIVALENT, PRESERVATIVE FREE maps_to OMOP:target_concept_id:40213146:Influenza, injectable, quadrivalent, preservative free
epic:source_concept_id:151:INFLUENZA, SEASONAL (NASAL) maps_to OMOP:target_concept_id:40213327:influenza nasal, unspecified formulation
epic:source_concept_id:152:PNEUMOCOCCAL (UNSPECIFIED FORMULATION) maps_to OMOP:target_concept_id:40213200:Pneumococcal Conjugate, unspecified formulation
epic:source_concept_id:153:INFLUENZA, INJ, MDCK, PRESERVATIVE FREE maps_to OMOP:target_concept_id:40213142:Influenza, injectable, Madin Darby Canine Kidney, preservative free
epic:source_concept_id:155:INFLUENZA, RECOMBINANT, INJ, PRESERV FREE maps_to OMOP:target_concept_id:40213151:Seasonal, trivalent, recombinant, injectable influenza vaccine, preservative free
epic:source_concept_id:158:INFLUENZA, INJECTABLE, QUADRIVALENT, CONTAINS PRESERVATIVE maps_to OMOP:target_concept_id:40213145:influenza, injectable, quadrivalent, contains preservative
epic:source_concept_id:158:INFLUENZA, INJ, QUADRIVALENT, WITH PRESERVATIVE maps_to OMOP:target_concept_id:40213145:influenza, injectable, quadrivalent, contains preservative
epic:source_concept_id:158:INFLUENZA, INJ, QUADRIVALENT, WITH PRESERVATIVE maps_to OMOP:target_concept_id:40213145:influenza, injectable, quadrivalent, contains preservative
epic:source_concept_id:158:INFLUENZA H1N1 (INJECTABLE) maps_to OMOP:target_concept_id:40213145:influenza, injectable, quadrivalent, contains preservative
epic:source_concept_id:161:INFLUENZA, INJ, QUADRIVALENT, PRESERVATIVE FREE, PEDIATRIC maps_to OMOP:target_concept_id:40213147:Influenza, injectable,quadrivalent, preservative free, pediatric
epic:source_concept_id:162:MENINGOCOCCAL B, RECOMBINANT (TRUMENBA) maps_to OMOP:target_concept_id:40213174:meningococcal B vaccine, fully recombinant
epic:source_concept_id:163:MENINGOCOCCAL B, OMV (BEXSERO) maps_to OMOP:target_concept_id:40213173:meningococcal B vaccine, recombinant, OMV, adjuvanted
epic:source_concept_id:164:MENINGOCOCCAL B, UNSPECIFIED maps_to OMOP:target_concept_id:40213175:meningococcal B, unspecified formulation
epic:source_concept_id:165:HPV9 (GARDASIL 9) maps_to OMOP:target_concept_id:40213322:Human Papillomavirus 9-valent vaccine
epic:source_concept_id:166:INFLUENZA, INTRADERMAL, QUADRIVALENT, PRESERVATIVE FREE maps_to OMOP:target_concept_id:40213148:influenza, intradermal, quadrivalent, preservative free, injectable
epic:source_concept_id:166:INFLUENZA, INTRADERMAL, QUADRIVALENT, PRESERVATIVE FREE maps_to OMOP:target_concept_id:40213148:influenza, intradermal, quadrivalent, preservative free, injectable
epic:source_concept_id:166:INFLUENZA, SEASONAL, INTRADERMAL, PRESERV FREE maps_to OMOP:target_concept_id:40213148:influenza, intradermal, quadrivalent, preservative free, injectable
epic:source_concept_id:168:INFLUENZA INF, TRIVALENT, PRESERVATIVE FREE maps_to OMOP:target_concept_id:40213157:Seasonal trivalent influenza vaccine, adjuvanted, preservative free
epic:source_concept_id:168:SEASONAL TRIVALENT INFLUENZA VACCINE, ADJUVANTED, PRESERVATIVE FREE maps_to OMOP:target_concept_id:40213157:Seasonal trivalent influenza vaccine, adjuvanted, preservative free
epic:source_concept_id:171:INFLUENZA, INJECTABLE, MDCK, PRESERVATIVE FREE, QUADRIVALENT maps_to OMOP:target_concept_id:40213143:Influenza, injectable, Madin Darby Canine Kidney, preservative free, quadrivalent
epic:source_concept_id:171:INFLUENZA INJ, QUADRIVALENT, PRESERVATIVE FREE AND ANTIBIOTIC FREE, DERIVED FROM CELL CULTURES maps_to OMOP:target_concept_id:40213143:Influenza, injectable, Madin Darby Canine Kidney, preservative free, quadrivalent
epic:source_concept_id:184:YELLOW FEVER, UNSPECIFIED maps_to OMOP:target_concept_id:40213259:Yellow fever vaccine, unspecified formulation
epic:source_concept_id:186:INFLUENZA INJ, QUADRIVALENT, WITH PRESERVATIVE, ANTIBIOTIC FREE, DERIVED FROM CELL CULTURES maps_to OMOP:target_concept_id:40213144:Influenza, injectable, Madin Darby Canine Kidney, quadrivalent with preservative
epic:source_concept_id:186:INFLUENZA, INJECTABLE, MDCK, QUADRIVALENT, PRESERVATIVE maps_to OMOP:target_concept_id:40213144:Influenza, injectable, Madin Darby Canine Kidney, quadrivalent with preservative
epic:source_concept_id:187:ZOSTER (SHINGRIX) maps_to OMOP:target_concept_id:706103:zoster vaccine recombinant
epic:source_concept_id:188:ZOSTER VACCINE, UNSPECIFIED maps_to OMOP:target_concept_id:706104:zoster vaccine, unspecified formulation
epic:source_concept_id:189:HEPB-CPG (HEPLISAV) maps_to OMOP:target_concept_id:706105:Hepatitis B vaccine (recombinant), CpG adjuvanted
epic:source_concept_id:193:HEP A / HEP B (TWINRIX) maps_to OMOP:target_concept_id:706109:hepatitis A and hepatitis B vaccine, pediatric/adolescent (non-US)
epic:source_concept_id:195:DT, IPV ADSORBED VACCINE maps_to OMOP:target_concept_id:724894:Diphtheria, Tetanus, Poliomyelitis adsorbed
epic:source_concept_id:196:TD, ADSORBED, PRESERVATIVE FREE, ADULT USE maps_to OMOP:target_concept_id:724895:tetanus and diphtheria toxoids, adsorbed, preservative free, for adult use, Lf unspecified
epic:source_concept_id:196:TETANUS TOXOID maps_to OMOP:target_concept_id:724895:tetanus and diphtheria toxoids, adsorbed, preservative free, for adult use, Lf unspecified
epic:source_concept_id:196:TD (ADULT, PRESERVATIVE-FREE) maps_to OMOP:target_concept_id:724895:tetanus and diphtheria toxoids, adsorbed, preservative free, for adult use, Lf unspecified
epic:source_concept_id:196:TETANUS TOXOID (ADSORBED) maps_to OMOP:target_concept_id:724895:tetanus and diphtheria toxoids, adsorbed, preservative free, for adult use, Lf unspecified
epic:source_concept_id:203:MENINGOCOCCAL POLYSACCHARIDE (MENOMUNE) maps_to OMOP:target_concept_id:724901:meningococcal polysaccharide (groups A, C, Y, W-135) tetanus toxoid conjugate vaccine .5mL dose, preservative free
epic:source_concept_id:207:(MODERNA), SARS-COV-2 (COVID-19) VACCINE, MRNA, PRESERVATIVE FREE, 100 MCG/0.5 ML DOSAGE maps_to OMOP:target_concept_id:724906:SARS-COV-2 (COVID-19) vaccine, mRNA, spike protein, LNP, preservative free, 100 mcg or 50 mcg dose
epic:source_concept_id:208:(PFIZER), SARS-COV-2 (COVID-19) VACCINE, MRNA, PRESERVATIVE FREE, 30MCG/0.3ML DOSE maps_to OMOP:target_concept_id:724907:SARS-COV-2 (COVID-19) vaccine, mRNA, spike protein, LNP, preservative free, 30 mcg/0.3mL dose
epic:source_concept_id:212:JANSSEN J&J SARS-COV-2 (COVID-19) VACCINE maps_to OMOP:target_concept_id:702866:SARS-COV-2 (COVID-19) vaccine, vector non-replicating, recombinant spike protein-Ad26, preservative free, 0.5 mL
      </Hardcoded>
 =================================================================================== */

/* ### Set a variable with the string for the local vocabulary identifier to be used in 
 [vocabulary].[vocabulary_id] and [source_to_concept_map].[source_vocabulary_id]. */
DECLARE @local_vocabulary_id VARCHAR(20) = 'JHMImmCVX'

/* ### If this vocabulary's entry has disappeared from the OMOP CDM vocabulary table, re-insert it before
 doing any work with source_to_concept_map, which has a foreign key constraint from
 [source_to_concept_map].[source_vocabulary_id] to [vocabulary].[vocabulary_id] */
IF NOT EXISTS (	SELECT 1
				FROM [dbo].[vocabulary] AS knownVocabs              
				WHERE knownVocabs.[vocabulary_id] = @local_vocabulary_id)
BEGIN
	INSERT INTO [dbo].[vocabulary]
			   ([vocabulary_id]
			   ,[vocabulary_name]
			   ,[vocabulary_reference]
			   ,[vocabulary_version]
			   ,[vocabulary_concept_id])
		 VALUES
			   (@local_vocabulary_id
			   ,'JHM IMMUNZATN_ID to CVX'
			   ,'JHM Internal'
			   ,'kburke23 2021-07-02'
			   ,0)
END

DECLARE @RC INT = 0
		,@destinationTable VARCHAR(50)='source_to_concept_map';

DECLARE @elapsed_seconds INT = 0
		,@comment VARCHAR(255)
		,@start_datetime Datetime
		,@end_datetime Datetime;

SET @start_datetime = getdate()

/* ### Step 1: Flush the existing entries for this vocabulary from the source_to_concept_map table */
DELETE
FROM [dbo].[source_to_concept_map]
WHERE [source_vocabulary_id] = @local_vocabulary_id

SET @RC  = @@ROWCOUNT 

 IF ( @@ROWCOUNT>0 )
BEGIN 
 SET @end_datetime = getdate() 
 SET @elapsed_seconds = DATEDIFF(second,@start_datetime,@end_datetime) 
 INSERT INTO stage.OMOP_ETL_runlog (table_name, start_datetime, end_datetime, elapsed_seconds, count_of_rows,[block_number], [procedure_name], comment)
 VALUES (  @destinationTable, @start_datetime, @end_datetime, @elapsed_seconds,@RC, 0, OBJECT_NAME(@@PROCID), CONCAT('DELETE ',@local_vocabulary_id,' rows' ));
END

/* ### Step 2: Insert all of the entries for this vocabulary to the table used by the standard CTE  */
SET @start_datetime = getdate()

INSERT INTO [dbo].[source_to_concept_map]
           ([source_code]
           ,[source_concept_id]
           ,[source_vocabulary_id]
           ,[source_code_description]
           ,[target_concept_id]
           ,[target_vocabulary_id]
           ,[valid_start_date]
           ,[valid_end_date]
           ,[invalid_reason])
     VALUES
(8,0,@local_vocabulary_id,'DTP',   40213291,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 01)
,(50,0,@local_vocabulary_id,'OPV',   40213190,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 02)
,(44,0,@local_vocabulary_id,'MMR (MMR II)',   40213183,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 03)
,(45,0,@local_vocabulary_id,'MEASLES',   40213170,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 05)
,(59,0,@local_vocabulary_id,'RUBELLA',   40213223,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 06)
,(49,0,@local_vocabulary_id,'MUMPS',   40213185,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 07)
,(99,0,@local_vocabulary_id,'HEPATITIS B PEDIATRIC',   40213304,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 08)
,(51,0,@local_vocabulary_id,'IPV (IPOL)',   40213160,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 10)
,(19,0,@local_vocabulary_id,'INFLUENZA (WHOLE)',   40213159,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 16)
,(37,0,@local_vocabulary_id,'HIB',   40213316,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 17)
,(79,0,@local_vocabulary_id,'RABIES-INTRAMUSCULAR',   40213208,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 18)
,(4,0,@local_vocabulary_id,'BCG',   40213271,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 19)
,(15,0,@local_vocabulary_id,'DTAP',   40213281,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 20)
,(9,0,@local_vocabulary_id,'VARICELLA (VARIVAX)',   40213251,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 21)
,(16,0,@local_vocabulary_id,'DTP / HIB',   40213292,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 22)
,(52,0,@local_vocabulary_id,'PLAGUE',   40213197,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 23)
,(2,0,@local_vocabulary_id,'ANTHRAX',   40213268,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 24)
,(65,0,@local_vocabulary_id,'TYPHOID LIVE',   40213242,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 25)
,(106,0,@local_vocabulary_id,'CHOLERA',   40213275,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 26)
,(60,0,@local_vocabulary_id,'DT',   40213280,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 28)
,(107,0,@local_vocabulary_id,'HEP A (PEDIATRIC, UNSPECIFIED FORMULATION)',   40213301,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 31)
,(54,0,@local_vocabulary_id,'PNEUMOCOCCAL POLYSACCHARIDE (PNEUMOVAX 23)',   40213201,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 33)
,(68,0,@local_vocabulary_id,'YELLOW FEVER',   40213257,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 37)
,(264,0,@local_vocabulary_id,'YELLOW FEVER (STAMARIL)',   40213257,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 37)
,(64,0,@local_vocabulary_id,'TYPHOID (INACTIVATED)',   40213243,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 41)
,(81,0,@local_vocabulary_id,'HEP B (ADULT)',   40213306,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 43)
,(200,0,@local_vocabulary_id,'HEP B (ADULT)',   40213306,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 43)
,(82,0,@local_vocabulary_id,'HEP B (DIALYSIS DOSE)',   40213307,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 44)
,(27,0,@local_vocabulary_id,'HEP B (UNSPECIFIED FORMULATION)',   40213308,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 45)
,(83,0,@local_vocabulary_id,'HIB (PRP-D)',   40213313,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 46)
,(84,0,@local_vocabulary_id,'HIB (HBOC)',   40213312,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 47)
,(85,0,@local_vocabulary_id,'HIB (PRP-T)',   40213315,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 48)
,(86,0,@local_vocabulary_id,'HIB, PRP-OMP (PEDVAX HIB)',   40213314,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 49)
,(14,0,@local_vocabulary_id,'DTAP / HIB',   40213287,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 50)
,(30,0,@local_vocabulary_id,'HEP B / HIB',   40213317,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 51)
,(87,0,@local_vocabulary_id,'HEP A ADULT',   40213296,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 52)
,(3,0,@local_vocabulary_id,'HPV (QUADRIVALENT)',   40213320,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 62)
,(70,0,@local_vocabulary_id,'LYME DISEASE',   40213167,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 66)
,(109,0,@local_vocabulary_id,'LYME VACCINE',   40213167,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 66)
,(74,0,@local_vocabulary_id,'SMALLPOX',   40213248,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 75)
,(1,0,@local_vocabulary_id,'ADENOVIRUS',   40213267,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 82)
,(31,0,@local_vocabulary_id,'HEPATITIS A PEDS/ADOLESCENT',   40213300,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 84)
,(24,0,@local_vocabulary_id,'HEP A (UNSPECIFIED FORMULATION)',   40213302,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 85)
,(29,0,@local_vocabulary_id,'INFLUENZA H1N1',   40213158,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 88)
,(101,0,@local_vocabulary_id,'POLIO (UNSPECIFIED FORMULATION)',   40213203,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 89)
,(55,0,@local_vocabulary_id,'RABIES',   40213209,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 90)
,(7,0,@local_vocabulary_id,'MMR / VARICELLA (PROQUAD)',   40213184,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 94)
,(53,0,@local_vocabulary_id,'PNEUMOCOCCAL CONJUGATE 7-VALENT',   40213199,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 100)
,(90,0,@local_vocabulary_id,'TYPHOID (VICPS)',   40213246,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 101)
,(210,0,@local_vocabulary_id,'MENINGOCOCCAL C CONJUGATE VACCINE',   40213176,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 103)
,(112,0,@local_vocabulary_id,'DTAP, 5 PERTUSSIS ANTIGENS',   40213282,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 106)
,(211,0,@local_vocabulary_id,'DTAP, UNSPECIFIED FORMULATION',   40213283,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 107)
,(91,0,@local_vocabulary_id,'MENINGOCOCCAL (UNSPECIFIED FORMULATION)',   40213172,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 108)
,(12,0,@local_vocabulary_id,'DTAP / HEP B / IPV (PEDIARIX)',   40213286,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 110)
,(95,0,@local_vocabulary_id,'INFLUENZA H1N1 (NASAL)',   40213149,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 111)
,(93,0,@local_vocabulary_id,'MENINGOCOCCAL-MCV4P(MENACTRA)',   40213180,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 114)
,(61,0,@local_vocabulary_id,'TDAP',   40213230,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 115)
,(57,0,@local_vocabulary_id,'ROTAVIRUS, PENTAVALENT (ROTATEQ)',   40213217,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 116)
,(100,0,@local_vocabulary_id,'HPV BIVALENT',   40213319,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 118)
,(11,0,@local_vocabulary_id,'ROTAVIRUS MONOVALENT (ROTARIX)',   40213216,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 119)
,(13,0,@local_vocabulary_id,'DTAP / HIB / IPV (PENTACEL)',   40213288,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 120)
,(5,0,@local_vocabulary_id,'ZOSTAVAX (ZOSTER)',   40213260,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 121)
,(94,0,@local_vocabulary_id,'ROTAVIRUS (UNSPECIFIED FORMULATION)',   40213219,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 122)
,(17,0,@local_vocabulary_id,'JAPANESE ENCEPHALITIS',   40213163,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 129)
,(80,0,@local_vocabulary_id,'DTAP / IPV (KINRIX)',   40213289,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 130)
,(28,0,@local_vocabulary_id,'PNEUMOCOCCAL CONJUGATE 13-VALENT (PREVNAR 13)',   40213198,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 133)
,(204,0,@local_vocabulary_id,'INFLUENZA, HIGH DOSE, SEASONAL',   40213141,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 135)
,(210206,0,@local_vocabulary_id,'INFLUENZA, HIGH DOSE SEASONAL',   40213141,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 135)
,(209,0,@local_vocabulary_id,'MENINGOCOCCAL-MCV4O(MENVEO)',   40213179,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 136)
,(48,0,@local_vocabulary_id,'MENINGOCOCCAL-MCV40 (MENVEO)',   40213179,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 136)
,(98,0,@local_vocabulary_id,'HPV (UNSPECIFIED FORMULATION)',   40213321,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 137)
,(111,0,@local_vocabulary_id,'TD ADULT',   40213226,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 138)
,(105,0,@local_vocabulary_id,'TET/DIP',   40213229,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 139)
,(69,0,@local_vocabulary_id,'TD (UNSPECIFIED FORMULATION)',   40213229,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 139)
,(203,0,@local_vocabulary_id,'INFLUENZA, SEASONAL, INJ, PRESERV FREE',   40213154,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 140)
,(21021,0,@local_vocabulary_id,'INFLUENZA, SEASONAL, INJECTABLE, PRESERVATIVE FREE',   40213154,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 140)
,(202,0,@local_vocabulary_id,'INFLUENZA, SEASONAL (INJECTABLE)',   40213153,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 141)
,(97,0,@local_vocabulary_id,'INFLUENZA H1N1 (UNSPECIFIED FORMULATION)',   40213153,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 141)
,(89,0,@local_vocabulary_id,'INFLUENZA, SEASONAL (UNSPECIFIED FORMULATION)',   40213153,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 141)
,(21,0,@local_vocabulary_id,'INFLUENZA, SEASONAL (INJECTABLE)',   40213153,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 141)
,(201,0,@local_vocabulary_id,'INFLUENZA, QUADRIVALENT (NASAL)',   40213150,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 149)
,(21023,0,@local_vocabulary_id,'FLUMIST INFLUENZA, LIVE, INTRANASAL, QUADRIVALENT',   40213150,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 149)
,(205,0,@local_vocabulary_id,'INFLUENZA, INJ, QUADRIVALENT, PRESERVATIVE FREE',   40213146,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 150)
,(210207,0,@local_vocabulary_id,'FLUBLOK INFLUENZA, QUADRIVALENT,INJECTABLE, PRESERVATIVE FREE',   40213146,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 150)
,(210208,0,@local_vocabulary_id,'INFLUENZA, HIGH DOSE QUADRIVALENT, PRESERVATIVE FREE',   40213146,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 150)
,(210203,0,@local_vocabulary_id,'INFLUENZA, INJECTABLE, QUADRIVALENT, PRESERVATIVE FREE',   40213146,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 150)
,(23,0,@local_vocabulary_id,'INFLUENZA, SEASONAL (NASAL)',   40213327,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 151)
,(92,0,@local_vocabulary_id,'PNEUMOCOCCAL (UNSPECIFIED FORMULATION)',   40213200,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 152)
,(208,0,@local_vocabulary_id,'INFLUENZA, INJ, MDCK, PRESERVATIVE FREE',   40213142,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 153)
,(207,0,@local_vocabulary_id,'INFLUENZA, RECOMBINANT, INJ, PRESERV FREE',   40213151,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 155)
,(21025,0,@local_vocabulary_id,'INFLUENZA, INJECTABLE, QUADRIVALENT, CONTAINS PRESERVATIVE',   40213145,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 158)
,(212,0,@local_vocabulary_id,'INFLUENZA, INJ, QUADRIVALENT, WITH PRESERVATIVE',   40213145,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 158)
,(213,0,@local_vocabulary_id,'INFLUENZA, INJ, QUADRIVALENT, WITH PRESERVATIVE',   40213145,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 158)
,(96,0,@local_vocabulary_id,'INFLUENZA H1N1 (INJECTABLE)',   40213145,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 158)
,(214,0,@local_vocabulary_id,'INFLUENZA, INJ, QUADRIVALENT, PRESERVATIVE FREE, PEDIATRIC',   40213147,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 161)
,(251,0,@local_vocabulary_id,'MENINGOCOCCAL B, RECOMBINANT (TRUMENBA)',   40213174,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 162)
,(250,0,@local_vocabulary_id,'MENINGOCOCCAL B, OMV (BEXSERO)',   40213173,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 163)
,(262,0,@local_vocabulary_id,'MENINGOCOCCAL B, UNSPECIFIED',   40213175,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 164)
,(33,0,@local_vocabulary_id,'HPV9 (GARDASIL 9)',   40213322,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 165)
,(21022,0,@local_vocabulary_id,'INFLUENZA, INTRADERMAL, QUADRIVALENT, PRESERVATIVE FREE',   40213148,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 166)
,(216,0,@local_vocabulary_id,'INFLUENZA, INTRADERMAL, QUADRIVALENT, PRESERVATIVE FREE',   40213148,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 166)
,(206,0,@local_vocabulary_id,'INFLUENZA, SEASONAL, INTRADERMAL, PRESERV FREE',   40213148,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 166)
,(253,0,@local_vocabulary_id,'INFLUENZA INF, TRIVALENT, PRESERVATIVE FREE',   40213157,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 168)
,(210253,0,@local_vocabulary_id,'SEASONAL TRIVALENT INFLUENZA VACCINE, ADJUVANTED, PRESERVATIVE FREE',   40213157,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 168)
,(210255,0,@local_vocabulary_id,'INFLUENZA, INJECTABLE, MDCK, PRESERVATIVE FREE, QUADRIVALENT',   40213143,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 171)
,(254,0,@local_vocabulary_id,'INFLUENZA INJ, QUADRIVALENT, PRESERVATIVE FREE AND ANTIBIOTIC FREE, DERIVED FROM CELL CULTURES',   40213143,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 171)
,(263,0,@local_vocabulary_id,'YELLOW FEVER, UNSPECIFIED',   40213259,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 184)
,(255,0,@local_vocabulary_id,'INFLUENZA INJ, QUADRIVALENT, WITH PRESERVATIVE, ANTIBIOTIC FREE, DERIVED FROM CELL CULTURES',   40213144,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 186)
,(210254,0,@local_vocabulary_id,'INFLUENZA, INJECTABLE, MDCK, QUADRIVALENT, PRESERVATIVE',   40213144,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 186)
,(260,0,@local_vocabulary_id,'ZOSTER (SHINGRIX)',   706103,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 187)
,(261,0,@local_vocabulary_id,'ZOSTER VACCINE, UNSPECIFIED',   706104,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 188)
,(35,0,@local_vocabulary_id,'HEPB-CPG (HEPLISAV)',   706105,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 189)
,(36,0,@local_vocabulary_id,'HEP A / HEP B (TWINRIX)',   706109,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 193)
,(39,0,@local_vocabulary_id,'DT, IPV ADSORBED VACCINE',   724894,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 195)
,(40,0,@local_vocabulary_id,'TD, ADSORBED, PRESERVATIVE FREE, ADULT USE',   724895,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 196)
,(63,0,@local_vocabulary_id,'TETANUS TOXOID',   724895,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 196)
,(103,0,@local_vocabulary_id,'TD (ADULT, PRESERVATIVE-FREE)',   724895,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 196)
,(108,0,@local_vocabulary_id,'TETANUS TOXOID (ADSORBED)',   724895,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 196)
,(47,0,@local_vocabulary_id,'MENINGOCOCCAL POLYSACCHARIDE (MENOMUNE)',   724901,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 203)
,(210272,0,@local_vocabulary_id,'(MODERNA) SARS-COV-2 (COVID-19) VACCINE, MRNA, PRESERVATIVE FREE, 100 MCG/0.5 ML DOSAGE',   724906,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 207)
,(210271,0,@local_vocabulary_id,'(PFIZER) SARS-COV-2 (COVID-19) VACCINE, MRNA, PRESERVATIVE FREE, 30MCG/0.3ML DOSE',   724907,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 208)
,(210274,0,@local_vocabulary_id,'JANSSEN J&J SARS-COV-2 (COVID-19) VACCINE',   702866,'CVX','1970-01-01','2099-12-31',NULL) --target_concept_id for CVX code 212)

SET @RC  = @@ROWCOUNT 
 
IF ( @RC>0 )
BEGIN 
 SET @end_datetime = getdate() 
 SET @elapsed_seconds = DATEDIFF(second,@start_datetime,@end_datetime) 

 INSERT INTO stage.OMOP_ETL_runlog (table_name, start_datetime, end_datetime, elapsed_seconds, count_of_rows, block_number, procedure_name, comment)
 VALUES (  @destinationTable, @start_datetime, @end_datetime, @elapsed_seconds,@RC, 0, OBJECT_NAME(@@PROCID), CONCAT('INSERT ',@local_vocabulary_id,' rows' ))
END

/*
### 
select *
from [dbo].[source_to_concept_map] as sctm
where sctm.source_vocabulary_id = 'JHMImmCVX'

SELECT *
FROM [JHM_OMOP_Test].[dbo].[concept]
WHERE VOCABULARY_ID LIKE '%CVX%'
*/

GO


