Declare @Tabela Table
 (Codigo Int Identity(1,1),
  CodigoFunc VarChar(20))

Insert Into @Tabela Values('11.11.11.11.111')
Insert Into @Tabela Values('22.11.22.11.111')
Insert Into @Tabela Values('33.11.33.11.111')
Insert Into @Tabela Values('33.11.44.11.111')

Insert Into @Tabela Values('11.11.11.10.111')
Insert Into @Tabela Values('22.11.22.10.111')
Insert Into @Tabela Values('33.11.33.10.111')
Insert Into @Tabela Values('33.11.44.10.111')

Select * From @Tabela
Where SubString(CodigoFunc,10,2)='10'
