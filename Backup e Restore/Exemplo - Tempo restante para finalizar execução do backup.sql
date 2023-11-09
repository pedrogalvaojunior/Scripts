SELECT command, 

              'EstimatedEndTime' = Dateadd(ms,estimated_completion_time,Getdate()),

              'EstimatedSecondsToEnd' = estimated_completion_time / 1000,

              'EstimatedMinutesToEnd' = estimated_completion_time / 1000 / 60,

              'BackupStartTime' = start_time,

              'PercentComplete' = percent_complete

   FROM sys.dm_exec_requests

WHERE session_id = SPID
