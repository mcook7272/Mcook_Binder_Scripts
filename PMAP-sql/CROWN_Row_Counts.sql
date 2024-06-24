select 'select count(*) counts, ''' + DestTabName + ''' from ' + DestDBName + '.' +SchemaName +'.' + DestTabName + char(13) + 'union all', 
 DestTabName, *
from PMAP_Analytics..project_CuratedTables a
where  DestDBName ='CROWNThomas_Projection' 
AND NextRun is not null


ORDER BY a.DestTabName



