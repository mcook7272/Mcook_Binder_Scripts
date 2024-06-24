drop table if exists PMAP_Analytics.dbo.Parikh_Biospecimen
Select distinct [SUBJECT_NUMBER], birth_date,pat_status,death_date,pat.gender,genderabbr,ethnic_group,first_race,racew,raceb,
racei,racea,racep,raceo,racerf,raceu,racetwo,racedec,raceh,first_contact,last_contact,next_contact,employment_status,
primarycare_prov_id,primarycare_prov_name,primaryloc_id,primaryloc_name,[Date of Blood Draw],[Age at the time of the blood draw],
[Race],[Ethnicity],[Max WHO Score Group],[Max WHO Score],[Max WHO Score Numeric],[BMI(most recent)],[positive_test_time],[admit_time],
[Oxygen Start Time],[Oxygen End Time],[INT Dialysis Start Time],[INT Dialysis End Time],[NIPPV Start Time],[NIPPV End Time],
[Hi flow Start Time],[Hi flow End Time],[Vent Start Time],[Vent End Time],[IV Pressor Start Time],[IV Pressor End Time],
[CRRT Start Time],[CRRT End Time],[DNR/DNI Time],[Final Hospital Discharge Time],[Death Time],[Diabetes Y/N],[Coronary Disease Y/N],
[Heart Failure Y/N],[Solid Organ Transplant Y/N],[HIV Y/N],[HCV Y/N],[HTN Y/N],[Chronic Lung Disease Y/N],[Autoimmune Disease Y/N],
[Current Smoker Y/N],[Cancer Y/N],[WBC],[WBC specimen recieved time],[Total lymphocyte count],[lymphocyte specimen recieved time],
[Total neutrophil count],[Neutrophil specimen recieved time],[CRP],[CRP specimen recieved time],[D-Dimer],
[D-Dimer specimen recieved time],[Current WHO Score Group],[Current WHO Score],[Current WHO Score Numeric]
into PMAP_Analytics.dbo.Parikh_Biospecimen
from CROWNParikh_Projection..derived_epic_patient pat
inner join PMAP_Analytics..[CCDA2046_Cox_Final_Hyphens_NoHyphens] noh on noh.osler_id = pat.osler_id 
order by SUBJECT_NUMBER


