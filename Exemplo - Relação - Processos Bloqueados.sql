USE [master]
GO

SELECT  session_id, blocking_session_id, wait_time,
              wait_type, last_wait_type, wait_resource,
              transaction_isolation_level, lock_timeout
FROM sys.dm_exec_requests
WHERE blocking_session_id <> 0
GO