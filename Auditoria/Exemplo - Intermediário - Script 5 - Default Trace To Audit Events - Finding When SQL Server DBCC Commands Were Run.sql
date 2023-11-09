-- Finding Whe SQL Server DBCC Commands Were Run --
DECLARE @path NVARCHAR(260)

SELECT @path=path FROM sys.traces WHERE is_default = 1

--Security Audit: Audit DBCC CHECKDB, DBCC CHECKTABLE, DBCC CHECKCATALOG,
--DBCC CHECKALLOC, DBCC CHECKFILEGROUP Events, and more.
SELECT TextData, Duration, 
       StartTime, EndTime, 
	   SPID, ApplicationName, 
	   LoginName  
FROM sys.fn_trace_gettable(@path, DEFAULT)
WHERE EventClass IN (116) 
AND TextData like 'DBCC%CHECK%'
ORDER BY StartTime DESC