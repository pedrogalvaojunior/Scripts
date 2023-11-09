-- The following snippets appear in Chapter 2 in the 
-- section titled "Managing Access to Columns".

-- Change the connection context to the database AdventureWorks.
USE AdventureWorks;
GO
-- Grant SELECT and UPDATE permissions to Sara
-- on some specific columns of the Sales.Individual table 
GRANT SELECT,UPDATE (
Demographics,
ModifiedDate)
ON Sales.Individual 
TO Sara;

--

-- Change the connection context to the database AdventureWorks.
USE AdventureWorks;
GO
-- Revoke previosly granted or denied permissions 
-- from Sara on the Demographics column. 
REVOKE UPDATE (Demographics) 
ON Sales.Individual 
TO Sara;
