SELECT spid, QRY.[text] AS Consulta FROM sysprocesses AS P
CROSS APPLY sys.dm_exec_sql_text(P.sql_handle) AS QRY
WHERE P.open_tran <> 0