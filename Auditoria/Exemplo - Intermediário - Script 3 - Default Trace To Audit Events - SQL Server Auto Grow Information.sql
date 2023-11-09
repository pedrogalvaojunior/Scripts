-- SQL Server Auto Grow Information --
DECLARE @path NVARCHAR(260)

SELECT @path=path FROM sys.traces WHERE is_default = 1

--Database: Data & Log File Auto Grow --
SELECT DatabaseName, [FileName],
       CASE EventClass 
	    WHEN 92 THEN 'Data File Auto Grow'   
        WHEN 93 THEN 'Log File Auto Grow'
	   END AS EventClass,
       Duration, StartTime, 
	   EndTime, SPID, 
	   ApplicationName, LoginName 
FROM sys.fn_trace_gettable(@path, DEFAULT)
WHERE EventClass IN (92,93)
ORDER BY StartTime DESC