Use Master
Go

-- Criando a Tabela Temporária #TMP --
CREATE TABLE #TMP 
(ID INT, 
 Col1 CHAR(1), 
 Col2 INT)
GO

-- Inserindo os Dados na Tabela Temporária #TMP --
INSERT INTO #TMP 
 VALUES(1,'A', 5), 
       (2, 'A', 5), 
	   (3, 'B', 5), 
	   (4, 'C', 5), 
	   (5, 'D', 5)
GO

-- Utilizando a Windows Function Range e Rows --
SELECT *,
       SUM(Col2) OVER(ORDER BY Col1 RANGE UNBOUNDED PRECEDING) As 'Range',
       SUM(Col2) OVER(ORDER BY Col1 ROWS UNBOUNDED PRECEDING) 'Rows' 
FROM #TMP