--Create a credential to connect to the windows azure storage service
CREATE CREDENTIAL mydatabasestoragecredential 
 WITH IDENTITY = 'mydatabasestorage',
 SECRET = 'IKzMAPJufU1aGWaNfFyp8O6GuWoSW9mLAe7ofmXg+KHON+HannKPtqXWSnsNIXo5rIg4dQdXGbto63Xv6mu/eQ=='
GO

--Backup the database to the windows azure storage service - blob using URL
BACKUP DATABASE Vendas 
 TO URL = 'https://mydatabasestorage.blob.core.windows.net/vendas/vendas.bak' 
 WITH CREDENTIAL = 'mydatabasestoragecredential',
 COMPRESSION, --Compress the backup
 STATS = 10 --This reports the percentage complete as of the threshold for reporting the next interval
GO

--Restore the database to the windows azure storage service - blob using URL
USE master
RESTORE DATABASE Vendas 
FROM URL = 'https://mydatabasestorage.blob.core.windows.net/vendas/vendas.bak' 
WITH CREDENTIAL = 'mydatabasestoragecredential',
 MOVE 'AdventureWorks2012_Data' to 'D:\D Drive\SQL Server 2012\SampleDatabases\AdventureWorks2012_Data.mdf',
 MOVE 'AdventureWorks2012_Log' to 'D:\D Drive\SQL Server 2012\SampleDatabases\AdventureWorks2012_log.ldf',
 STATS = 10
GO