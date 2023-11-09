/*
  Sr.Nimbus - OnDemand
  http://www.srnimbus.com.br
*/

USE NorthWind
GO

/* 
  Manuten��o das Estat�sticas
*/

-- Problema com estat�sticas desatualizadas
-- AUTO_UPDATE_STATISTICS

ALTER DATABASE NorthWind SET AUTO_UPDATE_STATISTICS OFF WITH NO_WAIT
GO

UPDATE TOP (50) PERCENT Order_DetailsBig SET Quantity = CHECKSUM(NEWID()) / 10000
GO

-- Estimativa incorreta, pois as estatisticas est�o desatualizadas
SELECT * FROM Order_DetailsBig
WHERE Quantity = 100
OPTION (RECOMPILE)
GO

ALTER DATABASE NorthWind SET AUTO_UPDATE_STATISTICS ON WITH NO_WAIT
GO

-- Estimativa correta, pois o AUTO_UPDATE_STATISTICS � disparado
-- automaticamente
SELECT * FROM Order_DetailsBig
WHERE Quantity = 100
OPTION (RECOMPILE)

/*
  Quando um auto update statistics � disparado?
  AUTO_UPDATE_STATISTICS
  RowModCtr
  
  - Se a cardinalidade da tabela � menor que seis e a tabela esta no 
  banco de dados tempdb, auto atualiza a cada seis modifica��es na tabela

  - Se a cardinalidade da tabela � maior que seis e menor ou igual a 500,
  ent�o atualiza as estat�sticas a cada 500 modifica��es na tabela
  
  - Se a cardinalidade da tabela � maior que 500,
  atualiza as estat�sticas quando 500 + 20% da tabela for alterada.
  
  No Profiler visualizar os evento SP:StmtCompleted e SP:StmtStarting
*/



-- Exemplo sp_updatestats
-- Runs UPDATE STATISTICS against all user-defined and internal tables in 
-- the current database
EXEC sp_updatestats
GO


-- Linhas modificadas por coluna, antiga rowmodctr
IF OBJECT_ID('Tab1') IS NOT NULL
  DROP TABLE Tab1
GO
CREATE TABLE Tab1 (ID Int IDENTITY(1,1) PRIMARY KEY, Col1 Int, Col2 Int, Col3 Int, Col4 Int, Col5 Int)
GO
CREATE STATISTICS StatsCol1 ON Tab1(Col1)
CREATE STATISTICS StatsCol2 ON Tab1(Col2)
CREATE STATISTICS StatsCol3 ON Tab1(Col3)
CREATE STATISTICS StatsCol4 ON Tab1(Col4)
CREATE STATISTICS StatsCol5 ON Tab1(Col5)
GO
INSERT INTO Tab1(Col1, Col2, Col3, Col4, Col5) VALUES(1, 1, 1, 1, 1)
GO 100
CHECKPOINT
GO
SELECT * FROM Tab1
GO

-- Quantidade de modifica��es na tabela
SELECT name, id, rowmodctr
  FROM sysindexes
 WHERE id = OBJECT_ID('Tab1')
GO

-- Zerando rowmodctr
UPDATE STATISTICS Tab1 WITH FULLSCAN
GO

SELECT name, id, rowmodctr
  FROM sysindexes
 WHERE id = OBJECT_ID('Tab1')
GO

-- Atualizando 5 linhas
UPDATE TOP (5) Tab1 SET Col1 = 2
GO

SELECT name, id, rowmodctr
  FROM sysindexes
 WHERE id = OBJECT_ID('Tab1')
GO

-- E as estat�sticas com 2 colunas?
CREATE STATISTICS StatsCol1_Col2 ON Tab1(Col1, Col2)
GO

SELECT name, id, rowmodctr
  FROM sysindexes
 WHERE id = OBJECT_ID('Tab1')
GO

UPDATE TOP (5) Tab1 SET Col2 = 2
GO
-- Update na "segunda" coluna n�o atualiza rowmodctr
SELECT name, id, rowmodctr
  FROM sysindexes
 WHERE id = OBJECT_ID('Tab1')
GO

-- Apagando 5 linhas
DELETE TOP (5) FROM Tab1
GO

SELECT name, id, rowmodctr
  FROM sysindexes
 WHERE id = OBJECT_ID('Tab1')
GO

-- Zerar rowmodctr para seguir os testes
UPDATE STATISTICS Tab1 WITH FULLSCAN
GO

