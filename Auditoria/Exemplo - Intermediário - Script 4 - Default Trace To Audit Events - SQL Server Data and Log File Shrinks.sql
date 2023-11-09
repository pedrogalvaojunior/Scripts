-- SQL Server Data and Log File Shrinks --
DECLARE @path NVARCHAR(260)

SELECT @path=path FROM sys.traces WHERE is_default = 1

--Database: Data & Log File Shrink
SELECT TextData, Duration, 
       StartTime, EndTime, 
	   SPID, ApplicationName, 
	   LoginName  
FROM sys.fn_trace_gettable(@path, DEFAULT)
WHERE EventClass IN (116) 
AND TextData like 'DBCC%SHRINK%'
ORDER BY StartTime DESC