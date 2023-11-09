-- Comparando Espaço Ocupado ColumnStore Index X Clustered Index --
SELECT 'ColumnStoreIndex'As IndexName, SUM(on_disk_size_MB) AS TotalSizeInMBColumnStoredIndex
  FROM
  (
     (SELECT 'ColumnStoreIndex'As IndexName, SUM(css.on_disk_size)/(1024.0*1024.0) * 8 on_disk_size_MB
      FROM sys.indexes AS i
      JOIN sys.partitions AS p
          ON i.object_id = p.object_id 
      JOIN sys.column_store_segments AS css
          ON css.hobt_id = p.hobt_id
      WHERE i.object_id = object_id('Dados') 
      AND i.type_desc = 'NONCLUSTERED COLUMNSTORE')
    UNION ALL
     (SELECT 'ColumnStoreIndex'As IndexName, SUM(csd.on_disk_size)/(1024.0*1024.0) * 8 on_disk_size_MB
      FROM sys.indexes AS i
      JOIN sys.partitions AS p
          ON i.object_id = p.object_id 
      JOIN sys.column_store_dictionaries AS csd
          ON csd.hobt_id = p.hobt_id
      WHERE i.object_id = object_id('Dados') 
      AND i.type_desc = 'NONCLUSTERED COLUMNSTORE') 
  ) AS InformationColumnStoredIndex

SELECT 'PK_Dados'As IndexName, SUM(on_disk_size_MB) AS TotalSizeInMBIndex
  FROM
  (
     (SELECT SUM(i.rowcnt)/(1024.0*1024.0) * 8 on_disk_size_MB
      FROM sysindexes AS i
      JOIN sys.partitions AS p
          ON i.id = p.object_id 
      WHERE i.id = object_id('Dados'))
    UNION ALL
     (SELECT SUM(i.rowcnt)/(1024.0*1024.0) * 8 on_disk_size_MB
      FROM sysindexes AS i
      JOIN sys.partitions AS p
          ON i.id = p.object_id 
      WHERE i.id = object_id('Dados'))
  ) AS InformationIndex


-- Exibindo informações sobre as Colunas utilizadas no ColumnStore Index --
Select * from sys.column_store_segments

-- Exibindo informações sobre as Colunas com espaço ocupado no ColumnStore Index --
Select * from sys.column_store_dictionaries 

-- Comparativo de Informações entre Clustered Index X ColumnStore Index --
Select Name, status, indid, minlen, maxlen, dpages, rowcnt, used, rows from sysindexes
Where Name In ('ColumnStoreIndex_Dados','PK_Dados')