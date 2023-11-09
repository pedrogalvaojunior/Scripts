-- Buffer Pool Allocation and Physical_Memory --
SELECT
       physical_memory_in_bytes / 1024 / 1024 AS physical_memory_MB,
       bpool_committed / 128 AS bpool_MB,
       bpool_commit_target / 128 AS bpool_target_MB,
       bpool_visible / 128 AS bpool_visible_MB
FROM sys.dm_os_sys_info(nolock)
Go
