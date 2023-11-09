Create Table Loja1
(Codigo Int Identity(1,1),
 CodProduto Int,
 Descricao Varchar(10))

Create Table Loja2
(Codigo Int Identity(1,1),
 CodProduto Int,
 Descricao Varchar(10))

Create Table Lojas
(Codigo Int Identity(1,1),
 CodProduto Int,
 Descricao Varchar(10))


Insert Into Loja1 Values (IsNull(@@Identity,1),'Loja 1')
Go 20

Insert Into Loja1 Values (IsNull(@@Identity,1),'Loja 2')
Go 15

Merge Lojas Destino
Using Loja1 Origem
On Origem.Codigo = Destino.Codigo
When Not Matched Then
 Insert Values(CodProduto, Descricao)
When Matched Then
 Update Set Destino.Codigo = Origem.Codigo;

Merge Lojas Destino
Using Loja2 Origem
On Origem.Codigo = Destino.Codigo
When Matched Then
 Update Set Destino.Descricao = 'Em ambas as lojas'
When Not Matched Then
 Insert Values (CodProduto, Descricao);