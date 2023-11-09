SELECT s.group_id, 
             CAST(g.name as nvarchar(20)), 
             s.session_id, s.login_time, 
             CAST(s.host_name as nvarchar(20)), 
             CAST(s.program_name AS nvarchar(20))
FROM sys.dm_exec_sessions s INNER JOIN sys.dm_resource_governor_workload_groups g
                                                     ON g.group_id = s.group_id
ORDER BY g.name
GO