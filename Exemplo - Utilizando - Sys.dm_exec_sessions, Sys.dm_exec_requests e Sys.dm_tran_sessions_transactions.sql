Declare @Contador Int

Set @Contador=0

Begin Transaction T1

While @Contador <=10000000
 Begin

   Begin Transaction T2
    Print Convert(Varchar(10),@Contador)
    Set @Contador +=1 
   Commit Transaction T2     
   
 End 

Commit Transaction T1

SELECT s.session_id, s.login_name, s.host_name, 
            s.program_name, s.status, s.last_request_start_time, 
            s.last_request_end_time,             
            r.command,
            r.open_transaction_count As 'Quantidade Transações Abertas'
FROM sys.dm_exec_sessions AS s Inner Join sys.dm_exec_requests r
                                                          On s.session_id = r.session_id
WHERE EXISTS (SELECT session_id FROM sys.dm_tran_session_transactions AS t WHERE t.session_id = s.session_id)
AND EXISTS (SELECT session_id FROM sys.dm_exec_requests AS r WHERE r.session_id = s.session_id)
Order By s.login_name;

Select * from sys.dm_exec_query_stats

select * from sys.dm_exec_sql_text

Select * from sys.dm_tran_session_transactions

select * from sys.dm_exec_requests



