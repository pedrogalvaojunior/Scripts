Create Procedure P_BackupAllUsersDatabases
As
Begin
 Begin Try
  Select SD.DbId, 'Backup Database ['+sd.name + '] To Disk = '+'''S:\MSSQL-2017\Backup\'+sd.name+'.Bak'+''' With Init, NoFormat, Description = '+'''Backup para armazenamento - Database - '+sd.Name+''''+Char(13) As 'Command'
  Into #CommandBackupDatabases
  from Sys.SysDatabases SD
  WHERE  name NOT IN ('master', 'msdb', 'model', 'tempdb')
  and    status <> 66048

  Declare @Counter Int, @Command NVarchar(1000)

  Set @Counter = (Select MIN(DBID) from #CommandBackupDatabases)

  While @Counter < (Select COUNT(DBID) + Min(DBID) From #CommandBackupDatabases)
   Begin
 
    Set @Command = (Select Command From #CommandBackupDatabases Where dbid = @Counter) 
  
    Exec(@Command)
  
    Set @Counter +=1
  End
 End Try
 Begin Catch
   SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity,
                ERROR_STATE() AS ErrorState, ERROR_PROCEDURE() AS ErrorProcedure,
                ERROR_MESSAGE() AS ErrorMessage, ERROR_LINE() AS ErrorLine;   
 End Catch
End

Exec P_BackupAllUsersDatabases