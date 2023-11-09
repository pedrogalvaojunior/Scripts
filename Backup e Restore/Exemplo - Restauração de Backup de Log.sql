ALTER DATABASE AdventureWorks
SET RECOVERY FULL;
--Perform Full Database Backup
BACKUP DATABASE AdventureWorks
TO DISK = 'T:\BACKUPS\ADVFULL.BAK'
WITH INIT;
--Simulate a transaction
UPDATE AdventureWorks.Person.Contact
SET EmailAddress = 'AfterFull@test.com'
WHERE ContactID=3;
--Perform a Transaction Log Backup
BACKUP LOG AdventureWorks
TO DISK = 'T:\BACKUPS\ADVLOG1.BAK'
WITH INIT;
--Simulate a transaction 
UPDATE AdventureWorks.Person.Contact
SET EmailAddress = 'AfterLog@test.com'
WHERE ContactID=3;

--

--Perform a Transaction Log Backup of the tail of the log
BACKUP LOG AdventureWorks
TO DISK = 'T:\BACKUPS\ADVLOG2.BAK'
WITH INIT, NO_TRUNCATE;

--
--switch to the master db
USE master
GO
-- Restore the full database backup
RESTORE DATABASE AdventureWorks
FROM DISK = 'T:\BACKUPS\ADVFULL.BAK'
WITH REPLACE,NORECOVERY;
--Restore the first Transaction Log Backup
RESTORE LOG AdventureWorks
FROM DISK = 'T:\BACKUPS\ADVLOG1.BAK'
WITH NORECOVERY;
--Restore the second Transaction Log Backup 
RESTORE LOG AdventureWorks
FROM DISK = 'T:\BACKUPS\ADVLOG2.BAK';

--

SELECT EmailAddress
FROM AdventureWorks.Person.Contact
WHERE ContactID = 3

