Declare @Tabela table
 (Codigo Int Identity(1,1),
   Produto VarChar(10))

Insert Into @Tabela Values('Arroz')
Insert Into @Tabela Values('Feij�o')
Insert Into @Tabela Values('A�ucar')
Insert Into @Tabela Values('Batata')
Insert Into @Tabela Values('Tomate')

--Select ser� executado e organizado tendo como base o campo codigo
Select * from @tabela

--Select ser� executado e organizado tendo como base o valor �nico gerado pela fun��o NewID(), sendo que a cada nova execu��o um novo ID para cada registro ser� gerado!!!
Select * from @tabela
Order By NewId()