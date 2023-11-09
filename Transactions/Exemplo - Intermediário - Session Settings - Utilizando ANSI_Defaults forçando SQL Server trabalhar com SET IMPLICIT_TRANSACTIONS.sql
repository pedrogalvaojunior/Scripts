Create Table QOD_Customers
(CompanyName Varchar(20),
 Region nvarchar(15) Null)
 Go

 Insert Into QOD_Customers Values ('A','teste')
 Go 30


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[QOD_Test_1]
AS
  SET ANSI_DEFAULTS ON
-- Before rollback Select Statement
  SELECT COUNT(CompanyName) AS 'Before rollback' FROM [dbo].[QOD_Customers] WHERE [dbo].[QOD_Customers].[Region] IS NULL
  UPDATE Dbo.QOD_Customers SET Region = 'XXX' WHERE dbo.QOD_Customers.region IS NULL
-- The after update Select Statement
  SELECT COUNT(CompanyName) AS 'After update' FROM [dbo].[QOD_Customers] WHERE [dbo].[QOD_Customers].[Region] IS NULL
  ROLLBACK TRANSACTION 
  SET ANSI_DEFAULTS OFF
-- The after rollback Select Statement
  SELECT COUNT(CompanyName) AS 'After Rollback' FROM [dbo].[QOD_Customers] WHERE [dbo].[QOD_Customers].[Region] IS NULL
GO

Exec [QOD_Test_1]