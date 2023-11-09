SELECT OBJECT_SCHEMA_NAME(ios.object_id) + '.' + OBJECT_NAME(ios.object_id) as table_name
    ,i.name as index_name
    ,page_lock_count
    ,page_lock_wait_count
    ,CAST(100. * page_lock_wait_count / NULLIF(page_lock_count,0) AS decimal(6,2)) AS page_block_pct
    ,page_lock_wait_in_ms
    ,CAST(100. * page_lock_wait_in_ms / NULLIF(page_lock_wait_count,0) AS decimal(12,2)) AS page_avg_lock_wait_ms
FROM sys.dm_db_index_operational_stats (DB_ID(), NULL, NULL, NULL) ios
    INNER JOIN sys.indexes i ON i.object_id = ios.object_id AND i.index_id = ios.index_id
WHERE OBJECTPROPERTY(ios.object_id,'IsUserTable') = 1
ORDER BY row_lock_wait_count + page_lock_wait_count DESC, row_lock_count + page_lock_count DESC