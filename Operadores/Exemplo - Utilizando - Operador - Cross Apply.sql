Set NoCount On

Declare @Cliente Table
 (Codigo Int Identity(1,1),
   Nome VarChar(50))

Declare @Pedido Table
 (NumPedido Int Identity(1,1),
   CodCliente SmallInt,   
   Valor Float,   
   DataVenda DateTime)

Insert Into @Cliente Values('Junior')
Insert Into @Cliente Values('Pedro')
Insert Into @Cliente Values('Eduardo')

Insert Into @Pedido Values(1,100,GetDate()-1)
Insert Into @Pedido Values(1,10,GetDate())
Insert Into @Pedido Values(1,200,GetDate()+2)
Insert Into @Pedido Values(1,1000,GetDate()+3)
Insert Into @Pedido Values(1,200,GetDate()+2)
Insert Into @Pedido Values(1,1000,GetDate()+3)

Insert Into @Pedido Values(1,200,GetDate()+20)
Insert Into @Pedido Values(1,1000,GetDate()+300)
Insert Into @Pedido Values(1,200,GetDate()-2)

Insert Into @Pedido Values(2,100,GetDate()-1)
Insert Into @Pedido Values(2,10,GetDate())
Insert Into @Pedido Values(2,200,GetDate()+2)
Insert Into @Pedido Values(3,1000,GetDate()-3)
Insert Into @Pedido Values(3,200,GetDate()+22)
Insert Into @Pedido Values(3,1000,GetDate())

Insert Into @Pedido Values(2,1200,GetDate()-1)
Insert Into @Pedido Values(2,1330,GetDate())
Insert Into @Pedido Values(2,2500,GetDate()+2)
Insert Into @Pedido Values(3,11000,GetDate()+3)
Insert Into @Pedido Values(3,23400,GetDate()+29)
Insert Into @Pedido Values(3,134000,GetDate()+36)


SELECT Cli.Nome, P.NumPedido, P.DataVenda
FROM @Cliente AS CLI CROSS APPLY 
   (SELECT TOP 5 NumPedido, DataVenda FROM @Pedido
     WHERE CodCliente = CLI.Codigo
     ORDER BY DataVenda) AS P   
 