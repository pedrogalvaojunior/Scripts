Declare @Tabela table
 (Codigo Int Identity(1,1),
   Produto VarChar(10))

Insert Into @Tabela Values('Arroz')
Insert Into @Tabela Values('Feijão')
Insert Into @Tabela Values('Açucar')
Insert Into @Tabela Values('Batata')
Insert Into @Tabela Values('Tomate')

--Select será executado e organizado tendo como base o campo codigo
Select * from @tabela

--Select será executado e organizado tendo como base o valor único gerado pela função NewID(), sendo que a cada nova execução um novo ID para cada registro será gerado!!!
Select * from @tabela
Order By NewId()