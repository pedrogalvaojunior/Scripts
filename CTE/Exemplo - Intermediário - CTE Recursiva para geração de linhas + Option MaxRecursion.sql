-- Exemplo 1 - Recursividade infinita --
;WITH CTE (ID) AS 
(
SELECT 1 ID
UNION ALL 
SELECT C.ID+1 FROM CTE C
)

SELECT * FROM CTE
OPTION (MAXRECURSION 0)
Go

-- Exemplo 2 - Limitando a quantidade de linhas de retorno e limitando a recursividade --
Set RowCount 1000

;WITH CTE (ID) AS 
(
SELECT 1 ID
UNION ALL 
SELECT C.ID+1 FROM CTE C
)

SELECT * FROM CTE
OPTION (MAXRECURSION 0)
Go
