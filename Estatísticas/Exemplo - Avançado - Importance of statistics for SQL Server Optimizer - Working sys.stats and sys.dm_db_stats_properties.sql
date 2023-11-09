-- first the table will be created...
CREATE TABLE dbo.Customer 
(
     Id      INT             NOT NULL IDENTITY (1, 1), 
     Name    VARCHAR(100)    NOT NULL, 
     Street  VARCHAR(100)    NOT NULL, 
     ZIP     CHAR(5)         NOT NULL, 
     City    VARCHAR(100)    NOT NULL 
); 
GO 
 
-- and filled with ~10,000 records
INSERT INTO dbo.Customer WITH (TABLOCK) (Name, Street, ZIP, CIty) 
SELECT 'Customer ' + CAST(message_id AS VARCHAR(10)), 
       'Street ' + CAST(severity AS VARCHAR(10)), 
       severity * 1000, 
       LEFT(text, 100) 
FROM   sys.messages 
WHERE  language_id = 1033; 
GO 
 
-- than we create two indexes for accurate statistics
CREATE UNIQUE CLUSTERED INDEX ix_Customer_ID ON dbo.Customer (Id); 
CREATE NONCLUSTERED INDEX ix_Customer_ZIP ON dbo.Customer (ZIP); 
GO

-- what statistics will be used by different queries
-- result of implemented statistics?
SELECT S.object_id,
       S.name,
       DDSP.last_updated,
       DDSP.rows,
       DDSP.modification_counter
FROM   sys.stats AS S
       CROSS APPLY sys.dm_db_stats_properties(S.object_id, S.stats_id) AS DDSP
WHERE  S.object_id = OBJECT_ID(N'dbo.Customer', N'U');
GO

-- When a query runs against both indexes the corresponding stats will be used. To make the usage of the stats 
-- visible the following code will be executed! KEEP IN MIND THAT TRACEFLAGS WILL BE USED! 
DBCC TRACEON (3604, 9204, 9292); 
GO
 
DECLARE @stmt NVARCHAR(1000) = N'SELECT * FROM dbo.Customer WHERE Id = @Id;';
DECLARE @parm NVARCHAR(100) = N'@Id INT';
EXEC sp_executesql @stmt, @parm, 10;
GO
 
DECLARE @stmt NVARCHAR(1000) = N'SELECT * FROM dbo.Customer WHERE ZIP = @ZIP;';
DECLARE @parm NVARCHAR(100) = N'@ZIP CHAR(5)';
EXEC sp_executesql @stmt, @parm, '15000';
GO

DBCC TRACEOFF (3604, 9204, 9292);
GO

-- The output shows that for each query the corresponding stats will be loaded. 
-- This indicates that the optimizer of Microsoft SQL Server take the stats into consideration for a good execution plan! 
-- In the next step the table will get 4,000 additional records. These additional 4,000 records are more than 20% and the stats will become outdated.

-- now additional 4,000 records will be filled into the table
-- to make the stats invalid!
INSERT INTO dbo.Customer WITH (TABLOCK) 
(Name, Street, ZIP, CIty) 
SELECT TOP 4000
       'Customer ' + CAST(message_id AS VARCHAR(10)), 
       'Street ' + CAST(severity AS VARCHAR(10)), 
       severity * 1000, 
       LEFT(text, 100) 
FROM   sys.messages 
WHERE  language_id = 1033;
GO
 
-- what statistics will be used by different queries
-- result of implemented statistics
SELECT    S.object_id,
          S.name,
          DDSP.last_updated,
          DDSP.rows,
          DDSP.modification_counter
FROM sys.stats AS S
          CROSS APPLY sys.dm_db_stats_properties(S.object_id, S.stats_id) AS DDSP
WHERE S.object_id = OBJECT_ID(N'dbo.Customer', N'U');
GO 


-- After the records have been inserted the queries against the table will be executed again. 
DBCC TRACEON (3604, 9204, 9292); 
GO
 
DECLARE @stmt NVARCHAR(1000) = N'SELECT * FROM dbo.Customer WHERE Id = @Id;';
DECLARE @parm NVARCHAR(100) = N'@Id INT';
EXEC sp_executesql @stmt, @parm, 10;
GO
 
DECLARE @stmt NVARCHAR(1000) = N'SELECT * FROM dbo.Customer WHERE ZIP = @ZIP;';
DECLARE @parm NVARCHAR(100) = N'@ZIP CHAR(5)';
EXEC sp_executesql @stmt, @parm, '15000';
GO
 
DBCC TRACEOFF (3604, 9204, 9292);
GO
