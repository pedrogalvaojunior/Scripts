SELECT 
  ES.login_name AS LoginName,
  ES.host_name AS HostName, 
  T.*
FROM sys.dm_tran_locks T Inner JOIN sys.dm_exec_sessions ES 
                                              ON ES.session_id = T.request_session_id
WHERE T.resource_type = 'DATABASE'
AND T.resource_database_id = DB_ID('Innov')