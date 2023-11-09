CREATE DATABASE AES
ON PRIMARY
	(NAME = AES_Dados,
	  FILENAME = N'C:\SQL\AES_Dados.mdf',
          SIZE = 10MB,
          MAXSIZE = 50MB,
          FILEGROWTH = 10%),	
	( NAME = Banco1_Dados1,
	  FILENAME = N'C:\SQL\SQL_Dados1.ndf',
          SIZE = 10MB,
          MAXSIZE = 50MB,
          FILEGROWTH = 10%),
FILEGROUP Secundario
	( NAME = AES_Secundario_Dados,
	  FILENAME = N'C:\SQL\AES_Secundario_Dados.ndf',
          SIZE = 10MB,
          MAXSIZE = 50MB,
          FILEGROWTH = 10%),	
	( NAME = AES_Secundario_Dados2,
	  FILENAME = N'C:\SQL\AES_Secundario_Dados1.ndf',
          SIZE = 10MB,
          MAXSIZE = 50MB,
          FILEGROWTH = 10%)
LOG ON
	( NAME = AES_Log,
	  FILENAME = N'C:\SQL\AES_Log.ldf',
          SIZE = 10MB,
          MAXSIZE = 50MB,
          FILEGROWTH = 10%)
GO

Alter DataBase AES
 Add Filegroup Terceiro
 
Alter DataBase AES
 Add Filegroup Quarto
 
Alter Database AES
 Remove Filegroup Quarto