  drop table if exists #Ex1A_mcook49;
  drop table if exists #Ex1B_mcook49;
    drop table if exists #Ex2A_mcook49;

select ID, NEWID() AS "New_ID"
into [DeIdentification_DB].[dbo].#Ex1A_mcook49
  from [DeIdentification_DB].[dbo].[patients]
  order by ID;

  select mask.New_ID
      ,[Sex]
      ,[Ethnicity]
      ,[Race]
      ,[BirthDate]
      ,[DeathDate]
      ,[VitalStatus]
      ,[StateOrProvince]
      ,[Country]
	  into [DeIdentification_DB].[dbo].#Ex1B_mcook49
  from [DeIdentification_DB].[dbo].[patients] pat
  inner join #Ex1A_mcook49 mask on mask.ID = pat.ID;
  
  select CSN, NEWID() AS "New_CSN", checksum(NewID()) % 180 "shifter"
into [DeIdentification_DB].[dbo].#Ex2A_mcook49
  from [DeIdentification_DB].[dbo].Visits;

  select mrn.New_ID, mask.New_Csn, bp.bp_systolic_diastolic, bp_date, shifter, dateadd(dd, mask.shifter, bp.bp_date) "new_bp_date"
  from [DeIdentification_DB].[dbo].visits_BP bp
  inner join #Ex2A_mcook49 mask on mask.CSN = bp.csn
  inner join [DeIdentification_DB].[dbo].visits vis on vis.CSN = bp.csn
  inner join #Ex1A_mcook49 mrn on mrn.ID = vis.PatientID
  order by New_CSN;

