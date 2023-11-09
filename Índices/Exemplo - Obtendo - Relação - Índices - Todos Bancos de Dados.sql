SELECT DB_NAME(Database_ID) DBName,
       SCHEMA_NAME(schema_id) AS SchemaName,
       OBJECT_NAME(ius.OBJECT_ID) ObjName,
       i.type_desc, 
	   i.name,
       user_seeks, 
	   user_scans,
       user_lookups, 
	   user_updates
FROM sys.dm_db_index_usage_stats ius INNER JOIN sys.indexes i
                                      ON i.index_id = ius.index_id
                                      AND ius.OBJECT_ID = i.OBJECT_ID
                                     INNER JOIN sys.tables t 
									  ON t.OBJECT_ID = i.OBJECT_ID
GO