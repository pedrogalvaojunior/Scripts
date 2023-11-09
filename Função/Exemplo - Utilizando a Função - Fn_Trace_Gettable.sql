USE AdventureWorks2008R2;
GO
SELECT * INTO temp_trc
FROM fn_trace_gettable('c:\temp\mytrace.trc', default);
GO


SELECT IDENTITY(int, 1, 1) AS RowNumber, * INTO temp_trc from fn_trace_gettable
('C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\LOG\log_74.trc', default)
GO