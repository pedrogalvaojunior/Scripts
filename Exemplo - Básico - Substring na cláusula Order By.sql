Declare @Tabela Table
 (Codigo VarChar(15))

Insert Into @Tabela Values('191-XXX-003')
Insert Into @Tabela Values('192-XXX-003')
Insert Into @Tabela Values('193-XXX-003')
Insert Into @Tabela Values('194-XXX-003')
Insert Into @Tabela Values('195-XXX-003')

Insert Into @Tabela Values('191-XXX-001')
Insert Into @Tabela Values('192-XXX-001')
Insert Into @Tabela Values('193-XXX-001')
Insert Into @Tabela Values('194-XXX-001')
Insert Into @Tabela Values('195-XXX-001')


Insert Into @Tabela Values('191-XXX-002')
Insert Into @Tabela Values('192-XXX-002')
Insert Into @Tabela Values('193-XXX-002')
Insert Into @Tabela Values('194-XXX-002')
Insert Into @Tabela Values('195-XXX-002')


Select * from @Tabela
Order By SubString(codigo,Len(Codigo)-2,3) Asc


--Select Len(codigo) from @Tabela

   