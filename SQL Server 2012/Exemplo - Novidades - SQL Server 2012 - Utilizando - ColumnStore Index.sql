Use AdventureWorks2012

-- Limpando o Cache de Execu��o --
DBCC FREEPROCCACHE
 
 -- Ativando as Estat�sticas de Time e IO --
SET STATISTICS TIME ON
SET STATISTICS IO ON
Go

-- Listando a Rela��o de �ndices da Tabela dbo.FactProductIventory --
Exec sp_helpindex 'FactProductInventory'


SELECT DimP.EnglishProductName,
			 DimP.Color,
			 DimD.CalendarYear,
			 AVG(FP.UnitCost),
			 DimD.WeekNumberOfYear,
			 SUM(FP.UnitsOut)
FROM FactProductInventory AS FP INNER JOIN DimProduct AS DimP
														ON FP.ProductKey = DimP.ProductKey
													INNER JOIN DimDate AS DimD
														ON DimD.DateKey = FP.DateKey
WHERE DimD.WeekNumberOfYear BETWEEN 20 AND 50
GROUP BY DimP.EnglishProductName, DimP.Color, DimD.WeekNumberOfYear, DimD.CalendarYear


/*Analisando o que foi descrito anteriormente, esse seria um �timo cen�rio para que seja implementado o ColumnStore Index, 
isso porque poss�imos opera��es de agrega��es, agrupamento de dados e ainda esta no caso � tabela de fatos (Fact Table). 
Olhando um pouco mais atentamente dento do plano de execu��o gerado, vemos que o operador Hash Match operador esse que � 
utilizando quando � demandado para o QO opera��es de agrega��es, joins e para retirar valores duplicados da consulta, 
est� custando 41% do plano total da consulta acima.

Sendo assim criaremos o ColumnStore Index na tabela dbo.FactProductIventory.*/


CREATE NONCLUSTERED COLUMNSTORE INDEX ColumStoreIndex_FactProductInventory
ON dbo.FactProductInventory
(
     ProductKey,
     DateKey,
     UnitCost,
     UnitsOut
)

--Assim temos o novo plano de execu��o mostrando as seguintes informa��es:

SELECT DimP.EnglishProductName,
			 DimP.Color,
			 DimD.CalendarYear,
			 AVG(FP.UnitCost),
			 DimD.WeekNumberOfYear,
			 SUM(FP.UnitsOut)
FROM FactProductInventory AS FP INNER JOIN DimProduct AS DimP
														ON FP.ProductKey = DimP.ProductKey
													INNER JOIN DimDate AS DimD
														ON DimD.DateKey = FP.DateKey
WHERE DimD.WeekNumberOfYear BETWEEN 20 AND 50
GROUP BY DimP.EnglishProductName, DimP.Color, DimD.WeekNumberOfYear, DimD.CalendarYear

/*De fato vemos que o QO utilizou o novo �Mode Batch� para retornar os valores em lotes, sendo assim, 
comparando as consultas utilizando a Hint � OPTION (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX), temos:*/

SELECT DimP.EnglishProductName,
			 DimP.Color,
			 DimD.CalendarYear,
			 AVG(FP.UnitCost),
			 DimD.WeekNumberOfYear,
			 SUM(FP.UnitsOut)
FROM FactProductInventory AS FP INNER JOIN DimProduct AS DimP
														ON FP.ProductKey = DimP.ProductKey
													INNER JOIN DimDate AS DimD
														ON DimD.DateKey = FP.DateKey
WHERE DimD.WeekNumberOfYear BETWEEN 20 AND 50
GROUP BY DimP.EnglishProductName, DimP.Color, DimD.WeekNumberOfYear, DimD.CalendarYear
OPTION (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX);