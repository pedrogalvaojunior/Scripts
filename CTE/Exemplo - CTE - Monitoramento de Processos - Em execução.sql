With Monitor (SPID, Bloqueio, LastWaittype, Evento, Máquina, Programa, 
              CPU, [I/O], Banco, Usuário, DiaHora, Início, [Plano Execução])
As 
(select 
		er.session_id,
		wt.blocking_session_id,
		er.last_wait_type,
		es.text,
		ss.host_name,
		ss.program_name,
		er.cpu_time,
		er.logical_reads,
		er.database_id,
		ss.login_name,
		getdate(),
		er.start_time,
		ep.query_plan
from sys.dm_exec_requests er left Join sys.dm_os_waiting_tasks wt 
                              on er.session_id=wt.session_id 
                             cross apply sys.dm_exec_sql_text(er.sql_handle) es  
                             Left Outer Join sys.sysusers su 
                              on su.uid=er.user_id 
                             Left Outer Join sys.dm_exec_sessions ss 
                              on ss.session_id=er.session_id 
                             Cross apply sys.dm_exec_query_plan(plan_handle)ep)

Select * From Monitor
Where SPID = 58