Create Table T1
 (codigo int)

Insert Into T1 Values (1) 
Insert Into T1 Values (2)
Insert Into T1 Values (3)
Insert Into T1 Values (4)
Insert Into T1 Values (5)
Insert Into T1 Values (10)


Select * from T1
Where Codigo=Case Codigo When 2 Then 10 
                                                When 2 Then 4
                                              End  
