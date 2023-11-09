-- Acessando o System Database SBO_GRUPO_COLISEU --
Use ProjetoDWQueimadas
Go

-- Identificando a alocação atual dos arquivos de dados e log --
Select * from Sys.sysfiles
Go 

/* Serão adicionados mais 3 novos arquivos de dados, formando um total de 4 arquivos, número 
indicado de acordo com a quantidade processadores reconhecidos pelo SQL Server dividido / 2 */

-- Adicionando os novos arquivos --
Use Master
Go

Alter Database ProjetoDWQueimadas
Add File
 (
      NAME = ProjetoDWQueimadas_Data1,
      FILENAME = 'S:\MSSQL-2017\Data\ProjetoDWQueimadas_data1.ndf',
      SIZE = 2048MB,
      MAXSIZE = Unlimited,
      FILEGROWTH = 4096MB
  )
Go

Alter Database ProjetoDWQueimadas
Add File
 (
      NAME = ProjetoDWQueimadas_Data2,
      FILENAME = 'S:\MSSQL-2017\Data\ProjetoDWQueimadas_data2.ndf',
      SIZE = 2048MB,
      MAXSIZE = Unlimited,
      FILEGROWTH = 4096MB
  )
Go

Alter Database ProjetoDWQueimadas
Add File
 (
      NAME = ProjetoDWQueimadas_Data3,
      FILENAME = 'S:\MSSQL-2017\Data\ProjetoDWQueimadas_data3.ndf',
      SIZE = 2048MB,
      MAXSIZE = Unlimited,
      FILEGROWTH = 4096MB
  )
Go

-- Identificando a nova distribuição de arquivos de dados e log --
Select name, physical_name, size, max_size, growth From sys.master_files  
Where database_id = DB_ID('ProjetoDWQueimadas')  
Go
