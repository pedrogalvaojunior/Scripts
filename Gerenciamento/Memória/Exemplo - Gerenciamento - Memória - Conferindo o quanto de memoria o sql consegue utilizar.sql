--Conferindo mem�ria que o sql conseguiria usar
--Se os contadores do perfmon tiverem vazios, resolver isso antes (dm_os_performance_counters)

select counter_name, cntr_value,
       cast((cntr_value/1024.0)/1024.0 as numeric(10,4)) as Gbs,
       cast((cntr_value/1024.0)/1024.0*1024 as numeric(10,2)) as Mbs

from sys.dm_os_performance_counters

where counter_name like '%Target server_memory%'

OR counter_name like '%Total server_memory%';