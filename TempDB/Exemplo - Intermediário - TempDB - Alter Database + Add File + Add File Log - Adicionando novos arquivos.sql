-- Acessando o System Database TempDB --
Use tempdb
Go

-- Identificando a alocação atual dos arquivos de dados e log --
Select * from Sys.sysfiles
Go 

-- Alterando o fator de crescimento do atual arquivo de dados e log --
Alter Database TempDB   
MODIFY FILE  
(NAME = tempdev,  
 Filegrowth = 1024MB) -- Definindo o fator de crescimento de 1Gb
Go

Alter Database TempDB   
MODIFY FILE  
(NAME = templog,  
 Filegrowth = 2048MB) -- Definindo o fator de crescimento de 2Gbs
Go

/* Serão adicionados mais 7 novos arquivos de dados, formando um total de 8 arquivos, número 
indicado de acordo com a quantidade processadores reconhecidos pelo SQL Server */

Alter Database TempDb
Add File
 (
      NAME = TempDev1,
      FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.ROJEMAC\MSSQL\DATA\tempdb1.ndf',
      SIZE = 10MB,
      MAXSIZE = Unlimited,
      FILEGROWTH = 1024MB
  )
Go

Alter Database TempDb
Add File
 (
      NAME = TempDev2,
      FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.ROJEMAC\MSSQL\DATA\tempdb2.ndf',
      SIZE = 10MB,
      MAXSIZE = Unlimited,
      FILEGROWTH = 1024MB
  )
Go

Alter Database TempDb
Add File
 (
      NAME = TempDev3,
      FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.ROJEMAC\MSSQL\DATA\tempdb3.ndf',
      SIZE = 10MB,
      MAXSIZE = Unlimited,
      FILEGROWTH = 1024MB
  )
Go

Alter Database TempDb
Add File
 (
      NAME = TempDev4,
      FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.ROJEMAC\MSSQL\DATA\tempdb4.ndf',
      SIZE = 10MB,
      MAXSIZE = Unlimited,
      FILEGROWTH = 1024MB
  )
Go

Alter Database TempDb
Add File
 (
      NAME = TempDev5,
      FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.ROJEMAC\MSSQL\DATA\tempdb5.ndf',
      SIZE = 10MB,
      MAXSIZE = Unlimited,
      FILEGROWTH = 1024MB
  )
Go

Alter Database TempDb
Add File
 (
      NAME = TempDev6,
      FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.ROJEMAC\MSSQL\DATA\tempdb6.ndf',
      SIZE = 10MB,
      MAXSIZE = Unlimited,
      FILEGROWTH = 1024MB
  )
Go

Alter Database TempDb
Add File
 (
      NAME = TempDev7,
      FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.ROJEMAC\MSSQL\DATA\tempdb7.ndf',
      SIZE = 10MB,
      MAXSIZE = Unlimited,
      FILEGROWTH = 1024MB
  )
Go

-- Identificando a nova distribuição de arquivos de dados e log --
Select name, physical_name From sys.master_files  
Where database_id = DB_ID('tempdb')  
Go

-- Habilitar Trace Flags T1117 e T1118 --

--T1117 Grow All Files in a FileGroup Equally
--T1118 Full Extents Only