drop table if exists #test_enc_dx;
drop table if exists #test_hosp_dx;
drop table if exists #test_bill_dx;

CREATE TABLE #test_enc_dx (
   [myTableID] INT NOT NULL IDENTITY(1, 1), [ID] VARCHAR(4) NULL, [dx_date] VARCHAR(255) NULL, [dx] VARCHAR(255) 
   NULL, PRIMARY KEY ([myTableID])
   );

   CREATE TABLE #test_hosp_dx (
   [myTableID] INT NOT NULL IDENTITY(1, 1), [ID] VARCHAR(4) NULL, [dx_date] VARCHAR(255) NULL, [dx] VARCHAR(255) 
   NULL, PRIMARY KEY ([myTableID])
   );

   CREATE TABLE #test_bill_dx (
   [myTableID] INT NOT NULL IDENTITY(1, 1), [ID] VARCHAR(4) NULL, [dx_date] VARCHAR(255) NULL, [dx] VARCHAR(255) 
   NULL, PRIMARY KEY ([myTableID])
   );

INSERT INTO #test_enc_dx (ID, dx_date, dx)
VALUES (3014, '12/10/2022', 'F20'), (3014, '10/07/2022', 'F20'), (3014, '06/15/2022', 'H787'
   ), (5064, '09/21/2022', 'X4J 1F5'), (2719, '01/28/2022', 'Y1W 3N5'), (7990, '11/10/2021', 'X7T 8U5'
   );

   INSERT INTO #test_hosp_dx (ID, dx_date, dx)
VALUES (5064, '03/10/2023', 'F20'), (1383, '03/25/2023', 'L0P 4M3'), (2719, '01/03/2022', 'N9U 6C8'
   ), (2315, '07/05/2021', 'H4G 9K4'),(1383, '03/20/2023', 'F20');

   INSERT INTO #test_bill_dx (ID, dx_date, dx)
VALUES (5064, '03/17/2023', 'F20'), (1383, '03/20/2023', 'F20'), (2719, '01/05/2022', 'F20'
   ), (2719, '07/05/2021', 'F20');

   SELECT T.ID
--INTO #inc_dx
FROM 
		(
		SELECT ID, dx_date
		FROM #test_enc_dx
		where dx like 'F20%'
		UNION	
		--HSP_BILLING_DX
		SELECT ID, dx_date
		FROM #test_hosp_dx
		where dx like 'F20%'
		UNION
		--HSP_ADMISSION_DX
		SELECT ID, dx_date
		FROM #test_bill_dx
		where dx like 'F20%'
		) T
		GROUP BY T.ID
		HAVING COUNT(*) > 1