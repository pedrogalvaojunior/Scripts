-- SQLSaturday 945 Chicago 2020
-- Fabiano Amorim
-- http:\\www.blogfabiano.com | fabianonevesamorim@hotmail.com

/*
USE [Stage1]
GO
-- Check Table1_2GB size in MB and number of pages...
SELECT Object_Name(p.Object_Id) As TabName,
       I.Name As IndexName, 
       Total_Pages AS TotPages,
       Total_Pages * 8 / 1024.00 As SizeInMB
  FROM sys.Partitions AS P
 INNER JOIN sys.Allocation_Units AS A 
    ON P.Hobt_Id = A.Container_Id
 INNER JOIN sys.Indexes AS I 
    ON P.object_id = I.object_id 
   AND P.index_id = I.index_id
 WHERE p.Object_Id = Object_Id('Table1_2GB')
*/

-- Check clerks
-- MEMORYCLERK_SQLBUFFERPOOL is using some GBs... so, there are some data already in cache...
SELECT TOP (50)
       mc.[type] AS [Memory Clerk Type],
       CAST((SUM(mc.pages_kb) / 1024.0) AS DECIMAL(15, 2)) AS [Memory Usage (MB)]
  FROM sys.dm_os_memory_clerks AS mc WITH (NOLOCK)
 GROUP BY mc.[type]
 ORDER BY SUM(mc.pages_kb) DESC;
GO


USE Stage1
GO
-- Considering Table1_2GB is not in cache...  
-- How much time would it take to read this 2GB table (Table1_2GB) from disk? ...
SET STATISTICS IO, TIME ON
SELECT COUNT(*) FROM Stage1.dbo.Table1_2GB
OPTION (MAXDOP 1)
SET STATISTICS IO, TIME OFF
GO

/*
  While query is running go to following notes...

  Bonus info, let's do some math:

  QO fixed cost for random disk I/O is 0.003125, 1 sec / 320 IOPS
    Let's consider a worst case scenario where QP will trigger I/Os of 8KB (page size)...
    So, no read-ahead and other I/O features QP can use...
    In 1 second, it will be able to do 320 I/Os, 320 * 8KB = 2.5MB per second...
 
  Sequential fixed cost is 0.00074074, 1 sec / 1350 IOPS
    In 1 second, it will be able to do 1350 I/Os, 320 * 8KB = 10.54MB per second...

  Table1_2GB has aprox. 256001 pages and since this is doing a serial TableScan, 
    QO is considering will do all sequential I/Os
    that is 256001 * 0.00074074 = 189.63 which is very close to estimated I/O cost shown on execution plan...
  Another way to translate it to time, 256001 / 1350. = 189.63...
    If 1350 IO/s take 1 second, 256001 IO/s will take 166 seconds...

  But wait, my SSD (data physical location) can do a lot more than 1350 IOPS...
    those fixed costs are very outdated as they're based in an old hardware...
    According to the manufacturer I can do 145,000 IOPS on my Lite-on NVMe SSD
  So it should take 1.76(256001 / 145000.) seconds to read the data...
  Now let's see how much time it took...
*/

-- Avg of 80 seconds to read 2GB from disk? What a hell? 


-- So, now this is in cache, right? Let's try to read it again... 
-- Logical reads? 
SET STATISTICS IO, TIME ON
SELECT COUNT(*) FROM Stage1.dbo.Table1_2GB
OPTION (MAXDOP 1)
SET STATISTICS IO, TIME OFF
GO

-- Ok, now let's force a physical read again... 

DBCC DROPCLEANBUFFERS; 
GO

-- Physical read, correct? how much time this will take? another 80 seconds? 
SET STATISTICS IO, TIME ON
SELECT COUNT(*) FROM Stage1.dbo.Table1_2GB
OPTION (MAXDOP 1)
SET STATISTICS IO, TIME OFF
GO

-- Wow, now it took 1.3 seconds to do the pysical I/Os, so, what is going on here? 
-- Why sometimes it is taking so much time to run? 

