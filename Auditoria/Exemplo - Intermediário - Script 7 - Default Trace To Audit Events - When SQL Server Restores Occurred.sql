-- When SQL Server Restores Occurred --

DECLARE @path NVARCHAR(260)

SELECT @path=path FROM sys.traces WHERE is_default = 1

--Security Audit: Audit Restore Event
SELECT TextData, Duration, 
       StartTime, EndTime, 
	   SPID, ApplicationName, 
	   LoginName     
FROM sys.fn_trace_gettable(@path, DEFAULT)
WHERE EventClass IN (115) 
and EventSubClass=2
ORDER BY StartTime DESC