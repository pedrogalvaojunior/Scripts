--Processos bloqueados e bloqueadores

SELECT
spid,blocked,waittype,waittime,dbid,cpu,login_time,last_batch,status,hostname,hostprocess,cmd,net_address,request_id
FROM SYS.SYSPROCESSES WHERE BLOCKED >0
ORDER BY SPID
GO

--principal bloqueador

SELECT
spid,blocked,waittype,waittime,dbid,cpu,login_time,last_batch,status,hostname,hostprocess,cmd,net_address,request_id
FROM SYS.SYSPROCESSES WHERE BLOCKED =0
AND SPID in (select blocked from master.dbo.sysprocesses where blocked > 0)
ORDER BY SPID
GO