/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) map.MappingKey, map.MappingTableColumnComboKey, map.SourceValue, map.StandardCode, 
map.StandardTerm, map.SourceValueId, bridge.MappingTableColumnComboKey, bridge.MappingTableColumnKey, 
col.MappingTableColumnKey, col.TableName, col.ColumnName, att.AttributeKey, att.SmartDataElementEpicId, 
att.[Name], att.Abbreviation, att.DataType, att.ConceptType, att.ConceptValue
  FROM MappingDim map
  inner join MappingTableColumnBridge bridge on map.MappingTableColumnComboKey = bridge.MappingTableColumnComboKey
  inner join CDW.dbo.MappingTableColumnDim col on bridge.MappingTableColumnKey = col.MappingTableColumnKey
  inner join AttributeDim att 
	on CAST(map.SourceValueId AS varchar(max)) = CAST(att.AttributeKey AS varchar(max))
  where MappingKey > 0 and map.MappingTableColumnComboKey > 0
  and col.TableName = 'AttributeDim' and col.ColumnName = 'AttributeKey'
  --and SmartDataElementEpicId > ''
  and att.ConceptType = 'SNOMED'
  and SmartDataElementEpicId = 'EPIC#31000188182';
  --and SourceValueId = '7133725'

  SELECT TOP (1000) map.MappingKey, map.MappingTableColumnComboKey, map.SourceValue, map.StandardCode, 
map.StandardTerm, map.SourceValueId, bridge.MappingTableColumnComboKey, bridge.MappingTableColumnKey, 
col.MappingTableColumnKey, col.TableName, col.ColumnName
  FROM MappingDim map
  inner join MappingTableColumnBridge bridge on map.MappingTableColumnComboKey = bridge.MappingTableColumnComboKey
  inner join CDW.dbo.MappingTableColumnDim col on bridge.MappingTableColumnKey = col.MappingTableColumnKey
  where bridge.MappingTableColumnKey > 0;

  SELECT top 100 *
  from AttributeDim att
  inner join AttributeMappingDim map on att.AttributeKey = map.AttributeKey
  inner join TerminologyConceptDim conc on map.TerminologyConceptKey = conc.TerminologyConceptKey
  where SmartDataElementEpicId like 'JHM#%';

  SELECT top 100 *
  from AttributeDim att
  where SmartDataElementEpicId like 'JHM#%';


  --New, improved query here
  SELECT top 100 att.SmartDataElementEpicId, att.Name, att.Abbreviation,
  conc.TerminologyConceptKey, conc.StandardName, conc.Concept, 
  conc.Name "ConceptName", conc._CreationInstant
  from AttributeDim att
  inner join AttributeMappingDim map on att.AttributeKey = map.DurableKey --Use durable
  inner join TerminologyConceptDim conc on map.TerminologyConceptKey = conc.TerminologyConceptKey
  where SmartDataElementEpicId like 'JHM#%' --Change this to desired SDE
	and map.IsCurrent = 1