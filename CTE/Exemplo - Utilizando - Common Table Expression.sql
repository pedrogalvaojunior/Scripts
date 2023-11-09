Create Table Dias
 (Dias DateTime,
  Valor Float)

Insert Into Dias Values(2008-04-01, 250.00)
Insert Into Dias Values(2008-04-02, 250.00)
Insert Into Dias Values(2008-04-02, 250.00)
Insert Into Dias Values(2008-04-03, 250.00)
Insert Into Dias Values(2008-04-04, 250.00)
Insert Into Dias Values(2008-04-07, 250.00)
Insert Into Dias Values(2008-04-07, 250.00)
Insert Into Dias Values(2008-04-08, 250.00)
Insert Into Dias Values(2008-04-08, 250.00)
Insert Into Dias Values(2008-04-08, 250.00)

Select * from Dias

With Total (Dias, Valor) As
 (
  Select Distinct Count(Dias), Valor from dias
  group by dias, valor  
)
Select Sum(Dias) from Total

