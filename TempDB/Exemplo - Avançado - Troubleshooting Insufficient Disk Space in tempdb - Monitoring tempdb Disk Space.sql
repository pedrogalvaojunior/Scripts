-- Determining the Amount of Free Space in tempdb --
SELECT SUM(unallocated_extent_page_count) AS [free pages], 
            (SUM(unallocated_extent_page_count)*1.0/128) AS [free space in MB]
FROM sys.dm_db_file_space_usage
Go

-- Determining the Amount Space Used by the Version Store --
SELECT SUM(version_store_reserved_page_count) AS [version store pages used],
            (SUM(version_store_reserved_page_count)*1.0/128) AS [version store space in MB]
FROM sys.dm_db_file_space_usage
Go

-- Determining the Longest Running Transaction --
SELECT transaction_id
FROM sys.dm_tran_active_snapshot_database_transactions 
ORDER BY elapsed_time_seconds DESC
Go

-- Determining the Amount of Space Used by Internal Objects --
SELECT SUM(internal_object_reserved_page_count) AS [internal object pages used],
            (SUM(internal_object_reserved_page_count)*1.0/128) AS [internal object space in MB]
FROM sys.dm_db_file_space_usage
Go

-- Determining the Amount of Space Used by User Objects --
SELECT SUM(user_object_reserved_page_count) AS [user object pages used],
            (SUM(user_object_reserved_page_count)*1.0/128) AS [user object space in MB]
FROM sys.dm_db_file_space_usage
Go

-- Determining the Total Amount of Space (Free and Used) --
SELECT SUM(size)*1.0/128 AS [size in MB]
FROM tempdb.sys.database_files
Go