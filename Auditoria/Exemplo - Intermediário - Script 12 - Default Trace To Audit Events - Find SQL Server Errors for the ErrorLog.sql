-- Find SQL Server Errors for the ErrorLog --
DECLARE @path NVARCHAR(260)

SELECT @path=path FROM sys.traces WHERE is_default = 1

--Errors and Warnings: ErrorLog
SELECT TextData, Duration, 
       StartTime, EndTime, 
	   SPID, ApplicationName, 
	   LoginName   
FROM sys.fn_trace_gettable(@path, DEFAULT)
WHERE EventClass IN (22)
ORDER BY StartTime DESC