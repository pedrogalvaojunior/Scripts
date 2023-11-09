Declare @Comando Varchar(200)

Set @Comando = 'BACKUP DATABASE SIGP_IPEAS'+Char(10)+
  'TO DISK = '+'''D:\MSSQL2005-Backup\BACKUP-SIGP_IPEAS-'+''+Convert(VarChar(10),GetDate(),112)+'.bak'''+Char(10)+
  'WITH INIT, DESCRIPTION = '+'''Backup Full SIGP'''

Exec(@comando)