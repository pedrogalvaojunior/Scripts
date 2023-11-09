CREATE DATABASE TESTE

-- Criando uma nova Sequ�ncia de Valores --
CREATE SEQUENCE Seq As INT -- Tipo
 START WITH 1 -- Valor Inicial (1)
 INCREMENT BY 1 -- Avan�a de um em um
 MINVALUE 1 -- Valor m�nimo 1
 MAXVALUE 10000 -- Valor m�ximo 10000
 CACHE 100 -- Mant�m 10 posi��es em cache
 NO CYCLE -- N�o ir� reciclar

 -- Criando a Tabela Dados --
Create Table Dados
  (Descricao VarChar(60) Null,
   Valor Float Null,
   Date Date Default GetDate(),
   Time Time Default GetDate())

-- Inserindo a Massa de Dados --
Insert Into Dados (Descricao, Valor)
Values ('Ola...'+Convert(Varchar(100),Rand()),Rand())
Go 1000

-- Executando o Select em conjunto com Sequence e Verificar o Plano de Execu��o --
Select Next Value for Seq As Codigo, Descricao, Valor, Date, Time from Dados

-- Limpando o Cache de Execu��o --
DBCC FREEPROCCACHE
 
 -- Ativando as Estat�sticas de Time e IO --
SET STATISTICS TIME ON
SET STATISTICS IO ON
Go

-- Criando o ColumnStore Index --
CREATE NONCLUSTERED COLUMNSTORE INDEX ColumStoreIndex_Dados
ON dbo.Dados
(
     Descricao,
	 Valor,
	 Date,
	 Time     
)

-- Executando o novamente o Select com ColumnStore Index e Verificar o Plano de Execu��o --
Select Next Value for Seq As Codigo, Descricao, Valor, Date, Time from Dados 
Go


-- Executando o novamente o Select ignorando o ColumnStore Index e Verificar o Plano de Execu��o --
Select Next Value for Seq As Codigo, Descricao, Valor, Date from Dados 
OPTION (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX);
Go


-- Executando o novamente o Select + Group By com ColumnStore Index e Verificar o Plano de Execu��o --
Select Next Value for Seq As Codigo, Descricao, Valor, Date, Count(Time) As Contagem from Dados 
Group By Descricao, Valor, Date
Go

-- Executando o novamente o Select + Group By ignorando o ColumnStore Index e Verificar o Plano de Execu��o --
Select Next Value for Seq As Codigo, Descricao, Valor, Date, Count(Time) As Contagem from Dados 
Group By Descricao, Valor, Date
OPTION (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX);
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