SELECT ser.session_id As 'SessionID',
	         ssp.ecid,
	         DB_NAME(ssp.dbid) As 'DatabaseName',
	         ssp.nt_username as 'User',
	         ser.status As 'Status',
	         ser.wait_type As 'Wait',
		     SUBSTRING (sqt.text,  ser.statement_start_offset/2,
	           (CASE WHEN 
			              ser.statement_end_offset = -1 THEN LEN(CONVERT(NVARCHAR(MAX), sqt.text)) * 2
		         ELSE ser.statement_end_offset 
				 END - ser.statement_start_offset)/2) As 'Individual Query',
	         sqt.text As 'Parent Query',
	         ssp.program_name As 'ProgramName',
	         ssp.hostname,
	         ssp.nt_domain As 'NetworkDomain',
	         ser.start_time
FROM sys.dm_exec_requests ser INNER JOIN sys.sysprocesses ssp 
                                                       On ser.session_id = ssp.spid
CROSS APPLY sys.dm_exec_sql_text(ser.sql_handle)as sqt
WHERE ser.session_Id > 50             
AND ser.session_Id NOT IN (@@SPID)     
ORDER BY SessionID, ssp.ecid
Go
