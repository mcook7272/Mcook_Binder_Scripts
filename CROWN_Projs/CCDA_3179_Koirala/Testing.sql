IF EXISTS (
      SELECT 1
      FROM sys.tables
      WHERE object_id = OBJECT_ID('#myTable')
      )
BEGIN
      ;

   DROP TABLE #myTable;
END;
   GO

CREATE TABLE #myTable (
   [myTableID] INT NOT NULL IDENTITY(1, 1), [ID] VARCHAR(4) NULL, [diag] VARCHAR(255) NULL, PRIMARY KEY ([myTableID]
      )
   );

INSERT INTO #myTable (ID, diag)
VALUES (2764, 'K4B.7Y1'), (2764, 'X4B.6U5'), (3098, 'K4B.7Y1'), (1938, 'E3E.8T1'), (1938, 'X4B.6U5'
   ), (3766, 'K4B.7Y1'), (3766, 'R4T.3N1'), (7430, 'K4B.7Y1'), (7430, 'E3E.8T1'), (7070, 'H9U.8X9'
   );

drop table if exists #inc_DX_LIST;
drop table if exists #inc_DX_LIST_2;

SELECT myTableID "DX_ID"
INTO #inc_DX_LIST
FROM #myTable 
WHERE diag LIKE 'K4B.7Y1';

SELECT myTableID "DX_ID"
INTO #inc_DX_LIST_2
FROM #myTable 
WHERE diag in('E3E.8T1','X4B.6U5');

IF OBJECT_ID(N'TEMPDB..#inc_dx') IS NOT NULL DROP TABLE #inc_dx
SELECT distinct t.ID
--INTO #inc_dx
FROM 
		(
		SELECT PAT.ID
		FROM #myTable PAT
		INNER JOIN #inc_DX_LIST DX ON DX.DX_ID = PAT.diag
		) t
		INNER JOIN #myTable tab on t.ID = tab.ID
		LEFT JOIN #inc_DX_LIST_2 DX2 ON DX2.DX_ID = tab.diag
		WHERE DX2.DX_ID is not null;

SELECT ID
INTO #inc_DX_LIST_ID
FROM #myTable 
WHERE diag LIKE 'K4B.7Y1';

SELECT tab.ID
--INTO #inc_DX_LIST_2
FROM #myTable tab
join #inc_DX_LIST_ID dx on tab.ID = dx.ID
WHERE diag in('E3E.8T1','X4B.6U5');

SELECT distinct t.ID
--INTO #inc_dx
FROM 
		(
		SELECT *
		FROM #myTable PAT
		inner JOIN #inc_DX_LIST DX ON DX.DX_ID = PAT.myTableID
		--LEFT JOIN #inc_DX_LIST_2 DX2 ON DX2.DX_ID = PAT.myTableID
		JOIN (select ID from #myTable JOIN #inc_DX_LIST_2 DX2 ON DX2.DX_ID = #myTable.myTableID) tab2 on PAT.ID = tab2.ID
		WHERE ID in (select ID from #myTable JOIN #inc_DX_LIST_2 DX2 ON DX2.DX_ID = #myTable.myTableID);
		) t
		INNER JOIN #myTable tab on t.ID = tab.ID
		LEFT JOIN #inc_DX_LIST_2 DX2 ON DX2.DX_ID = tab.diag
		WHERE DX2.DX_ID is not null;