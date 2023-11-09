-- Criando o Banco de Dados Pitagoras --
CREATE DATABASE Pitagoras
Go

-- Acessando o Banco de Dados Pitagoras --
Use Pitagoras
Go

-- Criando uma nova Sequência de Valores --
CREATE SEQUENCE Seq As INT -- Tipo
 START WITH 1 -- Valor Inicial (1)
 INCREMENT BY 1 -- Avança de um em um
 MINVALUE 1 -- Valor mínimo 1
 MAXVALUE 100000 -- Valor máximo 100000
 CACHE 100 -- Mantém 10 posições em cache
 NO CYCLE -- Não irá reciclar
Go

-- Excluíndo a Tabela Dados --
If Object_Id('Dados') Is Not Null
 Drop Table Dados
Else
Begin
 -- Criando a Tabela Dados com Primary Key --
Create Table Dados
  (Descricao VarChar(60) Primary Key,
   Valor Float Null,
   Date Date Default GetDate(),
   Time Time Default GetDate())
End

-- Listando a Relação de Índices da Tabela dbo.FactProductIventory --
Exec sp_helpindex 'Dados'
Go

-- Inserindo a Massa de Dados --
Insert Into Dados (Descricao, Valor)
Values ('Ola...'+Convert(Varchar(100),Rand()),Rand())
Go 10000

-- Executando o Select em conjunto com Sequence e Verificar o Plano de Execução --
Select Next Value for Seq As Codigo, Descricao, Valor, Date, Time from Dados
Go

-- Limpando o Cache de Execução --
DBCC FREEPROCCACHE
Go
 
-- Criando o ColumnStore Index --
CREATE NONCLUSTERED COLUMNSTORE INDEX ColumnStoreIndex_Dados
ON dbo.Dados
(
     Descricao,
	 Valor,
	 Date,
	 Time     
)

-- Ativando as Estatísticas de Time e IO --
SET STATISTICS TIME ON
SET STATISTICS IO ON
Go

-- Executando o novamente o Select com ColumnStore Index e Verificar o Plano de Execução --
Select Next Value for Seq As Codigo, Descricao, Valor, Date, Time from Dados 
Go

-- Executando o novamente o Select ignorando o ColumnStore Index e Verificar o Plano de Execução --
Select Next Value for Seq As Codigo, Descricao, Valor, Date from Dados 
OPTION (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX);
Go

-- Executando o novamente o Select + Group By com ColumnStore Index e Verificar o Plano de Execução --
Select Next Value for Seq As Codigo, Descricao, Valor, Date, Count(Time) As Contagem from Dados 
Group By Descricao, Valor, Date
Go

-- Executando o novamente o Select + Group By ignorando o ColumnStore Index e Verificar o Plano de Execução --
Select Next Value for Seq As Codigo, Descricao, Valor, Date, Count(Time) As Contagem from Dados 
Group By Descricao, Valor, Date
OPTION (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX);
Go

-- Desativando as Estatísticas de Time e IO --
SET STATISTICS TIME OFF
SET STATISTICS IO OFF
Go

-- Tentando Inserir Dados com o ColumnStore Index em uso --
Insert Into Dados (Descricao, Valor)
Values ('Ola...'+Convert(Varchar(100),Rand()),Rand())
Go

-- Desativando o ColumnStore Index --
ALTER INDEX ColumStoreIndex_Dados
ON Dados DISABLE
GO

-- Inserindo novos Dados com o ColumnStore Index em desabilitado --
Insert Into Dados (Descricao, Valor)
Values ('Ola...'+Convert(Varchar(100),Rand()),Rand())
Go 1000

-- Realizando o Rebuild do ColumnStore Index --
ALTER INDEX ColumStoreIndex_Dados
ON Dados REBUILD PARTITION = ALL
GO