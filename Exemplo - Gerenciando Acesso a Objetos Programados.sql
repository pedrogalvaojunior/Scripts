-- The following snippets appear in Chapter 2 in the 
-- section titled "Managing Access to Programmable Objects".

-- Change the connection context to the database AdventureWorks.
USE AdventureWorks;
GO
-- Grant EXECUTE permission to Sara on a stored procedure. 
GRANT EXECUTE On dbo.uspGetBillOfMaterials 
TO Sara;

--

-- Change the connection context to the database AdventureWorks.
USE AdventureWorks;
GO
-- Grant permission to Sara to execute a user defined function. 
GRANT SELECT ON dbo.ufnGetContactInformation 
TO Sara;

--

-- Change the connection context to the database AdventureWorks.
USE AdventureWorks;
GO
-- Grant Sara permission to execute a user defined function. 
GRANT EXECUTE ON dbo.ufnGetStock 
TO Sara;

--

-- Change the connection context to the database AdventureWorks.
USE AdventureWorks;
GO
-- Grant Sara permission to execute an assembly. 
GRANT EXECUTE ON <AssemblyName> 
TO Sara;

--

-- Change the connection context to the database AdventureWorks.
USE AdventureWorks;
GO
-- Change the execution context to the user Sara. 
EXECUTE AS USER='Sara';
-- The following statement will be executed under Sara's credentials. 
TRUNCATE TABLE dbo.ErrorLog;

--

-- Change the execution context back to the original state 
REVERT;
-- Now the following statement will be executed under 
-- the original execution context. 
TRUNCATE TABLE dbo.ErrorLog;

--

-- Create a stored procedure to execute statements.\
--' as dbo.
CREATE PROCEDURE dbo.usp_TruncateErrorLog
    WITH EXECUTE AS 'dbo'
    AS
    TRUNCATE TABLE dbo.ErrorLog;
GO
-- Grant permissions to execute this procedure to Sara.
GRANT EXECUTE ON dbo.usp_TruncateErrorLog TO Sara
-- Change the execution context of this batch to Sara.
EXECUTE AS [USER=]'Sara'
-- Execute the stored procedure.
EXECUTE dbo.usp_TruncateErrorLog
