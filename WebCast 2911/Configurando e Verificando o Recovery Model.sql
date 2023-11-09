--Setting Recovery Model to Simple

USE master;
GO
ALTER DATABASE AdventureWorks
SET RECOVERY Simple;
GO
--
--Retrieve recovery model
SELECT DATABASEPROPERTYEX('AdventureWorks','Recovery') As Recovery_Model
