Create Table Valores
 (Codigo Char(4),
  Sequencia Int)

Insert Into Valores Values ('0001',1),('0001',2),('0001',3),('0001',4)

Insert Into Valores Values ('0002',5),('0002',6),('0002',7),('0002',8)

Insert Into Valores Values ('0003',9),('0003',10)

Select * from Valores

Create View V_Contador
As
Select Codigo, 
       Row_Number() OVER (Order BY Codigo ASC) As NumeroLinha,        
       RANK() OVER (PARTITION BY Codigo ORDER BY Sequencia) As NovaSequencia
From Valores

Select * from V_Contador

UPDATE Valores
SET Sequencia = vi.NovaSequencia
FROM Valores V INNER JOIN V_Contador Vi
                    ON V.Codigo = Vi.Codigo
                    AND V.Sequencia = Vi.NumeroLinha

Select * from Valores