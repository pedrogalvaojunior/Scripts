USE MyDatabase
Go

If EXISTS (Select [name] FROM master..sysdatabases WHERE [name] = 'MyDatabase')
 Begin

  Print 'Updating Permissions for MyDatabase'
  Print ' '

  Declare @tablename varchar(255), @tablename_header varchar(255)
 
  Declare tnames_cursor CURSOR FOR 
  Select name FROM MyDatabase..sysobjects
  WHERE type = 'U'

  Open tnames_cursor
  Fetch Next From tnames_cursor INTO @tablename
 
  While (@@Fetch_status <> -1)
  Begin
  
   If (@@Fetch_status <> -2)
    Begin
     Select @tablename_header = 'Updating ' + 'MyDatabase..' + RTrim(UPPER(@tablename) )
     Print @tablename_header
     Exec ('Grant All on ' + @tablename +' to shanewiso')
    End

  Fetch Next From tnames_cursor INTO @tablename
 End

 Deallocate tnames_cursor
End
Go