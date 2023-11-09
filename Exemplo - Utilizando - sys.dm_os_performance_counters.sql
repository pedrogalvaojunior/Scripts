Select count(*) from sys.dm_os_performance_counters

Select * from sys.dm_os_performance_counters
Where counter_name In ('SQL Cache Memory (KB)', 'Total Server Memory (KB)')