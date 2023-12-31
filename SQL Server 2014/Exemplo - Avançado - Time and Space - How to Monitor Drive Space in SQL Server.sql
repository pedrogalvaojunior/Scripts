USE dba;
go

--create a table to capture daily drive space data
IF OBJECT_ID('dbo.DriveSpace', 'u') IS NOT NULL DROP TABLE dbo.DriveSpace;
CREATE TABLE dbo.DriveSpace (
  ID Integer not null IDENTITY (1, 1),
    CONSTRAINT DriveSpace_PK primary key clustered (ID),
  Drive Char(1) not null,
  Total Bigint not null,
  Free Bigint not null,
  EntryDate Datetime not null default GETDATE());
go

--create a table to store the drive letters and descriptions
IF OBJECT_ID('svr.ServerDrives', 'u') IS NOT NULL DROP TABLE svr.ServerDrives;
CREATE TABLE svr.ServerDrives (
  ID Integer not null IDENTITY (1, 1),
  CONSTRAINT ServerDrives_PK primary key clustered (ID),
  ServerName Varchar(128) not null,
  DriveLetter Char(1) not null,
  Description Varchar(32) not null,
  EntryDate Datetime not null DEFAULT GETDATE());
go

--populate the drives for this server. you'll need to adjust the drive letters
--and descriptions for your server.
INSERT INTO svr.ServerDrives(ServerName, DriveLetter, Description, EntryDate)
SELECT @@SERVERNAME, d.Letter, d.Description, GETDATE()
  FROM (VALUES('C', 'System'),
              ('D', 'Data'),
              ('L', 'Log'),
              ('R', 'Backup')
       ) d (Letter, Description)
  ORDER BY d.Letter;

IF OBJECT_ID('dbo.TrackDriveSpace', 'p') IS NOT NULL DROP PROCEDURE dbo.TrackDriveSpace;
go

CREATE PROCEDURE dbo.TrackDriveSpace
AS

  DECLARE @dtmNow Datetime = GETDATE();

BEGIN

  -----------------------------------------------------------------------------
  --initialization
  -----------------------------------------------------------------------------
  SET NOCOUNT ON;

  --create a temp table to capture our incoming rows from the dos command
  IF OBJECT_ID('tempdb.dbo.#incoming', 'u') IS NOT NULL DROP TABLE #incoming;
  CREATE TABLE #incoming (
    RawLine Varchar(255),
    N integer not null identity(1, 1));

  -----------------------------------------------------------------------------
  --shell out to dos and call wmic to get the disk space data needed
  -----------------------------------------------------------------------------
  INSERT INTO #incoming(rawline)
    EXECUTE xp_cmdshell 'wmic logicaldisk get deviceid,freespace,size';

  -----------------------------------------------------------------------------
  --extract the data and write the rows to the permanent table
  -----------------------------------------------------------------------------
  WITH cteHeader AS ( 
    --read our header row
    SELECT RawLine 
      FROM #incoming 
      WHERE N = 1
  ),
  cteStart AS (
    --determine the starting positions of each column to extract
    SELECT DriveStart = 1,
           FreeStart = CHARINDEX('FreeSpace', h.RawLine),
           TotalStart = CHARINDEX('Size', h.RawLine)
      FROM cteHeader h
  ),
  cteDriveInfo AS (
    --isolate each "column" of data, allowing for the return at the end of the last column
    SELECT Drive = SUBSTRING(i.RawLine, p.DriveStart, 1),
        FreeBytes = LTRIM(RTRIM(SUBSTRING(i.RawLine, p.FreeStart, p.TotalStart - p.FreeStart))),
        TotalBytes = RTRIM(LTRIM(RTRIM(REPLACE(SUBSTRING(i.Rawline, p.TotalStart, 99), CHAR(13), ''))))
      FROM #incoming i 
        CROSS APPLY cteStart p
      WHERE i.N > 1
        AND RawLine IS NOT NULL
        AND NOT SUBSTRING(RawLine, 3, 99) = REPLICATE(SUBSTRING(RawLine, 3, 99), ' ')
  )
  INSERT INTO dbo.DriveSpace(Drive, Total, Free, EntryDate)
    SELECT LOWER(Drive), CONVERT(Bigint, TotalBytes), CONVERT(Bigint, FreeBytes), @dtmNow
      FROM cteDriveInfo
      WHERE NOT TotalBytes = ''
      ORDER BY Drive;

  -----------------------------------------------------------------------------
  --termination
  -----------------------------------------------------------------------------
  DROP TABLE #incoming;
  
