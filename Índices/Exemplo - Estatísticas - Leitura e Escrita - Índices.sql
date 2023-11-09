--- Index Read/Write stats (all tables in current DB)
SELECT  OBJECT_NAME(s.[object_id]) AS [ObjectName] ,
              i.name AS [IndexName] ,
              i.index_id ,
              user_seeks + user_scans + user_lookups AS [Reads] ,
              user_updates AS [Writes] ,
              i.type_desc AS [IndexType] ,
              i.fill_factor AS [FillFactor]
FROM    sys.dm_db_index_usage_stats AS s INNER JOIN sys.indexes AS i 
                                                                         ON s.[object_id] = i.[object_id]
WHERE   OBJECTPROPERTY(s.[object_id], 'IsUserTable') = 1
AND i.index_id = s.index_id
AND s.database_id = DB_ID()
ORDER BY OBJECT_NAME(s.[object_id]), Writes DESC, Reads DESC;