-- Utilizando o banco de dados TempDB--
Use TempDB
Go

-- Criando a Tabela TBOrigem --
Create Table TBOrigem
(Codigo Int Primary Key Identity(1,1),
 Texto Varchar(100) Null,
 Contador UniqueIdentifier Not Null,
 DataCadastro DateTime Default GetDate())
Go

-- Criando a Tabela TBDestino --
Create Table TBDestino
(Codigo Int Primary Key Identity(1,1),
 Texto Varchar(100) Null,
 Contador UniqueIdentifier Not Null,
 DataCadastro DateTime Default GetDate())
Go

-- Inserindo linhas de registros --
Insert Into TBOrigem (Texto, Contador)
Values('Este é um teste de transferência de estrutura...', NEWID())	
Go 10000

-- Consultando informações sobre as páginas de dados --
DBCC Ind('TempDB','TBOrigem',1)
Go

DBCC Ind('TempDB','TBDestino',1)
Go

 -- Realizando a Transferência da Estrutura da Tabela TBOrigem para TBDestino --
Alter Table TBOrigem Switch To TBDestino
Go

Select * from TBOrigem
Go

Select Top 100 Codigo, Texto, Contador, DataCadastro from TBDestino
Go


-- Consultando informações sobre as páginas de dados --
DBCC Ind('TempDB','TBOrigem',1)
Go

DBCC Ind('TempDB','TBDestino',1)
Go

-- Renomeando a Tabela TBOrigem para TBOrigemOld --
exec sp_rename 'dbo.TBOrigem','TBOrigemOld'
Go

-- Renomeando a Tabela TBDestino para TBOrigem --
exec sp_rename 'dbo.TBDestino','TBOrigem'
Go

-- Consultando os dados --
select * from TBOrigemOld
Go

select * from TBOrigem
Go