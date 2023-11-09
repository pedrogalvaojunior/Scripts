-- Change the connection context to the database AdventureWorks.
USE AdventureWorks
GO
-- Create the Application role FinancialRole
-- in the current database
CREATE APPLICATION ROLE FinancialRole 
WITH PASSWORD = 'Pt86Yu$$R3';

--

-- Change the connection context to the database AdventureWorks.
USE AdventureWorks;
GO
-- Drop the application role FinancialRole
-- from the current database
DROP APPLICATION ROLE FinancialRole;
