-- Script# 1: Computed column with conditional formula
-- Use sample database
USE [AdventureWorks]
GO 
 
-- Create Table with computed column
IF OBJECT_ID('CCtest', 'U') IS NOT NULL
  DROP TABLE [dbo].[CCtest]
GO
 
CREATE TABLE [dbo].[CCtest]
  (
  [EmpNumb] INT NOT NULL,
  [Designation] VARCHAR(50) NOT NULL,
  [DOBirth] DATETIME NOT NULL,
  [DORetirement] AS 
    CASE WHEN designation = 'Manager' 
      THEN (DATEADD(YEAR,(65),[DOBirth]))
      ELSE (DATEADD(YEAR,(60),[DOBirth]))
    END
)
GO
 
--Insert sample data 
INSERT INTO CCTest (empNumb, Designation, DOBirth) 
SELECT 84, 'DBA', '1985-12-13' UNION ALL
SELECT 85, 'DBA', '1980-11-18' UNION ALL
SELECT 86, 'Manager', '1978-01-19' UNION ALL
SELECT 88, 'Manager', '1985-12-13' UNION ALL
SELECT 90, 'Developer', '1975-07-23' 
GO
 
-- Check the required functionality in result
SELECT Designation, datediff(yy,dobirth,doretirement ) AgeLimit, DOBirth, DORetirement 
FROM CCTest
GO

-- Script# 2: Avoiding divided by zero error
-- Use sample database
USE [AdventureWorks]
GO 
-- Create Table with computed column
IF OBJECT_ID('CCtest', 'U') IS NOT NULL
  DROP TABLE CCtest
GO
CREATE TABLE [dbo].[CCtest]
  (
  [Numerator] int NOT NULL,
  [Denominator] int NOT NULL,
  [Result] AS (Numerator/NULLIF(Denominator,0)) 
  )
GO
--Insert sample data
INSERT INTO CCTest (Numerator, Denominator) 
SELECT 840, 12 UNION ALL
SELECT 805, 6 UNION ALL
SELECT 846, 3 UNION ALL
SELECT 88, 0 UNION ALL
SELECT 90, 15
GO
-- Check the result
SELECT * from CCTest
GO

--Script # 3: Use UDF to access column in other table
-- Use sample database
USE [AdventureWorks]
GO 
-- Create Table to reference in UDF
IF OBJECT_ID('LeaveBalance', 'U') IS NOT NULL
  DROP TABLE LeaveBalance
GO
CREATE TABLE [dbo].[LeaveBalance]
  (
  [EmpNumb] INT NOT NULL,
  [LeavesAvailed] TINYINT NOT NULL,
  )
GO
--Insert sample data
INSERT INTO LeaveBalance
SELECT 840, 12 UNION ALL
SELECT 805, 6 UNION ALL
SELECT 846, 13 UNION ALL
SELECT 88, 7 UNION ALL
SELECT 90, 15
GO
-- Create UDF to get leave balance
IF OBJECT_ID('UDF_GetLeaveBalance', 'FN') IS NOT NULL
  DROP FUNCTION UDF_GetLeaveBalance
GO
-- Create UDF to use in computed column
CREATE FUNCTION UDF_GetLeaveBalance (@EmpNumb int)
RETURNS TINYINT
AS
BEGIN
  DECLARE @LeaveBalance TINYINT
  SELECT @LeaveBalance = (20 - LeavesAvailed) 
  FROM LeaveBalance
  WHERE EmpNumb = @empnumb
  RETURN @LeaveBalance
END
GO
-- Create Table to use computed column
IF OBJECT_ID('CCTest', 'U') IS NOT NULL
  DROP TABLE CCtest
GO
CREATE TABLE [dbo].[CCtest]
  (
  [EmpNumb] INT NOT NULL,
  [Designation] VARCHAR(50) NOT NULL,
  [LeaveBalance] AS ([dbo].UDF_GetLeaveBalance(EmpNumb))
  )
GO
--Insert sample data
INSERT INTO CCTest (EmpNumb, Designation) 
SELECT 840, 'DBA' UNION ALL
SELECT 805, 'DBA' UNION ALL
SELECT 846, 'Manager' UNION ALL
SELECT 88, 'Manager' UNION ALL
SELECT 90, 'Developer' 
GO
-- Check the result
SELECT * from CCTest
GO