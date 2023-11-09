Drop Table Saldos
 (Codigo Int Identity(1,1),
  Produto Int,
  Descricao Char(10),
  Quantidade Float(8),
  Data DateTime,
  Saldo Float(8) Null)

Truncate Table Saldos

Insert Into Saldos Values (311,'Bal�o 1',10,GetDate(),0)
Insert Into Saldos Values (211,'Bal�o 2',10,GetDate(),0)
Insert Into Saldos Values (331,'Bal�o 3',10,GetDate(),0)
Insert Into Saldos Values (211,'Bal�o 4',10,GetDate(),0)
Insert Into Saldos Values (312,'Bal�o 5',10,GetDate(),0)

Select * from Saldos

Create Trigger T_Atualizar_Saldos
On Saldos
After Insert, Update
As
Begin
 Update Saldos 
 Set Saldos.Saldo = Saldos.Saldo + I.Quantidade
 From Saldos  Inner Join Inserted I
                       On Saldos.Produto = I.Produto
End

Insert Into Saldos Values (312, 'Bal�o 1',4,GetDate(),0)

Select * from Saldos