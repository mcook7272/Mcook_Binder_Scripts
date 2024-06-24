--Search census in top left search bar
select top 100 * from CDW.FullAccess.CensusDatasetDimX cdd
select top 100 * from CDW.FullAccess.CensusGeographyDataFactX cgf
select top 100 * from CDW.FullAccess.CensusGeographyDimX cgeo --GeoType
select top 100 * from CDW.FullAccess.CensusVariableDimX cvar
-- Geographies in order of descending size/population: State -> County -> Tract -> BlockGroup -> Blocks
-- 24 510140 300201 3
-- 245101403002013
-- SHould rename it CensusFullGeoId
-- CensusBlockGroupGeoId
-- CensusTractGeoId
-- XKCD Heat Map: https://xkcd.com/1138/
-- Tableau Census Shape Data Sources: https://tableau.jhmi.edu/#/site/JHMEnterpriseAnalytics/datasources?search=census&order=relevancy:desc
select count(*) as cnt from CDW.FullAccess.CensusGeographyDimX cgeo
where 1=1
 and cgeo.GeographyType='Tract'
 --and cgeo.GeographyType='Block Group'
--
select
 top 10000
 pat.[Name] as PatientName
 ,ad.CensusTract_X --Full GeoId
 ,left(ad.CensusTract_X,12) as Geoid10
from CDW.FullAccess.PatientDim pat
inner join CDW.FullAccess.AddressDim ad on pat.AddressKey=ad.AddressKey
where 1=1
 and pat.IsCurrent=1
 and len(ad.CensusTract_X)>3
 and pat.PatientKey > 0

 select top 100 * from CDW.FullAccess.PatientDim

 --Get Area Deprivation Index (National Percentile) for Patients
 select top 100 
 PatientDurableKey = pat.DurableKey
 ,adi.AreaDeprivationIndexStateDecile
from cdw.FullAccess.PatientDim pat
left join (
 select
 pat.DurableKey as PatientDurableKey
 ,fct.EstimateValue as AreaDeprivationIndexNationalPercentileString
 ,case when TRY_CONVERT(numeric(18,2),fct.EstimateValue) is not null then cast(fct.EstimateValue as
numeric(18,2)) / cast(100 as numeric(18,2)) end as AreaDeprivationIndexStateDecile
 from CDW.FullAccess.PatientDim pat
 inner join CDW.FullAccess.AddressDim ad on pat.AddressKey=ad.AddressKey
 inner join CDW.FullAccess.CensusGeographyDimX dm on left(ad.CensusTract_X,12)=dm.GeoId and dm.GeographyType='Block Group' 
 inner join CDW.FullAccess.CensusGeographyDataFactX fct on fct.CensusGeographyDimKey=dm.CensusGeographyKey
 where 1=1
 and fct.EstimateVariableKey=1
 and pat.isCurrent=1
 and TRY_CONVERT(NUMERIC(18, 2), fct.EstimateValue) IS NOT NULL
) adi on pat.DurableKey=adi.PatientDurableKey
where 1=1
 and pat.IsCurrent=1

 --Get Area Deprivation Index (State Decile) for Patients
 select top 100
 PatientDurableKey = pat.DurableKey
 ,adi.AreaDeprivationIndexNationalPercentile
from cdw.FullAccess.PatientDim pat
left join (
 select
 pat.DurableKey as PatientDurableKey
 ,fct.EstimateValue as AreaDeprivationIndexNationalPercentileString
 ,case when TRY_CONVERT(numeric(18,2),fct.EstimateValue) is not null then cast(fct.EstimateValue as
numeric(18,2)) / cast(100 as numeric(18,2)) end as AreaDeprivationIndexNationalPercentile
 from CDW.FullAccess.PatientDim pat
 inner join CDW.FullAccess.AddressDim ad on pat.AddressKey=ad.AddressKey
 inner join CDW.FullAccess.CensusGeographyDimX dm on left(ad.CensusTract_X,12)=dm.GeoId and dm.GeographyType='Block Group'
 inner join CDW.FullAccess.CensusGeographyDataFactX fct on fct.CensusGeographyDimKey=dm.CensusGeographyKey
 where 1=1
 and fct.EstimateVariableKey=2
 and pat.isCurrent=1
 and TRY_CONVERT(NUMERIC(18, 2), fct.EstimateValue) IS NOT NULL
) adi on pat.DurableKey=adi.PatientDurableKey
where 1=1
 and pat.IsCurrent=1

 --Count emergency room visits by diabetic patients by Block Group (works!!)
 select
 count(*) as NumberEdVisitsByPatientWithDiabetes
