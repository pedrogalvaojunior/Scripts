Declare @T1 Table
 (Codigo Int)

Declare @T2 Table
 (Codigo Int)

Insert Into @T1 Values(1)
Insert Into @T1 Values(2)
Insert Into @T1 Values(3)
Insert Into @T1 Values(4)

Insert Into @T2 Values(1)
Insert Into @T2 Values(2)
Insert Into @T2 Values(5)
Insert Into @T2 Values(6)

Select * from @T1

Select * from @T2

Select * from @T1 T1
 Where Exists (Select Codigo From @T2 T2 Where T1.Codigo = T2.Codigo)

Select * from @T1 T1
 Where Not Exists (Select Codigo From @T2 T2 Where T1.Codigo = T2.Codigo)