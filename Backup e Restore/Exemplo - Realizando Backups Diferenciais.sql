ALTER DATABASE AdventureWorks
SET RECOVERY SIMPLE;
--Perform Full Database Backup
BACKUP DATABASE AdventureWorks
TO DISK = 'T:\BACKUPS\ADVFULL.BAK'
WITH INIT;
--Simulate a transaction
UPDATE AdventureWorks.Person.Contact
SET EmailAddress = 'kim@testbackup.com'
WHERE ContactID=3;
--Perform a differential Backup
BACKUP DATABASE AdventureWorks
TO DISK = 'T:\BACKUPS\ADVDIFF.BAK'
WITH INIT,Differential;

--

USE AdventureWorks
GO
SELECT EmailAddress 
FROM Person.Contact
WHERE ContactID =3;

