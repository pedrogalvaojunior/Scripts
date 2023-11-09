-- backing up user databases in SQL Server 

declare @DatabaseName varchar(300)
		,@BackupSQL varchar(8000)
		,@Timestamp varchar(30)
		,@DirectoryPath varchar(2000)
		,@FullPath varchar(2500)
		,@RecoveryModel int

set @DirectoryPath = 'D:\MSSQL\BACKUP\'

-- create a timestamp for the backup file name
set @TimeStamp = convert(varchar, getdate(),112) + replace(convert(varchar, getdate(),108),':','') 

-- get user databases only
declare Database_Cursor cursor for
  select d.name 
  from sys.databases d
  where d.name not in('master','tempdb','model','msdb')
  
open Database_Cursor

fetch next from Database_Cursor
into @DatabaseName

while @@fetch_status = 0
  begin

	set @FullPath = ''
	set @FullPath = @DirectoryPath + @DatabaseName

	exec sys.xp_create_subdir @FullPath

      set @BackupSQL = ''
	set @BackupSQL = @BackupSQL + 'BACKUP DATABASE ' + @DatabaseName + ' TO  DISK = N''' + @FullPath + '\' + @DatabaseName + '_' + @TimeStamp + '.bak'' WITH NOFORMAT, NOINIT, SKIP'

	exec (@BackupSQL)

    -- backups tlogs
    select @RecoveryModel = d.recovery_model from sys.databases as d where d.name = @DatabaseName
    -- only backup transaction logs for databases set for Full Recovery
    if @RecoveryModel = 1
    begin
    	set @BackupSQL = ''
	set @BackupSQL = @BackupSQL + 'BACKUP LOG ' + @DatabaseName + ' TO  DISK = N''' + @FullPath + '\' + @DatabaseName + '_' + @TimeStamp + '.trn'' WITH NOFORMAT, NOINIT, SKIP'
	exec(@BackupSQL)
    end 

	fetch next from Database_Cursor
	into @DatabaseName
  
  end

close Database_Cursor
deallocate Database_Cursor
