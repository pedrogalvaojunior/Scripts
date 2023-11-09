Select object_name(ddips.object_id) As 'Tabela', 
       si.name As '�ndice', 
       convert(decimal(5,2),isnull(ddips.avg_fragmentation_in_percent,0)) As '% M�dia de Fragmenta��o', 
       ddips.page_count As 'P�ginas', 
       ddips.compressed_page_count As 'P�ginas compactadas', 
       ddips.record_count As 'Registros', 
       ddips.ghost_record_count As 'Registros Fantasmas' 
From sys.dm_db_index_physical_stats(db_id(), object_id('queimadas2018'),null, null, 'detailed') ddips Inner Join sys.indexes si 
      on si.object_id = ddips.object_id 
Where ddips.avg_fragmentation_in_percent > 0 
Go