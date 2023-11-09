Create Table Tabela
 (Id Int,
  IdProd Int,
  Custo Float,
  DataCompra DateTime)
 
Insert Into Tabela Values(1,5,66.60, GETDATE())
Insert Into Tabela Values(2,5,08.61, GETDATE()-2)
Insert Into Tabela Values(3,5,14.62, GETDATE()-1)
Insert Into Tabela Values(4,8,28.63, GETDATE()+1)
Insert Into Tabela Values(5,8,32.64, GETDATE()+2)
Insert Into Tabela Values(6,8,64.65, GETDATE()+3)


Select * from Tabela;

With SomaData(IdProd, Data)
As (
      Select IdProd, MAX(DataCompra) from Tabela
      Group By IdProd
     )    
     
Select T.Id, S.IdProd, T.Custo, S.Data 
from Tabela T Inner Join SomaData S
                     On T.DataCompra = S.Data



--Sem CTE --

Select T.Id, S.IdProd, T.Custo, S.Data 
from Tabela T Inner Join (Select IdProd, MAX(DataCompra) As Data from Tabela Group By IdProd) S
                     On T.DataCompra = S.Data                                                      
