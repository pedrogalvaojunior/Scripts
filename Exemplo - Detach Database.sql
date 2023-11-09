--T-SQL for Detaching a database.
EXEC sp_detach_db AdventureWorks
GO

-- T-SQL for Attaching a database.
-- Change file paths and file names as required.
EXEC sp_attach_db @dbname = N'AdventureWorks', 
   @filename1 = N'd:\MSSQL\AdventureWorks.mdf', 
   @filename2 = N'd:\MSSQL\AdventureWorks_Log.ldf'
GO
