DECLARE @id INT = ( SELECT id FROM sys.traces WHERE is_default = 1 )
 
SELECT DISTINCT
    eventid,
    name
FROM
    fn_trace_geteventinfo(@id) A
    JOIN sys.trace_events B ON A.eventid = B.trace_event_id