,count(distinct pat.DurableKey) as NumberOfPatientsWithDiabetes
 ,left(ad.CensusTract_X,12) as Geoid10
FROM PatientDim pat
inner join AddressDim ad on pat.AddressKey=ad.AddressKey
inner join EncounterFact ef on pat.DurableKey=ef.PatientDurableKey
inner join (
 select
 plf.PatientDurableKey
 ,count(*) as cnt
 from ProblemListFact plf
 inner join DiagnosisSetDim dsd on plf.DiagnosisKey=dsd.DiagnosisKey
 where dsd.Name like '%diabetes%'
 group by
 plf.PatientDurableKey
) grouper on grouper.PatientDurableKey=pat.DurableKey
where 1=1
 and pat.isCurrent=1
 and grouper.PatientDurableKey is not null
 and ef.DateKey between 20180101 and 20190612
 and ef.IsEdVisit=1
group by
 left(ad.CensusTract_X,12)

 --Get Area Deprivation Index scores for Census Block Groups (works!)
 select
 cast(fct.EstimateValue as numeric(18,2)) as AreaDeprivationIndexNational
 ,fct.EstimateValue as AreaDeprivationIndexNational
 ,dm.GeoId as Geoid10
from CDW.FullAccess.CensusGeographyDataFactX fct
inner join CDW.FullAccess.CensusGeographyDimX dm on fct.CensusGeographyDimKey=dm.CensusGeographyKey
where 1=1
 and fct.EstimateVariableKey=1
 and ISNUMERIC(fct.EstimateValue)=1
 and left(dm.GeoId,2)='24'


 --Get Area Deprivation Index Along with Readmissions
 select
 haf.PatientDurableKey
 ,haf.EncounterEpicCsn
 ,ddd.DateValue as DischargeDate
 ,dur.Years as PatientAge
 ,next_admission.DaysToReadmission
 ,pat.FirstRace
 ,ad.Address
 ,adi.AreaDeprivationIndexNationalPercentile
 ,adi.AreaDeprivationIndexNationalPercentileString
 ,pat.SmokingStatus
 ,drg.CaseType as DrgCaseType
 ,ddp.Name as PrimaryDiagnosisName
 ,haf.InpatientLengthOfStayInDays
 ,haf.LengthOfStayInDays
 ,drg.[Name] as DrgName
 ,hcc.MaHccRolUpSco
 ,claims_amt.SumClaimAmount
 ,claims_amt_past_six_months.SumClaimAmount as SumClaimAmountLastSixMonths
 ,case when next_admission.DaysToReadmission <= 30 and next_admission.RowNum is not null then 1 else 0
end as Is30DayReadmitNumerator
 ,1 as IsDenominator
