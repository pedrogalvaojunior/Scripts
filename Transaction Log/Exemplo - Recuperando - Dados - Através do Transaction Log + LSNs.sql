--Create DB.
USE [master];
GO
CREATE DATABASE ReadingDBLog;
GO

-- Create tables.
USE ReadingDBLog;
GO
CREATE TABLE [Location] (
    [Sr.No] INT IDENTITY,
    [Date] DATETIME DEFAULT GETDATE (),
    [City] CHAR (25) DEFAULT 'Bangalore');


USE ReadingDBLog
go
INSERT INTO Location DEFAULT VALUES ;
GO 100


USE ReadingDBLog
Go
DELETE Location 
WHERE [Sr.No] < 10
go
select * from Location


use ReadingDBLog
go
SELECT 
 [Current LSN],    
 [Transaction ID],
     Operation,
     Context,
     AllocUnitName
    
FROM 
    fn_dblog(NULL, NULL) 
WHERE 
    Operation = 'LOP_DELETE_ROWS'



USE ReadingDBLog
go
SELECT
 [Current LSN],    
 Operation,
     [Transaction ID],
     [Begin Time],
     [Transaction Name],
     [Transaction SID]
FROM
    fn_dblog(NULL, NULL)
WHERE
    [Transaction ID] = '0000:0000055e'
AND
    [Operation] = 'LOP_BEGIN_XACT'


--Restoring Full backup with norecovery.
RESTORE DATABASE ReadingDBLog_COPY
    FROM DISK = 'C:\ReadingDBLog_FULL_15JAN2014.bak'
WITH
    MOVE 'ReadingDBlog' TO 'C:\ReadingDBLog.mdf',
    MOVE 'ReadingDBlog_log' TO 'C:\ReadingDBLog_log.ldf',
    REPLACE, NORECOVERY;
    
    GO

--Restore Log backup with STOPBEFOREMARK option to recover exact LSN.

   RESTORE LOG ReadingDBLog_COPY
FROM
    DISK = N'C:\ReadingDBlog_tlogbackup_15thJan610.trn'
WITH
    STOPBEFOREMARK = 'lsn:22000000042100001'



USE ReadingDBLog_COPY
GO
SELECT * from Location


USE ReadingDBLog
GO
DROP TABLE Location


USE ReadingDBLog
GO
SELECT 
[Current LSN],
Operation,
[Transaction Id],
[Transaction SID],
[Transaction Name],
 [Begin Time],
   [SPID],
   Description

FROM fn_dblog (NULL, NULL)
WHERE [Transaction Name] = 'DROPOBJ'
GO