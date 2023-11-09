-- For SQL-2005/2008
USE MSDB;
go
CREATE TABLE [dbo].[dba_defrag_maintenance_history]
(
[db_name] [SYSNAME] NOT NULL,
[table_name] [SYSNAME] NOT NULL,
[index_name] [SYSNAME] NOT NULL,
[frag] [FLOAT] NULL,
[page] [INT] NULL,
[action_taken] [VARCHAR](35) NULL,
[date] [DATETIME] NULL DEFAULT (GETDATE())
)
go
--Archive the data's in master DB
USE MASTER;
go
CREATE TABLE [dbo].[dba_defrag_maintenance_history]
(
[db_name] [SYSNAME] NOT NULL,
[table_name] [SYSNAME] NOT NULL,
[index_name] [SYSNAME] NOT NULL,
[frag] [FLOAT] NULL,
[page] [INT] NULL,
[action_taken] [VARCHAR](35) NULL,
[date] [DATETIME] NULL DEFAULT (GETDATE())
)
go
USE msdb
go
CREATE PROC [dbo].[indexdefragmentation]@p_dbname SYSNAME
/*
Summary: Remove the Index Fragmentation to improve the query performance
Contact: Muthukkumaran Kaliyamoorhty SQL DBA
Description: This Sproc will take the fragmentation details and do four kinds of work.
 1. Check the fragmentation greater than 30% and pages greater than 1000 then rebuild
 2. Check the fragmentation between 15% to 29% and pages greater than 1000 then reorganize
 3. Check the fragmentation between 15% to 29% and pages greater than 1000 and page level lock disabled then rebuild
 4. Update the statistics if the three conditions is false
ChangeLog:
Date Coder Description
2011-11-23 Muthukkumaran Kaliyamoorhty created

*************************All the SQL keywords should be written in upper case*************************

*/
AS
BEGIN
SET NOCOUNT ON

DECLARE
@db_name SYSNAME,
@tab_name SYSNAME,
@ind_name VARCHAR(500),
@schema_name SYSNAME,
@frag FLOAT,
@pages INT,
@min_id INT,
@max_id INT

SET @db_name=@p_dbname

--------------------------------------------------------------------------------------------------------------------------------------
--inserting the Fragmentation details
--------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE #tempfrag
(
id INT IDENTITY,
table_name SYSNAME,
index_name VARCHAR(500),
frag FLOAT,
pages INT,
schema_name SYSNAME
)

EXEC ('USE ['+@db_name+'];
INSERT INTO #tempfrag (table_name,index_name,frag,pages,schema_name)
SELECT OBJECT_NAME(F.OBJECT_ID) obj,i.name ind,
f.avg_fragmentation_in_percent,
f.page_count,table_schema
FROM SYS.DM_DB_INDEX_PHYSICAL_STATS (DB_ID(),NULL,NULL,NULL,NULL) F
JOIN SYS.INDEXES I
ON(F.OBJECT_ID=I.OBJECT_ID)AND i.index_id=f.index_id
JOIN INFORMATION_SCHEMA.TABLES S
ON (s.table_name=OBJECT_NAME(F.OBJECT_ID))
--WHERE INDEX_ID<> 0
AND f.database_id=DB_ID()
AND OBJECTPROPERTY(I.OBJECT_ID,''ISSYSTEMTABLE'')=0'
)

SELECT @min_id=MIN(ID)FROM #tempfrag
SELECT @max_id=MAX(ID)FROM #tempfrag

TRUNCATE TABLE msdb.dbo.dba_defrag_maintenance_history

WHILE (@min_id<=@max_id)
BEGIN

SELECT
@tab_name=table_name,
@schema_name=schema_name,
@ind_name=index_name ,
@frag=frag ,
@pages=pages
FROM #tempfrag WHERE id = @min_id

--------------------------------------------------------------------------------------------------------------------------------------

--Check the fragmentation greater than 30% and pages greater than 1000 then rebuild
--------------------------------------------------------------------------------------------------------------------------------------

IF (@ind_name IS NOT NULL)
BEGIN
IF (@frag>=30 AND @pages>1000)
BEGIN
EXEC ('USE ['+@db_name+'];ALTER INDEX ['+@ind_name+'] ON ['+@schema_name+'].['+@tab_name +'] REBUILD ')
INSERT INTO msdb.dbo.dba_defrag_maintenance_history
VALUES (@db_name,@tab_name,@ind_name,@frag,@pages,'REBUILD',GETDATE())
END
--------------------------------------------------------------------------------------------------------------------------------------
--Check the fragmentation between 15% to 29% and pages greater than 1000 then reorganize
--------------------------------------------------------------------------------------------------------------------------------------
ELSE IF((@frag BETWEEN 15 AND 29) AND @pages>1000 )
BEGIN
BEGIN TRY
EXEC ('USE ['+@db_name+'];ALTER INDEX ['+@ind_name+'] ON ['+@schema_name+'].['+@tab_name +'] REORGANIZE ')
EXEC ('USE ['+@db_name+'];UPDATE STATISTICS ['+@schema_name+'].['+@tab_name+'] (['+@ind_name+']) ' )
INSERT INTO msdb.dbo.dba_defrag_maintenance_history
VALUES (@db_name,@tab_name,@ind_name,@frag,@pages,'REORGANIZE & UPDATESTATS',GETDATE())
END TRY
BEGIN CATCH
--------------------------------------------------------------------------------------------------------------------------------------
--Check the fragmentation between 15% to 29% and pages greater than 1000 and page level 
--lock disabled then rebuild
--------------------------------------------------------------------------------------------------------------------------------------

IF ERROR_NUMBER()=2552
EXEC ('USE ['+@db_name+'];ALTER INDEX ['+@ind_name+'] ON ['+@schema_name+'].['+@tab_name +'] REBUILD ')
INSERT INTO msdb.dbo.dba_defrag_maintenance_history
VALUES (@db_name,@tab_name,@ind_name,@frag,@pages,'PLLD_REBUILD',GETDATE())
END CATCH
END

--------------------------------------------------------------------------------------------------------------------------------------
--Update the statistics for all indexes if the first three conditions is false
--------------------------------------------------------------------------------------------------------------------------------------
ELSE 
BEGIN 
EXEC ('USE ['+@db_name+'];UPDATE STATISTICS ['+@schema_name+'].['+@tab_name+'] (['+@ind_name+']) ' ) 
INSERT INTO msdb.dbo.dba_defrag_maintenance_history
VALUES (@db_name,@tab_name,@ind_name,@frag,@pages,'UPDATESTATS',GETDATE()) 
END 
END 
ELSE
BEGIN

--------------------------------------------------------------------------------------------------------------------------------------
--Update the statistics for all tables if the first three conditions is false
--------------------------------------------------------------------------------------------------------------------------------------
EXEC ('USE ['+@db_name+'];UPDATE STATISTICS ['+@schema_name+'].['+@tab_name+']') 
INSERT INTO msdb.dbo.dba_defrag_maintenance_history 
VALUES (@db_name,@tab_name,'HEAP',@frag,@pages,'UPDATESTATS',GETDATE()) 
END

SET @min_id=@min_id+1
END
DROP TABLE #tempfrag

INSERT INTO master.dbo.dba_defrag_maintenance_history
SELECT * FROM msdb.dbo.dba_defrag_maintenance_history

END