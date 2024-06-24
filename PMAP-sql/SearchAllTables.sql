SET NOCOUNT ON
DECLARE @AllTables table (DbName sysname,SchemaName sysname, TableName sysname)
DECLARE
     @SearchDb nvarchar(200)
    ,@SearchSchema nvarchar(200)
    ,@SearchTable nvarchar(200)
    ,@SQL nvarchar(4000)
SET @SearchDb='%_Projection%'
SET @SearchSchema='dbo' --EPIC for phi
SET @SearchTable='derived_epic_patient'
SET @SQL='select ''?'' as DbName, s.name as SchemaName, t.name as TableName from [?].sys.tables t left join sys.schemas s on t.schema_id=s.schema_id WHERE ''?'' LIKE '''+@SearchDb+''' AND s.name LIKE '''+@SearchSchema+''' AND t.name LIKE '''+@SearchTable+''''

INSERT INTO @AllTables (DbName, SchemaName, TableName)
    EXEC sp_msforeachdb @SQL
SET NOCOUNT OFF
SELECT * FROM @AllTables ORDER BY DbName, SchemaName, TableName

/*
PR5

SET NOCOUNT ON
DECLARE @AllTables table (DbName sysname,SchemaName sysname, TableName sysname)
DECLARE
     @SearchDb nvarchar(200)
    ,@SearchSchema nvarchar(200)
    ,@SearchTable nvarchar(200)
    ,@SQL nvarchar(4000)
SET @SearchDb='%_Projection%'
--SET @SearchSchema= '%' --EPIC for phi
SET @SearchTable='derived_epic_patient'
SET @SQL='select ''?'' as DbName, coalesce(s.name, ''phi'') as SchemaName, t.name as TableName from [?].sys.tables t left join sys.schemas s on t.schema_id=s.schema_id WHERE ''?'' LIKE '''+@SearchDb+''' AND t.schema_id = 5  AND t.name LIKE '''+@SearchTable+''''

INSERT INTO @AllTables (DbName, SchemaName, TableName)
    EXEC sp_msforeachdb @SQL
SET NOCOUNT OFF
SELECT * FROM @AllTables ORDER BY DbName, SchemaName, TableName
*/