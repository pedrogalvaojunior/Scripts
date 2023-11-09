-- Adding and Finding SQL Server Auto Statistics Events --
DECLARE @path NVARCHAR(260)

SELECT @path=path FROM sys.traces WHERE is_default = 1

--Auto Stats, Indicates an automatic updating of index statistics has occurred.
SELECT TextData, ObjectID, 
       ObjectName, IndexID, 
	   Duration, StartTime, 
	   EndTime, SPID, 
	   ApplicationName, LoginName  
FROM sys.fn_trace_gettable(@path, DEFAULT)
WHERE EventClass IN (58)
ORDER BY StartTime DESC