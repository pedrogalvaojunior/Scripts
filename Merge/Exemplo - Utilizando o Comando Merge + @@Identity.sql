Create Table MeusProdutos
(Codigo TinyInt Identity(1,1),
 Descricao Varchar(50))

Create Table Estoque
(Codigo TinyInt Identity(1,1),
 CodProduto Int,
 Descricao Varchar(50))

Insert Into MeusProdutos Values ('Produto - '+CONVERT(VarChar(2),IsNull(@@Identity,1)))
Go 20

Select * from MeusProdutos

Merge Estoque Destino
Using MeusProdutos Origem
On Origem.Codigo = Destino.CodProduto
When Not Matched Then
 Insert Values (Origem.Codigo,  Origem.Descricao)
When Matched Then
 Update Set Destino.CodProduto = Origem.Codigo;


Select * from Estoque