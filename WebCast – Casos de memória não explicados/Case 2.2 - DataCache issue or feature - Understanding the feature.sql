-- SQLSaturday 945 Chicago 2020
-- Fabiano Amorim
-- http:\\www.blogfabiano.com | fabianonevesamorim@hotmail.com

-- Start demo with a cold cache
EXEC xp_cmdShell 'net stop MSSQL$SQL2017 && net start MSSQL$SQL2017'
GO
SELECT 1
GO


-- What BP data cache looks like?
SELECT DB_NAME(database_id) AS [Database Name],
       CAST(COUNT(*) * 8 / 1024.0 AS DECIMAL(10, 2)) AS [CachedSizeMB],
       COUNT(page_id) AS PageCount
  FROM sys.dm_os_buffer_descriptors WITH (NOLOCK)
 WHERE DB_NAME(database_id) IS NOT NULL
 GROUP BY DB_NAME(database_id)
 ORDER BY COUNT(page_id) DESC
GO
-- Check clerks
SELECT TOP (50)
       mc.[type] AS [Memory Clerk Type],
       CAST((SUM(mc.pages_kb) / 1024.0) AS DECIMAL(15, 2)) AS [Memory Usage (MB)]
  FROM sys.dm_os_memory_clerks AS mc WITH (NOLOCK)
 GROUP BY mc.[type]
 ORDER BY SUM(mc.pages_kb) DESC;
GO

-- Approximately 2 seconds to run
-- Read 3 tables with 900MB (put a total of 2.7GB in cache...)
USE DBMemory1;
GO
SET STATISTICS IO ON
SELECT COUNT(*) FROM dbo.Products1 OPTION (MAXDOP 1)
SELECT COUNT(*) FROM dbo.Products2 OPTION (MAXDOP 1)
SELECT COUNT(*) FROM dbo.Products3 OPTION (MAXDOP 1)
SET STATISTICS IO OFF
GO

-- What BP data cache looks like?
SELECT DB_NAME(database_id) AS [Database Name],
       CAST(COUNT(*) * 8 / 1024.0 AS DECIMAL(10, 2)) AS [CachedSizeMB],
       COUNT(page_id) AS PageCount
  FROM sys.dm_os_buffer_descriptors WITH (NOLOCK)
 WHERE DB_NAME(database_id) IS NOT NULL
 GROUP BY DB_NAME(database_id)
 ORDER BY COUNT(page_id) DESC
GO
-- Check clerks
SELECT TOP (50)
       mc.[type] AS [Memory Clerk Type],
       CAST((SUM(mc.pages_kb) / 1024.0) AS DECIMAL(15, 2)) AS [Memory Usage (MB)]
  FROM sys.dm_os_memory_clerks AS mc WITH (NOLOCK)
 GROUP BY mc.[type]
 ORDER BY SUM(mc.pages_kb) DESC;
GO

-- 2.7GB of data on MEMORYCLERK_SQLBUFFERPOOL... 
-- There is not enough memory to keep all 2.7GB plus the 8GB we're about to read...  
-- So, something will have to be removed from cache to give space for the new pages...

/*
   Note: There are a lot of variants (latch promotion of a page accessed more than 2k times 
   in a second, and number of access of a page, just to mention a couple) 
   on the SQL buffer pool replacement algorithm to be considered...
   I'll not consider all of those... one because I don't know it and two because it would make this 
   demo very complex... 
  
   In theory the pages with latest "time of last access" identification are the first in line 
   for eviction from the buffer pool... Every page in memory has a bUse1 field that is used 
   to track the "time of last access" of a page in memory... 
   that means pages of tables Products1, 2 and 3 should be removed, since they were the objects
   we read first, therefore with oldest last acessed "mark"/timestamp... 
*/

USE DBMemory2;
GO
SET STATISTICS IO, TIME ON
SELECT COUNT(*) FROM dbo.Products4GB_1
SELECT COUNT(*) FROM dbo.Products4GB_2
SET STATISTICS IO, TIME OFF
GO


-- 2.7GB of BP data cache usage of DBMemory1 is still there... 
-- pages were not removed...
SELECT DB_NAME(database_id) AS [Database Name],
       CAST(COUNT(*) * 8 / 1024.0 AS DECIMAL(10, 2)) AS [CachedSizeMB],
       COUNT(page_id) AS PageCount
  FROM sys.dm_os_buffer_descriptors WITH (NOLOCK)
 WHERE DB_NAME(database_id) IS NOT NULL
 GROUP BY DB_NAME(database_id)
 ORDER BY COUNT(page_id) DESC
