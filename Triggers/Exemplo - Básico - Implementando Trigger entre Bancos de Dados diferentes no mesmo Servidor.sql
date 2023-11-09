-- Criando os bancos de dados --
Create Database Banco1
Go

Create Database Banco2
Go

-- Criando a tabela Teste --
Use Banco1
Go

Create Table TabelaTeste
(Codigo Int)
Go

Create Table Banco2.dbo.TabelaTeste
(Codigo Int Not Null)
Go

-- Criando o Trigger --
Use Banco1
Go

Create Trigger T_UpdateTabelaTeste
On Banco1.dbo.TabelaTeste
After Update
As
Begin
 
  If (Select Count(*) From Banco2.dbo.TabelaTeste) <> 0
  Begin
   Update Banco2.dbo.TabelaTeste
   Set Codigo = (Select Codigo From Inserted)
  End
  Else
   Begin
    Insert Into Banco2.dbo.TabelaTeste
	Select * From inserted
   End
End

-- Testando Inserindo --
Insert Into Banco1.dbo.TabelaTeste Values (1)
Insert Into Banco1.dbo.TabelaTeste Values (2)
Insert Into Banco1.dbo.TabelaTeste Values (3)
Go

-- Consultando --
Select Codigo from TabelaTeste
Select Codigo From Banco2.dbo.TabelaTeste
Go

-- Testando Atualizando --
Update Banco1.dbo.TabelaTeste
Set Codigo = 5
Where Codigo = 3
Go

-- Consultando --
Select Codigo from TabelaTeste
Select Codigo From Banco2.dbo.TabelaTeste
Go