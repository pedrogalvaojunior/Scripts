USE TempDB
GO

-- Confirmar a escrita dos dados --
CHECKPOINT

-- Remover e Limpar Buffer Caches --
DBCC DROPCLEANBUFFERS
DBCC FREEPROCCACHE
GO

-- Ativando Estatísticas de IO para análise de Performance --
SET STATISTICS IO ON

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

-- Desativando Estatísticas de IO --
SET STATISTICS IO OFF
GO

-- Problema
/*
  Consulta demora 1 minutos e 41 segundos para rodar e o uso dos recursos são:
  CPU: 96503
  Reads: 75902646
  Writes: 100350
  Duration (ms): 101522
*/