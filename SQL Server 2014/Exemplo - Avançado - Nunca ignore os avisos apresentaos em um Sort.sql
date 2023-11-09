-- Creating a DB --
CREATE DATABASE MyDB
GO

USE MyDB
GO

-- Creating a table --
IF OBJECT_ID('SortTable') IS NOT NULL
  DROP TABLE SortTable
GO


-- Inserindo uma massa de dados na Table SortTable --
SELECT TOP 100000
       IDENTITY(INT, 1,1) AS OrderID,
       ABS(CHECKSUM(NEWID()) / 10000000) AS CustomerID,
       CONVERT(DATETIME, GETDATE() - (CHECKSUM(NEWID()) / 1000000)) AS OrderDate,
       ISNULL(ABS(CONVERT(NUMERIC(18,2), (CHECKSUM(NEWID()) / 1000000.5))),0) AS Value,
       CONVERT(CHAR(500), NEWID()) AS ColChar
  INTO SortTable
  FROM sysobjects A
 CROSS JOIN sysobjects B CROSS JOIN sysobjects C CROSS JOIN sysobjects D
GO

-- Criando um índice Clusterede na Tabela SortTable para coluna OrderID --
CREATE CLUSTERED INDEX ix1 ON SortTable (OrderID)
GO

-- Query 1 - Realizar sort em memória, forçando o Query Optimizer a negligenciar o uso do índice --
DECLARE @v1 Char(500), @v2 Int

SELECT @v1 = ColChar, @v2 = OrderID
FROM SortTable
ORDER BY CONVERT(VarChar(5000), ColChar) + ''
OPTION (MAXDOP 1, RECOMPILE)

-- Utilizando a DMV dm_exec_query_profiles para apresentar informações sobre o profile de execução da Query 1 --
SELECT node_id,
       physical_operator_name,
       CAST(SUM(row_count)*100 AS float) / SUM(estimate_row_count) AS percent_complete,
       SUM(elapsed_time_ms) AS elapsed_time_ms,
       SUM(cpu_time_ms) AS cpu_time_ms,
       SUM(logical_read_count) AS logical_read_count,
       SUM(physical_read_count) AS physical_read_count,
       SUM(write_page_count) AS write_page_count,
       SUM(estimate_row_count) AS estimate_row_count
  FROM sys.dm_exec_query_profiles
 WHERE session_id = 52 -- spid running query
 GROUP BY node_id,
          physical_operator_name
 ORDER BY node_id;

 -- Query 2 - Sort terrível --
DECLARE @v1 Char(500), @v2 Int

SELECT @v1 = ColChar, @v2 = OrderID
FROM SortTable
ORDER BY ColChar
OPTION (MAXDOP 1, RECOMPILE)

-- Utilizando a DMV dm_exec_query_profiles para apresentar informações sobre o profile de execução da Query 2 --
SELECT node_id,
       physical_operator_name,
       CAST(SUM(row_count)*100 AS float) / SUM(estimate_row_count) AS percent_complete,
       SUM(elapsed_time_ms) AS elapsed_time_ms,
       SUM(cpu_time_ms) AS cpu_time_ms,
       SUM(logical_read_count) AS logical_read_count,
       SUM(physical_read_count) AS physical_read_count,
       SUM(write_page_count) AS write_page_count,
       SUM(estimate_row_count) AS estimate_row_count
  FROM sys.dm_exec_query_profiles
 WHERE session_id = 52 -- spid running query
 GROUP BY node_id,
          physical_operator_name
 ORDER BY node_id;

 -- Query 3 -- Sort Horrível --
DECLARE @v1 Char(500), @v2 Int

SELECT @v1 = ColChar, @v2 = OrderID
  FROM SortTable
 ORDER BY ColChar
OPTION (MAXDOP 1, RECOMPILE)

-- Criando um novo índice na Table SortTable na coluna ColChar, incluíndo a coluna OrderId para forçar o Sort --
CREATE INDEX ix2 ON SortTable(ColChar) INCLUDE(OrderID) WITH(MAXDOP = 1)

-- Rodar novamente as querys --

select * from sys.dm_exec_query_memory_grants 

select * from sys.dm_xe_session_event_actions