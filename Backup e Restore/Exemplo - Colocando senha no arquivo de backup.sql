Declare @Comando VarChar(500),
           @Senha VarChar(10)

Set @Senha='P@ssw0rd1'

Set @Comando='BACKUP DATABASE AdventureWorks
TO DISK = ''C:\MSSQL\BACKUP\AdventureWorks.Bak''
   WITH FORMAT,
   NAME = ''Full Backup of AdventureWorks'',
   PASSWORD='+@Senha

Print @comando
