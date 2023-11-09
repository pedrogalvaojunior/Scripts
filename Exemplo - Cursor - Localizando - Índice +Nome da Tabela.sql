Use TempDB
Go

DECLARE @DatabaseName varchar(30), @cmd varchar(1000), @IndexName Varchar(100)

Set @IndexName='idx_balance_daf'
 
DECLARE cur_FindIndexName CURSOR FOR
 
SELECT name FROM MASTER..SYSDATABASES
WHERE  name NOT IN ('master', 'msdb', 'model', 'tempdb')
and    status <> 66048
Order By Name
 
OPEN cur_FindIndexName
FETCH NEXT FROM cur_FindIndexName
INTO @DatabaseName
 
WHILE @@FETCH_STATUS = 0
BEGIN
   SELECT @cmd =  'SET NOCOUNT ON' + char(10) +
          'USE ' + @DatabaseName + '' + char(10) + 
          
          'If Exists(Select Name from sys.sysindexes Where Name ='+''''+@IndexName+''''+')
            begin
             
			 
             select'+''''+@DatabaseName+'''As DatabaseName'+', si.Name As IndexName, st.Name As TableName 
             from sys.sysindexes si Inner Join sys.tables st
		                			   on si.id = st.object_id
             where si.name = '+''''+@IndexName+'''' + char(10)+'
             
            End'
         
 Exec(@cmd)
 
 FETCH NEXT FROM cur_FindIndexName
 INTO @DatabaseName
END

Close cur_FindIndexName
Deallocate cur_FindIndexName