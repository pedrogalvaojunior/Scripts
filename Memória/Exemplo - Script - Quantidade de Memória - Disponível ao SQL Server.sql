SELECT  cntr_value/1024 AS 'Memory (MB)'
 
FROM master.dbo.sysperfinfo
 
WHERE object_name = 'SQLServer:Memory Manager'
 
AND counter_name = 'Total Server Memory (KB)'
