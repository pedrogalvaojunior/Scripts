-- Find SQL Server Errors for Sort Warnings --
DECLARE @path NVARCHAR(260)

SELECT @path=path FROM sys.traces WHERE is_default = 1

--Errors and Warnings: Sort Warnings
SELECT DatabaseName, TextData, 
       Duration, StartTime, 
	   EndTime, SPID, 
	   ApplicationName, LoginName   
FROM sys.fn_trace_gettable(@path, DEFAULT)
WHERE EventClass IN (69)
ORDER BY StartTime DESC