END;
go

--query to get the most recent picture of each monitored drive
WITH cteDrives AS (
  SELECT Drive, Total, Free, EntryDate, 
      ROW_NUMBER() OVER(PARTITION BY Drive ORDER BY EntryDate DESC) rn
    FROM dbo.DriveSpace 
),
cteRecent AS (
  SELECT Drive, Total, Free
    FROM cteDrives 
    WHERE rn = 1
)
SELECT sd.DriveLetter, sd.Description, 
    CONVERT(Numeric(18, 1), r.Total * 1.0 / POWER(1024, 3)) TotalGB, 
    CONVERT(Numeric(18, 1), r.Free  * 1.0 / POWER(1024, 3)) FreeGB,
    CONVERT(Numeric(18, 1), 100 - (r.Free * 100.0 / r.Total)) FreePercent
  FROM cteRecent r
    INNER JOIN svr.ServerDrives sd ON r.Drive = sd.DriveLetter 
  WHERE sd.ServerName = @@SERVERNAME
  ORDER BY sd.DriveLetter;

--query to get the most recent full run
WITH cteRecent AS (
  SELECT TOP 1 EntryDate
    FROM dbo.DriveSpace 
    ORDER BY EntryDate DESC
)
SELECT ds.Drive, 
    CONVERT(Numeric(18, 1), ds.Total * 1.0 / POWER(1024, 3)) TotalGB, 
    CONVERT(Numeric(18, 1), ds.Free  * 1.0 / POWER(1024, 3)) FreeGB,
    CONVERT(Numeric(18, 1), 100 - (ds.Free * 100.0 / ds.Total)) FreePercent
  FROM dbo.DriveSpace ds
    CROSS APPLY cteRecent r
  WHERE ds.EntryDate = r.EntryDate 
  ORDER BY ds.Drive;
go

IF OBJECT_ID('svr.RecentDriveGrowth', 'p') IS NOT NULL DROP PROCEDURE svr.RecentDriveGrowth;
go

CREATE PROCEDURE svr.RecentDriveGrowth(@Days Integer,
                                       @IncludeNegativeGrowth Bit = 0) 
AS

