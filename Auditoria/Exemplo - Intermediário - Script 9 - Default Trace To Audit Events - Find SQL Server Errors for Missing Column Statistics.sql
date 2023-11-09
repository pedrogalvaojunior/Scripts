-- Find SQL Server Errors for Missing Column Statistics --
DECLARE @path NVARCHAR(260)

SELECT @path=path FROM sys.traces WHERE is_default = 1

--Errors and Warnings: Missing Column Statistics
SELECT DatabaseName, TextData, 
       Duration, StartTime, 
	   EndTime, SPID, 
	   ApplicationName, LoginName 
FROM sys.fn_trace_gettable(@path, DEFAULT)
WHERE  EventClass IN (79)
ORDER BY StartTime DESC;