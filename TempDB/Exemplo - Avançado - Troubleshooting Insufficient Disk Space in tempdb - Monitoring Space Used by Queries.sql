-- Method 1: Batch-Level Information --

-- Obtaining the space consumed by internal objects in all currently running tasks in each session --
CREATE VIEW all_task_usage
AS 
    SELECT session_id, 
      SUM(internal_objects_alloc_page_count) AS task_internal_objects_alloc_page_count,
      SUM(internal_objects_dealloc_page_count) AS task_internal_objects_dealloc_page_count 
    FROM sys.dm_db_task_space_usage 
    GROUP BY session_id
GO

-- Obtaining the space consumed by internal objects in the current session for both running and completed tasks --
CREATE VIEW all_session_usage 
AS
    SELECT R1.session_id,
        R1.internal_objects_alloc_page_count 
        + R2.task_internal_objects_alloc_page_count AS session_internal_objects_alloc_page_count,
        R1.internal_objects_dealloc_page_count 
        + R2.task_internal_objects_dealloc_page_count AS session_internal_objects_dealloc_page_count
    FROM sys.dm_db_session_space_usage AS R1 
    INNER JOIN all_task_usage AS R2 ON R1.session_id = R2.session_id
GO

-- DBCC INPUTBUFFER once every three minutes for all the sessions, as shown in the following example --
DECLARE @max int
DECLARE @i int
SELECT @max = max (session_id)
FROM sys.dm_exec_sessions
SET @i = 51
  WHILE @i <= @max BEGIN
         IF EXISTS (SELECT session_id FROM sys.dm_exec_sessions
                    WHERE session_id=@i)
         DBCC INPUTBUFFER (@i)
         SET @i=@i+1
         END
Go

-- Method 2: Query-Level Information --
CREATE VIEW all_request_usage
AS 
  SELECT session_id, request_id, 
      SUM(internal_objects_alloc_page_count) AS request_internal_objects_alloc_page_count,
      SUM(internal_objects_dealloc_page_count)AS request_internal_objects_dealloc_page_count 
  FROM sys.dm_db_task_space_usage 
  GROUP BY session_id, request_id
GO

-- View all_query_usage --
CREATE VIEW all_query_usage
AS
  SELECT R1.session_id, R1.request_id, 
      R1.request_internal_objects_alloc_page_count, R1.request_internal_objects_dealloc_page_count,
      R2.sql_handle, R2.statement_start_offset, R2.statement_end_offset, R2.plan_handle
  FROM all_request_usage R1
  INNER JOIN sys.dm_exec_requests R2 ON R1.session_id = R2.session_id and R1.request_id = R2.request_id
GO

-- Using SQL Server Profiler events --
sys.dm_exec_query_stats 
sys.dm_exec_requests 
sys.dm_exec_cursors 
sys.dm_exec_xml_handles 
sys.dm_exec_query_memory_grants 
sys.dm_exec_connections 

SELECT * FROM sys.dm_exec_sql_text(@sql_handle)
SELECT * FROM sys.dm_exec_query_plan(@plan_handle)
Go

-- Using the polling method --
SELECT R1.sql_handle, R2.text 
FROM all_query_usage AS R1
OUTER APPLY sys.dm_exec_sql_text(R1.sql_handle) AS R2
Go

-- Monitoring Space Used by Temp Tables and Table Variables --
Select user_objects_alloc_page_count, user_objects_dealloc_page_count 
from sys.dm_db_session_space_usage
Go

-- Monitoring Page Allocation and Deallocation by Session --
Select * from sys.dm_db_file_space_usage
Select * from sys.dm_db_session_space_usage
Select * from sys.dm_db_task_space_usage
Go

