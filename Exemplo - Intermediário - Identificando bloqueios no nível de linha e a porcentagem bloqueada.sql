SELECT OBJECT_SCHEMA_NAME(ios.object_id) + '.' + OBJECT_NAME(ios.object_id) as table_name
    ,i.name as index_name
    ,row_lock_count
    ,row_lock_wait_count
    ,CAST(100. * row_lock_wait_count / NULLIF(row_lock_count,0) AS decimal(6,2)) AS row_block_pct
    ,row_lock_wait_in_ms
    ,CAST(100. * row_lock_wait_in_ms / NULLIF(row_lock_wait_count,0) AS decimal(12,2)) AS row_avg_lock_wait_ms
FROM sys.dm_db_index_operational_stats (DB_ID(), NULL, NULL, NULL) ios
    INNER JOIN sys.indexes i ON i.object_id = ios.object_id AND i.index_id = ios.index_id
WHERE OBJECTPROPERTY(ios.object_id,'IsUserTable') = 1
ORDER BY row_lock_wait_count + page_lock_wait_count DESC, row_lock_count + page_lock_count DESC