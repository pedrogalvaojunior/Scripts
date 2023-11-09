Declare @Tabela1 Table
 (ID int)
 
Insert Into @Tabela1 Values(1)
Insert Into @Tabela1 Values(2)
Insert Into @Tabela1 Values(10)
Insert Into @Tabela1 Values(10)
Insert Into @Tabela1 Values(10)

Declare @Tabela2 Table
 (ID int)

Insert Into @Tabela2 Values(2)
Insert Into @Tabela2 Values(3)
Insert Into @Tabela2 Values(10)
Insert Into @Tabela2 Values(10)
Insert Into @Tabela2 Values(1)

Declare @Tabela3 Table
 (ID int )

Insert Into @Tabela3 Values(10)
Insert Into @Tabela3 Values(10)
Insert Into @Tabela3 Values(10)

Select Sum(Total) From(
Select Count(T1.ID) Total from @Tabela1 T1
 Where T1.Id = 10
Union All
Select Count(T2.ID) Total from @Tabela2 T2
 Where T2.Id = 10
Union All
Select Count(T3.ID) Total from @Tabela3 T3
 Where T3.Id = 10) As Valor


SELECT

(Select count(id) as total from @tabela1 Where ID = 10) +

(Select count(id) as total from @tabela2 Where ID = 10) +

(Select count(id) as total from @tabela3 Where ID = 10) As Total

