--Criando Table Produtos /0003--

Create Table ProdutosBarra3
 (Codigo Int Identity(1,1),
   Descricao VarChar(20),
   Data DateTime default Getdate())
Go

--Criando Table Produtos /0002--
Create Table ProdutosBarra2
 (Codigo Int Identity(1,1),
   Descricao VarChar(20),
   Data DateTime default Getdate())
Go

--Criando Table Movimentação--
Create Table Movimentacao
 (CodSequencial Int Identity(1,1),
   CodProduto Int,
   CodMovimentacao Int,
   DataMovimentacao DateTime,
   Quantidade Int,
   LocalEstoque Int)
Go

--Criando Table Movimentação Auxiliar--
Create Table MovimentacaoAuxiliar
 (CodSequencial Int Identity(1,1),
   CodProduto Int,
   CodMovimentacao Int,
   DataMovimentacao DateTime,
   Quantidade Int,
   LocalEstoque Int)
Go

--Carregando dados Produtos--
Insert Into ProdutosBarra3 Values('Borracha',default)
Insert Into ProdutosBarra3 Values('Papel',default)
Insert Into ProdutosBarra3 Values('Lápis',default)
Go

Insert Into ProdutosBarra2 Values('Borracha',default)
Insert Into ProdutosBarra2 Values('Papel',default)
Insert Into ProdutosBarra2 Values('Lápis',default)
Go

--Carregando dados Movimentação--
Insert Into Movimentacao Values(1,54,'2007-07-20',100,1)
Insert Into Movimentacao Values(1,54,'2007-06-20',100,1)
Insert Into Movimentacao Values(1,54,'2007-05-20',100,1)
Insert Into Movimentacao Values(1,54,'2007-04-20',100,2)
Insert Into Movimentacao Values(1,54,'2007-03-20',100,2)
Go

Insert Into Movimentacao Values(2,54,'2007-08-22',100,2)
Insert Into Movimentacao Values(2,54,'2007-07-22',100,2)
Insert Into Movimentacao Values(2,54,'2007-06-22',100,2)
Insert Into Movimentacao Values(2,54,'2007-05-22',100,1)
Insert Into Movimentacao Values(2,54,'2007-04-22',100,1)
Go

Insert Into Movimentacao Values(1,58,'2007-08-30',100,1)
Insert Into Movimentacao Values(1,58,'2007-07-30',100,1)
Insert Into Movimentacao Values(1,58,'2007-06-30',100,1)
Insert Into Movimentacao Values(1,58,'2007-05-30',100,2)
Insert Into Movimentacao Values(1,58,'2007-04-30',100,2)
Go

Insert Into Movimentacao Values(2,58,'2007-07-21',100,2)
Insert Into Movimentacao Values(2,58,'2007-06-21',100,2)
Insert Into Movimentacao Values(2,58,'2007-05-20',100,2)
Insert Into Movimentacao Values(2,58,'2007-04-20',100,1)
Insert Into Movimentacao Values(2,58,'2007-03-20',100,1)
Go

--Processo para análise de movimentação --
Truncate Table MovimentacaoAuxiliar

Set NoCount On

Declare @Contador Int,
           @CodProduto Int

Set @Contador = 1

While @Contador < (Select Count(CodSequencial) from Movimentacao)
 Begin
  
  Select Top 1 @CodProduto = CodProduto From Movimentacao Where CodProduto=@Contador
 
  If (Select Max(DataMovimentacao) from Movimentacao Where CodProduto = @CodProduto And CodMovimentacao=58) > (Select Max(DataMovimentacao) from Movimentacao Where CodProduto = @CodProduto And CodMovimentacao=54)
   Begin
    Insert Into MovimentacaoAuxiliar (CodProduto, CodMovimentacao, DataMovimentacao, Quantidade, LocalEstoque)
    Select CodProduto,  
             CodMovimentacao,
             Max(DataMovimentacao), 
             Quantidade,
             LocalEstoque from Movimentacao 
    Where CodProduto = @CodProduto 
    And CodMovimentacao=54 
    Group By CodProduto, CodMovimentacao, Quantidade, LocalEstoque
   End
   Else
    Begin
     
     IF Not Exists (Select CodProduto from MovimentacaoAuxiliar Where CodProduto = @CodProduto And CodMovimentacao=58)
      Begin
       
       Insert Into MovimentacaoAuxiliar (CodProduto, CodMovimentacao, DataMovimentacao, Quantidade, LocalEstoque)
        Select CodProduto,  
                 CodMovimentacao,
                 Max(DataMovimentacao), 
                 Quantidade,
                 LocalEstoque from Movimentacao 
        Where CodProduto = @CodProduto 
        And CodMovimentacao=58 
        Group By CodProduto, CodMovimentacao, Quantidade, LocalEstoque
      End
    End
  Set @Contador=@Contador+1
 End

Select * from MovimentacaoAuxiliar
Where DataMovimentacao > (Select DataMovimentacao From MovimentacaoAuxiliar Where CodMovimentacao=54 And LocalEstoque=2)





