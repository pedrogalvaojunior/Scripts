-- SQLSaturday 945 Chicago 2020
-- Fabiano Amorim
-- http:\\www.blogfabiano.com | fabianonevesamorim@hotmail.com


-- Setup demo...

------------------------------------------------------------
-- Only run if DBs and tables were not created before... ---
------------------------------------------------------------


USE master
GO

sp_configure 'show advanced options', 1;  
RECONFIGURE;
GO 
-- Set BP to 10GB
EXEC sys.sp_configure N'max server memory (MB)', N'10240'
GO
RECONFIGURE WITH OVERRIDE
GO

/*

-- 30 seconds to run...
if exists (select * from sysdatabases where name='DBMemory1')
BEGIN
  ALTER DATABASE DBMemory1 SET SINGLE_USER WITH ROLLBACK IMMEDIATE
		DROP DATABASE DBMemory1
end
GO
CREATE DATABASE DBMemory1
 ON  PRIMARY 
( NAME = N'DBMemory1', FILENAME = N'C:\DBs\DBMemory1.mdf' , SIZE = 5GB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'DBMemory1_log', FILENAME = N'C:\DBs\DBMemory1_log.ldf' , SIZE = 2GB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO

USE DBMemory1
GO
-- Create 5 tables with approximately 900MB
IF OBJECT_ID('Products1') IS NOT NULL
  DROP TABLE Products1
GO
SELECT TOP 115000 IDENTITY(Int, 1,1) AS ProductID, 
       SubString(CONVERT(VarChar(250),NEWID()),1,8) AS ProductName, 
       CONVERT(VarChar(250), NEWID()) AS Col1,
       CONVERT(Char(4000), NEWID()) AS Col2
  INTO Products1
  FROM sysobjects A
 CROSS JOIN sysobjects B
 CROSS JOIN sysobjects C
 CROSS JOIN sysobjects D
GO
ALTER TABLE Products1 ADD CONSTRAINT xpk_Products1 PRIMARY KEY(ProductID)
GO
SELECT * INTO Products2 FROM Products1
SELECT * INTO Products3 FROM Products1
GO
ALTER TABLE Products2 ADD CONSTRAINT xpk_Products2 PRIMARY KEY(ProductID)
ALTER TABLE Products3 ADD CONSTRAINT xpk_Products3 PRIMARY KEY(ProductID)
GO

-- 45 seconds to run...
USE master
GO
if exists (select * from sysdatabases where name='DBMemory2')
BEGIN
  ALTER DATABASE DBMemory2 SET SINGLE_USER WITH ROLLBACK IMMEDIATE
		DROP DATABASE DBMemory2
end
GO
CREATE DATABASE DBMemory2
 ON  PRIMARY 
( NAME = N'DBMemory2', FILENAME = N'C:\DBs\DBMemory2.mdf' , SIZE = 10GB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'DBMemory2_log', FILENAME = N'C:\DBs\DBMemory2_log.ldf' , SIZE = 5GB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO

-- 5 minutes to run...
USE DBMemory2
GO
-- Create two tables with approximately 4GB each
IF OBJECT_ID('Products4GB_1') IS NOT NULL
  DROP TABLE Products4GB_1
GO
SELECT TOP 512000 IDENTITY(Int, 1,1) AS ProductID, 
       SubString(CONVERT(VarChar(250),NEWID()),1,8) AS ProductName, 
       CONVERT(VarChar(250), NEWID()) AS Col1,
       CONVERT(Char(4000), NEWID()) AS Col2
  INTO Products4GB_1
  FROM sysobjects A
 CROSS JOIN sysobjects B
 CROSS JOIN sysobjects C
 CROSS JOIN sysobjects D
GO
ALTER TABLE Products4GB_1 ADD CONSTRAINT xpk_Products4GB_1 PRIMARY KEY(ProductID) WITH(MAXDOP = 1)
GO
IF OBJECT_ID('Products4GB_2') IS NOT NULL
  DROP TABLE Products4GB_2
GO
SELECT * INTO Products4GB_2 FROM Products4GB_1
GO
ALTER TABLE Products4GB_2 ADD CONSTRAINT xpk_Products4GB_2 PRIMARY KEY(ProductID) WITH(MAXDOP = 1)
GO

-- 4007.07 MB -- SELECT 4103248 /1024.
EXEC sp_spaceused Products4GB_1
GO

*/

-- Starting with cold cache
-- Restart SQL2017
EXEC xp_cmdShell 'net stop MSSQL$SQL2017 && net start MSSQL$SQL2017'
GO

SELECT 1
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

