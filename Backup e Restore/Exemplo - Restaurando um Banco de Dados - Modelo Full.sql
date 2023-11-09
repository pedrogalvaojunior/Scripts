--Setting Recovery Model to Simple

USE master;
GO
ALTER DATABASE AdventureWorks
SET RECOVERY SIMPLE;
GO
--
--Retrieve recovery model
SELECT DATABASEPROPERTYEX('AdventureWorks','Recovery')
