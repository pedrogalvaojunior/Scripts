-- Criando o Banco de Dados - MyDatabaseDesastre --
CREATE DATABASE MyDatabaseDesastre
ON PRIMARY
	(NAME = MyDatabaseDesastre_Dados,
	  FILENAME = N'C:\Bancos\MyDatabaseDesastre\MyDatabaseDesastre-Dados.mdf',
          SIZE = 5MB,
          MAXSIZE = 25MB,
          FILEGROWTH = 10%)	
LOG ON
	( NAME = MyDatabaseDesastre_Log,
	  FILENAME = N'C:\Bancos\MyDatabaseDesastre\MyDatabaseDesastre-Log.ldf',
          SIZE = 2MB,
          MAXSIZE = 40MB,
          FILEGROWTH = 10%)
GO

-- Alterando o Recovery Model para Simple - Descartando o Log de Transações --
ALTER DATABASE MyDatabaseDesastre
 SET RECOVERY SIMPLE
Go

-- Alterando o Recovery Model para Full - Mantendo o Log de Transações --
ALTER DATABASE MyDatabaseDesastre
 SET RECOVERY FULL
Go

-- Consultando a System Table Sys.Databases --
SELECT * FROM SYS.Databases
Go

-- Consultando a System Table Sys.SysDatabases --
SELECT * FROM SYS.SysDatabases
Go

-- Utilizando a System Function DATABASEPROPERTYEX() --
SELECT DATABASEPROPERTYEX('MyDatabaseDesastre', 'Status') As Status, 
             DATABASEPROPERTYEX('MyDatabaseDesastre', 'Recovery') As 'Modelo de Recuperação',
             DATABASEPROPERTYEX('MyDatabaseDesastre', 'UserAccess') As 'Forma de Acesso', 
             DATABASEPROPERTYEX('MyDatabaseDesastre', 'Version') As 'Versão' 
Go
