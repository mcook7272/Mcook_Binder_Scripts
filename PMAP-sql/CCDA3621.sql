With

Diag_info

as

(

select distinct DiagEvent.PatientDurableKey,Min(DateDim.DateValue) as 'First Diag Date'

              from [CDW].dbo.[DiagnosisEventFact] DiagEvent

              inner join [CDW].dbo.[DiagnosisDim] DiagDim on DiagDim.DiagnosisKey = DiagEvent.DiagnosisKey

              inner join [CDW].dbo.[DateDim] DateDim on DateDim.DateKey = DiagEvent.StartDateKey

              where DiagEvent.Status = 'Active' and

                     (DiagDim.RefBillCode_X like 'E10.%'

                     or DiagDim.RefBillCode_X like 'E11.%'

                     or DiagDim.RefBillCode_X like 'I20.%'

                     or DiagDim.RefBillCode_X like 'I21.%'

                     or DiagDim.RefBillCode_X like 'I22.%'

                     or DiagDim.RefBillCode_X like 'I23.%'

                     or DiagDim.RefBillCode_X like 'I24.%'

                     or DiagDim.RefBillCode_X like 'I25.%'

                     or DiagDim.RefBillCode_X like 'I60.%'

                     or DiagDim.RefBillCode_X like 'I61.%'

                     or DiagDim.RefBillCode_X like 'I61.%'

                     or DiagDim.RefBillCode_X like 'I62.%'

                     or DiagDim.RefBillCode_X like 'I63.%'

                     or DiagDim.RefBillCode_X like 'I67.2'

                     or DiagDim.RefBillCode_X like 'I70.%'

                     or DiagDim.RefBillCode_X like 'I73.9')

group by DiagEvent.PatientDurableKey

),

 

Visit_info

as(

select distinct VFact.PatientDurableKey,EncFact.EncounterEpicCsn,DateDim.DateValue as Enc_date

from [CDW].dbo.[VisitFact] VFact

       inner join [CDW].dbo.[EncounterFact] EncFact on EncFact.EncounterKey = Vfact.EncounterKey

       inner join [CDW].dbo.[ProviderDim] ProvDim on ProvDim.ProviderKey = Vfact.PrimaryVisitProviderKey

       inner join [CDW].dbo.[DateDim] DateDim on DateDim.DateKey = VFact.EncounterDateKey

       inner join [CDW].dbo.[DepartmentDim] DepDim on DepDim.DepartmentKey = VFact.DepartmentKey

       where VFact.IsFaceToFace = 1 and VFact.AppointmentStatus = 'Completed'

       and (DepartmentSpecialty in ('Cardiology','Internal Medicine','Family Medicine','Endocrinology/Diabetes') and DepDim.ServiceAreaEpicId = '11' and DepDim._IsDeleted = 0 and IsBed = 0)

       and Vfact.EncounterType in ('Office Visit','Video Visit')

       and ProvDim.Type in ('Physician','Nurse Practitioner','Resident','Physician Assistant','Registered Nurse','Fellow')

       --and ProvDim.PrimarySpecialty in ('Cardiology','Internal Medicine','Endocrinology','General Practice')

       and DateDim.[Year] in (2020,2021)

)

 

select distinct PtDim.DurableKey

              ,PtDim.PatientEpicId

              ,PtDim.EnterpriseId

              ,Visit_info.EncounterEpicCsn

              ,PtDim.AgeInYears

              ,PtDim.DeathDate

              ,PtDim.Status

              ,Diag_info.[First Diag Date]

 

from [CDW].dbo.[PatientDim] PtDim

inner join Diag_info on Diag_info.PatientDurableKey = PtDim.DurableKey

inner join Visit_info on Visit_info.PatientDurableKey = PtDim.DurableKey and Visit_info.Enc_date >= Diag_info.[First Diag Date]

 

where (PtDim.AgeInYears between 18 and 75) and PtDim.IsCurrent = 1 and PtDim.Status = 'Alive'

and PtDim.DurableKey in

(

select distinct CompResult.PatientDurableKey from [CDW].dbo.[LabComponentResultFact] CompResult
inner join [CDW].dbo.[LabComponentDim] CompDim on CompDim.LabComponentKey = CompResult.LabComponentKey
where CompDim.BaseName = 'LDLCALC'
group by CompResult.PatientDurableKey
having min(CompResult.NumericValue) > 100 --max(CompResult.NumericValue) > 100 and

)

and PtDim.DurableKey not in

(Select AllFact.PatientDurableKey from [CDW].dbo.[AllergyFact] AllFact

       inner join [CDW].dbo.[AllergenDim] AllDim on AllFact.AllergenKey = AllDim.AllergenKey

       where name like '%Statin%')

and PtDim.DurableKey not in

(select MedOrder.PatientDurableKey from [CDW].dbo.[MedicationOrderFact] MedOrder

       inner join [CDW].dbo.[MedicationDim] MedDim on MedOrder.MedicationKey = MedDim.MedicationKey

       where MedDim.GenericName like '%simvastatin%'

       or MedDim.GenericName like '%lovastatin%'

       or MedDim.GenericName like '%atorvastatin%'

       or MedDim.GenericName like '%pravastatin%'

       or MedDim.GenericName like '%rosuvastatin%'

       or MedDim.GenericName like '%fluvastatin%'

       or MedDim.GenericName like '%cerivastatin%'

union

select distinct MedFact.PatientDurableKey from [CDW].dbo.[MedicationEventFact] MedFact

       inner join [CDW].dbo.[MedicationDim] MedDim on MedFact.MedicationKey = MedDim.MedicationKey

       where MedDim.GenericName like '%simvastatin%'

       or MedDim.GenericName like '%lovastatin%'

       or MedDim.GenericName like '%atorvastatin%'

       or MedDim.GenericName like '%pravastatin%'

       or MedDim.GenericName like '%rosuvastatin%'

       or MedDim.GenericName like '%fluvastatin%'

       or MedDim.GenericName like '%cerivastatin%'

)

order by PtDim.EnterpriseId,Visit_info.EncounterEpicCsn