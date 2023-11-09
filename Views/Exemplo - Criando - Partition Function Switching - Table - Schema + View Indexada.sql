USE MASTER
GO

DROP DATABASE test_partition
GO

--Create database with the file groups that will be used by the partition schemes.
CREATE DATABASE test_partition
ON PRIMARY 
 (NAME = 'paiv_Dat0', 
 FILENAME='C:\temp\test_partition_DataFile0.mdf'),
FILEGROUP FG1 
 (NAME = 'paiv_Dat1', 
  FILENAME = 'C:\temp\test_partition_DataFile1.ndf'),
FILEGROUP FG2 
 (NAME = 'paiv_Dat2', 
  FILENAME = 'C:\temp\test_partition_DataFile2.ndf'),
FILEGROUP FG3 
 (NAME = 'paiv_Dat3', 
  FILENAME = 'C:\temp\test_partition_DataFile3.ndf'),
FILEGROUP FG4 
 (NAME = 'paiv_Dat4', 
  FILENAME = 'C:\temp\test_partition_DataFile4.ndf'),
FILEGROUP FG5 
 (NAME = 'paiv_Dat5', 
  FILENAME = 'C:\temp\test_partition_DataFile5.ndf')
LOG ON 
 (NAME = 'paiv_log', 
  filename='C:\temp\test_partition_log.ldf')
GO

USE test_partition
GO

-- Create partition function and partition scheme.
CREATE PARTITION FUNCTION [PF1] (int)
AS RANGE LEFT FOR VALUES (20060331, 20060630, 20060930, 20061231);
GO

CREATE PARTITION SCHEME [PS1]
AS PARTITION [PF1] 
TO ([FG1], [FG2], [FG3], [FG4], [FG5], [PRIMARY]);
GO

-- Create fact table.
CREATE TABLE dbo.f_sales 
(date_key INT NOT NULL, 
 cust_key INT, 
 store_key INT, 
 amt MONEY) 
ON PS1(date_key);
GO

-- Populate data into table f_sales. 
SET NOCOUNT ON
GO

DECLARE @d INT, @ds INT, 
        @cs INT, @s INT

SET @d = 20060101
SET @ds = 7  -- date_key increment step

WHILE (@d <= 20061231) 
 BEGIN
  
  WHILE @d%100 > 0 AND @d%100 < 29
   BEGIN
    
	SET @cs = 10  -- # of records for customer/store for that date
    SET @s = CAST ( RAND() * 1000 as INT )
    
	WHILE (@cs > 0)
     BEGIN

       INSERT dbo.f_sales (date_key, cust_key, store_key, amt)
       VALUES (@d, CAST ( RAND() * 1000 as INT ), @s, CAST ( RAND() * 1000 as MONEY ) )

       SET @cs = @cs - 1
     END

    SET @d = @d + @ds
   
   END

  SET @d = @d + @ds
 END
GO


-- The table with clustered index is partitioned using the partition scheme specified.
CREATE CLUSTERED INDEX UCIdx_f_sales on dbo.f_sales 
(date_key, 
 cust_key, 
 store_key) 
ON PS1(date_key)
GO

--Create indexed view, which aggregates on the date and store.
CREATE VIEW dbo.v_f_sales_sumamt 
WITH SCHEMABINDING 
AS
(
 SELECT date_key, store_key, 
        sum(ISNULL(amt,0)) AS amt, 
		count_big(*) AS cnt
 FROM dbo.f_sales AS sales
 GROUP BY date_key, store_key
)
GO

-- Materialize the view. The indexed view is now partition-aligned with table f_sales.
CREATE UNIQUE CLUSTERED INDEX ucidx_v_sales_sum ON dbo.v_f_sales_sumamt 
 (date_key) 
ON PS1(date_key)
GO

-- Check data distribution in various partitions of the table & the indexed view.
SELECT OBJECT_NAME(p.object_id) as obj_name, 
       p.index_id, 
	   p.partition_number, 
	   p.rows, a.type, 
	   a.filegroup_id 
FROM sys.system_internals_allocation_units a Inner JOIN sys.partitions p
                                              ON p.partition_id = a.container_id
