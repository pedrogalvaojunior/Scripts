SELECT OBJECT_NAME(s.object_id) SP_Name,
       eqp.query_plan
FROM sys.dm_exec_procedure_stats s CROSS APPLY sys.dm_exec_query_plan (s.plan_handle) eqp
WHERE DB_NAME(database_id) = 'CycleCountTest'