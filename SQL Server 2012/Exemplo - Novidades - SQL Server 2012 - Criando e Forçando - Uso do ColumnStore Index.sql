--Exclu�ndo ColumnStore Index
DROP INDEX dbo.FactProductInventory.ColumStoreIndex_FactProductInventory

CREATE NONCLUSTERED COLUMNSTORE INDEX ColumStoreIndex_FactProductInventory
ON dbo.FactProductInventory
(
     ProductKey,
     DateKey,
     UnitCost,
     UnitsOut
)

--For�ando a utiliza��o do ColumnStore Index, veremos agora que o dado foi atualizado com sucesso.

SELECT*
FROM dbo.FactProductInventory WITH(INDEX(ColumStoreIndex_FactProductInventory))
WHERE ProductKey = 1
