select scheduler_id,
            current_tasks_count,
            current_workers_count,
            active_workers_count,
            work_queue_count    
from sys.dm_os_schedulers    
where status = 'Visible Online' 


select is_preemptive,
            state,
            last_wait_type,
            count(*) as NumWorkers 
from sys.dm_os_workers    
Group by state,last_wait_type,is_preemptive    
order by count(*) desc  


select last_wait_type, 
            count(*) as NumRequests 
from sys.dm_exec_requests    
group by last_wait_type    
order by count(*) desc


select  is_user_process,
             count(*) as RequestCount 
from sys.dm_exec_sessions s  inner join sys.dm_exec_requests r    
                                                           on s.session_id = r.session_id    
group by is_user_process