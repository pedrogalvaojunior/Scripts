Use Aula2
Go

Create Table Produtos
(Codigo Int Primary Key,
 Descricao Varchar(10) Not Null)
Go

Create Table Pedidos
(Codigo Int Primary key,
 CodProduto Int Not Null,
 Valor Int)
Go

Insert Into Produtos Values(1,'A'),(2,'B'),(3,'C')

Insert Into Pedidos Values (1,1,10), (2,1,20), (3,2,30),(4,2,40),(5,1,10)

Create Function F_RetornarProdutosXPedidos (@CodProduto Int)
 Returns @Resultado Table
 (codigo int,
  descricao varchar(10),
  Valor Int)
As
 Begin

  Insert @Resultado
  Select Pe.Codigo, Pr.Descricao, Pe.Valor 
  from Pedidos Pe Inner Join Produtos Pr
                   On Pe.CodProduto = Pr.Codigo                                        
   Where Pe.CodProduto = @CodProduto
  Return
End

Select * from Produtos

Select * from Pedidos

Select * from Produtos P Inner Join F_RetornarProdutosXPedidos(1) F
                          On P.Codigo = F.Codigo