/*
"From BOL"
In SQL Server 2000 and earlier, the Database Engine maintained row-level 
modification counters. 
Such counters are now maintained at the column level. 
Therefore, the rowmodctr column is calculated and produces results that 
are similar to the results in earlier versions, but are not exact. 
*/

-- Consultando modifica��es por coluna
-- DMV sys.system_internals_partition_columns mostra modifica��es por coluna, 
-- independente de terem �ndice ou estat�stica
CHECKPOINT
SELECT partitions.object_id,
       partitions.index_id,
       columns.name,
       system_internals_partition_columns.partition_column_id,
       system_internals_partition_columns.modified_count
  FROM sys.system_internals_partition_columns
 INNER JOIN sys.partitions
    ON system_internals_partition_columns.partition_id = partitions.partition_id
 INNER JOIN sys.columns
    ON partitions.object_id = columns.object_id
   AND system_internals_partition_columns.partition_column_id = columns.column_id 
 WHERE partitions.object_id = OBJECT_ID('Tab1')
GO
-- system_internals_partition_columns s� � atualizada depois do checkpoint


-- Atualizando algumas colunas
UPDATE TOP (10) Tab1 SET Col4 = 5, Col5 = 5
GO

CHECKPOINT
SELECT OBJECT_NAME(partitions.object_id) AS objName,
       partitions.object_id,
       partitions.index_id,
       columns.name,
       system_internals_partition_columns.partition_column_id,
       system_internals_partition_columns.modified_count
  FROM sys.system_internals_partition_columns
 INNER JOIN sys.partitions
    ON system_internals_partition_columns.partition_id = partitions.partition_id
 INNER JOIN sys.columns
    ON partitions.object_id = columns.object_id
   AND system_internals_partition_columns.partition_column_id = columns.column_id 
 WHERE partitions.object_id = OBJECT_ID('Tab1')
GO

-- Apagando 10 linhas
DELETE TOP (10) FROM Tab1
GO

CHECKPOINT
SELECT OBJECT_NAME(partitions.object_id) AS objName,
       partitions.object_id,
       partitions.index_id,
       columns.name,
       system_internals_partition_columns.partition_column_id,
       system_internals_partition_columns.modified_count
  FROM sys.system_internals_partition_columns
 INNER JOIN sys.partitions
    ON system_internals_partition_columns.partition_id = partitions.partition_id
 INNER JOIN sys.columns
    ON partitions.object_id = columns.object_id
   AND system_internals_partition_columns.partition_column_id = columns.column_id 
 WHERE partitions.object_id = OBJECT_ID('Tab1')
GO

-- AUTO_UPDATE_STATISTICS
-- Quanto tempo demora para disparar um auto_update em uma tabela grande?

ALTER DATABASE NorthWind SET AUTO_UPDATE_STATISTICS ON
GO

-- Criando �ndice para testes
CREATE INDEX ixOrderDate ON OrdersBig(OrderDate)
GO
-- Consultando quantidade de modifica��es no �ndice desde sua cria��o/update
SELECT name, id, rowmodctr
  FROM sysindexes
 WHERE id = OBJECT_ID('OrdersBig')
GO

-- Gerando update de v�rias linhas para disparar auto_update_statistics
-- 15 segundos
UPDATE TOP (50) PERCENT OrdersBig SET OrderDate = CONVERT(Date, GETDATE() - (CheckSUM(NEWID()) / 100000))
GO

-- Consultando quantidade de modifica��es no �ndice desde sua cria��o/update
SELECT name, id, rowmodctr
  FROM sysindexes
 WHERE id = OBJECT_ID('OrdersBig')
GO

-- Disparando auto update statsitics
SELECT *
  FROM OrdersBig
 WHERE OrderDate = '20121221' -- Maias estavam errados!
GO


-- Mas quanto tempo demorou?

-- Profiler SP:StmtCompleted e SP:StmtStarting
-- Ou TraceFlags 3604/3605 e 8721
DBCC TRACEON(3605)
/*
  Error Log:
  Message
  AUTOSTATS: Tbl: OrdersBig Objid:1637580872 Rows: 1000070.000000 Threshold: 200514 Duration: 1055ms
  Message
  AUTOSTATS: UPDATED Stats: OrdersBig..ixOrderDate Dbid = 5 Indid = 3 Rows: 315415 Duration: 1061ms
*/

DBCC TRACEON(3604) -- Resultado para Console (painel de results do SSMS)
DBCC TRACEON(8721)


-- AUTO_UPDATE_STATISTICS_ASYNC
-- E se eu n�o quiser esperar pelo update?

