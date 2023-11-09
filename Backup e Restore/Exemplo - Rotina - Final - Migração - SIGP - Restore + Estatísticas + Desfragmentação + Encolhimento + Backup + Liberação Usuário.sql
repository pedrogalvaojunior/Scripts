-- Connect Database --
USE MASTER
Go

-- Execute Restore Database and Move Files --
Restore Database SIGP_IPEAS
From Disk = '\\saont033\Backup-Servidores\SAONT137\MSSQL-BACKUP\SIGP_IPEAS-20120731.bak'
With Replace, Recovery,
Stats=10,
Move 'SIGP_IPEAS' TO 'E:\MSSQL2005\DATA\SIGP_IPEAS.mdf',
Move 'SIGP_IPEAS_log' To 'E:\MSSQL2005\LOG\SIGP_IPEAS_LOG.Ldf'
Go

-- Connect Database --
USE SIGP_IPEAS
Go

-- Drop User --
Drop User Sigp
Go

-- Create User From Login --
Create User Sigp From Login SIGP With Default_Schema=dbo
Go

-- User Mapping in RoleMember DB_Owner --
sp_AddroleMember 'db_owner','SIGP'

-- Change Context in Connection Test And Permission --
Exec As User = 'SIGP'
Go

-- Change Context Commit --
Select User_Name()
Go

-- Create Table for Permission Test --
Create Table T1
(Codigo Int)
Go

-- Drop Table for Permission Test --
Drop Table T1
Go

-- Change Context in Connection for Sysadmin --
Exec As User = 'SA'
Go

-- Change Database Connection --
Use Master
Go

-- Execute Backup Database --
Backup Database SIGP_Ipeas
 To Disk = 'E:\MSSQL2005-BACKUP\BACKUP-FINAL-SIGP_IPEAS_MIGRACAO-20120727-Phase1.Bak'
 With Init,
 Stats=10
Go

-- Change Database Connection --
Use SIGP_IPEAS
Go

-- Update Statistics in Internal Tables --
Exec sp_updatestats
Go

-- Update Statistics in User Tables, Index and Data Pages --
Exec sp_msforeachtable 'Update Statistics ? With FullScan, All'
Go

-- Update and Fix Data Pages, Refresh Row Count --
Exec sp_msforeachtable 'DBCC UpdateUsage(SIGP_IPEAS,"?") With Count_Rows'
Go

-- Rebuild All Index And Change Fill Factor in 70% --
Exec sp_msforeachtable 'ALTER INDEX ALL ON ? REBUILD 
                        WITH (FILLFACTOR = 70, SORT_IN_TEMPDB = OFF, STATISTICS_NORECOMPUTE = ON)'
Go

-- Update Statistics in Internal Tables --
Exec sp_updatestats
Go

-- Update Statistics in User Tables, Index and Data Pages --
Exec sp_msforeachtable 'Update Statistics ? With FullScan, All'
Go

-- Update and Fix Data Pages, Refresh Row Count --
Exec sp_msforeachtable 'DBCC UpdateUsage(SIGP_IPEAS,"?") With Count_Rows'
Go

-- ShrinkDatabase and Shrik Datafile and Log File --
Alter Database SIGP_IPEAS
Set Recovery Simple;
Go

DBCC ShrinkDatabase('SIGP_IPEAS',10)
Go

DBCC ShrinkFile(1,1000);
Go

DBCC ShrinkFile(1,TruncateOnly);
Go

DBCC ShrinkFile(2,100);
Go

DBCC ShrinkFile(2,TruncateOnly);
Go
 
Alter Database SIGP_IPEAS
Set Recovery Full;
Go

-- Update Statistics in Internal Tables --
Exec sp_updatestats
Go

-- Update Statistics in User Tables, Index and Data Pages --
Exec sp_msforeachtable 'Update Statistics ? With FullScan, All'
Go

-- Update and Fix Data Pages, Refresh Row Count --
Exec sp_msforeachtable 'DBCC UpdateUsage(SIGP_IPEAS,"?") With Count_Rows'
Go

-- Execute Backup Database --
Backup Database SIGP_Ipeas
 To Disk = 'E:\MSSQL2005-BACKUP\BACKUP-FINAL-SIGP_IPEAS_MIGRACAO-20120727-Phase2.Bak'
 With Init,
 Stats=10
Go
