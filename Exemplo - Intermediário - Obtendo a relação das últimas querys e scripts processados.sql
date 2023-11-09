-- Exemplo 1 --
SELECT  DMQS.last_execution_time AS [Executed At] ,
              DMST.text AS [Query]
FROM  sys.dm_exec_query_stats AS DMQS CROSS APPLY sys.dm_exec_sql_text(DMQS.sql_handle) AS DMST
ORDER BY DMQS.last_execution_time DESC; 
Go

-- Exemplo 2 --
SELECT  DEC.client_net_address AS 'IP do cliente' ,
              sp.hostname AS 'HostName' ,
              DMET.text AS 'Query or Command' ,
              DB_NAME(sp.dbid) AS 'Database' ,
              sp.[program_name] AS 'Software or application'
FROM  sys.dm_exec_connections DEC
        INNER JOIN sys.sysprocesses sp ON DEC.session_id = sp.spid
        CROSS APPLY sys.dm_exec_sql_text(most_recent_sql_handle) AS DMET;
Go