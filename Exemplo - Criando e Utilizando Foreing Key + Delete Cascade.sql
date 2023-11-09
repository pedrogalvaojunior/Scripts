Create Table Tabela1
 (Codigo Int Identity(1,1),
   Descricao VarChar(10))

Alter Table Tabela1
 Add Constraint [PK_Codigo_Tabela1] Primary Key Clustered (Codigo)

Create Table Tabela2
 (codigo Int identity(1,1),
   Cod_tabela1 int,
   descricao varchar(10))

Alter Table Tabela2
 Add Constraint [PK_Codigo_Tabela2] Primary Key Clustered (Codigo)

Alter Table Tabela2
 Add Constraint [FK_CodTabela1_Tabela2] Foreign Key (Cod_Tabela1) References tabela1(Codigo) On Delete Cascade


Insert Into Tabela1 Values('Teste1')
Insert Into Tabela1 Values('Teste2')
Insert Into Tabela1 Values('Teste3')
Insert Into Tabela1 Values('Teste4')
Insert Into Tabela1 Values('Teste5')

Insert Into Tabela2 Values(1,'Novo Item')
Insert Into Tabela2 Values(1,'Novo Item')
Insert Into Tabela2 Values(1,'Novo Item')

Insert Into Tabela2 Values(2,'Novo Item')
Insert Into Tabela2 Values(2,'Novo Item')
Insert Into Tabela2 Values(2,'Novo Item')

Select * from tabela1

Select * from tabela2

Delete from Tabela1
where codigo=2

