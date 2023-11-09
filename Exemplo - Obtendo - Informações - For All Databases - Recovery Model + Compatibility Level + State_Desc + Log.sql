With DatabaseInfo (DatabaseName, RecoveryModel, LogReuseWaitDescription, CompatibilityLevel, PageVerifyOption, state_desc)
As
(SELECT db.name,
              db.recovery_model_desc,
              db.log_reuse_wait_desc,
              db.compatibility_level,
			  db.page_verify_option_desc,
			  db.State_Desc
FROM    sys.databases AS db),
DatabasePerfCounters 
As
(SELECT  db.DatabaseName As InstanceName,
               ls.cntr_value As LogSizeKB,
               lu.cntr_value As LogUsedKb,
              CAST(CAST(lu.cntr_value AS FLOAT) / CAST(ls.cntr_value AS FLOAT) AS DECIMAL(18,2)) * 100 As LogSizePercent
FROM  sys.dm_os_performance_counters AS lu Inner Join DatabaseInfo db
                                              ON lu.instance_name = db.DatabaseName 
                                             INNER JOIN sys.dm_os_performance_counters AS ls
                                              ON ls.instance_name = db.DatabaseName 
WHERE   lu.counter_name LIKE 'Log File(s) Used Size (KB)%'
AND ls.counter_name LIKE 'Log File(s) Size (KB)%')

Select DatabaseName, RecoveryModel, LogReuseWaitDescription, CompatibilityLevel, PageVerifyOption, State_Desc, LogSizeKb, LogUsedKb, LogSizePercent
from DatabaseInfo db Inner Join DatabasePerfCounters DPC
                                      On db.DatabaseName = DPC.InstanceName
