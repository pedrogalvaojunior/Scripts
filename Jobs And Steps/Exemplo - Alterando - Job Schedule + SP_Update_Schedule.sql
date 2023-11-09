USE MSDB
GO

EXEC msdb.dbo.sp_update_schedule
    @name = 'Schedure - SIGP - Project Status Report',
    @enabled = 1,
    @freq_type = 4,
    @active_start_date = Null, -- Informe a data inicial de execução, se for a data atual deixa Null
    @active_end_date = Null, -- Informe a data final de execução, se for a data atual deixa Null
    @active_start_time = 144000, -- Informe aqui o horário inicial de execução no formato HHMMSS
    @active_end_time = 150000 -- Informe aqui o horário final de execução no formato HHMMSS

Select sj.Name, sj.job_id, 
       ss.Name,
       sjs.schedule_id
from msdb.dbo.sysjobs sj Inner Join msdb.dbo.sysjobschedules sjs
                          on sj.job_id = sjs.job_id
                         Inner Join msdb.dbo.sysschedules ss
                          On sjs.schedule_id = ss.schedule_id

select * from msdb.dbo.sysjobschedules

select * from msdb.dbo.sysjobs

select * from msdb.dbo.sysschedules