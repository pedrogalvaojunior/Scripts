Create Database Teste

Use Teste

Create Table Categorias
(idCat Int Primary Key,
 Descricao Varchar(60))


Create Table Produtos
(idProduto Int Primary Key,
 Descricao Varchar(60),
 Categoria Int,
 Preco_Compra Decimal(18,2),
 Preco_Padrao_Venda Decimal(18,2))

Alter Table Produtos
 Add Constraint [FK_Categoria_Produtos] Foreign Key (Categoria)
  References Categorias(idcat)

Create Table Promocoes
(idPromocoes Int,
 idProduto int,
 Preco Decimal(18,2),
 Dataini Date,
 DataFim Date,
 divulgacao Varchar(200),
 CONSTRAINT PK_Promocoes PRIMARY KEY (idPromocoes, IdProduto))

Create Table Vendas_Produto
(IdNf Int,
 idProduto int,
 idPromocoes Int,
 qtd Int,
 CONSTRAINT PK_Vendas_Produto PRIMARY KEY (idNF, IdProduto))

Alter Table Vendas_Produto
 Add Constraint [FK_Promocoes_Vendas_Produtos] Foreign Key (idPromocoes, idProduto)
  References Promocoes(idPromocoes, idProduto)

Create Table Lojas
(idLJ Int Primary Key,
 Nome varchar(100),
 endereco Varchar(100),
 Telefone Varchar(15))

Create Table Clientes
(CPF Char(11) Primary Key ,
 Nome Varchar(80),
 Endereco Varchar(100),
 Telefone Varchar(15))

Create Table Vendas
(idNF Int Primary Key,
 DataCompra Date,
 ValorTotal Decimal(18,2),
 CPF Char(11),
 idLJ Int)

Alter Table Vendas
 Add Constraint [FK_Vendas_Clientes] Foreign Key (CPF)
  References Clientes(CPF)

Alter Table Vendas
 Add Constraint [FK_Lojas_Clientes] Foreign Key (idLJ)
  References Lojas(idLJ)

