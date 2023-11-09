SELECT TLS.resource_type,
	CASE
		WHEN TLS.resource_type IN ('DATABASE', 'FILE', 'METADATA') THEN TLS.resource_type
		WHEN TLS.resource_type = 'OBJECT' THEN OBJECT_NAME(TLS.resource_associated_entity_id, SPS.[dbid])
		WHEN TLS.resource_type IN ('KEY', 'PAGE', 'RID') THEN
			(
			SELECT OBJECT_NAME([object_id])
			FROM sys.partitions
			WHERE sys.partitions.hobt_id = TLS.resource_associated_entity_id
			)
   END AS requested_object_name, TLS.request_mode, TLS.request_status,
   EXC.[text], SPS.spid, SPS.blocked, SPS.[status], SPS.loginame 
FROM sys.dm_tran_locks AS TLS
INNER JOIN sys.sysprocesses AS SPS ON TLS.request_session_id = SPS.spid
CROSS APPLY sys.dm_exec_sql_text(SPS.sql_handle) AS EXC
WHERE 
--SP.spid = @@SPID AND
TLS.[resource_type] <> 'DATABASE'
GO