CREATE DATABASE AES
ON PRIMARY
	(NAME = AES_Dados,
	  FILENAME = N'C:\BANCOS\AES_Dados.mdf',
          SIZE = 10MB,
          MAXSIZE = 50MB,
          FILEGROWTH = 10%),	
FILEGROUP Secundario
	( NAME = AES_Secundario_Dados,
	  FILENAME = N'C:\BANCOS\AES_Secundario_Dados.ndf',
          SIZE = 10MB,
          MAXSIZE = 50MB,
          FILEGROWTH = 10%),
FILEGROUP Terceiro
	( NAME = AES_Terceiro_Dados,
	  FILENAME = N'C:\BANCOS\AES_Terceiro_Dados.ndf',
          SIZE = 10MB,
          MAXSIZE = 50MB,
          FILEGROWTH = 10%)          
LOG ON
	( NAME = AES_Log,
	  FILENAME = N'C:\BANCOS\AES_Log.ldf',
          SIZE = 10MB,
          MAXSIZE = 50MB,
          FILEGROWTH = 10%)
GO

Use AES
Go

Create Table T1
 (Codigo Int) On [Primary]
 
Create Table T2
 (Codigo Int) On [Secundario]

Create Table T3
 (Codigo Int) On [Terceiro]
  
--Backup Database
Backup Database AES
 To Disk = 'C:\BANCOS\Backup-Full-AES.bak'
 With Init, NoFormat
 
--Backup Database + File x Filegroup
Backup Database AES
 File = 'AES_Dados',
 Filegroup = 'Primary'
 To Disk = 'C:\BANCOS\Backup-Primary-AES.bak'
 With Init

Backup Database AES
 File = 'AES_Secundario_Dados',
 Filegroup = 'Secundario'
 To Disk = 'C:\BANCOS\Backup-Secundario-AES.bak'
 With Init

Backup Database AES
 File = 'AES_Terceiro_Dados',
 Filegroup = 'Secundario'
 To Disk = 'C:\BANCOS\Backup-Terceiro-AES.bak'
 With Init 
 
--Backup Log
Use master
Go

Backup Log AES
 To Disk = 'C:\BANCOS\Backup-Log-AES.bak'
 With Init, NoRecovery
Go

-- Exemplo 1 --

--Restaurando o Filegroup(Primary)
Use master
Go

Restore Database AES 
 Filegroup = 'Primary' 
 From Disk = 'C:\BANCOS\Backup-Primary-AES.bak'
 With Partial, NoRecovery, Replace
Go

--Restaurando o Filegroup(Secundario)
Use master
Go

Restore Database AES 
 Filegroup = 'Secundario' 
 From Disk = 'C:\BANCOS\Backup-Secundario-AES.bak'
 With NoRecovery
Go

--Restaurando do Log e liberando o Banco de Dados
Use master
Go

Restore Log AES 
 From Disk = 'C:\BANCOS\Backup-Log-AES.bak'
 With Recovery
Go

Select * from sys.master_files

Select * from T1

Select * from T2

Select * from T3

-- Exemplo 2 --
--Restaurando o Backup Full e forçando a leitura dos filegroups
Use master
Go

Restore Database AES READ_WRITE_FILEGROUPS
 From Disk = 'C:\BANCOS\Backup-Full-AES.bak'
 With File=1, Replace, NoRecovery
Go 

--Restore File e Filegroup 
Restore Database AES
 File = 'AES_Secundario_Dados',
 Filegroup = 'Secundario'
 From Disk = 'C:\BANCOS\Backup-Secundario-AES.bak'
 With File=1, Replace, NoRecovery

--Restaurando o Filegroup em Estado Offline 
Restore Database AES 
 Filegroup='Secundario' 
 From Disk ='C:\BANCOS\Backup-Secundario-AES.bak'
 With NoRecovery
Go
 
--Restaurando do Log e liberando o Banco de Dados
Use master
Go

Restore Log AES 
 From Disk = 'C:\BANCOS\Backup-Log-AES.bak'
 With Recovery
Go


Select * from AES.sys.filegroups

Use AES

Select * from sys.master_files

Select * from T1

Select * from T2

Select * from T3