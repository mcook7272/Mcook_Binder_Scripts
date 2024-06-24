select  cv.name ,cdim.geographytype,count(*) as cc
	 from censusgeographydatafactx cf
	 inner join censusvariabledimx cv on cf.estimatevariablekey = cv.censusvariablekey
	 inner join censusgeographydimx cdim on cf.censusgeographydimkey = cdim.censusgeographykey
	    where cf.estimatevariablekey >=4
		AND cdim.GeographyType = 'Block Group'
		group by cv.name ,cdim.geographytype
		order by cv.name,cdim.geographytype

--patientkey, addresskey, county, block group, var name, var value, date value
select distinct top 10000 pat.PatientKey, ad.AddressKey, 
 ad.County, left(ad.CensusTract_X,12) "BlockGroup"
, cv.[name] "VariableName", fct.EstimateValue, fct._LastUpdatedInstant "LastUpdated"
from CDW.FullAccess.PatientDim pat
 inner join CDW.FullAccess.AddressDim ad on pat.AddressKey=ad.AddressKey
 inner join CDW.FullAccess.CensusGeographyDimX dm on left(ad.CensusTract_X,12)=dm.GeoId and dm.GeographyType='Block Group' 
 inner join CDW.FullAccess.CensusGeographyDataFactX fct on fct.CensusGeographyDimKey=dm.CensusGeographyKey
 inner join CDW.FullAccess.censusvariabledimx cv on fct.estimatevariablekey = cv.censusvariablekey
 where fct.estimatevariablekey >= 4
 and ad.AddressKey > 0
 and pat.PatientKey > 0
 order by VariableName

 SELECT DISTINCT pat.PatientKey,
	ad.AddressKey,
	ad.County,
	left(ad.CensusTract_X, 12) "BlockGroup",
	cv.[name] "VariableName",
	fct.EstimateValue,
	fct._LastUpdatedInstant "LastUpdated"
FROM CDW.FullAccess.PatientDim pat
INNER JOIN CDW.FullAccess.AddressDim ad
	ON pat.AddressKey = ad.AddressKey
INNER JOIN CDW.FullAccess.CensusGeographyDimX dm
	ON left(ad.CensusTract_X, 12) = dm.GeoId
		AND dm.GeographyType = 'Block Group'
INNER JOIN CDW.FullAccess.CensusGeographyDataFactX fct
	ON fct.CensusGeographyDimKey = dm.CensusGeographyKey
INNER JOIN CDW.FullAccess.censusvariabledimx cv
	ON fct.estimatevariablekey = cv.censusvariablekey
WHERE fct.estimatevariablekey >= 4
	AND ad.AddressKey > 0
	AND pat.PatientKey > 0
ORDER BY County, BlockGroup, VariableName