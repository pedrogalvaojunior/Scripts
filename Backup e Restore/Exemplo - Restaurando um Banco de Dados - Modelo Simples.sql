USE MASTER
GO
RESTORE DATABASE AdventureWorks
FROM DISK='T:\BACKUPS\ADVFULL.BAK'

--

SELECT EmailAddress
FROM AdventureWorks.Person.Contact
WHERE ContactID = 3

--

USE MASTER
GO
RESTORE DATABASE AdventureWorks
FROM DISK='T:\BACKUPS\ADVFULL.BAK'
WITH NORECOVERY

--

USE MASTER
GO
RESTORE DATABASE AdventureWorks
FROM DISK='T:\BACKUPS\ADVDIFF.BAK'

--

SELECT EmailAddress
FROM AdventureWorks.Person.Contact
WHERE ContactID = 3