WHERE p.object_id IN (OBJECT_ID(N'dbo.f_sales'), OBJECT_ID(N'dbo.v_f_sales_sumamt '))
ORDER BY obj_name, p.index_id, p.partition_number

-- Create archive table to receive the partition that will be switched out of table f_sales. 
CREATE TABLE dbo.sales_archive 
(date_key INT NOT NULL, 
 cust_key INT, 
 store_key INT, 
 amt MONEY) 
ON FG1
GO

CREATE CLUSTERED INDEX UCIdx_sales_archive on dbo.sales_archive 
 (date_key, 
  cust_key, 
  store_key) 
ON FG1
GO

--Create indexed view with view definition matching v_f_sales_sumamt on table f_sales.
CREATE VIEW dbo.v_sales_archive_sumamt 
WITH SCHEMABINDING AS
(
 SELECT date_key, 
        store_key, 
		sum(ISNULL(amt,0)) AS amt, 
		count_big(*) AS cnt
 FROM dbo.sales_archive AS sales
 GROUP BY date_key, store_key
)
GO

-- Materialize the view. The indexed view is partition-aligned with table sales_archive.
CREATE UNIQUE CLUSTERED INDEX ucidx_v_sales_sum ON dbo.v_sales_archive_sumamt
 (date_key) 
ON FG1
GO

-- Check data distribution in various partitions of the table and the indexed view. 
SELECT OBJECT_NAME(p.object_id) as obj_name, 
       p.index_id, 
	   p.partition_number, 
	   p.rows, 
	   a.type, 
	   a.filegroup_id 
FROM sys.system_internals_allocation_units a Inner JOIN sys.partitions p
                                              ON p.partition_id = a.container_id
WHERE p.object_id IN (OBJECT_ID(N'dbo.sales_archive'), OBJECT_ID(N'dbo.v_sales_archive_sumamt '))
ORDER BY obj_name, p.index_id, p.partition_number

-- Data associated with the old partition of the source table - [f_sales] and the indexed view [v_f_sales_sumamt] - 
-- is switched out to archive table [sales_archive] and the indexed view [v_sales_archive_sumamt].
ALTER TABLE dbo.f_sales 
 SWITCH PARTITION 1 TO dbo.sales_archive

-- Data distribution in various partitions shows that 
-- partition 1 of [f_sales] and the indexed view [v_f_sales_sumamt] are now empty 
-- and these rows are now in [sales_archive] and [v_sales_archive_sumamt], respectively.
SELECT OBJECT_NAME(p.object_id) as obj_name, 
       p.index_id, 
	   p.partition_number, 
	   p.rows, 
	   a.type, 
	   a.filegroup_id 
FROM sys.system_internals_allocation_units a Inner JOIN sys.partitions p
                                              ON p.partition_id = a.container_id
WHERE p.object_id IN (OBJECT_ID(N'dbo.sales_archive'), 
                      OBJECT_ID(N'dbo.v_sales_archive_sumamt '), 
                      OBJECT_ID(N'dbo.f_sales'), 
					  OBJECT_ID(N'dbo.v_f_sales_sumamt '))
ORDER BY obj_name, p.index_id, p.partition_number

-- This query runs against the table [f_sales]
SELECT date_key, 
       store_key AS [Store Number], 
	   sum(ISNULL(amt,0)) AS Sales_Amount
FROM dbo.f_sales
WHERE date_key >= '20060701' AND date_key < '20060801'
GROUP BY date_key, store_key
ORDER BY date_key, store_key
OPTION (EXPAND VIEWS)

-- This query runs against the indexed view [v_f_sales_sumamt]
-- the result of this query is the same as the one against the table
-- the indexed view materializes the pre-calculated aggregate, resulting in significant improvements in query performance   
SELECT date_key, 
       store_key AS [Store Number], 
	   sum(ISNULL(amt,0)) AS Sales_Amount
FROM dbo.v_f_sales_sumamt WITH (NOEXPAND)
WHERE date_key >= '20060701' AND date_key < '20060801'
GROUP BY date_key, store_key