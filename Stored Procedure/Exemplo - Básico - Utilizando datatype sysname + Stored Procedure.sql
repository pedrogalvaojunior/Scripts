declare @procname sysname;

set @procname = N'sys.sp_columns';

exec @procname @table_name = N'objects', @table_owner = N'sys';