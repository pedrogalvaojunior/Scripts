-- FULL recovery model
USE master;
GO
ALTER DATABASE AdventureWorks
SET RECOVERY FULL;
GO
--
USE master;
GO
BACKUP LOG AdventureWorks
TO DISK='t:\adv_log.bak'
--
USE master;
GO
BACKUP LOG AdventureWorks
TO DISK='t:\adv_log.bak'
WITH INIT
--


