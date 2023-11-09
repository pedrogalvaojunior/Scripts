Create Database TableHints
Go

Use TableHints
Go

-- Criando as Tabelas - NoLockTable e ReadPastTable --
Create Table NoLockTable 
(Codigo Int Identity(1,1) Not Null Primary Key Clustered,
  Valores Varchar(20))
Go

Create Table ReadPastTable 
(Codigo Int Identity(1,1) Not Null Primary Key Clustered,
  Valores Varchar(20))
Go

-- Inserindo uma pequena porção de dados --
Insert Into  NoLockTable
Values ('Pedro'), ('Antonio'), ('Galvão'), ('Junior'), 
            ('MVP'), ('MCC'), ('MSTC'), ('MIE'), ('SQL Server'),
			('Banco de Dados'),('Table Hint NoLock')
Go

Insert Into  ReadPastTable
Values ('Pedro'), ('Antonio'), ('Galvão'), ('Junior'), 
            ('MVP'), ('MCC'), ('MSTC'), ('MIE'), ('SQL Server'),
			('Databases'),('Table Hint ReadPast')
Go

-- Consultando os dados --
Select Codigo, Valores From NoLockTable
Order By Valores Desc

Select Codigo, Valores From ReadPastTable
Order By Valores Asc
Go

-- Utilizando o NoLock --
Begin Transaction TNL

Update NoLockTable
Set Valores = 'BD'
Where Codigo = 10
Go

/* Abrir uma nova sessão */
Begin Transaction TNLII

Insert Into NoLockTable Values ('Forçando NoLock')
Go

-- Executar primeiro o Select sem Nolock, depois adicionar o NoLock --
Select * From NoLockTable With (NoLock)
Go

-- Utilizando o ReadPast --
Begin Transaction TNR

Update ReadPastTable
Set Valores = 'ReadPast'
Where Codigo = 10
Go

/* Abrir uma nova sessão */
Insert Into ReadPastTable Values ('Utilizando ReadPast')
Go

-- Executar primeiro o Select sem ReadPast, depois adicionar o ReadPast --
Select * From ReadPastTable With (ReadPast)
Go