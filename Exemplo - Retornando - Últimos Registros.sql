Set NoCount On

Declare @CodCliente SmallInt

Declare @Movimentacao Table
 (Codigo SmallInt,
   Nome VarChar(50),
   NumPedido SmallInt,
   ValorPedido Float,
   DataVenda DateTime)

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


Set @CodCliente=0

Declare Cursor_Movimentacao Cursor For
Select Distinct CodCliente From @Pedido

Open Cursor_Movimentacao

Fetch Next From Cursor_Movimentacao
Into @CodCliente

While @@Fetch_Status = 0 
 Begin   

   Insert Into @Movimentacao
   Select Top 5 Cli.Codigo As 'Código Cliente',
             Cli.Nome As 'Nome Cliente',
             P.NumPedido As 'Número Pedido',
             P.Valor As 'Valor Pedido',
             P.DataVenda As 'Data da Venda'
   From @Cliente Cli Inner Join @Pedido P
                            On Cli.Codigo = P.CodCliente
   Where Cli.Codigo = @CodCliente
   Order By P.DataVenda Desc

   Fetch Next From Cursor_Movimentacao
   Into @CodCliente

  End

Close Cursor_Movimentacao
Deallocate Cursor_Movimentacao


Select * from @Movimentacao
Order By Nome, NumPedido Desc
 