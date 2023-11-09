SELECT 
jbs.[job_id] AS [JobID]
, jbs.[name] AS [JobName]
, CASE jbs.[enabled]
WHEN 1 THEN 'Yes'
WHEN 0 THEN 'No'
  END AS [IsEnabled]
, jbs.[date_created] AS [JobCreatedOn]
, jbs.[date_modified] AS [JobLastModifiedOn]
,jbs_Step.step_id AS StepID
, jbs_Step.[step_name] AS [JobStartStepName]
,jbs_Step.subsystem AS StepType
,jbs_Step.database_name AS DataBaseStep
,msdb.dbo.agent_datetime(run_date, run_time) as 'RunDateTime'
,((jbs_Step.last_run_duration/10000*3600 + (jbs_Step.last_run_duration/100)%100*60 + jbs_Step.last_run_duration%100 + 31 ) / 60) 
  as 'LastRunDurationMinute'
,CASE WHEN h.run_status = 0 THEN 'Failed'
WHEN h.run_status = 1 THEN 'Succeeded'
WHEN h.run_status = 2 THEN 'Retry'
WHEN h.run_status = 3 THEN 'Canceled'
ELSE 'Unknown' END AS LastRunStatus
,CONVERT(SMALLDATETIME, GETDATE()) AS DataColeta
FROM
[msdb].[dbo].[sysjobs] AS jbs
LEFT JOIN [msdb].[dbo].[sysjobsteps] AS jbs_Step ON jbs.[job_id] = jbs_Step.[job_id]
  INNER JOIN
msdb.dbo.sysjobhistory  h ON jbs_Step.job_id = h.job_id AND jbs_Step.step_id = h.step_id AND h.step_id <> 0  
WHERE 
msdb.dbo.agent_datetime(run_date, run_time) > DATEADD(DAY, -1, GETDATE())
ORDER BY [JobName], jbs_Step.step_id