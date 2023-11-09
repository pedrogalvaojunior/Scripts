-- Utilização por tipo de cache
SELECT  type, 
        SUM(single_pages_kb)/1024. AS [SPA Mem, MB],
		SUM(Multi_pages_kb)/1024. AS [MPA Mem,MB]
FROM sys.dm_os_memory_clerks
GROUP BY type
HAVING  SUM(single_pages_kb) + sum(Multi_pages_kb)  > 40000 -- Só os maiores consumidores de memória
ORDER BY SUM(single_pages_kb) DESC

-- Total utilizado
SELECT  SUM(single_pages_kb)/1024. AS [SPA Mem, KB],
        SUM(Multi_pages_kb)/1024. AS [MPA Mem, KB]
FROM sys.dm_os_memory_clerks