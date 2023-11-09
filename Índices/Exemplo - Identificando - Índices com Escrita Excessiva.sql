-- Identificando os Índices com Escrita Excessiva em comparação a Leitura --
SELECT  OBJECT_NAME(s.object_id), 
              i.name, 
              i.type_desc
FROM    sys.dm_db_index_usage_stats s WITH ( NOLOCK ) Inner JOIN sys.indexes i WITH (NOLOCK) 
                                                                                                      ON s.index_id = i.index_id
AND s.object_id = i.object_id
WHERE OBJECTPROPERTY(s.[object_id], 'IsUserTable') = 1
AND s.database_id = DB_ID()
AND s.user_updates > ( s.user_seeks + s.user_scans + s.user_lookups )
AND s.index_id > 1

-- Quantidade de Índices com Escrita Excessiva --
SELECT  COUNT(*)
FROM    sys.dm_db_index_usage_stats s WITH ( NOLOCK )
WHERE   OBJECTPROPERTY(s.[object_id], 'IsUserTable') = 1
        AND s.database_id = DB_ID()
        AND s.user_updates > ( s.user_seeks + s.user_scans + s.user_lookups )
        AND s.index_id > 1
