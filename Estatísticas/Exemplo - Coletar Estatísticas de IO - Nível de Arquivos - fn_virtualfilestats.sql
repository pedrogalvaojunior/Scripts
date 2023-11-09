SELECT *
FROM fn_virtualfilestats(1, 1);

SELECT * FROM sys.dm_io_virtual_file_stats(DB_ID(N'Master'), 1);