WITH Waits AS 
 ( 
 SELECT wait_type,  
   wait_time_ms / 1000. AS wait_time_s, 
   100. * wait_time_ms / SUM(wait_time_ms) OVER() AS pct, 
   ROW_NUMBER() OVER(ORDER BY wait_time_ms DESC) AS rn 
 FROM sys.dm_os_wait_stats 
 WHERE wait_type  
   NOT IN 
     ('CLR_SEMAPHORE', 'LAZYWRITER_SLEEP', 'RESOURCE_QUEUE', 
   'SLEEP_TASK', 'SLEEP_SYSTEMTASK', 'SQLTRACE_BUFFER_FLUSH', 'WAITFOR', 
   'CLR_AUTO_EVENT', 'CLR_MANUAL_EVENT') 
   ) -- filter out additional irrelevant waits 
    
SELECT distinct W1.wait_type, 
 CAST(W1.wait_time_s AS DECIMAL(12, 2)) AS wait_time_s, 
 CAST(W1.pct AS DECIMAL(12, 2)) AS pct, 
 CAST(SUM(W2.pct) AS DECIMAL(12, 2)) AS running_pct 
FROM Waits AS W1 
 INNER JOIN Waits AS W2 ON W2.rn <= W1.rn 
GROUP BY  
 W1.wait_type,  
 W1.wait_time_s,  
 W1.pct 
HAVING SUM(W2.pct) - W1.pct < 95 -- percentage threshold;
order by wait_time_s desc