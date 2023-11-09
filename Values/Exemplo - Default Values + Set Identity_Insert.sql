Create Table InserirValores
 (Codigo Int Identity(1,1))

Insert Into InserirValores Default Values
Go 20

Select * from InserirValores

Delete From InserirValores
Where Codigo In (2,4,6,8,10)

Select * from InserirValores

Set Identity_Insert InserirValores ON
Insert Into InserirValores (Codigo) Values (2)

Set Identity_Insert InserirValores OFF
Insert Into InserirValores Default Values
