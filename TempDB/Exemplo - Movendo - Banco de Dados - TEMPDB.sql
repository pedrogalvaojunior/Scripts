SELECT name, physical_name
FROM sys.master_files
WHERE database_id = DB_ID('tempdb');
GO

USE master;
GO
ALTER DATABASE tempdb 
MODIFY FILE (NAME = tempdev, FILENAME = 'D:\MSSQL2008\TEMPDB\tempdb.mdf');
GO

ALTER DATABASE  tempdb 
MODIFY FILE (NAME = templog, FILENAME = 'D:\MSSQL2008\TEMPDB\templog.ldf');
GO

SELECT name, physical_name
FROM sys.master_files
WHERE database_id = DB_ID('tempdb');
GO
