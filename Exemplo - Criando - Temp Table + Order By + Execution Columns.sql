-- Criando uma Tabela Tempor�ria Local --
Create Table #MeusProdutos
(
 Codigo Int Identity(1,1) Primary Key,
  Descricao Varchar(20),
  Valor Float
)

-- Criando um Tabela Tempor�ria Global --
Create Table ##MeusProdutos
(
 Codigo Int Identity(1,1) Primary Key,
  Descricao Varchar(20),
  Valor Float
)

-- Inserindo 100 linhas de Registros --
Insert Into #MeusProdutos (Descricao, Valor)
                          Values('Meu Produto n:', 10.00)
Go 100

-- Consultando as Linhas Inseridas --
Select Codigo, Descricao, Valor From #MeusProdutos

-- Ordenando Valores--
Select Codigo, Descricao, Valor From #MeusProdutos
Order By Valor Asc

Select Codigo, Descricao, Valor From #MeusProdutos
Order By Valor Asc, Codigo Desc

-- Ordenando Valores atrav�s de uma coluna criada na execu��o do C�digo --
Select Codigo, Descricao, Valor, 
            Codigo+Valor As NovaColuna 
From #MeusProdutos
Order By NovaColuna Desc

-- Ordenando Valores atrav�s da Ordem de Declara��o das Colunas --
Select Codigo, 
            Descricao, 
            Valor, 
            Codigo+Valor As NovaColuna,
            Descricao + CONVERT(Varchar(3),Codigo) As NovaDescricao  
From #MeusProdutos
Order By  5 Asc