--Criando Function - InLine - Table Value
Create Function F_City (@NomeCidade VarChar(100))
Returns Table
As
 Return(
  Select * from Person.Address
  Where City = @NomeCidade) 

--Executando
Select * from F_City ('Bothell')

-- Criando Function - Scalar
Alter Function F_Scalar_Valor (@Numero Int)
Returns Int
As
 Begin
  Declare @Numero2 Int
  Set @Numero2=1

  Set @Numero2=@Numero2+@Numero
  
  Return (@Numero2)
 End

--Executando
Select dbo.F_Scalar_Valor (10)

-- Criando Function - Multi - Statament - Table - Value
Alter Function F_Multi_Statament_Tabela (@Id Int)
Returns @Tabela1 Table
 (codigo int,
  descricao varchar(10))
As
 Begin
  --With tabela1(codigo,descricao) 

  Insert @Tabela1
  Select Codigo, Descricao from Tabela1
   Where Codigo = @Id
  Return
 End

--Executando
Select * from F_Multi_Statament_Tabela (1)
