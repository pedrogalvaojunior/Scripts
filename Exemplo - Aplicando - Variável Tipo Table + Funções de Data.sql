Declare @Tabela Table
 (Codigo Int Identity(1,1),
   Data DateTime)


Insert Into @Tabela Values(GetDate()+1)
Insert Into @Tabela Values(GetDate()+10)
Insert Into @Tabela Values(GetDate()+20)
Insert Into @Tabela Values(GetDate()+30)
Insert Into @Tabela Values(GetDate()+60)
Insert Into @Tabela Values(GetDate()+90)
Insert Into @Tabela Values(GetDate()+120)

Insert Into @Tabela Values(GetDate()+2)
Insert Into @Tabela Values(GetDate()+40)
Insert Into @Tabela Values(GetDate()+80)
Insert Into @Tabela Values(GetDate()+160)
Insert Into @Tabela Values(GetDate()+180)
Insert Into @Tabela Values(GetDate()+200)
Insert Into @Tabela Values(GetDate()+220)

Insert Into @Tabela Values(GetDate()+100)
Insert Into @Tabela Values(GetDate()+1000)
Insert Into @Tabela Values(GetDate()+250)
Insert Into @Tabela Values(GetDate()+300)
Insert Into @Tabela Values(GetDate()+600)
Insert Into @Tabela Values(GetDate()+900)
Insert Into @Tabela Values(GetDate()+1200)

--Retornando todos os dados da table
Select * from @Tabela

--Retornando todos os dados de 2007
Select * from @Tabela
Where Year(Data)=2007

--Retornando todos os dados de mês 10 independente do ano
Select * from @Tabela
Where Month(Data)=10

--Retornando todos os dados do 01 independente do ano e mês
Select * from @Tabela
Where Day(Data)=01

