Create Table Tabela1
(Codigo Int,
 ValoresXXX Int,
 ValoresYYY Int)
Go

Create Table Tabela2
(Codigo Int,
 ValoresXXX Int,
 ValoresYYY Int)
Go

Insert Into Tabela1 Values (1,10,100),(2,20,200),(3,30,300)
Go

Insert Into Tabela2 Values (1,10,100),(2,20,200),(3,30,300)
Go

Create Trigger T_InserirTabela1
On Tabela1
After Insert
As
Begin

 Declare @Codigo Int, @ValoresXXXNovo Int, @ValoresYYYNovo Int

 Select @Codigo = Codigo,
        @ValoresXXXNovo = ValoresXXX,
        @ValoresYYYNovo = ValoresYYY
 From inserted


 If (((Select ValoresXXX From Tabela1 Where Codigo = @Codigo) = @ValoresXXXNovo) And (Select ValoresYYY From Tabela1 Where Codigo = @Codigo) = @ValoresYYYNovo)
  Begin
   Update Tabela2
   Set ValoresXXX = @ValoresXXXNovo,
       ValoresYYY = @ValoresYYYNovo
   Where Codigo = @Codigo
 End
End