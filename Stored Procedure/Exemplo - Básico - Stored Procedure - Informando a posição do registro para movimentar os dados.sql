Create Table Teste
(Id TinyInt Primary Key,
 IdProduto TinyInt,
 IDCT TinyInt,
 Valor Varchar(20),
 Ordem TinyInt)
Go

Insert Into Teste 
Values (1, 2, 1, 'Sansung',1),
       (2, 2, 3, 'Sansung',2),
       (3, 2, 4, 'Sansung',3),
       (4, 2, 4, 'Sansung',4)
Go

Alter Procedure P_MovimentarRegistros @Acao Char(1) = 'F' , @PosicaoAtual TinyInt = 1
As
Begin

Set NoCount On

If (@PosicaoAtual <= (Select Max(ID) From Teste) And @PosicaoAtual <> 0 And @Acao In ('F','P','N','L'))
Begin

 If @Acao = 'F'
  Set @PosicaoAtual = (Select Min(ID) From Teste)

 If @Acao = 'P' And @PosicaoAtual <= (Select Max(ID) From Teste)
  Set @PosicaoAtual = @PosicaoAtual - 1
 Else
  Set @PosicaoAtual = (Select Min(ID) From Teste)

 If @Acao = 'N' And @PosicaoAtual = (Select Max(ID) From Teste)
  Set @PosicaoAtual = (Select Min(ID) From Teste)
 Else
  Set @PosicaoAtual = @PosicaoAtual + 1

 If @Acao = 'L'
  Set @PosicaoAtual = (Select Max(ID) From Teste)


 Select * From Teste
 Where Ordem = @PosicaoAtual
End
End

-- Executando --
Exec P_MovimentarRegistros 'F',1
Go