Create Database TableHints
Go

Use TableHints
Go

-- Criando as Tabelas - UpdLockTable e TabLockTable --
Create Table UpdLockTable 
(Codigo Int Identity(1,1) Not Null Primary Key Clustered,
  Valores Varchar(20))
Go

Create Table TabLockTable 
(Codigo Int Identity(1,1) Not Null Primary Key Clustered,
  Valores Varchar(20))
Go

-- Inserindo uma pequena por��o de dados --
Insert Into  UpdLockTable
Values ('Pedro'), ('Antonio'), ('Galv�o'), ('Junior'), 
            ('MVP'), ('MCC'), ('MSTC'), ('MIE'), ('SQL Server'),
			('Banco de Dados'),('Table Hint UpdLock')
Go

Insert Into  TabLockTable
Values ('Pedro'), ('Antonio'), ('Galv�o'), ('Junior'), 
            ('MVP'), ('MCC'), ('MSTC'), ('MIE'), ('SQL Server'),
			('Databases'),('Table Hint TabLock')
Go

-- Consultando os dados --
Select Codigo, Valores From UpdLockTable
Order By Valores Desc

Select Codigo, Valores From TabLockTable
Order By Valores Asc
Go

-- Utilizando o UpdLock --
Begin Transaction TUPD

Update UpdLockTable
Set Valores = 'BD'
Where Codigo = 10
Go

-- Rollback Transaction TUPD

/* Abrir uma nova sess�o */
Begin Transaction TUPDII

Update UpdLockTable 
Set Valores =  'Banco'
Where Codigo = 10
Go

Select * From UpdLockTable
Go

--Rollback Transaction TUPDII

-- Realizar novamente o Update agora com UpdLock e Abrir nova Sess�o --
Begin Transaction TUPD

Update UpdLockTable With (UpdLock)
Set Valores = 'For�ando UpdLock'
Where Codigo = 11
Go

--Commit Transaction TUPD

Begin Transaction TUPDII

Update UpdLockTable 
Set Valores =  'For�ando UpdLock'
Where Codigo = 11
Go

Select * From UpdLockTable
Go

-- Utilizando o TabLock --
Begin Transaction TTBL

Declare @Contador TinyInt = 1

Select 'In�cio...'

While @Contador < 255
 Begin
  
  Update TabLockTable
  Set Valores = @Contador
  Where Codigo = 10

  Select Valores From TabLockTable
  Where Codigo = 10

  Set @Contador += 1 
End

Select 'Fim...'
Go

Commit Transaction TTBL

-- Abrir nova Sess�o e realizar Insert com sucesso --
Insert Into TabLockTable Values ('Teste TabLock')
Go

-- Adicionar TabLock --
Begin Transaction TTBL

Declare @Contador TinyInt = 1

Select 'In�cio...'

While @Contador < 255
 Begin
  
  Update TabLockTable With (TabLock)
  Set Valores = @Contador
  Where Codigo = 10

  Select Valores From TabLockTable
  Where Codigo = 10

  Set @Contador += 1 
End

Select 'Fim...'
Go

Commit Transaction TTBL

-- Abrir nova Sess�o e realizar Insert vai ocorrer bloqueio --
Insert Into TabLockTable Values ('Teste TabLock II')
Go