-- SQLSaturday 945 Chicago 2020
-- Fabiano Amorim
-- http:\\www.blogfabiano.com | fabianonevesamorim@hotmail.com

USE master
GO

-- Cold cache
-- Restart SQL2017
EXEC xp_cmdShell 'net stop MSSQL$SQL2017 && net start MSSQL$SQL2017'
GO
SELECT 1
GO

-- Approximately 5 minutes to run script

-- Recreate DB and tables if needed...
/*
USE [master]
GO
if exists (select * from sysdatabases where name='Stage1')
BEGIN
  ALTER DATABASE Stage1 SET SINGLE_USER WITH ROLLBACK IMMEDIATE
		DROP DATABASE Stage1
end
GO

-- 60 seconds to run...
CREATE DATABASE [Stage1]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Stage1', FILENAME = N'C:\DBs\Stage1.mdf' , SIZE = 10485760KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Stage1_log', FILENAME = N'C:\DBs\Stage1_log.ldf' , SIZE = 10240MB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO


-- 4 minutes to run...
USE [Stage1]
GO
DROP TABLE IF EXISTS Stage1.dbo.TabStage1;
CREATE TABLE Stage1.dbo.TabStage1
(
    Col1 CHAR(500)
);
GO

DROP TABLE IF EXISTS Table1_2GB, Table2_2GB, Table3_2GB, Table4_2GB
-- Creating tables with almost 8GB
SELECT TOP 256000 IDENTITY(Int, 1,1) AS ProductID, 
       SubString(CONVERT(VarChar(250),NEWID()),1,8) AS ProductName, 
       CONVERT(VarChar(250), NEWID()) AS Col1,
       CONVERT(Char(4000), NEWID()) AS Col2
  INTO Table1_2GB
  FROM sysobjects A
 CROSS JOIN sysobjects B
 CROSS JOIN sysobjects C
 CROSS JOIN sysobjects D
GO
SELECT * INTO Table2_2GB FROM Table1_2GB
SELECT * INTO Table3_2GB FROM Table1_2GB
SELECT * INTO Table4_2GB FROM Table1_2GB
GO
-- Sanity note: Make sure tables are heaps, 
-- otherwise it will trigger disfavoring and demo 
-- will not work as expected
*/

-- Approximately 80 seconds to run...
USE master
GO

EXEC sys.sp_configure N'max server memory (MB)', N'10240'
GO
RECONFIGURE WITH OVERRIDE
GO

-- Put some data in cache...
USE Stage1
GO
CHECKPOINT; DBCC DROPCLEANBUFFERS;
GO
SELECT COUNT(*) FROM Stage1.dbo.Table1_2GB OPTION (MAXDOP 1)
SELECT COUNT(*) FROM Stage1.dbo.Table2_2GB OPTION (MAXDOP 1)
SELECT COUNT(*) FROM Stage1.dbo.Table3_2GB OPTION (MAXDOP 1)
SELECT COUNT(*) FROM Stage1.dbo.Table4_2GB OPTION (MAXDOP 1)
GO

-- Run a insert into a #tmp table
DROP TABLE IF EXISTS #TabStage1;
GO
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
DROP TABLE IF EXISTS #TabStage1;
GO 3 -- Run insert 3 times... 
