select Concat('Alter Index ',sys.indexes.name,' On ',sys.tables.name,' REBUILD WITH (FILLFACTOR = 80, SORT_IN_TEMPDB = OFF,  STATISTICS_NORECOMPUTE = ON)'),
           sys.tables.name as tabela, 
           sys.indexes.name as indice, 
           sys.indexes.type_desc as tipo, 
           sys.indexes.fill_factor, 
           sys.indexes.is_padded as padded,
		   sys.partitions.data_compression_desc
        from sys.indexes inner join  sys.tables
                                     on sys.indexes.object_id = sys.tables.object_id
									inner join sys.partitions
									 on sys.partitions.object_id = sys.indexes.object_id
where sys.indexes.is_disabled =0 
and sys.indexes.name is not null
and sys.indexes.type_desc <> 'NONCLUSTERED COLUMNSTORE'
and sys.partitions.data_compression_desc <> 'COLUMNSTORE'
and sys.indexes.fill_factor = 0
order by tabela, tipo 
Go