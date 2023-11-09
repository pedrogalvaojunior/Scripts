;with cte as    
(    
       select    
              s.is_user_process,    
              w.worker_address,    
              w.is_preemptive,    
              w.state,    
              r.status,    
              t.task_state,    
              r.command,    
              w.last_wait_type,    
              t.session_id,    
              t.exec_context_id,    
              t.request_id    
       from sys.dm_exec_sessions s inner join sys.dm_exec_requests r    
                                                                  on s.session_id = r.session_id    
                                                                 inner join sys.dm_os_tasks t    
                                                                  on r.task_address = t.task_address    
                                                                 inner join sys.dm_os_workers w    
                                                                  on t.worker_address = w.worker_address    
       where s.is_user_process = 0    
)    

select is_user_process,command,    
            last_wait_type,    
            count(*) as cmd_cnt    
from cte    
group by is_user_process,command, last_wait_type    
order by cmd_cnt desc  