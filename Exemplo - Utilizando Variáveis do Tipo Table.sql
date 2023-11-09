Declare @Tabela1 Table
 (Codigo Int Identity(1,1),
   Descricao VarChar(10))

Declare @Tabela2 Table
 (Codigo Int Identity(1,1),
   Descricao VarChar(10))


Insert Into @Tabela1 Values('Teste1')
Insert Into @Tabela1 Values('Teste2')
Insert Into @Tabela1 Values('Teste3')
Insert Into @Tabela1 Values('Teste4')

Insert Into @Tabela2 Values('Teste1')
Insert Into @Tabela2 Values('Teste2')
Insert Into @Tabela2 Values('Teste3')
Insert Into @Tabela2 Values('Teste4')

Insert Into @Tabela2 Values('Teste5')
Insert Into @Tabela2 Values('Teste6')
Insert Into @Tabela2 Values('Teste7')
Insert Into @Tabela2 Values('Teste8')

--Select * from @Tabela1

--Select * from @Tabela2

Select * from @Tabela1 
Where Exists(Select * from @Tabela2)



