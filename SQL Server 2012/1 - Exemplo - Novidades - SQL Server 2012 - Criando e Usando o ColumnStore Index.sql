-- Passo 1 -- Criando o Banco de Registros ColumnStoreIndex --
CREATE DATABASE ColumnStoreIndex
Go

-- Passo 1.1 -- Acessando o Banco de Registros ColumnStoreIndex --
Use ColumnStoreIndex
Go

-- Passo 2 -- Criando uma nova Sequência de Valores --
CREATE SEQUENCE Seq As INT -- Tipo
 START WITH 1 -- Valor Inicial (1)
 INCREMENT BY 1 -- Avança de um em um
 MINVALUE 1 -- Valor mínimo 1
 MAXVALUE 100000 -- Valor máximo 100000
 CACHE 100 -- Mantém 10 posições em cache
 NO CYCLE -- Não irá reciclar
Go

-- Passo 3 -- Criando a Tabela Registros com Primary Key --
Create Table Registros
  (Descricao VarChar(60) Not Null,
   Valor Float Null,
   Date Date Default GetDate(),
   Time Time Default GetDate())
Go

Alter Table Registros
 Add Constraint [PK_Registros] Primary Key Clustered (Descricao) On [Primary]
Go

-- Passo 3.1 -- Criando um Índice NonClustered para Tabela Registros --
CREATE NONCLUSTERED INDEX [IND_Registros_NonClustered]
ON Registros
 (Descricao, Valor, Date, Time)
Go

-- Passo 4 -- Listando a Relação de Índices da Tabela dbo.Registros --
Exec sp_helpindex 'Registros'
Go

-- Passo 5 -- Inserindo a Massa de Registros --
Insert Into Registros (Descricao, Valor)
Values ('Ola...'+Convert(Varchar(100),Rand()),Rand())
Go 10000

-- Passo 6 -- Executando o Select em conjunto com Sequence e Verificar o Plano de Execução --
Select Next Value for Seq As Codigo, Descricao, Valor, Date, Time from Registros
Go

-- Passo 7 -- Limpando o Cache de Execução - Procedure e Buffer --
DBCC DROPCLEANBUFFERS
DBCC FREEPROCCACHE
Go
 
-- Passo 8 -- Criando o ColumnStore Index --
CREATE NONCLUSTERED COLUMNSTORE INDEX ColumnStoreIndex_Registros
ON dbo.Registros
(
     Descricao,
     Valor,
     Date,
     Time     
)
Go

-- Passo 9 -- Ativando as Estatísticas de Time e IO --
SET STATISTICS TIME ON
SET STATISTICS IO ON
Go

-- Passo 10 -- Executando novamente o Select com ColumnStore Index e Verificar o Plano de Execução --
Select Next Value for Seq As Codigo, Descricao, Valor, Date, Time from Registros 
Go

-- Passo 11 -- Executando novamente o Select ignorando o ColumnStore Index e Verificar o Plano de Execução --
Select Next Value for Seq As Codigo, Descricao, Valor, Date from Registros 
OPTION (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX);
Go

-- Passo 12 -- Executando novamente o Select + Group By com ColumnStore Index e Verificar o Plano de Execução --
Select Next Value for Seq As Codigo, Descricao, Valor, Date, Count(Time) As Contagem from Registros 
Group By Descricao, Valor, Date
Go

-- Passo 13 -- Executando novamente o Select + Group By ignorando o ColumnStore Index e Verificar o Plano de Execução --
Select Next Value for Seq As Codigo, Descricao, Valor, Date, Count(Time) As Contagem from Registros 
Group By Descricao, Valor, Date
OPTION (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX);
Go

-- Passo 14 -- Desativando as Estatísticas de Time e IO --
SET STATISTICS TIME OFF
SET STATISTICS IO OFF
Go

-- Passo 15 -- Tentando Inserir Registros com o ColumnStore Index em uso --
Insert Into Registros (Descricao, Valor)
Values ('Ola...'+Convert(Varchar(100),Rand()),Rand())
Go

-- Passo 16 -- Desativando o ColumnStore Index --
ALTER INDEX ColumnStoreIndex_Registros
ON Registros DISABLE
GO

-- Passo 17 -- Inserindo novos Registros com o ColumnStore Index em desabilitado --
Insert Into Registros (Descricao, Valor)
Values ('Ola...'+Convert(Varchar(100),Rand()),Rand())
Go 1000

-- Passo 18 -- Realizando o Rebuild do ColumnStore Index --
ALTER INDEX ColumnStoreIndex_Registros
ON Registros REBUILD PARTITION = ALL
GO