from CDW.FullAccess.HospitalAdmissionFact haf
inner join (
 select
 rgs.PatientDurableKey
 ,count(*) as cnt
 from JhhcPayorMaRegistryDataMartX rgs
 where rgs.IsMostRecent=1 and rgs.RegistryStatusC='Active'
 group by
 rgs.PatientDurableKey
) medicare_advantage on medicare_advantage.PatientDurableKey=haf.PatientDurableKey
inner join DiagnosisDim ddp on haf.PrimaryCodedDiagnosisKey=ddp.DiagnosisKey
inner join CDW.FullAccess.PatientDim pat on haf.PatientKey=pat.PatientKey
inner join CDW.FullAccess.AddressDim ad on pat.AddressKey=ad.AddressKey
left join CDW.FullAccess.HccRegistryRegistryDataMartX hcc on hcc.PatientDurableKey=haf.PatientDurableKey and hcc.
IsMostRecent=1
inner join CDW.FullAccess.EncounterFact ef on haf.EncounterKey=ef.EncounterKey
inner join CDW.FullAccess.DurationDim dur on dur.DurationKey=haf.AgeKey
inner join CDW.FullAccess.DateDim dda on haf.AdmissionDateKey=dda.DateKey
inner join CDW.FullAccess.DateDim ddd on haf.DischargeDateKey=ddd.DateKey
inner join CDW.FullAccess.DrgDim drg on haf.DrgKey=drg.DrgKey
left join (
 select
 pat.DurableKey as PatientDurableKey
 ,pat.PatientKey
 ,fct.EstimateValue as AreaDeprivationIndexNationalPercentileString
 ,case when TRY_CONVERT(numeric(18,2),fct.EstimateValue) is not null then cast(fct.EstimateValue
as numeric(18,2)) / cast(100 as numeric(18,2)) end as AreaDeprivationIndexNationalPercentile
 from CDW.FullAccess.PatientDim pat
 inner join CDW.FullAccess.AddressDim ad on pat.AddressKey=ad.AddressKey
 inner join CDW.FullAccess.CensusGeographyDimX dm on left(ad.CensusTract_X,12)=dm.GeoId and dm.
GeographyType='Block Group'
 inner join CDW.FullAccess.CensusGeographyDataFactX fct on fct.CensusGeographyDimKey=dm.CensusGeographyKey
 where 1=1
 and fct.EstimateVariableKey=1
 and TRY_CONVERT(NUMERIC(18, 2), fct.EstimateValue) IS NOT NULL
) adi on haf.PatientKey=adi.PatientKey
outer apply (
 select
 hafr.PatientDurableKey
 ,DATEDIFF(dd,ddd.DateValue,ddar.DateValue) as DaysToReadmission
 ,ROW_NUMBER() over (partition by hafr.PatientDurableKey order by hafr.AdmissionDateKey asc) as
RowNum
 from CDW.FullAccess.HospitalAdmissionFact hafr
 inner join CDW.FullAccess.DateDim ddar on hafr.AdmissionDateKey=ddar.DateKey
 where 1=1
 and hafr.PatientClass='Inpatient'
 and hafr.PatientDurableKey=haf.PatientDurableKey
 and ddar.DateValue > ddd.DateValue
) next_admission
left join (
 select
 sum(hdr.TotalNetPayableAmount) as SumClaimAmount
 ,hdr.PatientDurableKey
 from ReceivedClaimFact hdr --FullAccess empty, make FullAccess?
 where 1=1
 and hdr.IDType in ('PharmClaimId|AdjSeq:EpicKey_6','MedicalClaimId|AdjSeq:EpicKey_6') --IDType is not a field...
 group by
 hdr.PatientDurableKey
) claims_amt on claims_amt.PatientDurableKey=haf.PatientDurableKey
left join (
 select
 sum(hdr6.TotalNetPayableAmount) as SumClaimAmount
 ,hdr6.PatientDurableKey
 from ReceivedClaimFact hdr6
 inner join DateDim ddc6 on hdr6.StartDateKey=ddc6.DateKey
 where 1=1
 and hdr6.IdType in ('PharmClaimId|AdjSeq:EpicKey_6','MedicalClaimId|AdjSeq:EpicKey_6')
 and cast(ddc6.DateValue as date) between '2018-09-01' and '2019-02-24'
 --and between DATEADD(MM,-6,ddd.DateValue) and ddd.DateValue
 group by
 hdr6.PatientDurableKey
) claims_amt_past_six_months on claims_amt_past_six_months.PatientDurableKey=pat.DurableKey
where 1=1
 and (next_admission.RowNum=1 or next_admission.RowNum is null)
 --and (claims_amt_past_six_months.PatientDurableKey is not null)
 --and cast(ddd.DateValue as date) between '2017-07-01' and '2019-02-24'
 and cast(ddd.DateValue as date) between '2019-01-01' and '2019-02-24'
 and haf.PatientClass='Inpatient'
 --and adi.AreaDeprivationIndexNationalPercentileString is not null
 ;

 select top 100 *
 from FullAccess.ReceivedClaimFact
 where 1=1
 and originalclaimkey > 0 

 select  distinct concept
 from Census_ODS.gsap2018ACS5.d_dic
 where concept like '%poverty%'


 select *
  from Census_ODS.gsap2018ACS5.d_dic
  where concept like '%poverty%'
   order by group_var