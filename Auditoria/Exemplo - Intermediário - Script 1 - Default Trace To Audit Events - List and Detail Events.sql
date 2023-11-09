-- List all traces in the server --
SELECT * FROM sys.traces

SELECT * FROM sys.traces WHERE is_default = 1


-- Complete list using this T-SQL --
DECLARE @id INT

SELECT @id=id FROM sys.traces WHERE is_default = 1

SELECT DISTINCT eventid, 
       name 
FROM  fn_trace_geteventinfo(@id) EI JOIN sys.trace_events TE  
                                     ON EI.eventid = TE.trace_event_id

