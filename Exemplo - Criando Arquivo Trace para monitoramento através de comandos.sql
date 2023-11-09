Create PROCEDURE audit_trace AS
/****************************************************/
/* Created by: SQL Profiler                            */
/* Date: 02/09/2007  10:15:35 AM               */
/****************************************************/

-- Create a Queue
declare @rc int
declare @TraceID int
declare @maxfilesize bigint
set @maxfilesize = 5 

-- Please replace the text InsertFileNameHere, with an appropriate
-- filename prefixed by a path, e.g., c:MyFolderMyTrace. The .trc extension
-- will be appended to the filename automatically. If you are writing from
-- remote server to local drive, please use UNC path and make sure server has
-- write access to your network share

exec @rc = sp_trace_create @TraceID output, 2, N'C:\trace.trc', @maxfilesize, NULL 
if (@rc != 0) goto error

-- Client side File and Table cannot be scripted

-- Set the events
declare @on bit
set @on = 1
exec sp_trace_setevent @TraceID, 41, 1, @on
exec sp_trace_setevent @TraceID, 41, 6, @on
exec sp_trace_setevent @TraceID, 41, 8, @on
exec sp_trace_setevent @TraceID, 41, 10, @on
exec sp_trace_setevent @TraceID, 41, 12, @on
exec sp_trace_setevent @TraceID, 41, 14, @on
exec sp_trace_setevent @TraceID, 41, 35, @on
exec sp_trace_setevent @TraceID, 42, 1, @on
exec sp_trace_setevent @TraceID, 42, 6, @on
exec sp_trace_setevent @TraceID, 42, 8, @on
exec sp_trace_setevent @TraceID, 42, 10, @on
exec sp_trace_setevent @TraceID, 42, 12, @on
exec sp_trace_setevent @TraceID, 42, 14, @on
exec sp_trace_setevent @TraceID, 42, 35, @on
exec sp_trace_setevent @TraceID, 46, 1, @on
exec sp_trace_setevent @TraceID, 46, 6, @on
exec sp_trace_setevent @TraceID, 46, 8, @on
exec sp_trace_setevent @TraceID, 46, 10, @on
exec sp_trace_setevent @TraceID, 46, 12, @on
exec sp_trace_setevent @TraceID, 46, 14, @on
exec sp_trace_setevent @TraceID, 46, 35, @on
exec sp_trace_setevent @TraceID, 47, 1, @on
exec sp_trace_setevent @TraceID, 47, 6, @on
exec sp_trace_setevent @TraceID, 47, 8, @on
exec sp_trace_setevent @TraceID, 47, 10, @on
exec sp_trace_setevent @TraceID, 47, 12, @on
exec sp_trace_setevent @TraceID, 47, 14, @on
exec sp_trace_setevent @TraceID, 47, 35, @on
exec sp_trace_setevent @TraceID, 53, 1, @on
exec sp_trace_setevent @TraceID, 53, 6, @on
exec sp_trace_setevent @TraceID, 53, 8, @on
exec sp_trace_setevent @TraceID, 53, 10, @on
exec sp_trace_setevent @TraceID, 53, 12, @on
exec sp_trace_setevent @TraceID, 53, 14, @on
exec sp_trace_setevent @TraceID, 53, 35, @on
exec sp_trace_setevent @TraceID, 103, 1, @on
exec sp_trace_setevent @TraceID, 103, 6, @on
exec sp_trace_setevent @TraceID, 103, 8, @on
exec sp_trace_setevent @TraceID, 103, 10, @on
exec sp_trace_setevent @TraceID, 103, 12, @on
exec sp_trace_setevent @TraceID, 103, 14, @on
exec sp_trace_setevent @TraceID, 103, 35, @on
exec sp_trace_setevent @TraceID, 104, 1, @on
exec sp_trace_setevent @TraceID, 104, 6, @on
exec sp_trace_setevent @TraceID, 104, 8, @on
exec sp_trace_setevent @TraceID, 104, 10, @on
exec sp_trace_setevent @TraceID, 104, 12, @on
exec sp_trace_setevent @TraceID, 104, 14, @on
exec sp_trace_setevent @TraceID, 104, 35, @on
exec sp_trace_setevent @TraceID, 117, 1, @on
exec sp_trace_setevent @TraceID, 117, 6, @on
exec sp_trace_setevent @TraceID, 117, 8, @on
exec sp_trace_setevent @TraceID, 117, 10, @on
exec sp_trace_setevent @TraceID, 117, 12, @on
exec sp_trace_setevent @TraceID, 117, 14, @on
exec sp_trace_setevent @TraceID, 117, 35, @on
exec sp_trace_setevent @TraceID, 118, 1, @on
exec sp_trace_setevent @TraceID, 118, 6, @on
exec sp_trace_setevent @TraceID, 118, 8, @on
exec sp_trace_setevent @TraceID, 118, 10, @on
exec sp_trace_setevent @TraceID, 118, 12, @on
exec sp_trace_setevent @TraceID, 118, 14, @on
exec sp_trace_setevent @TraceID, 118, 35, @on

-- Set the Filters
declare @intfilter int
declare @bigintfilter bigint

exec sp_trace_setfilter @TraceID, 8, 0, 7, N'xxx' -- Nome do Server
exec sp_trace_setfilter @TraceID, 10, 0, 7, N'sql profiler'
exec sp_trace_setfilter @TraceID, 10, 0, 7, N'sqlagent - alert engine'
exec sp_trace_setfilter @TraceID, 11, 1, 6, N'sa' -- Login não trusted
exec sp_trace_setfilter @TraceID, 11, 1, 6, N'sqlserver01mbarre43' 
exec sp_trace_setfilter @TraceID, 11, 1, 6, N'sqlserver01magerbd'
exec sp_trace_setfilter @TraceID, 11, 1, 6, N'sqlserver01gfpini'

-- Set the trace status to start
exec sp_trace_setstatus @TraceID, 1

-- display trace id for future references
select TraceID=@TraceID
goto finish

error: 
select ErrorCode=@rc

finish:
GO

     
