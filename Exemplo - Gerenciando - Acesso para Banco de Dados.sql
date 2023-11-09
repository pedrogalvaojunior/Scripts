-- The following snippets appear in Chapter 2 in the 
-- section titled "Managing Access to SQL Server Databases".

-- Create the login Peter
CREATE LOGIN Peter WITH PASSWORD='Tyu87IOR0';
-- Change the connection context to the database AdventureWorks.
USE AdventureWorks;
GO
-- Create the database user Peter,
-- mapped to the login Peter in the database AdventureWorks.
CREATE USER Peter FOR LOGIN Peter;

--

SELECT HAS_DBACCESS('AdventureWorks');

--

-- Change the connection context to the database AdventureWorks.
USE AdventureWorks;
GO
-- Revoke connect permission from Peter 
-- on the database AdventureWorks.
REVOKE CONNECT TO Peter;

--

-- Change the connection context to the database AdventureWorks.
USE AdventureWorks;
GO
-- Report all orphaned database users
EXECUTE sp_change_users_login @Action='Report';

--

-- Change the connection context to the database AdventureWorks.
USE AdventureWorks;
GO
-- Creates the database user Paul in the AdventureWorks database
-- without mapping it to any login in this SQL Server instance
CREATE USER Paul WITHOUT LOGIN;

--

-- Change the connection context to the database AdventureWorks.
USE AdventureWorks;
GO
-- Grant Guest access to the AdventureWorks database.
GRANT CONNECT TO Guest;

--

-- Change the connection context to the database AdventureWorks.
USE AdventureWorks;
GO
-- Create the role Auditors in the database AdventureWorks.
CREATE ROLE Auditors;
GO
-- Add the user Peter to the role Auditors
EXECUTE sp_addrolemember 'Auditors', 'Peter';

--

-- Change the connection context to the database AdventureWorks.
USE AdventureWorks;
GO
-- Checking if the current user belogs to the db_owner role
SELECT IS_MEMBER ('db_owner');

--

-- Change the connection context to the database AdventureWorks.
USE AdventureWorks;
GO
-- Checking if the current user belogs to the Managers group
-- in the ADVWORKS domain
SELECT IS_MEMBER ('[ADVWORKS\Managers]');

--

-- Change the connection context to the database AdventureWorks.
USE AdventureWorks;
GO
-- Drop the user Peter from the Auditors role 
EXECUTE sp_droprolemember 'Auditors', 'Peter';
-- Drop the Auditors role from the current database
DROP ROLE Auditors;

--

-- Change the connection context to the database AdventureWorks.
USE AdventureWorks;
GO
-- Grant permissions to the database user Peter 
-- to backup the database AdventureWorks.
GRANT BACKUP DATABASE TO Peter;

