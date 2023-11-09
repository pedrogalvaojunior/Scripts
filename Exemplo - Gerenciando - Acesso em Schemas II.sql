-- The following snippets appear in Chapter 2 in the 
-- section titled "Managing Access to Schemas".

SELECT * 
FROM sys.schemas;

--

-- Change the connection context to the database AdventureWorks.
USE AdventureWorks
GO
-- Retieve informatiomn about the Accounting schema. 
SELECT s.name AS 'Schema',
o.name AS 'Object' 
FROM sys.schemas s 
INNER JOIN sys.objects o
		ON s.schema_id=o.schema_id
WHERE s.name='Accounting';
GO
-- Drop the table Invoices from the Accounting schema. 
DROP TABLE Accounting.Invoices;
GO
-- Drop the Accounting schema. 
DROP SCHEMA Accounting;
