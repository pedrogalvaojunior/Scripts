-- SQLSaturday 945 Chicago 2020
-- Fabiano Amorim
-- http:\\www.blogfabiano.com | fabianonevesamorim@hotmail.com


/*
-----------------------------------------------------------

  Scenario:
  I've a SQL instance with 10GB of memory, but when I try to read
  a table that should fit in memory, sometimes SQL is doing a
  physical read instead of a logical read...

-----------------------------------------------------------
*/

-- How much memory avaiable to SQL? 10GB
SELECT description, value_in_use 
  FROM sys.configurations
 WHERE name = 'max server memory (MB)'
GO

-- Read tables Products4GB_1 and Products4GB_2... Approximately 8GB of data...
-- Physical reads right, first time we're reading those tables...
USE DBMemory2;
GO
SET STATISTICS IO, TIME ON
SELECT COUNT(*) FROM dbo.Products4GB_1
SELECT COUNT(*) FROM dbo.Products4GB_2
SET STATISTICS IO, TIME OFF
--Table 'Products4GB_1'. Scan count 13, logical reads 538318, physical reads 2, read-ahead reads 512816, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
--Table 'Products4GB_2'. Scan count 13, logical reads 541402, physical reads 2, read-ahead reads 512811, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
--SQL Server Execution Times:
  --CPU time = 1326 ms,  elapsed time = 1538 ms.
GO

-- Read tables again, logical reads right? MaxServerMemory is set to 10GB...
USE DBMemory2;
GO
SET STATISTICS IO, TIME ON
SELECT COUNT(*) FROM dbo.Products4GB_1
SELECT COUNT(*) FROM dbo.Products4GB_2
SET STATISTICS IO, TIME OFF
GO


-- Wait, why this is still doing physical reads?
-- Isn't it storing data in cache? 

-- Let's try to read it again... 
USE DBMemory2;
GO
SET STATISTICS IO, TIME ON
SELECT COUNT(*) FROM dbo.Products4GB_1
SELECT COUNT(*) FROM dbo.Products4GB_2
SET STATISTICS IO, TIME OFF
GO


-- What's going on here?...



-- What BP data cache looks like?
SELECT DB_NAME(database_id) AS [Database Name],
       CAST(COUNT(*) * 8 / 1024.0 AS DECIMAL(10, 2)) AS [CachedSizeMB],
       COUNT(page_id) AS PageCount
  FROM sys.dm_os_buffer_descriptors WITH (NOLOCK)
 WHERE DB_NAME(database_id) IS NOT NULL
 GROUP BY DB_NAME(database_id)
 ORDER BY COUNT(page_id) DESC
GO
-- No other clerks using the memory... In fact, there is memory available... 
SELECT TOP (50)
       mc.[type] AS [Memory Clerk Type],
       CAST((SUM(mc.pages_kb) / 1024.0) AS DECIMAL(15, 2)) AS [Memory Usage (MB)]
  FROM sys.dm_os_memory_clerks AS mc WITH (NOLOCK)
 GROUP BY mc.[type]
 ORDER BY SUM(mc.pages_kb) DESC;
GO


-- It is not possible, let's try again... 
USE DBMemory2;
GO
SET STATISTICS IO, TIME ON
SELECT COUNT(*) FROM dbo.Products4GB_1
SELECT COUNT(*) FROM dbo.Products4GB_2
SET STATISTICS IO, TIME OFF
GO