-- The following snippets appear in Chapter 2 in the 
-- section titled "Managing Access to Tables".

-- Change the connection context to the database AdventureWorks.
USE AdventureWorks;
GO
-- Grant some permissions to Sara on the Sales.Customer table.
GRANT SELECT,INSERT,UPDATE 
ON Sales.Customer 
TO Sara;

--

-- Change the connection context to the database AdventureWorks.
USE AdventureWorks;
GO
-- Revoke SELECT permissions from Sara on the Sales.Customer table
REVOKE SELECT 
ON Sales.Customer 
TO Sara;

--

-- Change the connection context to the database AdventureWorks.
USE AdventureWorks;
GO
-- Deny DELETE permission to Sara on the Sales.Customer table,
-- regardless of what permissions this user might
-- inherit from roles.
DENY DELETE 
ON Sales.Customer 
TO Sara;


