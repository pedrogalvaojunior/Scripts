WITH memory_cache_entries
AS
(
       SELECT
             name AS entry_name,
             [type],
             in_use_count,
             pages_allocated_count,
             CAST(entry_data AS XML) AS entry_data
       FROM sys.dm_os_memory_cache_entries(nolock)
       WHERE type = ‘USERSTORE_TOKENPERM’
),
memory_cache_entries_details
AS
(
       SELECT
             entry_data.value(‘(/entry/@class)[1]’, ‘bigint’) AS class,
             entry_data.value(‘(/entry/@subclass)[1]’, ‘int’) AS subclass,
             entry_data.value(‘(/entry/@name)[1]’, ‘varchar(100)’) AS token_name,
             pages_allocated_count,
             in_use_count
       FROM memory_cache_entries
)
SELECT
       class,
       subclass,
       token_name,
       COUNT(*) AS nb_entries
FROM memory_cache_entries_details
GROUP BY token_name, class, subclass
ORDER BY nb_entries DESC;