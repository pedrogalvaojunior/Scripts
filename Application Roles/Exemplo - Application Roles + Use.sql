-- Change the connection context to the database AdventureWorks.
USE AdventureWorks;
GO
-- Declare a variable to hold the connection context.
-- We will use the connection context later 
-- so that when the application role is deactivated
-- the connection recovers its original context. 
DECLARE @context varbinary (8000);
-- Activate the application role
-- and store the current connection context
EXECUTE sp_setapprole 'FinancialRole', 
'Pt86Yu$$R3', 
@fCreateCookie = true, 
@cookie = @context OUTPUT;
-- Verify that the user’s context has been replaced
-- by the application role context.
SELECT CURRENT_USER;
-- Deactivate the application role,
-- recovering the previous connection context.
EXECUTE sp_unsetapprole @context;
GO
-- Verify that the user’s original connection context 
-- has been recovered.
SELECT CURRENT_USER;
GO
