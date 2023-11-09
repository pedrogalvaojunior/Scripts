SET NOCOUNT ON; 

CREATE TABLE HeapTest (ID INT IDENTITY(1, 1), DESCR VARCHAR(255)); 

IF EXISTS(SELECT *
 FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('HeapTest'), NULL, NULL, 'SAMPLED')
 WHERE page_count > 0)
  PRINT 'Table Contains Pages After Create'; 

INSERT INTO HeapTest (DESCR)
 SELECT TOP 20000 REPLICATE('X', 255)
 FROM sys.objects o1
 CROSS JOIN sys.objects o2; 

IF EXISTS(SELECT *
 FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('HeapTest'), NULL, NULL, 'SAMPLED')
 WHERE page_count > 0)
  PRINT 'Table Contains Pages After Load'; 

DELETE FROM HeapTest; 

IF EXISTS(SELECT *
 FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('HeapTest'), NULL, NULL, 'SAMPLED')
 WHERE page_count > 0)
  PRINT 'Table Contains Pages After Delete'; 

INSERT INTO HeapTest (DESCR)
 SELECT TOP 20000 REPLICATE('X', 255)
 FROM sys.objects o1
 CROSS JOIN sys.objects o2; 

IF EXISTS(SELECT *
 FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('HeapTest'), NULL, NULL, 'SAMPLED')
 WHERE page_count > 0)
  PRINT 'Table Contains Pages After Load'; 

TRUNCATE TABLE HeapTest; 

IF EXISTS(SELECT *
 FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('HeapTest'), NULL, NULL, 'SAMPLED')
 WHERE page_count > 0)
  PRINT 'Table Contains Pages After Truncate'; 

DROP TABLE HeapTest; 
