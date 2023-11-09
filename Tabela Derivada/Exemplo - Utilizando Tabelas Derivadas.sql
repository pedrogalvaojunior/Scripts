Declare @T1 Table
 (Codigo Int)

Insert Into @T1 Values (1) 

--(Select Codigo2=Codigo+2 from @T1) 

Select A.Codigo, Codigo2 from 
 (Select Codigo, B.Codigo2 from
   (Select Codigo+1 As Codigo, Codigo+2 As Codigo2 from @T1) As B) As A

Select A.Codigo, Codigo2, Codigo3 from 
 (Select Codigo, B.Codigo2, Codigo3 from
  (Select Codigo, Codigo2, C.Codigo3 from   
   (Select Codigo+1 As Codigo, Codigo+2 As Codigo2, Codigo3=Codigo+3 from @T1) As C) As B) As A

  
 


 