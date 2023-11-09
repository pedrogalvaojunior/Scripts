USE MASTER

-- Realizando o Backup Full do Banco CORPORERM
BACKUP DATABASE CORPORERM 
 TO DISK = 'F:\SYS\MSSQL_BACKUP\CORPORERM_TESTE.BAK'
  WITH INIT,
  DESCRIPTION = 'Backup Full Database CORPORERM para restaura��o no Database CORPORERM_TESTE'
Go

-- Restaurando o Backup Full CORPORERM, sobrescrevendo o Banco CORPORERM_TESTE2
RESTORE DATABASE CORPORERM_TESTE
 FROM DISK = 'F:\SYS\MSSQL_BACKUP\CORPORERM_TESTE.BAK'
  WITH RECOVERY,
   REPLACE,
   FILE = 1,
   STATS = 10,
   MOVE 'LATEX_Data' TO 'F:\SYS\MSSQL_DADOS\CORPORERM_TESTE.mdf',
   MOVE 'LATEX_Log' TO 'F:\SYS\MSSQL_DADOS\CORPORERM_TESTE_log.ldf'
Go

--Conectando-se ao Banco CORPORERM_TESTE
USE CORPORERM_TESTE
go

--Reconfigurando o SQL Server para permitir altera��o em System Tables
sp_configure 'allow updates', '1'
go
reconfigure with override
go

--Exclu�ndo usu�rios para evitar conflito
delete sysusers where name = '\rm'
delete sysusers where name = '\sysdba'
delete sysusers where name = 'rm'
delete sysusers where name = 'sysdba'
go

--Reconfigurando o SQL Server para bloquear altera��o em System Tables
sp_configure 'allow updates', '0'
go
reconfigure with override
go

--Adicionando os usu�rios no Role DBO
Exec sp_addrolemember 'db_owner','rm'
Exec sp_addrolemember 'db_owner','sysdba'
go
-- Criando Usu�rios
sp_adduser sysdba,sysdba
go
sp_adduser rm,rm
go

-- Liberando acesso as tables de configura��o do Banco CORPORERM_TESTE
grant select on gparams to sysdba
grant select on gusuario to sysdba
grant select on gpermis  to sysdba
grant select on gacesso  to sysdba
grant select on gsistema  to sysdba
grant select on gcoligada  to sysdba
grant select on gusrperfil to sysdba
go

Print ''
Print '----------------------------------------------------------------------------------------------------------------'
Print 'Processo Realizado com sucesso!!!'
