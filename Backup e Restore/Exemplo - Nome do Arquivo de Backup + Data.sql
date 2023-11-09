Declare @Comando VarChar(1000)

Set @comando='Backup Database Laboratorio To Disk = ''F:\SYS\MSSQL_BACKUP\Laboratorio-Diff.bak'

                        +Convert(Char(10),GetDate(),103)

                        +' With Differential, Init,

                         Description=''Backup Laboratório - Posição diferencial em relação ao Backup Full'

 

Select @Comando
