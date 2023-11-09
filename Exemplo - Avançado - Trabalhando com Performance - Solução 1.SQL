USE TempDB
GO

-- Consulta atual --
SELECT a.CustomerID,
       a.CountCol,
       CASE a.CountCol
         WHEN 'Count' THEN COUNT(1)
         WHEN 'CountDistinct' THEN COUNT(DISTINCT a.OrderDate)
         WHEN 'CountDistinct_1' THEN COUNT(DISTINCT 1)
         ELSE NULL
       END AS Cnt,
       CASE (SELECT AVG(b.Value)
               FROM OrdersBig b
              WHERE b.CustomerID = a.CustomerID)
            WHEN 1000 THEN 'Média = 1 mil'
            WHEN 2000 THEN 'Média = 2 mil'
            WHEN 3000 THEN 'Média = 3 mil'
            WHEN 4000 THEN 'Média = 4 mil'
            WHEN 5000 THEN 'Média = 5 mil'
            ELSE 'Não é número exato'
       END AS Sts
FROM OrdersBig AS a
GROUP BY a.CustomerID, a.CountCol
ORDER BY a.CustomerID
OPTION (MAXDOP 1)

-- Solução 1 - Utilizando View Indexada --
USE TempDB
GO

-- Criando View Indexada --
CREATE VIEW vw_OrdersBig_TestPerf
WITH SCHEMABINDING
AS
SELECT CustomerID,
       CountCol,
       OrderDate,
       SUM_Value = SUM(Value),
       COUNT_BIG = COUNT_BIG(*)
  FROM dbo.OrdersBig
 GROUP BY CustomerID,
          CountCol,
          OrderDate
GO

-- Criando Unique Clustered Index para usar na View --
CREATE UNIQUE CLUSTERED INDEX PK_vw_OrdersBig_TestPerf 
 ON dbo.vw_OrdersBig_TestPerf (CustomerID, CountCol, OrderDate)
GO