 SELECT TOP 10
'Procedure'     = qt.text
,DiskReads      = qs.total_physical_reads -- The worst reads, disk reads
,MemoryReads    = qs.total_logical_reads  --Logical Reads are memory reads
,Executions     = qs.execution_count
,CPUTime      = qs.total_worker_time
,DiskWaitAndCPUTime = qs.total_elapsed_time
,MemoryWrites   = qs.max_logical_writes
,DateCached     = qs.creation_time
,DatabaseName   = DB_Name(qt.dbid)
,LastExecutionTime  = qs.last_execution_time
 FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
ORDER BY qs.total_physical_reads +  qs.total_logical_reads DESC
