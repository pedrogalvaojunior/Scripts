-- The following snippets appear in Chapter 2 in the 
-- section titled "Managing Access to SQL Server Instances".

CREATE LOGIN [ADVWORKS\jlucas] FROM WINDOWS;

--

CREATE LOGIN Mary 
WITH PASSWORD = '34TY$$543', 
DEFAULT_DATABASE =AdventureWorks;

--

SELECT * 
FROM sys.sql_logins;

--

CREATE LOGIN Mary 
WITH PASSWORD = '34TY$$543' MUST_CHANGE, 
CHECK_EXPIRATION=ON,
CHECK_POLICY =ON;

--

SELECT IS_SRVROLEMEMBER ('sysadmin');

--

EXECUTE sp_addsrvrolemember 'Mary', 'sysadmin';

--

EXECUTE sp_dropsrvrolemember 'Mary', 'sysadmin'

--

GRANT ALTER TRACE TO Mary;

--

SELECT * FROM fn_my_permissions (NULL, 'SERVER');

--

-- Disable the login
ALTER LOGIN Mary DISABLE; 
-- Enable the login
ALTER LOGIN Mary ENABLE;


--

-- Disable the login
ALTER LOGIN Mary DISABLE;
GO
-- Query the system catalog view
SELECT * FROM sys.sql_logins 
WHERE is_disabled=1;
GO
-- Enable the login
ALTER LOGIN Mary ENABLE;

--

DROP LOGIN Mary;

--

