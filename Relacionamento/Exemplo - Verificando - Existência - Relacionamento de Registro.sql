Create Table T1
(Codigo Int Identity(1,1),
  Descricao VarChar(100))

Create Table T2
 (Codigo Int Identity(1,1),
   CodT1 Int)


Insert Into T1 Values('Arroz')
Insert Into T1 Values('Feijao')
Insert Into T1 Values('Macarrão')

Insert Into T2 Values(1)
Insert Into T2 Values(2)

Select * from T1

Select * from T2

Select T1.Codigo, T1.Descricao, 
          Case When (T1.Codigo = T2.CodT1) Then 'Sim'
		   Else 'Não'
          End Existe
from T1 Left Join T2
            On T1.Codigo = T2.CodT1 