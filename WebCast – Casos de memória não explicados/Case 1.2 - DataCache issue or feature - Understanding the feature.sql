-- SQLSaturday 945 Chicago 2020
-- Fabiano Amorim
-- http:\\www.blogfabiano.com | fabianonevesamorim@hotmail.com

/*
-----------------------------------------------------------

  Scenario:
  A smart developer read an article mentioning that on SQL2014 an insert in a 
  table on tempdb is a lot faster then an insert on a user DB... 
  After run some tests, he decided to store all staging tables
  on tempdb, since it is a staging area, they can easily re-create the tables if needed.

  This change improved a lot the staging load process as they were 
  truncating/loading the data in a daily basis...

  But, after they change it, they've noticed some weird slowness 
  in certain queries...

-----------------------------------------------------------
*/


-- Cold cache
-- Restart SQL2017
EXEC xp_cmdShell 'net stop MSSQL$SQL2017 && net start MSSQL$SQL2017'
GO
SELECT 1
GO

-- Test 1... "Normal" insert without tablock take 65 seconds to run...
-- Note for Fabiano: This is optional 
--                   Just make sure you show the lack of TABLOCK which will trigger 
--                   an fully logged operation
/*
USE Stage1
GO

-- While it is running ... 
-- Notice on ResourceMonitor that there are writes on ldf and mdf files
-- Capture dm_io_virtual_file_stats snapshot
DROP TABLE IF EXISTS #tmp1
SELECT
    data_write = SUM(CASE DBF.[type_desc] WHEN 'ROWS' THEN num_of_bytes_written ELSE 0 END), 
    log_write  = SUM(CASE DBF.[type_desc] WHEN 'LOG' THEN num_of_bytes_written ELSE 0 END)
INTO #tmp1
FROM Stage1.sys.database_files AS DBF
JOIN sys.dm_io_virtual_file_stats(NULL, NULL) AS FS
    ON FS.[file_id] = DBF.[file_id]
WHERE fs.database_id IN (DB_ID('Stage1'), DB_ID('tempdb'))

-- Test 1 - "Normal" insert...
-- Takes avg of 65 seconds to run and writes 3.6GB into log file
TRUNCATE TABLE Stage1.dbo.TabStage1

SET STATISTICS TIME ON
INSERT INTO Stage1.dbo.TabStage1
SELECT TOP 5500000
       A.ProductName
FROM Northwind.dbo.Products A,
     Northwind.dbo.Products B,
     Northwind.dbo.Products c,
     Northwind.dbo.Products d
OPTION (MAXDOP 1);
SET STATISTICS TIME OFF
GO

-- Compare dm_io_virtual_file_stats with snapshot to see what changed...
SELECT
    data_write_MB = (SUM(CASE DBF.[type_desc] WHEN 'ROWS' THEN num_of_bytes_written ELSE 0 END) - #tmp1.data_write) / 1024. / 1024., 
    log_write_MB = (SUM(CASE DBF.[type_desc] WHEN 'LOG' THEN num_of_bytes_written ELSE 0 END) - #tmp1.log_write) / 1024. / 1024.
FROM Stage1.sys.database_files AS DBF
JOIN sys.dm_io_virtual_file_stats(NULL, NULL) AS FS
    ON FS.[file_id] = DBF.[file_id]
CROSS JOIN #tmp1
WHERE fs.database_id IN (DB_ID('Stage1'), DB_ID('tempdb'))
GROUP BY #tmp1.data_write, #tmp1.log_write
GO
*/


-- Test 2 - insert with tablock, 
-- Does a lot less writes on ldf file as this is a minimally logged operation
-- Takes avg of 27 seconds to run and writes 33mb into log file
USE Stage1
GO

-- While it is running ... Notice on ResourceMonitor that there are writes on ldf and mdf files 
-- Capture dm_io_virtual_file_stats snapshot
DROP TABLE IF EXISTS #tmp1
SELECT
    data_write = SUM(CASE DBF.[type_desc] WHEN 'ROWS' THEN num_of_bytes_written ELSE 0 END), 
    log_write  = SUM(CASE DBF.[type_desc] WHEN 'LOG' THEN num_of_bytes_written ELSE 0 END)
