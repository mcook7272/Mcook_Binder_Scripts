select 'select count(*) counts, ''' + DestTabName + ''' from ' + DestDBName + '..' + DestTabName + char(13) + 'union all'

from PMAP_Analytics..project_CuratedTables a
where  DestDBName ='CROWNpage_Projection'

ORDER BY a.DestTabName