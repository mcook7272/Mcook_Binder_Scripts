--ESMPMDBDEV31 Server

SELECT TOP (1000) [proj_id]
      ,[projName]
      ,[notesOnly]
      ,[projTarget]
      ,[tgtServer]
      ,[tgtDatabase]
      ,[tgtCatalog]
      ,[schedEnabled]
      ,[schedType]
      ,[days]
      ,[schedLastRefresh]
      ,[cohortName]
      ,[idType]
      ,[active]
      ,[maskingSalt]
      ,[ldsFlag]
      ,[sensitiveFilter]
      ,[agedateFilter]
      ,[startDateFilter]
      ,[patientNotes]
      ,[radiologyNotes]
      ,[pathologyNotes]
      ,[activeTbls]
      ,[inactiveTbls]
      ,[createDttm]
      ,[lastUpdateDttm]
  FROM [PMAP_ELT_Config_int].[dbo].[vw_v2ProjConfig]
