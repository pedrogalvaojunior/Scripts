Use TempDB

If Object_Id('TEMPDB..#RelacaoBancos') IS NOT NULL
 Begin
  Truncate Table #RelacaoBancos
 End
 Else
 Begin
  Create Table #RelacaoBancos
  (Codigo TinyInt Identity(1,1),
   DatabaseName Varchar(100),
   Space_DataFile Int,
   Space_LogFile Int)
 End
 
DECLARE @DatabaseName varchar(30), @cmd varchar(1000), @Indice Int
 
DECLARE cur_SpaceUsed CURSOR FOR
 
SELECT name FROM MASTER..SYSDATABASES
WHERE  name NOT IN ('master', 'msdb', 'model', 'tempdb')
and    status <> 66048
Order By Name
 
OPEN cur_SpaceUsed
FETCH NEXT FROM cur_SpaceUsed
INTO @DatabaseName
 
WHILE @@FETCH_STATUS = 0
BEGIN
   SELECT @cmd =  'SET NOCOUNT ON' + char(10) +
          'USE ' + @DatabaseName + '' + char(10) + 

          '
           DECLARE  @SizeDataFile Int, 
                            @SizeLogFile Int
           
           
           Set @SizeDataFile=(Select Sum(((size*8)/1024)) from SysFiles Where GroupId >= 1)
           Set @SizeLogFile=(Select Sum(((size*8)/1024)) from SysFiles Where GroupID = 0)        
         
           Insert Into TempDB..#RelacaoBancos(DatabaseName, Space_DataFile, Space_LogFile) 
                              Values('+''''+@DatabaseName+''''+','+'@SizeDataFile'+','+'@SizeLogFile'+')'

 Exec(@cmd)
 
 FETCH NEXT FROM cur_SpaceUsed
 INTO @DatabaseName
END
 
CLOSE cur_SpaceUsed
DEALLOCATE cur_SpaceUsed


Select Upper(DatabaseName) 'Database',
       Space_DataFile As 'Size Data File in MBs',
       Space_LogFile As 'Size Log File in MBs'
from #RelacaoBancos