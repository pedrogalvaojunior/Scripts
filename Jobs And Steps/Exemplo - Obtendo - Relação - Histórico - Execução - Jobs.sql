select 
 j.name as 'NomeJob',
 run_date,
 run_time,
 msdb.dbo.agent_datetime(run_date, run_time) as 'DataExec'
From msdb.dbo.sysjobs j 
INNER JOIN msdb.dbo.sysjobhistory h 
 ON j.job_id = h.job_id 
where j.enabled = 1
order by NomeJob, DataExec desc