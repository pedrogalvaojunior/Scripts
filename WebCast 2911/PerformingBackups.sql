--

USE master;
GO
BACKUP DATABASE AdventureWorks
TO Adv_FullDb_Dev1;

--
USE master;
GO
BACKUP DATABASE AdventureWorks
TO DISK='t:\adv.bak';
--
USE master;
GO
BACKUP DATABASE AdventureWorks
TO DISK='t:\adv.bak'
WITH INIT;
--
USE master;
GO
BACKUP DATABASE AdventureWorks
TO DISK='t:\adv_diff.bak'
WITH INIT,DIFFERENTIAL;
--
USE master;
go
EXEC sp_addumpdevice 'disk', 'Adv_Diff_Dev',
'T:\BACKUPS\AdvDiffDev.bak';
GO
BACKUP DATABASE AdventureWorks
TO Adv_Diff_Dev
WITH INIT,DIFFERENTIAL;