BEGIN

  -----------------------------------------------------------------------------
  --initialization
  -----------------------------------------------------------------------------
  SET NOCOUNT ON;
  SET ANSI_WARNINGS OFF;

  --create a temp table to hold the daily free space
  IF OBJECT_ID('tempdb.dbo.#DriveInfo', 'u') IS NOT NULL DROP TABLE #DriveInfo;
  CREATE TABLE #DriveInfo (
    ID Integer,
    EntryDate Date,
    CurrentData Numeric(18, 3),
    CurrentLog Numeric(18, 3),
    CurrentBackup Numeric(18, 3),
    NextData Numeric(18, 3),
    NextLog Numeric(18, 3),
    NextBackup Numeric(18, 3),
    DataGrowth Numeric(18, 3),
    LogGrowth Numeric(18, 3),
    BackupGrowth Numeric(18, 3));

  --create a temp table to hold the dates each drive will fill up and die
  IF OBJECT_ID('tempdb.dbo.#DatesOfDeath', 'u') IS NOT NULL DROP TABLE #DatesOfDeath;
  CREATE TABLE #DatesOfDeath (
    Drive Varchar(32),
    DailyGrowth Numeric(18, 6),
    DaysUntilEmpty Numeric(18, 1),
    DateEmpty Date);

  -----------------------------------------------------------------------------
  --build the base data set for the drives on this server
  -----------------------------------------------------------------------------
  WITH cteDrives AS (
    --start with the list of drives to check for this server
    SELECT DriveLetter, Description
      FROM svr.ServerDrives 
      WHERE ServerName = @@SERVERNAME
  ),
  cteDriveInfo AS (
    --query a list of dates going back @Days days and use a crosstab to pivot the rows into columns for each date.
    --this gives a table with date and free space on the data, log and backup drives, along with an ascending 
    --integer for each row.
    SELECT ROW_NUMBER() OVER(ORDER BY ds.EntryDate) RowNum, ds.EntryDate, 
        DataFree = CONVERT(Numeric(18, 3), MAX(CASE WHEN d.Description = 'Data' THEN ds.Free * 1.0 / POWER(1024, 3) END)),
        LogFree = CONVERT(Numeric(18, 3), MAX(CASE WHEN d.Description = 'Logs' THEN ds.Free * 1.0 / POWER(1024, 3) END)),
        BackupFree = CONVERT(Numeric(18, 3), MAX(CASE WHEN d.Description = 'Backup' THEN ds.Free * 1.0 / POWER(1024, 3) END))
      FROM cteDrives d
        INNER JOIN dbo.DriveSpace ds ON ds.Drive = d.DriveLetter
      WHERE EntryDate >= DATEADD(day, 0, DATEDIFF(day, 0, GETDATE()) - @Days)
      GROUP BY ds.EntryDate
  ),
  cteDailyGrowth AS (
    --using the row number, join the drive free table to itself, offset by one day. this gets the free
    -- space for each drive on that day and also on the next day.
    SELECT di1.RowNum, di1.EntryDate, di1.DataFree CurrentData, di1.LogFree CurrentLog, di1.BackupFree CurrentBackup,
        di2.DataFree NextData, di2.LogFree NextLog, di2.BackupFree NextBackup
      FROM cteDriveInfo di1
        INNER JOIN cteDriveInfo di2 ON di2.RowNum = di1.RowNum + 1
  )
  --populate the temp table with the drive, date and free space for each drive on the date and the following date.
  --the growth of each drive is the current minus the next.
  INSERT INTO #DriveInfo(ID, EntryDate, CurrentData, CurrentLog, CurrentBackup, 
      NextData, NextLog, NextBackup, DataGrowth, LogGrowth, BackupGrowth)
    SELECT RowNum, CAST(EntryDate AS Date), CurrentData, CurrentLog, CurrentBackup, NextData, NextLog, NextBackup,
        DataGrowth = CurrentData - NextData,
        LogGrowth = CurrentLog - NextLog,
        BackupGrowth = CurrentBackup - NextBackup
      FROM cteDailyGrowth
      ORDER BY EntryDate;

  -----------------------------------------------------------------------------
  --figure out when our drives are going to run out of space
  -----------------------------------------------------------------------------
  --using the average data growth per day, figure out how many days until the data drive is full
  WITH cteDataGrowth AS (
    --calculate the average growth per day, including negative growth only when specified in @IncludeNegativeGrowth
    SELECT AVG(DataGrowth) Daily
      FROM #DriveInfo
      WHERE ((@IncludeNegativeGrowth = 0 AND DataGrowth >= 0)
             OR @IncludeNegativeGrowth = 1)
  ),
  cteRecentFree AS (
    --read the most recent drive space info
    SELECT TOP 1 CurrentData, EntryDate
      FROM #DriveInfo 
      ORDER BY ID DESC
  )
  --record the number of days and date of death for the drive
  INSERT INTO #DatesOfDeath(Drive, DailyGrowth, DaysUntilEmpty, DateEmpty)
    SELECT 'Data', CONVERT(Numeric(18, 6), dg.Daily), 
        DaysUntilDataEmpty = CONVERT(Numeric(18, 1), rf.CurrentData / dg.Daily),
        DateDataEmpty = DATEADD(day, CONVERT(Integer, rf.CurrentData / dg.Daily), rf.EntryDate)
      FROM cteRecentFree rf
        CROSS APPLY cteDataGrowth dg;

  --using the average log growth per day, figure out how many days until the log drive is full
  WITH cteLogGrowth AS (
    --calculate the average growth per day, including negative growth only when specified in @IncludeNegativeGrowth
    SELECT AVG(LogGrowth) Daily
      FROM #DriveInfo 
      WHERE ((@IncludeNegativeGrowth = 0 AND LogGrowth >= 0)
             OR @IncludeNegativeGrowth = 1)
  ),
  cteRecentFree AS (
    --read the most recent drive space info
    SELECT TOP 1 CurrentLog, EntryDate
      FROM #DriveInfo 
      ORDER BY ID DESC
  )
  --record the number of days and date of death for the drive
  INSERT INTO #DatesOfDeath(Drive, DailyGrowth, DaysUntilEmpty, DateEmpty)
    SELECT 'Log', CONVERT(Numeric(18, 6), lg.Daily), 
        DaysUntilLogEmpty = CONVERT(Numeric(18, 1), rf.CurrentLog / lg.Daily),
        DateLogEmpty = DATEADD(day, CONVERT(Integer, rf.CurrentLog/ lg.Daily), rf.EntryDate)
      FROM cteRecentFree rf
        CROSS APPLY cteLogGrowth lg;

  --using the average backup growth per day, figure out how many days until the backup drive is full
  WITH cteBackupGrowth AS (
    --calculate the average growth per day, including negative growth only when specified in @IncludeNegativeGrowth
    SELECT AVG(BackupGrowth) Daily
      FROM #DriveInfo 
      WHERE ((@IncludeNegativeGrowth = 0 AND BackupGrowth >= 0)
             OR @IncludeNegativeGrowth = 1)
  ),
  cteRecentFree AS (
    --read the most recent drive space info
    SELECT TOP 1 CurrentBackup, EntryDate
      FROM #DriveInfo 
      ORDER BY ID DESC
  )
  --record the number of days and date of death for the drive
  INSERT INTO #DatesOfDeath(Drive, DailyGrowth, DaysUntilEmpty, DateEmpty)
    SELECT 'Backup', CONVERT(Numeric(18, 6), bg.Daily), 
        DaysUntilLogEmpty = CONVERT(Numeric(18, 1), rf.CurrentBackup / bg.Daily),
        DateLogEmpty = DATEADD(day, CONVERT(Integer, rf.CurrentBackup/ bg.Daily), rf.EntryDate)
      FROM cteRecentFree rf
        CROSS APPLY cteBackupGrowth bg;

  -----------------------------------------------------------------------------
  --reporting
  -----------------------------------------------------------------------------
  --select the report of dates of death
  SELECT Drive, DailyGrowth, DaysUntilEmpty, 
      DateEmpty = CASE WHEN DaysUntilEmpty < 0 THEN NULL ELSE DateEmpty END,
      @Days SampleDays, DATEADD(day, 0, DATEDIFF(day, 0, GETDATE()) - @Days) SampleStartDate
    FROM #DatesOfDeath
    ORDER BY CASE Drive WHEN 'Data' THEN 1
                        WHEN 'Log' THEN 2
                        WHEN 'Backup' THEN 3
                        ELSE 4
              END;

  --select the drive space history used in the report
  SELECT ID Day, EntryDate, CurrentData, CurrentLog, NextData, NextLog, DataGrowth, LogGrowth
    FROM #DriveInfo
    ORDER BY ID;

  -----------------------------------------------------------------------------
  --termination
  -----------------------------------------------------------------------------
  DROP TABLE #DatesOfDeath;
  DROP TABLE #DriveInfo;

END;
go
