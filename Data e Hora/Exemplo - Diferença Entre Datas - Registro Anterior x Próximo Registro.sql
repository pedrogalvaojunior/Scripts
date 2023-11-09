Create Table Datas
 (ID Int Identity(1,1),
  DataInicio Date,
  DataFinal Date)

Insert Into Datas Values (GETDATE(), GETDATE()+30) 
Insert Into Datas Values (GETDATE()+1, GETDATE()+20) 
Insert Into Datas Values (GETDATE()+2, GETDATE()+10) 
Insert Into Datas Values (GETDATE(), GETDATE()+5) 

Select * from Datas

-- Exemplo 1 --
Select I.ID, I.DataInicio, F.DataFinal, 
           DateDiff(D, I.DataInicio, F.DataFinal) As Intervalo         
From Datas I Left Join Datas F
                          On I.ID = F.ID + 1
                         
-- Exemplo 2 --
 SELECT
   [current].Id,
   [current].Time CurrentValue,
   [next].Time          NextValue
FROM #xpto AS [current] LEFT JOIN #xpto AS [next]
      ON [next].Id = (SELECT MIN(Id) FROM #xpto WHERE Id > [current].Id)
