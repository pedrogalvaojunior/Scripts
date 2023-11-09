ALTER PROCEDURE VerificarIndices80CentsMaiorQuetabela
 
AS
 
--DECLARE´S
 
DECLARE @Tables TABLE(Nome VARCHAR(100), Stat VARCHAR(2))
 
DECLARE @Tabela VARCHAR(100)
 
DECLARE @Final TABLE(Name VARCHAR(100), Rows INT, Reserved VARCHAR(100), Data VARCHAR(100), Index_Size VARCHAR(100), Unused VARCHAR(100))
 
--CARGA DE DADOS
 
INSERT INTO @Tables
 
SELECT NAME, NULL FROM SYS.TABLES
 
--LOOPING
 
WHILE(EXISTS(SELECT TOP 1 1 FROM @Tables WHERE Stat IS NULL))
 
BEGIN
 
SET @Tabela = (SELECT TOP 1 Nome FROM @Tables WHERE Stat IS NULL)
 
INSERT INTO @Final EXEC sp_spaceused @Tabela
 
UPDATE @Tables SET Stat = 'ok' WHERE Nome LIKE @Tabela
 
END
 
--SELECT Name, Data FROM @Final
 
SELECT a.TableName, a.IndexName, a.IndexSizeKB, b.Data
 
FROM
 
(SELECT
 
OBJECT_NAME(i.OBJECT_ID) AS TableName,
 
i.name AS IndexName,
 
i.index_id AS IndexID,
 
8 * SUM(a.used_pages) AS 'IndexsizeKB'
 
FROM sys.indexes AS i
 
JOIN sys.partitions AS p ON p.OBJECT_ID = i.OBJECT_ID AND p.index_id = i.index_id
 
JOIN sys.allocation_units AS a ON a.container_id = p.partition_id
 
WHERE i.name IS NOT NULL
 
AND OBJECT_NAME(i.OBJECT_ID) NOT LIKE '%sys%'
 
GROUP BY i.OBJECT_ID,i.index_id,i.name) a
 
INNER JOIN @Final b ON (a.TableName = b.Name)
 
WHERE a.IndexSizeKB > cast(RTRIM(LTRIM(REPLACE(b.Data,'KB',''))) as Int)*0.8
