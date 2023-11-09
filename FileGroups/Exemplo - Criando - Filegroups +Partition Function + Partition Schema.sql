Create Database Particionamento
ON PRIMARY
	(NAME = Particionamento_Dados,
	  FILENAME = N'C:\SQL\Teste_Dados.mdf',
          SIZE = 2MB,
          MAXSIZE = Unlimited,
          FILEGROWTH = 10%)
LOG ON
	( NAME = Particionamento_Log,
	  FILENAME = N'C:\SQL\Particionamento_Log.ldf',
          SIZE = 4MB,
          MAXSIZE = Unlimited,
          FILEGROWTH = 10%)

Alter Database Particionamento 
Add FileGroup ParticionamentoFG1
Go

Alter Database Particionamento
Add File
 (Name = Particionamento_Dados_Segundo,
  FileName = 'C:\SQL\Particionamento_Dados_Segundo.ndf',
  Size = 2MB,
  MaxSize = Unlimited,
  Filegrowth = 10%)
To Filegroup ParticionamentoFG1
Go

Alter Database Particionamento
Add FileGroup ParticionamentoFG2
Go

Alter Database Particionamento
Add File
 (Name = Particionamento_Dados_Terceiro,
  FileName = 'C:\SQL\Particionamento_Dados_Terceiro.ndf',
  Size = 5MB,
  MaxSize = Unlimited,
  Filegrowth = 10%)
To Filegroup ParticionamentoFG2
Go

CREATE PARTITION FUNCTION PF_Valores (Int)
AS RANGE Left FOR VALUES (1,4,8) 
GO

CREATE PARTITION SCHEME PS_Valores
AS PARTITION PF_Valores
TO (TesteFG1, TesteFG1, TesteFG2, TesteFG2);
GO
 
Create Table Valores
 (Codigo Int Identity(1,1),
  Descritivo Varchar(20) Not Null,
  Valor Int Not Null)
On PS_Valores(Valor)


Insert Into Valores (Descritivo, Valor)
Values ('Este é um teste',10)
Go 100000


Insert Into Valores (Descritivo, Valor)
Values ('Este é um teste',3)
Go 100000

select * from sys.filegroups

select * from sys.partition_schemes

select * from sys.partition_functions

select * from sys.data_spaces

select * from sys.destination_data_spaces

Select * from Valores