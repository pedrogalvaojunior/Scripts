Create Database DatabaseTableHints
Go

Use DatabaseTableHints
Go

-- Criando as Tabelas - ReadCommittedTable, RepeatableReadTable e SerializableTable --
Create Table ReadCommittedTable 
(Codigo Int Identity(1,1) Not Null Primary Key Clustered,
  Valores Varchar(30))
Go

Create Table RepeatableReadTable 
(Codigo Int Identity(1,1) Not Null Primary Key Clustered,
  Valores Varchar(30))
Go

Create Table SerializableTable 
(Codigo Int Identity(1,1) Not Null Primary Key Clustered,
  Valores Varchar(30))
Go

-- Inserindo uma pequena porção de dados --
Insert Into  ReadCommittedTable
Values ('Pedro'), ('Antonio'), ('Galvão'), ('Junior'), 
       ('MVP'), ('MCC'), ('MSTC'), ('MIE'), ('SQL Server'),
	   ('Banco de Dados'),('Table Hint ReadCommitted')
Go

Insert Into  RepeatableReadTable
Values ('Pedro'), ('Antonio'), ('Galvão'), ('Junior'), 
       ('MVP'), ('MCC'), ('MSTC'), ('MIE'), ('SQL Server'),
	   ('Banco de Dados'),('Table Hint RepeatableRead')
Go

Insert Into  SerializableTable
Values ('Pedro'), ('Antonio'), ('Galvão'), ('Junior'), 
       ('MVP'), ('MCC'), ('MSTC'), ('MIE'), ('SQL Server'),
	   ('Banco de Dados'),('Table Hint SerializableTable')
Go

-- Consultando os dados --
Select Codigo, Valores From ReadCommittedTable
Order By Valores Desc
Go

Select Codigo, Valores From RepeatableReadTable
Order By Valores Desc
Go

Select Codigo, Valores From SerializableTable
Order By Valores Desc
Go

-- Utilizando ReadCommitted --
Begin Transaction TRC

Update ReadCommittedTable
Set Valores = 'ReadCommitted'
Where Codigo = 11
Go

-- Forçando um Delay de 04 segundos para gerar bloqueio no nível de leitura compartilhadas -- 
WaitFor Delay  '00:00:04'
Go

-- Abrir nova query e executar o Select abaixo, após 10 segundos os dados serão apresentados --
Begin Transaction

Select * From ReadCommittedTable WITH(READCOMMITTED)
Where Codigo <10
Go

Commit Transaction

Select * From ReadCommittedTable WITH(READCOMMITTED)
Where Codigo=11
Go

-- Voltar para query anterior --

Update ReadCommittedTable
Set Valores = 'Databases...'
Where Codigo = 10

Commit Transaction TRC
Go

-- Abrir nova query e executar o Select abaixo, após 10 segundos os dados serão apresentados --
Begin Transaction

Select * From ReadCommittedTable WITH(READCOMMITTED)
Where Codigo <10
Go

Commit Transaction

Select * From ReadCommittedTable WITH(READCOMMITTED)
Where Codigo =10
Go

-- Voltar para query anterior --

Commit Transaction TRC
Go

-- Utilizando o RepeatableReadTable --

Begin Transaction TRT

Update RepeatableReadTable
Set Valores = 'Repeatable Read'
Where Codigo = 11
Go

-- Forçando um Delay de 04 segundos para gerar bloqueio no nível de leitura compartilhadas -- 
WaitFor Delay  '00:00:04'
Go

-- Abrir nova query e executar o Select abaixo, após 10 segundos os dados serão apresentados --
Begin Transaction

Select * From RepeatableReadTable WITH(RepeatableRead)
Go

-- Voltar para query anterior --

Begin Transaction TRTII

Update RepeatableReadTable
Set Valores = 'Databases'
Where Codigo = 10
Go

Commit Transaction TRTII
Go

Select Codigo, Valores From RepeatableReadTable
Order By Valores Desc
Go

Commit Transaction TRT
Go

-- Utilizando SerializableTable --
Begin Transaction TST

Select * From SerializableTable With (Serializable)
Go

WaitFor Delay '00:00:10'
Go

Commit Transaction TST
Go

-- Abrir nova query e executar o Select abaixo, após 10 segundos os dados serão apresentados --
Begin Transaction
Select 'Aguardando...' As 'Passo 1...'
Go

Select GetDate() As 'Passo 2 - Update Realizado...'

Update SerializableTable
Set Valores = 'SerializableTable'
Where Codigo = 11
Go

Select GetDate() As 'Passo 3 - Apresentar dados...'
Go

Select Codigo, Valores From SerializableTable
Where Codigo = 11

Commit Transaction
Go

Select GetDate() As 'Transações confirmadas...'
Go
