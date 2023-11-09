DECLARE @object_name VARCHAR(100)
DECLARE @schema_name VARCHAR(20)
DECLARE @sqltext VARCHAR(MAX)

DECLARE @temptable TABLE
([object_name] VARCHAR(100)
,[schema_name] VARCHAR(20)
,[index_id] INT
,[partition_number] INT
,[size_with_current_compression_setting(KB)] NUMERIC(18,0)
,[size_with_requested_compression_setting(KB)] NUMERIC(18,0)
,[sample_size_with_current_compression_setting(KB)] NUMERIC(18,0)
,[sample_size_with_requested_compression_setting(KB)] NUMERIC(18,0))

DECLARE C1 CURSOR FOR
SELECT s.name, o.name
FROM sys.objects o, sys.indexes i, sys.schemas s
WHERE o.object_id = i.object_id
AND o.type = 'U'
AND i.type_desc = 'CLUSTERED'
AND o.schema_id = s.schema_id

OPEN C1

FETCH C1 INTO @schema_name, @object_name 

WHILE @@FETCH_STATUS >= 0
BEGIN
SET @sqltext = 'sp_estimate_data_compression_savings ''' + @schema_name + ''', ''' + @object_name + ''', 1, NULL, ''PAGE'''
--PRINT @sqltext 

INSERT INTO @temptable
EXEC (@sqltext)

FETCH C1 INTO @schema_name, @object_name 
END

CLOSE C1
DEALLOCATE C1

SELECT 
[object_name]
,[schema_name] 
,[size_with_current_compression_setting(KB)]
,[size_with_requested_compression_setting(KB)]
,CASE WHEN [size_with_current_compression_setting(KB)] > 0 THEN CAST(ROUND([size_with_requested_compression_setting(KB)]/[size_with_current_compression_setting(KB)]*100,2) AS NUMERIC(20,2)) END AS PctCompressionRatio
,CASE WHEN [size_with_current_compression_setting(KB)] > 0 THEN CAST(ROUND((1-[size_with_requested_compression_setting(KB)]/[size_with_current_compression_setting(KB)])*100,2) AS NUMERIC(20,2)) END AS PctSpaceSavings
FROM @temptable
ORDER BY 3 