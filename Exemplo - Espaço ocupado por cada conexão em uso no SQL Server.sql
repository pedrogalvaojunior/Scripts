SELECT A.session_id,
            B.host_name, B.Login_Name ,
            (user_objects_alloc_page_count + internal_objects_alloc_page_count)*1.0/128 as TotalalocadoMB,
           D.Text
FROM sys.dm_db_session_space_usage A Inner JOIN sys.dm_exec_sessions B  
                                                                     ON A.session_id = B.session_id
                                                                    Inner JOIN sys.dm_exec_connections C 
                                                                     ON C.session_id = B.session_id
CROSS APPLY sys.dm_exec_sql_text(C.most_recent_sql_handle) As D
WHERE A.session_id > 50
and (user_objects_alloc_page_count + internal_objects_alloc_page_count)*1.0/128 > 100 -- Ocupam mais de 100 MB
ORDER BY totalalocadoMB desc
COMPUTE sum((user_objects_alloc_page_count + internal_objects_alloc_page_count)*1.0/128)