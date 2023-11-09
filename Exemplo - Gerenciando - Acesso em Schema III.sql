-- The following snippet appears in Chapter 2 in the 
-- section titled "Managing Access to Schemas".

-- Create a SQL Server login in this SQL Server instance. 
CREATE LOGIN Sara 
WITH PASSWORD='TUT87rr$$';
GO
-- Change the connection context to the database AdventureWorks.
USE AdventureWorks;
GO
-- Create the user Sara in the AdventureWorks database
-- and map the user to the login Sara 
CREATE USER Sara 
FOR LOGIN Sara;
GO
-- Create the schema Marketing, owned by Peter.
CREATE SCHEMA Marketing 
AUTHORIZATION Peter;
GO
-- Create the table Campaigns in the newly created schema.
CREATE TABLE Marketing.Campaigns (
CampaignID int, 
CampaignDate smalldatetime, 
Description varchar (max));
GO
-- Grant SELECT permission to Sara on the new table.
GRANT SELECT ON Marketing.Campaigns TO Sara;
GO
-- Declare the Marketing schema as the default schema for Sara
ALTER USER Sara 
WITH DEFAULT_SCHEMA=Marketing;
