-- Find SQL Server Errors for Missing Join Predicates --
DECLARE @path NVARCHAR(260)

SELECT @path=path FROM sys.traces WHERE is_default = 1

--Errors and Warnings: Missing Join Predicate
SELECT DatabaseName,TextData, 
       Duration, StartTime, 
	   EndTime, SPID, 
	   ApplicationName, LoginName  
FROM sys.fn_trace_gettable(@path, DEFAULT)
WHERE EventClass IN (80)
ORDER BY  StartTime DESC