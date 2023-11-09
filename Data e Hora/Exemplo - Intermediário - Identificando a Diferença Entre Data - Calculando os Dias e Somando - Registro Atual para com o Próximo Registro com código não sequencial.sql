Create Table Vendedores
(Codigo INT , 
 CodigoSell INT,
 TimeSeller DATE, 
 SellerOrigim INT,
 SellerAtual INT,
 SellerName VARCHAR(10))
Go

Insert Into Vendedores 
Values (1,10,'2020-02-06',50,1000,'PAUL'),
             (5,10,'2020-02-17',1500,2000,'JONH'),
             (8,10,'2020-02-18',2000,50,'PIERRE'),
             (11,10,'2020-02-19',50,1000,'PAUL'),
             (18,10,'2020-02-20',1500,2000,'JONH')
Go

Select * From Vendedores
Go

-- Identificar a diferença respeitando esta regra - Paul e Jonh,Jonh e Pierre,Pierre e Paul, Paul e John , e depois agrupar.

-- SQL Server 2008 R2 ou inferior --
Select (V.SellerName + ' --> ' + IsNull(V2.SellerName,'')) As SellerName,
           IsNull(DateDiff(D, V.TimeSeller, V2.TimeSeller),0) As 'Tempo em Dias' 
From Vendedores V Outer Apply (Select Top 1 SellerName, TimeSeller 
                                                         From Vendedores V1 
														 Where V.Codigo < V1.Codigo 
														 Order By Codigo) As V2
Go

-- Versão 2012 ou Superior --
Select Concat(V.SellerName, ' --> ',IsNull(V2.SellerName,'')) As SellerName,
           IsNull(DateDiff(D, V.TimeSeller, V2.TimeSeller),0) As 'Tempo em Dias' 
From Vendedores V Outer Apply (Select Top 1 SellerName, TimeSeller 
                                                         From Vendedores V1 
														 Where V.Codigo < V1.Codigo 
														 Order By Codigo) As V2
Go

-- Aplicando o Group By através do uso de CTE --
-- SQL Server 2008 R2 ou inferior --

;With CTEDiferencaEntreFornecedores2008 (Sellername, Tempo)
As
(
Select (V.SellerName + ' --> ' + IsNull(V2.SellerName,'')) As SellerName,
           IsNull(DateDiff(D, V.TimeSeller, V2.TimeSeller),0) As 'Tempo' 
From Vendedores V Outer Apply (Select Top 1 SellerName, TimeSeller 
                                                         From Vendedores V1 
														 Where V.Codigo < V1.Codigo 
														 Order By Codigo) As V2
)
Select SellerName, Sum(Tempo) As SomaDoTempo 
From CTEDiferencaEntreFornecedores2008
Group By Sellername
Order By Sellername
Go

-- Versão 2012 ou Superior --
;With CTEDiferencaFornecedores2012 (SellerName, Tempo)
As
(Select Concat(V.SellerName, ' --> ',IsNull(V2.SellerName,'')) As SellerName,
           IsNull(DateDiff(D, V.TimeSeller, V2.TimeSeller),0) As 'Tempo em Dias' 
From Vendedores V Outer Apply (Select Top 1 SellerName, TimeSeller 
                                                         From Vendedores V1 
														 Where V.Codigo < V1.Codigo 
														 Order By V.Codigo) As V2
)
Select SellerName, Sum(Tempo) As SomaDoTempo 
From CTEDiferencaFornecedores2012
Group By Sellername
Order By Sellername
Go

-- Identificando o próximo vendedor utilizando a Função Lead() e calculando a diferença através da Função DateDiff() --
Select V.SellerName, V2.SellerName, 
           V.TimeSeller,
		   V2.TimeSeller As 'TimeSellerProximo',
		   IsNull(DateDiff(dd, V.TimeSeller, Lead(V.TimeSeller) Over(Order By V.Codigo)),0) As 'Diferença em Dias'
From Vendedores V Outer Apply (Select Top 1 Codigo, SellerName, TimeSeller From Vendedores V1
                                                          Where V.Codigo < V1.Codigo
														  Order By V.Codigo) As V2
Go

-- Agrupando --
;With CTEDiferencaFornecedores (SellerNameAtual, SellerNameProximo, TimeSellerAnterior, TimeSellerProximo, DiferencaEmDias)
As
(
Select V.SellerName, V2.SellerName, 
           V.TimeSeller,
		   V2.TimeSeller,
		   IsNull(DateDiff(dd, V.TimeSeller, Lead(V.TimeSeller) Over(Order By V.Codigo)),0)
From Vendedores V Outer Apply (Select Top 1 Codigo, SellerName, TimeSeller From Vendedores V1
                                                          Where V.Codigo < V1.Codigo
														  Order By V.Codigo) As V2
)
Select Concat(SellerNameAtual,' - ', SellerNameProximo) As SellerName,
			Sum(DiferencaEmDias) As Somatoria
From CTEDiferencaFornecedores
Group By SellerNameAtual, SellerNameProximo 
Order By Somatoria
Go