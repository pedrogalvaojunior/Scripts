--You should write your own database name instead of TestDB in the below script
select instance_name AS 'Database_Name', 
	   cntr_value AS 'Transaction Count' from  sys.dm_os_performance_counters
WHERE counter_name = 'Transactions/sec' AND 
instance_name = 'TestDB';
Go

-- You can find all database’s transaction count in the instance since the start of SQL Server by using the following script. --
DECLARE @DatabaseName VARCHAR(250)
create table #TempTable (DatabaseName varchar(250),TransactionCount bigint)
/*Give the Cursor a name*/
DECLARE cursordbnames CURSOR
FOR
/*This is the Select clause that returns the recordset to move the cursor.*/
SELECT name FROM sys.sysdatabases where dbid>4
OPEN cursordbnames
FETCH NEXT FROM cursordbnames INTO @DatabaseName
/*"WHILE @@ FETCH_STATUS = 0" means that you continue to move the cursor by going to the 
next record until there are no more records left in the cursor.*/
WHILE @@FETCH_STATUS =0
BEGIN    
Insert Into #TempTable(DatabaseName, TransactionCount)
select instance_name 'Database Name', cntr_value 'Total Transaction Count' 
from  sys.dm_os_performance_counters
WHERE counter_name = 'Transactions/sec' AND instance_name = @DatabaseName;

 FETCH NEXT FROM cursordbnames INTO @DatabaseName
END                

/*We close the Cursor using the "CLOSE" and "DEALLOCATE" commands.*/
CLOSE cursordbnames
DEALLOCATE cursordbnames

Select * From #TempTable order by TransactionCount Desc
Go

-- You can also calculate the database transaction count in a specific time interval --
DECLARE @Start BIGINT
DECLARE @Finish BIGINT
SELECT @Start = cntr_value
FROM sys.dm_os_performance_counters
WHERE counter_name = 'Transactions/sec'
AND instance_name = 'TestDB';

WAITFOR DELAY '00:01:00'

SELECT @Finish = cntr_value
FROM sys.dm_os_performance_counters
WHERE counter_name = 'Transactions/sec'
AND instance_name = 'TestDB';
SELECT (@Finish - @Start) 'Transaction_Count_in_a_1_Minute'
GO

-- You can use the following script to calculate the transaction count in a specific time interval(Its 1 minute in our example) for all databases on Instance. --
DECLARE cursordbnames CURSOR
FOR

SELECT name FROM sys.sysdatabases where dbid>4
OPEN cursordbnames
FETCH NEXT FROM cursordbnames INTO @DatabaseName
WHILE @@FETCH_STATUS =0
BEGIN    
Insert Into #TempTable(DatabaseName, TransactionCount)
select instance_name 'Database Name', cntr_value 'Total Transaction Count' 
from  sys.dm_os_performance_counters
WHERE counter_name = 'Transactions/sec' AND instance_name = @DatabaseName;

 FETCH NEXT FROM cursordbnames INTO @DatabaseName
END                

CLOSE cursordbnames
DEALLOCATE cursordbnames

WAITFOR DELAY '00:01:00'

create table #TempTable2 (DatabaseName varchar(250),TransactionCount bigint)

DECLARE cursordbnames CURSOR
FOR

SELECT name FROM sys.sysdatabases where dbid>4
OPEN cursordbnames
FETCH NEXT FROM cursordbnames INTO @DatabaseName
WHILE @@FETCH_STATUS =0
BEGIN    
Insert Into #TempTable2(DatabaseName, TransactionCount)
select instance_name 'Database Name', cntr_value 'Total Transaction Count' 
from  sys.dm_os_performance_counters
WHERE counter_name = 'Transactions/sec' AND instance_name = @DatabaseName;

 FETCH NEXT FROM cursordbnames INTO @DatabaseName
END                

CLOSE cursordbnames
DEALLOCATE cursordbnames

select tmp1.DatabaseName,tmp2.TransactionCount-tmp1.TransactionCount 'Transaction_Count_in_a_Minute' 
from #TempTable tmp1 INNER JOIN #TempTable2 tmp2 ON tmp1.DatabaseName=tmp2.DatabaseName
order by tmp2.TransactionCount-tmp1.TransactionCount desc

DROP TABLE #TempTable
DROP TABLE #TempTable2
Go