CREATE DATABASE SMARTGP

CREATE LOGIN SmartGP
 WITH PASSWORD = 'SmartGP',
 Default_Database = SmartGP,
 Check_Expiration = Off,
 Check_Policy = Off
GO


Use SmartGP

Create User SmartGP from Login SmartGP

sp_addrolemember 'db_owner','SmartGP'

Exec As User ='SmartGP'

Use SmartGP