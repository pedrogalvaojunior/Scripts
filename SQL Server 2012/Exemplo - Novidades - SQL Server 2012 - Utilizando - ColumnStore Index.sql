Use AdventureWorks2012

-- Limpando o Cache de Execução --
DBCC FREEPROCCACHE
 
 -- Ativando as Estatísticas de Time e IO --
SET STATISTICS TIME ON
SET STATISTICS IO ON
Go

-- Listando a Relação de Índices da Tabela dbo.FactProductIventory --
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


/*Analisando o que foi descrito anteriormente, esse seria um ótimo cenário para que seja implementado o ColumnStore Index, 
isso porque possúimos operações de agregações, agrupamento de dados e ainda esta no caso é tabela de fatos (Fact Table). 
Olhando um pouco mais atentamente dento do plano de execução gerado, vemos que o operador Hash Match operador esse que é 
utilizando quando é demandado para o QO operações de agregações, joins e para retirar valores duplicados da consulta, 
está custando 41% do plano total da consulta acima.

Sendo assim criaremos o ColumnStore Index na tabela dbo.FactProductIventory.*/


CREATE NONCLUSTERED COLUMNSTORE INDEX ColumStoreIndex_FactProductInventory
ON dbo.FactProductInventory
(
     ProductKey,
     DateKey,
     UnitCost,
     UnitsOut
)

--Assim temos o novo plano de execução mostrando as seguintes informações:

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

/*De fato vemos que o QO utilizou o novo “Mode Batch” para retornar os valores em lotes, sendo assim, 
comparando as consultas utilizando a Hint – OPTION (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX), temos:*/

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