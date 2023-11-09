-- Criando o Banco de Dados --
Create Database ControleDeEstoque
Go

-- Acessando o Banco de Dados --
Use ControleDeEstoque
Go

-- Bloco de C�digo 2 -- Criando a Tabela Movimentacao �
Create Table Movimentacao
(CodigoMovimentacao Int Primary Key Identity(1,1),
CodigoProduto Int Not Null,
 CodigoLancamentoContabil Int Not Null,
DataMovimentacao Date Default GetDate())
Go

-- Bloco de C�digo 3 � Inserindo a massa de dados na Tabela Movimentacao --
Insert Into Movimentacao (CodigoLancamentoContabil, CodigoProduto)
Values (1,1),(2,1),(3,1),(4,1),
(1,2),(2,2),(3,2),(4,2),
(1,3),(2,3),(3,3),(4,3)
Go

-- Consultando os dados --
Select CodigoMovimentacao, CodigoLancamentoContabil, CodigoProduto, DataMovimentacao
From Movimentacao
Go

-- Bloco de C�digo 4 � Removendo alguns lan�amentos para similar a aus�ncia num�rica --
Delete From Movimentacao
Where CodigoProduto = 2
And CodigoLancamentoContabil = 1
Go

Delete From Movimentacao
Where CodigoProduto = 3
And CodigoLancamentoContabil = 2
Go

Delete From Movimentacao
Where CodigoProduto = 3
And CodigoLancamentoContabil = 3
Go

-- Bloco de C�digo 5 � Identificando as quantidades de lan�amentos cont�beis por produtos --
Select M.CodigoProduto, 
           Min(CodigoLancamentoContabil) As MenorLancamentoCadastrado,
           Max(CodigoLancamentoContabil) As MaiorLancamentoCadastrado,
           Count(CodigoLancamentoContabil) As QuantidadeLancamento
From Movimentacao M
Group By M.CodigoProduto
Go

-- Bloco de C�digo 6 - Criando a Stored Procedure P_IdentificarSequenciaNumerica --
Create Or Alter Procedure P_IdentificarSequenciaNumerica (@CodigoProduto Int)
As
Begin
 Declare @ContadorDeLancamento TinyInt,
               @QuantidadeDeLancamentos TinyInt,
			   @Comando NVarchar(Max)=''

 Select @ContadorDeLancamento=(IIf(Min(CodigoLancamentoContabil)>1,1,Min(CodigoLancamentoContabil))),
            @QuantidadeDeLancamentos=(Max(CodigoLancamentoContabil))
  From Movimentacao 
  Where CodigoProduto = @CodigoProduto

  While @ContadorDeLancamento <= @QuantidadeDeLancamentos
   Begin
    
	If Exists (Select CodigoLancamentoContabil From Movimentacao 
	               Where CodigoProduto = @CodigoProduto
				   And CodigoLancamentoContabil = @ContadorDeLancamento)
	Begin
	 Set @Comando=@Comando+' Select  * From (Values ('+Concat(@CodigoProduto,',',@ContadorDeLancamento,',', '''Lan�amento cadastrado''',')) As SequenciaNumerica (Produto, Lancamento, Status) ')
    End
    Else 
	 Begin
      Set @Comando=@Comando+' Select * From (Values ('+Concat(@CodigoProduto,',',@ContadorDeLancamento,',','''Lan�amento n�o cadastrado''',')) As SequenciaNumerica (Produto, Lancamento, Status) ')
     End

    Set @ContadorDeLancamento +=1

	If @ContadorDeLancamento <=@QuantidadeDeLancamentos
	 Set @Comando=@Comando +' Union '
    Else
	 Set @Comando=@Comando
  End

 EXEC sys.sp_executesql 
         @stmt = @Comando,
		 @params = N'@CodigoProduto Int',
		 @CodigoProduto = @CodigoProduto	
End

-- Bloco de C�digo 6 - Criando a Stored Procedure P_IdentificarSequenciaNumerica Vers�o 2 --
Create Or Alter Procedure P_IdentificarSequenciaNumerica (@CodigoProduto Int)
As
Begin
 Declare @ContadorDeLancamento TinyInt,
               @QuantidadeDeLancamentos TinyInt,
			   @Comando NVarchar(500)=''

 Select @ContadorDeLancamento=(IIf(Min(CodigoLancamentoContabil)>1,1,Min(CodigoLancamentoContabil))),
            @QuantidadeDeLancamentos=(Max(CodigoLancamentoContabil))
  From Movimentacao 
  Where CodigoProduto = @CodigoProduto

  While @ContadorDeLancamento <= @QuantidadeDeLancamentos
   Begin
    
	If Exists (Select CodigoLancamentoContabil From Movimentacao 
	               Where CodigoProduto = @CodigoProduto
				   And CodigoLancamentoContabil = @ContadorDeLancamento)
	 Set @Comando=@Comando+' Select '+Concat(@CodigoProduto,' As CodigoProduto, ',@ContadorDeLancamento,' As CodigoLancamentoContabil,','''Lan�amento cadastrado'' As Status')
    Else 
	  	 Set @Comando=@Comando+' Select '+Concat(@CodigoProduto,' As CodigoProduto, ',@ContadorDeLancamento,' As CodigoLancamentoContabil,','''Lan�amento n�o cadastrado'' As Status')

    Set @ContadorDeLancamento +=1

	If @ContadorDeLancamento <=@QuantidadeDeLancamentos
	 Set @Comando=@Comando +' Union '
    Else
	 Set @Comando=@Comando
  End

  EXEC sys.sp_executesql @stmt = @Comando, @params = N'@CodigoProduto Int', @CodigoProduto = @CodigoProduto	
End

-- Executando --
Exec P_IdentificarSequenciaNumerica 1
Go