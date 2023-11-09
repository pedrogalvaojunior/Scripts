-- Find Captured Trace Events and Occurrence --
DECLARE @path NVARCHAR(260)

SELECT @path=path FROM sys.traces WHERE is_default = 1

SELECT TE.name AS EventName, DT.DatabaseName, 
       DT.ApplicationName, DT.LoginName, COUNT(*) AS Quantity 
FROM dbo.fn_trace_gettable (@path,  DEFAULT) DT INNER JOIN sys.trace_events TE 
                                                 ON DT.EventClass = TE.trace_event_id 
GROUP BY TE.name , DT.DatabaseName , DT.ApplicationName, DT.LoginName 
ORDER BY TE.name, DT.DatabaseName , DT.ApplicationName, DT.LoginName 