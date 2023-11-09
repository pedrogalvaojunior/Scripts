SELECT sess.session_id, 
            sess.login_time, 
            sess.original_login_name, 
            sess.login_name, 
            sess.host_name, 
            sess.program_name ,
			t.text
 FROM sys.dm_exec_sessions sess Inner JOIN sys.dm_exec_connections conn 
                                                             ON sess.session_id = conn.session_id
														    Inner Join sys.dm_exec_requests R
															 On R.session_id = sess.session_id
                                                            Cross Apply SYS.DM_EXEC_SQL_TEXT(R.sql_handle) AS T
WHERE program_name = 'Microsoft SQL Server Management Studio'


select * from sys.dm_exec_sessions

