Create Table NovoUsuario
(Codigo TinyInt Identity(1,1) Primary Key,
 Descricao VarChar(10),
 Data DateTime,
 Senha Char(10))
Go

Insert Into NovoUsuario Values('Pedro', GetDate(),'')
Insert Into NovoUsuario Values('Eduardo', GetDate()-300,'')
Insert Into NovoUsuario Values('Joao', GetDate()-200,'')
Insert Into NovoUsuario Values('Malú', GetDate()-100,'')
Insert Into NovoUsuario Values('Fer', GetDate()-10,'')
Go

Select * From NovoUsuario
Go

Declare @Codigo TinyInt, @TotalDeLinhas TinyInt

Set @Codigo=1
Set @TotalDeLinhas = (Select Count(Codigo) from NovoUsuario)

While @Codigo <= @TotalDeLinhas
 Begin

  If ((Select Codigo From NovoUsuario Where Codigo = @Codigo) Is Not Null) And (Select Codigo From NovoUsuario Where Codigo = @Codigo) >0
   Begin  
    Update NovoUsuario
    Set Senha=Convert(Char(10),Data ,103)
    Where Codigo = @Codigo
   End

  Set @Codigo=@Codigo + 1
 End
Go

Select * From NovoUsuario
Go