-- Criando a Tabela A --
Create Table TabelaA
(Codigo Int Identity(1,1) Primary Key,
 Produto Char(5),
 Data Date,
 Quantidade Int,
 Status Char(1))
 Go

-- Criando a Tabela B --
 Create Table TabelaB
 (Codigo Int Identity(1,1) Primary Key,
  Ferramenta Char(5),
  Material Char(5))
Go

-- Criando a Tabela C --
Create Table TabelaC
(Codigo Int,
 Produto Char(5),
 Data Date,
 Quantidade Int,
 Ferramenta Char(5),
 Material Char(5))
Go

-- Inserindo Dados --
Insert Into TabelaA (Produto, Data, Quantidade, Status)
Values ('A',GetDate(),10,'P'),
       ('B',GetDate(),20,'N'),
       ('C',GetDate(),30,Null)
Go

Insert Into TabelaB (Ferramenta, Material)
Values ('F1','M1'),
       ('F2','M2'),
       ('F3','M3')
Go

-- Criando a Trigger --
Create Trigger T_TabelaA_Validar
On TabelaA
After Insert, Delete
As
Begin

Set NoCount On

Declare @Codigo Int  
-- Encerrando o trigger em caso de não ocorrer manipulação de linhas --
If (@@RowCount = 0)
Return;

If (Select Status From Inserted) Is Not Null
 Begin
  Set @Codigo = (Select Codigo From Inserted)

  Insert Into TabelaC (Codigo, Produto, Data, Quantidade, Ferramenta, Material)
  Select A.Codigo, A.Produto, A.Data, A.Quantidade,
         B.Ferramenta, B.Material
  From TabelaA A Inner Join TabelaB B
                On A.Codigo = B.Codigo
  Where A.Codigo = @Codigo
  End

 If (Select Status From Deleted) Is Not Null
  Begin
   Set @Codigo = (Select Codigo From Deleted)

   Delete From TabelaC 
   Where Codigo = @Codigo
  End

End

-- Criando a Trigger --
Create Trigger T_TabelaA_Validar
On TabelaA
After Insert, Delete
As
Begin

Set NoCount On

Declare @Codigo Int  

-- Encerrando o trigger em caso de não ocorrer manipulação de linhas --
If (@@RowCount = 0)
Return

If (Select Status From Inserted) Is Not Null
 Begin
  Set @Codigo = (Select Codigo From Inserted)

  Insert Into TabelaC (Codigo, Produto, Data, Quantidade, Ferramenta, Material)
  Select A.Codigo, A.Produto, A.Data, A.Quantidade,
         B.Ferramenta, B.Material
  From TabelaA A Inner Join TabelaB B
                On A.Codigo = B.Codigo
  Where A.Codigo = @Codigo
  End

 If (Select Status From Deleted) Is Not Null
  Begin
   Set @Codigo = (Select Codigo From Deleted)

   Delete From TabelaC 
   Where Codigo = @Codigo
  End

End

-- Testando --
Insert Into TabelaB (Ferramenta, Material)
Values ('F4','M4')
Go

Insert Into TabelaA (Produto, Data, Quantidade, Status)
Values ('D',GetDate(),40,'A')
Go

-- Validando os dados inseridos na Tabela C --
Select * From TabelaC
Go
