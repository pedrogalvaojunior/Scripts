Create Table Valores
 (Codigo Int)

Insert Into Valores Values(1)
Go 100

Select Identity(Int, 1,1) As Linha, Codigo Into Registros from Valores

Select * from Registros