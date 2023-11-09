sp_spaceused

-- Exemplo 1 --
SELECT t.[name], p.[rows]
FROM sys.schemas s INNER JOIN sys.tables t 
                                          ON t.[schema_id] = s.[schema_id] 
										 INNER JOIN sys.indexes i 
										  ON i.[object_id] = t.[object_id] 
										  AND i.[type] IN (0,1)
										 INNER JOIN sys.partitions p 
										 ON p.[object_id] = t.[object_id]
										 AND p.[index_id] = i.[index_id]
Go

-- Exemplo 2 --
;With Contador (name, rows)
As
(
SELECT t.[name], p.[rows]
FROM sys.schemas s INNER JOIN sys.tables t 
                                          ON t.[schema_id] = s.[schema_id] 
										 INNER JOIN sys.indexes i 
										  ON i.[object_id] = t.[object_id] 
										  AND i.[type] IN (0,1)
										 INNER JOIN sys.partitions p 
										 ON p.[object_id] = t.[object_id]
										 AND p.[index_id] = i.[index_id]
)
Select name, rows,  '' as soma from Contador
Union all
Select 'Total' , Null, convert(varchar(10),sum(rows)) as soma from contador


