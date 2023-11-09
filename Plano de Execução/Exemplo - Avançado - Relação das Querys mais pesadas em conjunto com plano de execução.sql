SELECT TOP 10 
			SUBSTRING(qt.TEXT,(qs.statement_start_offset / 2) + 1,((CASE qs.statement_end_offset 	WHEN -1 THEN DATALENGTH(qt.TEXT) ELSE qs.statement_end_offset END - qs.statement_start_offset) / 2) + 1) As 'Query', 
			qs.execution_count As 'Execution Count', 
			qs.total_logical_reads As 'Total Logical Reads', 
			qs.last_logical_reads As 'Last Logical Reads', 
			qs.total_logical_writes As 'Total Logical Writes', 
			qs.last_logical_writes As 'Last Logical Writes', 
			qs.total_worker_time As 'Total Worker Time', 
			qs.last_worker_time As 'Last Worker Time', 
			qs.total_elapsed_time / 1000000 As 'Total Elapsed Time in seconds', 
			qs.last_elapsed_time / 1000000 As 'Last Elapsed Time in seconds', 
			qs.last_execution_time As 'Last Execution Time',  
			qp.query_plan As 'Query Execution Plan'
FROM sys.dm_exec_query_stats qs CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt 
														   CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp 
ORDER BY qs.total_logical_reads DESC 