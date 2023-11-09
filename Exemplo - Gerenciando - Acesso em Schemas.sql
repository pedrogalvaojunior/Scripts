-- The following snippet appears in Chapter 2 in the 
-- section titled "Managing Access to Schemas".

-- Change the connection context to the database AdventureWorks. 
USE AdventureWorks;
GO
-- Create the schema Accounting with Peter as owner. 
CREATE SCHEMA Accounting 
AUTHORIZATION Peter;
GO
-- Create the table Invoices in the Accounting schema. 
CREATE TABLE Accounting.Invoices (
InvoiceID int, 
InvoiceDate smalldatetime, 
ClientID int);
GO
-- Grant SELECT permission on the new table to the public role. 
GRANT SELECT ON Accounting.Invoices
TO public;
GO
-- Insert a row of data into the new table.
-- Note the two-part name that we use to refer 
-- to the table in the current database. 
INSERT INTO Accounting.Invoices 
VALUES (101,getdate(),102);
