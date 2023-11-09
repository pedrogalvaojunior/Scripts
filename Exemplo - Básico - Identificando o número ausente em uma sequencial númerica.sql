Create Table Dados
(Codigo Int,
  Num_doc Int,
  Serie Int)
Go

-- Inserindo os dados --
Insert Into Dados 
 Values(1,1,1), (2,1,2), (3,3,2),
       (4,2,1), (5,3,1), (6,5,1),
       (7,7,1), (8,5,2)
Go

-- Consultando --
Select * From Dados
Order By Num_doc, Serie
Go

-- Executando a CTE e identificando os possíveis GAPS --
Select (Num_Doc+1) As Proximo, Serie
From Dados
Where (Num_Doc+1) Not In (Select Num_Doc From Dados Where Serie = Dados.Serie)
Order By Serie
Go