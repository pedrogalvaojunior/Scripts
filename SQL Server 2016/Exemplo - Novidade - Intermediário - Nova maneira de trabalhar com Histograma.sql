USE [AdventureworksDW2016CTP3]
GO

SELECT * FROM FactResellerSales
WHERE OrderDate BETWEEN '20110101' AND '20110606'
GO

SELECT * FROM sys.dm_db_stats_histogram(OBJECT_ID('[dbo].[FactResellerSales]'), 2)
Go

SELECT * FROM sys.dm_db_stats_properties(OBJECT_ID('[dbo].[FactResellerSales]'), 2)
Go

SELECT ss.name, ss.stats_id, shr.steps, shr.rows, 
    shr.rows_sampled, shr.modification_counter, shr.last_updated,
    SUM(sh.range_rows+sh.equal_rows) AS predicate_step_rows
FROM sys.stats ss
INNER JOIN sys.stats_columns sc 
    ON ss.stats_id = sc.stats_id AND ss.object_id = sc.object_id
INNER JOIN sys.all_columns ac 
    ON ac.column_id = sc.column_id AND ac.object_id = sc.object_id
CROSS APPLY sys.dm_db_stats_properties(ss.object_id, ss.stats_id) shr
CROSS APPLY sys.dm_db_stats_histogram(ss.object_id, ss.stats_id) sh
WHERE ss.[object_id] = OBJECT_ID('FactResellerSales') 
    AND ac.name = 'OrderDate'
    AND sh.range_high_key BETWEEN CAST('20110101' AS DATE) AND CAST('20110606' AS DATE)
GROUP BY ss.name, ss.stats_id, shr.steps, shr.rows, 
    shr.rows_sampled, shr.modification_counter, shr.last_updated
Go