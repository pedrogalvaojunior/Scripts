Create Table Items_Pedidos
 (Codigo Int Identity(1,1),
  NumPedido Int,
  NumItem Int,
  Descricao VarChar(40),
  QuantidadeSugerida Int,
  QuantidadeRecebida Int) on [Primary]

Alter Table Items_Pedidos
 Add DataRecebimento DateTime Null

Alter Table Items_Pedidos
 Add Constraint [PK_Codigo_Items_Pedidos] Primary Key Clustered (Codigo)

Create NonClustered Index Ind_NumPedido_Items_Pedidos On Items_Pedidos (NumPedido)

Create NonClustered Index Ind_Descricao_Items_Pedidos On Items_Pedidos (Descricao)

Alter Table Items_Pedidos
 Add Constraint [DF_QuantidadeSugerida_Items_Pedidos] Default 1 for [QuantidadeSugerida]

Alter Table Items_Pedidos
 Add Constraint [DF_QuantidadeRecebida_Items_Pedidos] Default 0 for [QuantidadeRecebida]