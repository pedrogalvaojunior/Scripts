select b.session_id, b.is_user_transaction, a.transaction_id, transaction_begin_time, 
  case transaction_type 
    when 1 then 'Read/write transaction ' 
    when 2 then 'Read-only transaction ' 
    when 3 then 'System transaction ' 
    when 4 then 'Distributed transaction ' 
  end as 'transaction_type',
  case transaction_state 
    when 0 then 'The transaction has not been completely initialized yet' 
    when 1 then 'The transaction has been initialized but has not started' 
    when 2 then 'The transaction is active ' 
    when 3 then 'The transaction has ended. This is used for read-only transactions ' 
    when 4 then 'The commit process has been initiated on the distributed transaction ' 
    when 5 then 'The transaction is in a prepared state and waiting resolution ' 
    when 6 then 'The transaction has been committed' 
    when 7 then 'The transaction is being rolled back' 
    when 8 then 'The transaction has been rolled back' 
  end as 'transaction_state',
  case dtc_state 
    when 1 then 'ACTIVE ' 
    when 2 then 'PREPARED ' 
    when 3 then 'COMMITTED ' 
    when 4 then 'ABORTED ' 
    when 5 then 'RECOVERED ' 
  end as 'dtc_state '
from sys.dm_tran_active_transactions a inner join sys.dm_tran_session_transactions b on a.transaction_id = b.transaction_id
Att.