INTO #tmp1
FROM Stage1.sys.database_files AS DBF
JOIN sys.dm_io_virtual_file_stats(NULL, NULL) AS FS
    ON FS.[file_id] = DBF.[file_id]
WHERE fs.database_id IN (DB_ID('Stage1'), DB_ID('tempdb'))

TRUNCATE TABLE Stage1.dbo.TabStage1

INSERT INTO Stage1.dbo.TabStage1 WITH(TABLOCK)
SELECT TOP 5500000
       A.ProductName
FROM Northwind.dbo.Products A,
     Northwind.dbo.Products B,
     Northwind.dbo.Products c,
     Northwind.dbo.Products d
OPTION (MAXDOP 1);
GO

-- Compare dm_io_virtual_file_stats with snapshot to see what changed...
SELECT
    data_write_MB = (SUM(CASE DBF.[type_desc] WHEN 'ROWS' THEN num_of_bytes_written ELSE 0 END) - #tmp1.data_write) / 1024. / 1024., 
    log_write_MB = (SUM(CASE DBF.[type_desc] WHEN 'LOG' THEN num_of_bytes_written ELSE 0 END) - #tmp1.log_write) / 1024. / 1024.
FROM Stage1.sys.database_files AS DBF
JOIN sys.dm_io_virtual_file_stats(NULL, NULL) AS FS
    ON FS.[file_id] = DBF.[file_id]
CROSS JOIN #tmp1
WHERE fs.database_id IN (DB_ID('Stage1'), DB_ID('tempdb'))
GROUP BY #tmp1.data_write, #tmp1.log_write
GO


-- Question... why this is showing writes on MDF file? 
-- Shouldn't this only be done on checkpoint or lazywriter ?... 
-- Since it is doing writes on data file, does it mean checkpoint is being called while query is executed?
-- Let's try again and while it runs, let's monitor checkpoint using TF3502


-- Force checkpoint to have a cold scenario... 
CHECKPOINT;
GO
-- Enabling tf3502 to write checkpoint info on errorlog 
dbcc traceon(3605, 3502, -1);
GO
-- cycle errorlog for next easy read
exec sp_cycle_errorlog;
go

-- Running insert...
-- Test 2 - Insert+Select with TABLOCK()...
TRUNCATE TABLE Stage1.dbo.TabStage1

INSERT INTO Stage1.dbo.TabStage1 WITH(TABLOCK)
SELECT TOP 5500000
       A.ProductName
FROM Northwind.dbo.Products A,
     Northwind.dbo.Products B,
     Northwind.dbo.Products c,
     Northwind.dbo.Products d
OPTION (MAXDOP 1);

-- Reading the error log file
exec xp_readerrorlog;

GO
dbcc traceoff(3605, 3502, -1);
GO

-- No checkpoint messages... 
-- Eager writer is the one flushing the data to mdf file...
-- Let's run it again and monitor eager writer using TF3917


-- Enabling tf3917 to write info about eagerwriter to errorlog 
dbcc traceon(3605, 3917, -1);
GO
-- cycle errorlog for next easy read
exec sp_cycle_errorlog;
go

-- Running insert...
-- Test 2 - Insert+Select with TABLOCK()...
TRUNCATE TABLE Stage1.dbo.TabStage1

INSERT INTO Stage1.dbo.TabStage1 WITH(TABLOCK)
SELECT TOP 5500000
       A.ProductName
FROM Northwind.dbo.Products A,
     Northwind.dbo.Products B,
     Northwind.dbo.Products c,
     Northwind.dbo.Products d
OPTION (MAXDOP 1);

-- Reading the error log file
exec xp_readerrorlog;

GO
dbcc traceoff(3605, 3917, -1);
GO
/*
  ...
  PageFlushMgr 000001D6430AA4D0 eager flushed 128 pages starting at 1:462112 while still managed. 
  PageFlushMgr 000001D6430AA4D0 retrying search loop after trying without handoff.
  PageFlushMgr 000001D6430AA4D0 eager flushed 128 pages starting at 1:462240 while still managed. 
  PageFlushMgr 000001D6430AA4D0 retrying search loop after trying without handoff.
  PageFlushMgr 000001D6430AA4D0 eager flushed 128 pages starting at 1:462368 while still managed. 
  PageFlushMgr 000001D6430AA4D0 FlushAll() with 4096 owned, 0 spilled, 329238 handoffs, 333192 eagerWrites, and 0 formats.
*/

-- So, eager writer is helping LW/Checkpoint and is flushing those new/dirty pages on mdf file...
-- No need to wait for checkpoint or indirect checkpoint(background writer)...


-- But what if we run this insert using a table on tempdb DB? 
-- How does it work? Is there a checkpoint on tempdb?  
-- Is there any need to flush tempdb pages to mdf? Remember, there is no recovery need for tempdb data... 
-- Will SQL spend time flushing those pages in a tempdb table? 
-- Let's give it a try... 


-- Before we run the test with tempdb table let's 
-- put some data in cache... 
-- We'll need it later to simulate the issue we saw earlier...
USE Stage1
GO
CHECKPOINT; DBCC DROPCLEANBUFFERS; DBCC FREEPROCCACHE()
GO
-- 35 seconds to read tables... 
SET STATISTICS IO, TIME ON
SELECT COUNT(*) FROM Stage1.dbo.Table1_2GB OPTION (MAXDOP 1)
SELECT COUNT(*) FROM Stage1.dbo.Table2_2GB OPTION (MAXDOP 1)
SELECT COUNT(*) FROM Stage1.dbo.Table3_2GB OPTION (MAXDOP 1)
SELECT COUNT(*) FROM Stage1.dbo.Table4_2GB OPTION (MAXDOP 1)
SET STATISTICS IO, TIME OFF

-- Checking dm_os_buffer_descriptors
SELECT DB_NAME(database_id) AS [Database Name],
       CAST(COUNT(*) * 8 / 1024.0 AS DECIMAL(10, 2)) AS [CachedSizeMB],
       COUNT(page_id) AS PageCount
  FROM sys.dm_os_buffer_descriptors WITH (NOLOCK)
 GROUP BY DB_NAME(database_id)
 ORDER BY 2 DESC
GO

-- Read tables again and you'll see a logical read...



-- Create a table to run tests...
-- Same table, only diff is that this is stored on tempdb
USE tempdb
GO

---------------------------------------------------------
---- Run the following code in a new session ------------
---------------------------------------------------------
DROP TABLE IF EXISTS #tmp1
SELECT
    data_write = SUM(CASE DBF.[type_desc] WHEN 'ROWS' THEN num_of_bytes_written ELSE 0 END), 
    log_write  = SUM(CASE DBF.[type_desc] WHEN 'LOG' THEN num_of_bytes_written ELSE 0 END)
INTO #tmp1
FROM Stage1.sys.database_files AS DBF
JOIN sys.dm_io_virtual_file_stats(NULL, NULL) AS FS
    ON FS.[file_id] = DBF.[file_id]
WHERE fs.database_id IN (DB_ID('Stage1'), DB_ID('tempdb'))

-- Test 3 - Insert+Select with TABLOCK() Tempdb table...
-- Takes avg of 2 seconds to run and writes 8MB into log file
DROP TABLE IF EXISTS #TabStage1;

SET STATISTICS TIME ON
SELECT TOP 5500000
       CONVERT(CHAR(500), A.ProductName) AS ProductName
INTO #TabStage1
FROM Northwind.dbo.Products A,
     Northwind.dbo.Products B,
     Northwind.dbo.Products c,
     Northwind.dbo.Products d
OPTION (MAXDOP 1);
SET STATISTICS TIME OFF

-- Compare dm_io_virtual_file_stats with snapshot to see what changed...
SELECT
    data_write_MB = (SUM(CASE DBF.[type_desc] WHEN 'ROWS' THEN num_of_bytes_written ELSE 0 END) - #tmp1.data_write) / 1024. / 1024., 
    log_write_MB = (SUM(CASE DBF.[type_desc] WHEN 'LOG' THEN num_of_bytes_written ELSE 0 END) - #tmp1.log_write) / 1024. / 1024.
FROM Stage1.sys.database_files AS DBF
JOIN sys.dm_io_virtual_file_stats(NULL, NULL) AS FS
    ON FS.[file_id] = DBF.[file_id]
CROSS JOIN #tmp1
WHERE fs.database_id IN (DB_ID('Stage1'), DB_ID('tempdb'))
GROUP BY #tmp1.data_write, #tmp1.log_write
GO

DROP TABLE IF EXISTS #TabStage1;
GO
-- Run a couple of more times to get an AVG and check the performance... 

-- Why this is faster?  
-- Noticed the almost ZERO data-write?




-- Explanation
-- https://blogs.msdn.microsoft.com/psssql/2014/04/09/sql-server-2014-tempdb-hidden-performance-gem/
-- On SQL2014, CU1 for SQL2012SP2 or CU10 for SQL2012SP1
-- Eager writing feature "relax" flush pages for minimal logged operations (insert+select+tablock, insert into, sort on tempdb...) 
-- on tempdb... pretty much an in-memory insert... 


-- BUT, that means those dirty pages will use buffer pool space... sometimes, A LOT of space...



-- Checking dm_os_buffer_descriptors
-- Noticed that tempdb is using some space... 
SELECT DB_NAME(database_id) AS [Database Name],
       CAST(COUNT(*) * 8 / 1024.0 AS DECIMAL(10, 2)) AS [CachedSizeMB],
       COUNT(page_id) AS PageCount
  FROM sys.dm_os_buffer_descriptors WITH (NOLOCK)
 GROUP BY DB_NAME(database_id)
 ORDER BY 2 DESC
GO

-- What will happen if I try to read Stage1.dbo.Table4_2GB again? This is in cache, right? 
-- Logical reads?
-- Note to Fabiano: if it doesn't do what you're expecting try  
--                  another Table1_2GB or Table2_2GB...
SET STATISTICS IO, TIME ON
SELECT COUNT(*) FROM Stage1.dbo.Table4_2GB
OPTION (MAXDOP 1)
SET STATISTICS IO, TIME OFF
GO
--Table 'Table4_2GB'. Scan count 1, logical reads 265000, physical reads 0, read-ahead reads 265000, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
-- SQL Server Execution Times:
--   CPU time = 437 ms,  elapsed time = 171663 ms.
GO

-- Not only a regular physical read, but your task will be put on sleep(SLEEP_TASK wait) while it wait for 
-- lazywriter to cleanup those dirty pages of tempdb and put them on freelist... 

-- Will show that you session is waiting...
SELECT * FROM sys.dm_os_waiting_tasks
WHERE session_id > 50
GO
-- You will see a bunch of write requests on tempdb data file...
SELECT * FROM sys.dm_io_pending_io_requests
GO

-- Also notice on perfmon that LW counter


-- If we run it again, now you'll see logical reads, right? since we just ran it... 
-- Note to Fabiano: if it doesn't do what you're expecting try  
--                  another Table1_2GB or Table2_2GB...
SET STATISTICS IO, TIME ON
SELECT COUNT(*) FROM Stage1.dbo.Table4_2GB
OPTION (MAXDOP 1)
SET STATISTICS IO, TIME OFF
GO
-- Wrong... more lazywrite cleanup... :-(

-- So, everytime lazywriter kicks in, you'll wait... 
-- In this case, things are slower because my tempdb is in a crappy disk (HDD)... 


-- I've spoke with Bob Ward and he confirmed that this is an area to improve in a future release...
-- Any non-logged “bulk” operation that qualifies for an “eager write” in tempdb is not a 
-- candidate to be flushed by the recovery writer (indirect checkpoint). 
-- The whole point is... Why is it LazyWriter flushing those pages that doesn't belong to an existing object ? 
-- It should be able to just put those in the freelist without flush it... 


-- Open "...\SQL Saturday945 - Chicago\Case 1.3 - BP usage.png" file...