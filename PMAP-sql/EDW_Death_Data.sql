SELECT Min([DeathConfidenceLabel]) as 'DeathConfidenceLabel', Avg([DeathConfidenceScore]) as 'DeathConfidenceScore', Count( [PatientDurablekey] ) as 'Patients'

 FROM [RPT].[dbo].[v_PotentialDeaths]

 group by [DeathConfidenceLabel]

 Order by 'DeathConfidenceScore' desc