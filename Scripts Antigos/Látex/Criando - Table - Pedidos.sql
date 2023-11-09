Create Table Pedidos
 (Codigo Int Identity(1,1),
  NumPedido Int,
  Empresa VarChar(60),
  Telefone Char(9),
  DDD Char(2),
  NumNTFiscal Int,
  DataCompra DateTime,
  Responsavel VarChar(10),
  Observacao VarChar(100)) on [Primary]

Alter Table Pedidos
 Add Constraint [PK_Codigo_Pedidos] Primary Key Clustered (Codigo)

Create NonClustered Index Ind_NumPedido On Pedidos (NumPedido)

Create NonClustered Index Ind_DataCompra On Pedidos (DataCompra)

Alter Table Pedidos
 Add Constraint [DF_DataCompra_Pedidos] Default GetDate() for [DataCompra]
