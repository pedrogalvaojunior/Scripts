-- When SQL Server Backups Occurred --
DECLARE @path NVARCHAR(260)

SELECT @path=path FROM sys.traces WHERE is_default = 1

--Security Audit: Audit Backup Event
SELECT DatabaseName, TextData, 
       Duration, StartTime, 
	   EndTime, SPID, 
	   ApplicationName, LoginName   
FROM sys.fn_trace_gettable(@path, DEFAULT)
WHERE EventClass IN (115) 
and EventSubClass=1
ORDER BY StartTime DESC