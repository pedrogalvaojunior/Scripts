-- Identificando a existência de registros fantasmas --
SELECT db_name(database_id), object_name(object_id),
       ghost_record_count,
       version_ghost_record_count
FROM sys.dm_db_index_physical_stats(DB_ID(N'ProjetoDWQueimadas'), OBJECT_ID(N'TestTable'), NULL, NULL , 'DETAILED')
GO


-- Eliminando os registros fantasmas --
USE master;
GO
EXEC sp_clean_db_free_space @dbname = N'ProjetoDWQueimadas'