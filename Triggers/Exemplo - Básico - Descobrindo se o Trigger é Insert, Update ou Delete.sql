Create Database Teste
Go


Use Teste
Go

Create Table T1
 (Codigo Int)

Create Table T2
 (Codigo Int,
  Comando Varchar(10))
Go

Create Trigger Trigger1
On T1
After Insert, Update, Delete
As
Begin

 If Exists (Select * From Inserted) And Not Exists (Select * From Deleted)
  Insert Into T2 (Comando) Values ('Insert')

 If Exists (Select * From Inserted) And Exists (Select * From Deleted)
  Insert Into T2 (Comando) Values ('Update')
 
 If Not Exists (Select * From Inserted) And Exists (Select * From Deleted)
  Insert Into T2 (Comando) Values ('Delete')  

End

Insert Into T1 Values (1)
Insert Into T1 Values (2)
Insert Into T1 Values (3)
Insert Into T1 Values (4)
Insert Into T1 Values (5)

Select * from T2