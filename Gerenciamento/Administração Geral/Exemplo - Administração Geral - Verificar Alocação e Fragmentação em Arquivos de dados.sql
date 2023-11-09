IF Object_ID('tempdb..#Used_Pages_List') Is not Null
 DROP TABLE #Used_Pages_List;
GO
SELECT object_id, allocated_page_page_id as page_id INTO #Used_Pages_List
FROM sys.dm_db_database_page_allocations(DB_ID(), NULL, NULL, NULL, NULL) as a
WHERE partition_id = 1
GO
CREATE CLUSTERED INDEX #CLIX_Used_Pages_List ON #Used_Pages_List(object_id,page_id)
GO
DECLARE @i INT = 0;
DECLARE @m INT = (SELECT MAX(object_id) FROM #Used_Pages_List);
DECLARE @g TABLE(Alloc GEOMETRY, Table_Object SYSNAME, object_id INT);
DECLARE @s INT = 131072
DECLARE @LineMegabytes INT = (SELECT Size/(64000)+1 FROM sys.database_files WHERE file_id = 1);
DECLARE @d INT = 128*@LineMegabytes;
DECLARE @DBSize INT = (SELECT Size FROM sys.database_files WHERE file_id = 1) / @d + 1
DECLARE @t TABLE(ID INT, MessageText VARCHAR(100));

INSERT INTO @t(ID,MessageText) VALUES
(1,'Scale: 1 Square 10x10 = 1 Page (8 Kb)'),
(2,'Row: ' + CAST(@LineMegabytes as VARCHAR) + ' Mb'),
(3,'Vertical: 100 points = ' + CAST(10*@LineMegabytes as VARCHAR) + ' Mb')

SELECT * FROM @t ORDER BY ID;

WHILE @i < @m
BEGIN
 SELECT @i = MIN(object_id) FROM #Used_Pages_List
 WHERE @i < object_id

 PRINT CONVERT(VARCHAR,@i) 

 INSERT INTO @g(object_id, Table_Object, Alloc) 
 SELECT @i, '[' + Object_Schema_Name(@i)+ '].[' + Object_Name(@i) + ']'
  , CONVERT(GEOMETRY,'POLYGON(' + SUBSTRING( (
  SELECT 
   ',(' 
   + CONVERT(VARCHAR, (page_id % @d) * 10) + ' ' + CONVERT(VARCHAR, (page_id / -@d) * 10 ) + ','
   + CONVERT(VARCHAR, (page_id % @d+1) * 10) + ' ' + CONVERT(VARCHAR, (page_id / -@d) * 10 ) + ','
   + CONVERT(VARCHAR, (page_id % @d+1) * 10) + ' ' + CONVERT(VARCHAR, (page_id / -@d) * 10 - 10) + ','
   + CONVERT(VARCHAR, (page_id % @d) * 10) + ' ' + CONVERT(VARCHAR, (page_id / -@d) * 10 - 10) + ','
   + CONVERT(VARCHAR, (page_id % @d) * 10) + ' ' + CONVERT(VARCHAR, (page_id / -@d) * 10 ) + ')'
  FROM #Used_Pages_List
  WHERE @i = object_id
  FOR XML PATH ('')
 ),2,@@TEXTSIZE) + ')');
END

SELECT object_id, Table_Object, Alloc FROM @g
UNION ALL
SELECT 0, 'Database Size', CONVERT(GEOMETRY,'LINESTRING(0 ' 
 + CONVERT(VARCHAR, @DBSize * -10) + ', ' + CONVERT(VARCHAR, @d * 10) + ' ' + CONVERT(VARCHAR, @DBSize * -10) + ')')
ORDER BY object_id
GO