ALTER DATABASE Northwind SET AUTO_UPDATE_STATISTICS_ASYNC ON
GO

-- Gerando update de v�rias linhas para disparar auto_update_statistics
-- 15 segundos
UPDATE TOP (50) PERCENT OrdersBig SET OrderDate = CONVERT(Date, GETDATE() - (CheckSUM(NEWID()) / 100000))
GO

-- Disparando auto update statsitics
SELECT *
  FROM OrdersBig
 WHERE OrderDate = '20121221' -- Maias estavam errados!
GOMessage
AUTOSTATS: CREATED Dbid = 5 Tbl: TestAutoUpdateStatistics(Value) Rows: 315481  Dur: 1591ms

-- Consultando tempo gasto... 
SELECT * FROM sys.dm_exec_background_job_queue_stats
GO

ALTER DATABASE Northwind SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO

-- Ou desabilita o auto update/create statistics para a tabela 
EXEC sp_autostats 'OrdersBig', 'OFF' 
GO


-- AUTO_CREATE_STATISTICS
-- Quanto tempo demora para disparar um auto_create em uma tabela grande?
-- Criando tabela com 1 milh�o de linhas
-- DROP TABLE TestAutoUpdateStatistics
SELECT TOP 1000000 *
  INTO TestAutoUpdateStatistics
  FROM OrdersBig
GO

-- Gera auto create statistics pois estat�stica ainda n�o existe
SELECT *
  FROM TestAutoUpdateStatistics
 WHERE Value BETWEEN 1000 AND 1100
GO
-- Message
-- AUTOSTATS: CREATED Dbid = 5 Tbl: TestAutoUpdateStatistics(Value) Rows: 315481  Dur: 1591ms

-- TFs para verificar tempo gasto
DBCC TRACEON(3605) -- Resultado para Console (painel de results do SSMS)
DBCC TRACEON(8721)


-- EDGE Cases
-- E colunas blob ?

IF OBJECT_ID('TestBlobTab') IS NOT NULL
  DROP TABLE TestBlobTab
GO
CREATE TABLE TestBlobTab (ID Int IDENTITY(1,1) PRIMARY KEY, Col1 Int, Foto VarBinary(MAX))
GO

-- 51 mins e 39 segundos para rodar
INSERT INTO TestBlobTab (Col1, Foto)
SELECT TOP 30000
       CheckSUM(NEWID()) / 1000000, 
       CONVERT(VarBinary(MAX),REPLICATE(CONVERT(VarBinary(MAX), CONVERT(VarChar(250), NEWID())), 5000))
FROM sysobjects a, sysobjects b, sysobjects c, sysobjects d 
GO

INSERT INTO TestBlobTab (Col1, Foto)
SELECT CheckSUM(NEWID()) / 1000000, 
       NULL
GO 100


-- Consulta quantidade de p�ginas LOB
SELECT t.name, au.*
  FROM sys.system_internals_allocation_units au
 INNER JOIN sys.partitions p
    ON au.container_id = p.partition_id
 INNER JOIN sys.tables t
    ON p.object_id = t.object_id
 WHERE t.name = 'TestBlobTab'
GO


-- Demora uma eternidade para criar a estat�stica na coluna Foto...
-- 20 mins e 17 segundos para criar a estat�stica
-- Consulta roda em 0 segundos
SELECT COUNT(*)
  FROM TestBlobTab
 WHERE Foto IS NULL

-- Message
-- AUTOSTATS: CREATED Dbid = 5 Tbl: Tab1(Foto) Rows: 70100  Dur: 1217604ms

-- Mais informa��es aqui...
http://blogs.msdn.com/b/psssql/archive/2009/01/22/how-it-works-statistics-sampling-for-blob-data.aspx



-- NO_RECOMPUTE

-- Identificando as estat�sticas criadas automaticamente
SELECT * 
  FROM sys.stats
 WHERE Object_ID = OBJECT_ID('TestBlobTab')
GO

DROP STATISTICS TestBlobTab._WA_Sys_00000003_03F0984C
GO

-- Criando manualmente com clausula NORECOMPUTE
-- DROP STATISTICS TestBlobTab.StatsFoto
CREATE STATISTICS StatsFoto ON TestBlobTab(Foto) WITH NORECOMPUTE, SAMPLE 0 PERCENT
GO

SELECT COUNT(*)
  FROM TestBlobTab
 WHERE Foto IS NULL
OPTION (RECOMPILE)