GO



-- Explanation... 
-- https://www.sqlskills.com/blogs/paul/buffer-pool-disfavoring/
-- Large table scans that are more than 10% of the buffer pool size will disfavor pages 
-- instead of forcing pages from other databases to be flushed from memory



-- That means, pages read on Products4GB_1 scan are disfavored 
-- The last "Last time of access" ("bUse1" field in the BUF structure) of a disfavored page 
-- is set to 1 hour in the past... 
-- That means those pages are most likely to be removed from cache in a BP pressure...

-- Read tables Products4GB_1 and Products4GB_1 again will always do 
-- a physical read, unless you wait for one hour to make "bUse1" field of pages related to 
-- Products1, 2 and 3 to be older than a hour... 
USE DBMemory2;
GO
SET STATISTICS IO, TIME ON
SELECT COUNT(*) FROM dbo.Products4GB_1
SELECT COUNT(*) FROM dbo.Products4GB_2
SET STATISTICS IO, TIME OFF
GO


-- Note 1: Extended Event leaf_page_disfavored can tell you that a page was disfavored

-- Note 2: Query processor has to know in advance that it will read a table greater 
-- than 10% of max server memory, that means you can fake it :-( and therefore disable disfavoring 
-- for those page reads... Pleas don't :-)
/*
USE DBMemory2;
GO
UPDATE STATISTICS Products4GB_1 WITH ROWCOUNT = 1, PAGECOUNT = 1
UPDATE STATISTICS Products4GB_2 WITH ROWCOUNT = 1, PAGECOUNT = 1
GO
-- Reset values
DBCC UPDATEUSAGE (DBMemory2,'Products4GB_1') WITH COUNT_ROWS;
DBCC UPDATEUSAGE (DBMemory2,'Products4GB_2') WITH COUNT_ROWS;
GO
*/

/*

  If time allows... Show internals...

*/

USE master
GO
CHECKPOINT; DBCC DROPCLEANBUFFERS; DBCC FREEPROCCACHE()
GO


-- Read some pages of a table that will not trigger page read disfavoring
SELECT COUNT(*) FROM DBMemory1.dbo.Products1
GO

-- Vejamos o BUF com último acesso (bUse1)...

-- Get a any page_id (allocated_page_page_id)...
SELECT TOP 5 database_id, DB_NAME(database_id) as [Database], 
             OBJECT_NAME(object_id, DB_ID('DBMemory1')) AS ObjName, allocated_page_page_id , page_type_desc
FROM sys.dm_db_database_page_allocations(DB_ID('DBMemory1'), OBJECT_ID('DBMemory1.dbo.Products1'), NULL, NULL, 'Detailed')
GO

-- Check if page_id is in BP data cache
SELECT * FROM sys.dm_os_buffer_descriptors
WHERE database_id = DB_ID('DBMemory1')
AND page_id = 131512
GO

-- Read page and check BUF info, notice bUse1 field...
DBCC TRACEON(3604)
DBCC PAGE (10, 1, 131512, 3)
GO

-- Save BUF hexa 0x000001DEFD13C0C0 as we'll use it later... 
-- bUse1 = 9842


-- Date on sys.dm_os_sys_info.ms_ticks (specifies the number of milliseconds since the computer started) 
-- is used to calculate the bUse1, ...  
-- ms_ticks value rolls over every 65,536 seconds, so to know when computer was last restarted we can use
-- the following command:
-- Based on current GetDate(), decrease N seconds... 

SELECT DATEADD(SECOND, ((((ms_ticks) % 65536000) / 1000) * -1), GETDATE()) ms_ticks_count_starting_time 
FROM sys.dm_os_sys_info
GO

-- If we add the number of seconds saved on the bUse1 field on this computer restart date
-- we'll have the "time of last access" page information
DECLARE @dtComputerStart DATETIME,
        @bUse1 INT = 5550

SELECT @dtComputerStart = DATEADD(SECOND, ((((ms_ticks) % 65536000) / 1000) * -1), GETDATE()) FROM sys.dm_os_sys_info
SELECT DATEADD(SECOND, @bUse1, @dtComputerStart) AS DtLastAccess
GO

-- What is the value of bUse1 filed on WinDbg dump, ? 

dp 0x000002748FE17080 -- BUF
? 0xhexa -- to convert hexa to decimal on windbg  ... 

/*
  0:073> dp 0x000002748FE17080
  00000274`8fe17080  00000273`cba3a000 00000000`00000000
  00000274`8fe17090  00000274`8fe16fd0 00000000`00000000
  00000274`8fe170a0  00000000`00000000 00080001`000201b8
  00000274`8fe170b0  00000274`80d80040 00000009`0000000a
  00000274`8fe170c0  00000000`00000000 15ab215a`0000079e
  00000274`8fe170d0  00000000`00000000 00000000`00000000
  00000274`8fe170e0  00000000`00000000 00000000`00000bbc
  00000274`8fe170f0  00000000`00000000 00000000`00000000
*/


-- Converting 0x079e to Int
SELECT CONVERT(INT, 0x079e) -- 1950 
GO



-- What was last access of the page? 
DECLARE @dtComputerStart DATETIME,
        @bUse1 INT = 1950

SELECT @dtComputerStart = DATEADD(SECOND, ((((ms_ticks) % 65536000) / 1000) * -1), GETDATE()) FROM sys.dm_os_sys_info
SELECT DATEADD(SECOND, @bUse1, @dtComputerStart) AS DtLastAccess
GO
-- Wait, but DBMemory1.dbo.Products1 table should NOT trigger disfavoring... 
-- Yeah, but DBCC PAGE does, so when we ran DBCC PAGE to check the BUF, 
-- the page was disfavored... 


-- Now we know the BUF, if we read the page again we'll see the 
-- correct "time of last access" page information
-- Read all pages of table DBMemory1.dbo.Products1
SELECT COUNT(*) FROM DBMemory1.dbo.Products1
GO



-- What now, what is the value of bUse1 on BUF dump?
dp 0x000002748FE17080 -- BUF

/*
  0:105> dp 0x000002748FE17080
  00000274`8fe17080  00000273`cba3a000 00000000`00000000
  00000274`8fe17090  00000274`8fe16fd0 00000000`00000000
  00000274`8fe170a0  00000000`00000000 00080001`000201b8
  00000274`8fe170b0  00000274`80d80040 00000009`0000000a
  00000274`8fe170c0  00000000`00000000 15ab215a`0000171d
  00000274`8fe170d0  00000000`00000000 00000000`00000000
  00000274`8fe170e0  00000000`00000000 00000000`00000bbc
  00000274`8fe170f0  00000000`00000000 00000000`00000000
*/


-- Converting 0x171d to Int
SELECT CONVERT(INT, 0x171d) -- 5917 
GO

-- Now I can see the correct value...
DECLARE @dtComputerStart DATETIME,
        @bUse1 INT = 5917

SELECT @dtComputerStart = DATEADD(SECOND, ((((ms_ticks) % 65536000) / 1000) * -1), GETDATE()) FROM sys.dm_os_sys_info
SELECT DATEADD(SECOND, @bUse1, @dtComputerStart) AS DtLastAccess
GO


USE DBMemory1;
GO
-- Update table statistic to a big number to make QP trigger disfavoring for this table...
UPDATE STATISTICS Products1 WITH ROWCOUNT = 1000000000, PAGECOUNT = 5120000
GO

-- Now since QO thinks this is greater than 10% of max server memory, it will trigger 
-- page disfavoring and set bUse1 back to 1 hour...
SELECT COUNT(*) FROM DBMemory1.dbo.Products1
GO

-- Check value of bUse1 on BUF dump...
dp 0x000002748FE17080 -- BUF

/*
  0:111> dp 0x000002748FE17080
  00000274`8fe17080  00000273`cba3a000 00000000`00000000
  00000274`8fe17090  00000274`8fe16fd0 00000000`00000000
  00000274`8fe170a0  00000000`00000000 00080001`000201b8
  00000274`8fe170b0  00000274`80d80040 00000009`0000000a
  00000274`8fe170c0  00000000`00000000 15ab215a`00000a11
  00000274`8fe170d0  00000000`00000000 00000000`00000000
  00000274`8fe170e0  00000000`00000000 00000000`00000bbc
  00000274`8fe170f0  00000000`00000000 00000000`00000000
*/


-- Converting 0x0a11 to Int
SELECT CONVERT(INT, 0x0a11) -- 5917 
GO

-- As you can see, on this read, bUse1 was set to 1 hour ago...
DECLARE @dtComputerStart DATETIME,
        @bUse1 INT = 2577

SELECT @dtComputerStart = DATEADD(SECOND, ((((ms_ticks) % 65536000) / 1000) * -1), GETDATE()) FROM sys.dm_os_sys_info
SELECT DATEADD(SECOND, @bUse1, @dtComputerStart) AS DtLastAccess
GO

-- Reset values
DBCC UPDATEUSAGE (DBMemory1,'Products1') WITH COUNT_ROWS;
GO

