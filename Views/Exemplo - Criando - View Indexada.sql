-- Criando a Tabela --
Create Table Produtos
 (Codigo SmallInt Identity(1,1) Primary Key Clustered,
  Descricao VarChar(20) Default 'Sem Descrição',
  Quantidade As (Codigo+1))
Go

-- Inserindo 1000 linhas de registros lógicos --
Insert Into Produtos Default Values
Go 1000

-- Ativando as Diretivas Sets para garantir o funcionamento correto da View Indexada --
SET NUMERIC_ROUNDABORT OFF
Go

SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
Go

-- Criando a Visão --
Create View V_RelatorioProdutos With SchemaBinding
As 
 Select Codigo, Descricao, Quantidade from dbo.Produtos
Go

-- Criando o índice Unique Clustered para coluna Valor aplicada a Visão V_RelatorioProdutos --
Create Unique Clustered Index Ind_V_RelatorioProdutosQuantidade On V_RelatorioProdutos (Quantidade)
Go

-- Validando a estrutura do índice --
Exec sp_helpindex V_RelatorioProdutos
Go

-- Ativar o plano de execução - CTRL+M ---

-- Ativando o indicador de Input e Output -- Para identificar a quantidade de Logical Reads e Physical Reads --
Set Statistics IO ON

-- Executando a Visão sem uso do índice através da Option (Expand Views)
Select * From V_RelatorioProdutos 
Where Quantidade=100
Option (Expand Views)

Set Statistics IO Off -- Desativando o indicador de Input e Output --
Go

-- Executando a Visão fazendo uso do índice através instrução With (NoExpand)
Set Statistics IO On

Select * From V_RelatorioProdutos With (NoExpand)
Where Quantidade=100

Set Statistics IO Off
Go
