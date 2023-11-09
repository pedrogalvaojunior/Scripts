Method 1: sys.sysperfinfo

SELECT cntr_value
FROM sys.sysperfinfo
WHERE counter_name ='Page Splits/sec' AND
OBJECT_NAME LIKE'%Access methods%'
GO

Method 2: sys.dm_os_performance_counters(Recommended)
SELECT object_name, counter_name, instance_name, cntr_value, cntr_type
FROM sys.dm_os_performance_counters
WHERE counter_name ='Page Splits/sec' AND
OBJECT_NAME LIKE'%Access methods%'
GO