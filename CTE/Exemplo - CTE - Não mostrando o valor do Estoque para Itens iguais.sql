Create Table Movimentacao
(Pedido Int,
 Item Int,
 QTDE Int,
 Estoque Int,
 Cliente Char(1),
 DataEntrega Date)
Go

Insert Into Movimentacao
Values (1,	1,	10,	5,	'a',	'2020-08-03'),
			(1,	1,	30,	5,	'a',	'2020-08-15'),
			(2,	1,	50,	100,	'b',	'2020-08-03'),
			(3,	1,	30,	0,	'c',	'2020-08-12'),
			(4,	2,	40,	80,	'd',	'2020-08-04'),
			(5,	2,	30,	0,	'e',	'2020-08-10'),
			(1,	2,	20,	0,	'a',	'2020-08-18'),
			(2,	2,	50,	0,	'b',	'2020-08-18')
Go

Select * From Movimentacao
Go

;With CTEItemPorLinha (Estoque)
As
(
Select Distinct Estoque From Movimentacao
)
Select Distinct M.Pedido, M.Item, M.QTDE, 
                         IsNull(Lead(C.Estoque,1) Over (Partition By M.Pedido Order By M.Pedido),0) As Estoque,
		                 M.Cliente,
		                 M.DataEntrega
From Movimentacao M Inner Join CTEItemPorLinha C
											On M.Estoque = C.Estoque
Go

-- Totais --
;With CTESomaEstoquePorItem (SomaEstoque)
As
(Select Distinct Estoque From Movimentacao)
Select 'Totais -->' As ' ',
           (Select SUM(QTDE) From Movimentacao) As Quantidade,
           Sum(SomaEstoque) As Estoque
From CTESomaEstoquePorItem
Go
