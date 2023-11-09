USE Exemplos
Go

Create Table T1
 (Codigo Int Identity(1,1))
Go

Insert Into T1 default values
Go 100

SELECT QT.text,
             QP.query_plan,
             QS.execution_count,
             QS.total_elapsed_time,
             QS.last_elapsed_time,
             QS.total_logical_reads
FROM sys.dm_exec_query_stats as QS
 CROSS APPLY sys.dm_exec_sql_text(QS.sql_handle) as QT
 CROSS APPLY sys.dm_exec_query_plan (QS.plan_handle) as QP
ORDER BY QS.execution_count DESC