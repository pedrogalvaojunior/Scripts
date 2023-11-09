Select Case transaction_isolation_level 
              When 0 Then 'Unspecified' 
              When 1 Then 'Read Uncommitted' 
              When 2 Then 'Read Committed' 
              When 3 Then 'Repeatable'  
              When 4 Then 'Serializable' 
              When 5 Then 'Snapshot' 
          End As 'Nível de Isolamento'
FROM sys.dm_exec_sessions 
Where session_id = @@SPID
Go