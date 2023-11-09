SELECT
       name AS clerk_name,
       memory_node_id,
       sum(single_pages_kb) / 1024 as single_page_total_size_mb,
       sum(multi_pages_kb) / 1024 as multi_page_total_size_mb,
       sum(awe_allocated_kb) / 1024 as awe_allocaed_size_MB
FROM sys.dm_os_memory_clerks(nolock)
WHERE memory_node_id 64
group by memory_node_id, name
HAVING SUM(multi_pages_kb) > 0
ORDER BY sum(single_pages_kb) + sum(multi_pages_kb) + sum(awe_allocated_kb) DESC;