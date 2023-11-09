Declare @Tabela Table
 (Codigo Int,
   Total1 Int,
   Total2 Int)


Insert Into @Tabela Values(1,10,20)
Insert Into @Tabela Values(1,10,20)

Insert Into @Tabela Values(2,20,40)
Insert Into @Tabela Values(2,20,40)

Insert Into @Tabela Values(2,30,60)


Select * from @Tabela
Compute Sum(Total1)

Select * from @Tabela
Compute Sum(Total1), Sum(Total2)

Select * from @Tabela
Order By Total1
Compute Count(Codigo) By Total1