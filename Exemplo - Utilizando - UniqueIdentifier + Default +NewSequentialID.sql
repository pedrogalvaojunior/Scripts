-- Exemplo 1 --
Create Table T1
 (Codigo UniqueIdentifier Primary Key,
  Descricao varchar(100))
Go

Insert Into T1 (Codigo, Descricao)
Values (NewId(), 'Oi'),
             (NewId(), 'Testando')
Go

Select * From T1
Go

-- Exemplo 2 --
Create Table T2
 (Codigo UniqueIdentifier Primary Key Default NewSequentialID(),
  Descricao varchar(100))
Go

Insert Into T2 (Descricao)
Values ( 'Oi'),
             ('Testando')
Go

Select * From T2
Go