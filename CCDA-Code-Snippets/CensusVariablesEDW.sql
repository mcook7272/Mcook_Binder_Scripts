--Census Variables from EDW
select distinct
pat.EnterpriseId
,pat.Name
,ad.Address
,fct.EstimateValue
,ad.SourcePostalCode
,ad.ZipPlus4_X
,ad.CensusTract_X
,left(ad.CensusTract_X,12) as CensusTract_X_12
,ad.Latitude
,ad.Longitude
,dm.GeoId AS BlockGroup,
cv.name AS VariableName,
        fct._LastUpdatedInstant AS LastUpdated
 
from cdw..PatientDim pat
inner join cdw..AddressDim ad on pat.AddressKey = ad.AddressKey
inner join CDW.dbo.CensusGeographyDimX dm on left(ad.CensusTract_X,12)=dm.GeoId and dm.GeographyType='Block Group'
inner join CDW.dbo.CensusGeographyDataFactX fct on fct.CensusGeographyDimKey=dm.CensusGeographyKey --and fct.EstimateVariableKey ='1'
INNER JOIN cdw..censusvariabledimx cv
ON fct.estimatevariablekey = cv.censusvariablekey
 
where 1=1 -- fct.estimatevariablekey >= 4
AND dm.GeographyType = 'Block Group'
--pat.IsCurrent ='1'
and pat.EnterpriseId in (Select distinct emrn from Table); -- Replace table with your tablename 
 
------------------------------------------------------------------------------------------------------
-- Pivoting 
------------------------------------------------------------------------------------------------------
 
 
select Distinct EnterpriseId, SourcepostalCode,variablename,BlockGroup,
   CASE
WHEN (trim(variablename) = '2018 ADI Index (State Deciles)')
THEN '2018 ADI Index (State Deciles)'
WHEN (trim(variablename) = '2018 ADI Index (National Percentiles)')
THEN '2018 ADI Index (National Percentiles)'
 
WHEN (trim(variablename) = '2015 ADI Index (State Deciles)')
THEN '2015 ADI Index (State Deciles)'
WHEN (trim(variablename) = '2015 ADI Index (National Percentiles)')
THEN '2015 ADI Index (National Percentiles)'
 
 
WHEN (left(variablename, 14) = 'US:B17010_002E')
THEN 'Total Income For Families With Children With Income Below Poverty Level In Past 12 Months'
WHEN (left(variablename, 14) = 'US:B23025_003E')
THEN 'Population Over 16 in Labor Force'
WHEN (left(variablename, 14) = 'US:B23025_005E')
THEN 'Population Over 16 Unemployed'
WHEN (left(variablename, 14) = 'US:B19013_001E')
THEN 'Inflation-Adjusted Median Household Income In The Past 12 Months'
WHEN (left(variablename, 15) = 'US: B17010_001E')
THEN 'Poverty Status of Families With Children In Past 12 Months'
ELSE 'No Name Attributed'
END AS VariableNameClean
, EstimateValue
from [Your Table Name]
 
order by variablename;
