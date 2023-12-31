ALTER Procedure [dbo].[P_HelloWorld] (@NomeUsuario Varchar(20) = Null, @Idade TinyInt Output)
As
Begin

 Set NoCount On

 If @NomeUsuario Is Not Null
 Begin
  Select Concat('Hello World....',@NomeUsuario,' a minha idade é: ',@Idade)
 End
 Else
  Select 'Informe o valor para o parâmetro....'

End

-- Utilizando --
Declare @Idade Int

Select @Idade=CodigoProduto From Produtos
Where CodigoProduto=1

-- Executando --
Exec P_HelloWorld 'Pedro', @Idade Output

-- Aproveitando o parâmetro Output --
Select 'Reutilizando o valor do Output ' + Convert(Char(2),@Idade)
Go