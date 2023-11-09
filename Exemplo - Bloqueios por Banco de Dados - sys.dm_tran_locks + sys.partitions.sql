USE [master]
GO

SELECT   tl.resource_type, tl.resource_associated_entity_id, OBJECT_NAME(p.object_id) AS object_name,
			   tl.request_status, tl.request_mode, tl.request_session_id, tl.resource_description
FROM sys.dm_tran_locks t LEFT JOIN sys.partitions p 
											 ON p.hobt_id = tl.resource_associated_entity_id
WHERE tl.resource_database_id = DB_ID()
GO