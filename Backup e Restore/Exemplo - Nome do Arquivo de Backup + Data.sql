Declare @Comando VarChar(1000)

Set @comando='Backup Database Laboratorio To Disk = ''F:\SYS\MSSQL_BACKUP\Laboratorio-Diff.bak'

                        +Convert(Char(10),GetDate(),103)

                        +' With Differential, Init,

                         Description=''Backup Laborat�rio - Posi��o diferencial em rela��o ao Backup Full'

 

Select @Comando
