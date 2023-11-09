select * from Person.Person

SELECT * FROM :: fn_trace_getinfo(DEFAULT)

SELECT * FROM :: fn_trace_getfilterinfo(4)

SELECT * FROM :: fn_trace_geteventinfo(4)

SELECT TextData,    ApplicationName,    SPID,    ServerName,    EventClass   FROM :: fn_trace_gettable('e:\trace2.trc', DEFAULT)