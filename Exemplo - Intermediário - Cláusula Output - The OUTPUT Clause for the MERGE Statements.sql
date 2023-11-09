Create Database OutputDatabase
Go

Use OutputDatabase
Go

CREATE TABLE [dbo].[Department_Source]
(
   [DepartmentID] [SMALLINT] NOT NULL,
   [Name] VARCHAR(50) NOT NULL,
   [GroupName] VARCHAR(50) NOT NULL,
   [ModifiedDate] [DATETIME] NOT NULL
) ON [PRIMARY];
GO
CREATE TABLE [dbo].[Department_Target]
(
   [DepartmentID] [SMALLINT] NOT NULL,
   [Name] VARCHAR(50) NOT NULL,
   [GroupName] VARCHAR(50) NOT NULL,
   [ModifiedDate] [DATETIME] NOT NULL
) ON [PRIMARY];
GO
---Insert some test values
INSERT INTO [dbo].[Department_Source]
(
   [DepartmentID],
   [Name],
   [GroupName],
   [ModifiedDate]
)
VALUES
(
   1, 'Engineering', 'Research and Development', GETDATE()
);
---Checking the Source Table Data
SELECT  * FROM  [Department_Source];

-- Capturing OUTPUT Clause Results for WHEN NOT MATCHED THEN --
-----Inseting data when no macth found.
MERGE [dbo].[Department_Target] AS tar
USING [dbo].[Department_Source] AS src
ON tar.[DepartmentID] = src.[DepartmentID]
WHEN NOT MATCHED THEN
   INSERT
   (
      [DepartmentID],
      [Name],
      [GroupName],
      [ModifiedDate]
   )
   VALUES
   (
      src.[DepartmentID], src.[Name], src.[GroupName], src.[ModifiedDate]
   )
OUTPUT
   $action,
   inserted.*,
   deleted.*;

-- Capturing OUTPUT clause Results for WHEN MATCHED THEN --
--Update Source table Group Column
UPDATE  [Department_Source] SET GroupName = 'IT' WHERE  DepartmentID = 1;

-----Updating data when macth found.
MERGE [dbo].[Department_Target] AS tar
USING [dbo].[Department_Source] AS src
ON tar.[DepartmentID] = src.[DepartmentID]
WHEN MATCHED THEN
   UPDATE SET
      tar.Name = src.Name,
      tar.[GroupName] = src.[GroupName],
      tar.[ModifiedDate] = src.[ModifiedDate]
OUTPUT
   $action,
   inserted.*,
   deleted.*;

-- Capturing OUTPUT Clause Results for WHEN MATCHED BY SOURCE THEN --
--Inserting extra record into target table
Insert into [dbo].[Department_Target]([DepartmentID],[Name],[GroupName],[ModifiedDate])
Values(3,'Sales',   'Sales & Marketing',getdate());
---Checking the Source Table  Data
Select * from [Department_Source]

---Checking the Target Table  Data
Select * from [Department_Target]

---MERGE Source to target table

MERGE [dbo].[Department_Target] as tar
using [dbo].[Department_Source] as src
on tar.[DepartmentID]=src.[DepartmentID]

WHEN NOT MATCHED BY SOURCE
THEN DELETE
OUTPUT $action,deleted.*,inserted.*;

-- Capturing OUTPUT Clause Results for all MERGE Conditions --
--Inserting records into target table
INSERT INTO [dbo].[Department_Target]
(
   [DepartmentID],
   [Name],
   [GroupName],
   [ModifiedDate]
)
VALUES
( 3, 'Sales', 'Sales & Marketing', GETDATE()),
( 1, 'Engineering', 'IT', GETDATE());
--Inserting  records into target table
INSERT INTO [dbo].[Department_Source]
(
   [DepartmentID],
   [Name],
   [GroupName],
   [ModifiedDate]
)
VALUES
(   2, 'Marketing', 'Sales & Marketing', GETDATE()),
(   1, 'Engineering', 'IT', GETDATE());
---Checking the Source Table
SELECT  * FROM  [Department_Source];
---Checking the Target Table
SELECT  * FROM  [Department_Target];

MERGE [dbo].[Department_Target] AS tar
USING [dbo].[Department_Source] AS src
ON tar.[DepartmentID] = src.[DepartmentID]
WHEN MATCHED THEN
   UPDATE SET
      tar.Name = src.Name,
      tar.[GroupName] = src.[GroupName],
      tar.[ModifiedDate] = src.[ModifiedDate]
WHEN NOT MATCHED THEN
   INSERT
   (
      [DepartmentID],
      [Name],
      [GroupName],
      [ModifiedDate]
   )
   VALUES
   (
      src.[DepartmentID], src.[Name], src.[GroupName], src.[ModifiedDate]
   )
WHEN NOT MATCHED BY SOURCE THEN
   DELETE
OUTPUT
   $action,
   deleted.*,
   inserted.*;

/*In order to archive the data into an historic table, I will be declaring a table variable @archive. Then I insert the OUPUT clause results into the table variable.*/
DECLARE @archive TABLE
(
   ActionType VARCHAR(50),
   [DepartmentID] INT,
   [Name] VARCHAR(50),
   [GroupName] VARCHAR(50),
   [ModifiedDate] DATE
);

MERGE [dbo].[Department_Target] AS tar
USING [dbo].[Department_Source] AS src
ON tar.[DepartmentID] = src.[DepartmentID]
WHEN MATCHED THEN
   UPDATE SET
      tar.Name = src.Name,
      tar.[GroupName] = src.[GroupName],
      tar.[ModifiedDate] = src.[ModifiedDate]
WHEN NOT MATCHED THEN
   INSERT
   (
      [DepartmentID],
      [Name],
      [GroupName],
      [ModifiedDate]
   )
   VALUES
   (
      src.[DepartmentID], src.[Name], src.[GroupName], src.[ModifiedDate]
   )
WHEN NOT MATCHED BY SOURCE THEN
   DELETE
OUTPUT
   $action AS ActionType,
   deleted.*
INTO @archive;

SELECT  * FROM  @archive WHERE  ActionType IN ( 'DELETE', 'UPDATE' );
Go