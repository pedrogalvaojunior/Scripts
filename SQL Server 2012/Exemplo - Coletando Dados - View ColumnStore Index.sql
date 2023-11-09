IF OBJECT_ID('dbo.vw_DadosColumnStoreIndex') IS NOT NULL
	DROP VIEW dbo.vw_DadosColumnStoreIndex
GO

CREATE VIEW dbo.vw_DadosColumnStoreIndex 
AS	
WITH DadosColumnStoreIndex AS 
(SELECT  S.object_id AS ObjectID,
		SSC.name + '.'+ S.name AS TableName,
		S.type_desc AS ObjectType,
		SI.index_id AS IndexID,
		SI.name AS IndexName,
		SI.type_desc AS IndexType,
		SI.is_disabled AS Disabled,
		SI.has_filter AS Filtered,
		SI.filter_definition AS FilterDefinition,
		CL.column_id AS ColumnID,
		CL.name AS ColumnName,
		STS.name AS	ColumnType,
		CL.max_length AS Lenght, 
		STS.collation_name AS Collation
FROM sys.tables AS S
INNER JOIN sys.indexes AS SI 
ON  SI.object_id = S.object_id
INNER JOIN sys.index_columns AS IC
ON IC.index_id = CAST(SI.index_id AS INT) 
	AND IC.object_id = SI.object_id
	AND SI.type = 6
INNER JOIN sys.columns AS CL
ON CL.object_id = IC.object_id 
	AND CL.column_id = IC.column_id
INNER JOIN sys.schemas AS SSC
ON SSC.schema_id = S.schema_id
INNER JOIN sys.types AS STS 
ON STS.system_type_id = CL.system_type_id
	AND STS.user_type_id = CL.user_type_id
),
DadosPartitionsColumnsStoreIndex AS 
(SELECT A.partition_id, 
        A.object_id, 
	    A.index_id, 
	    A.rows, 
	    A.data_compression, 
	    A.data_compression_desc,
	    ss.column_id, 
	    ss.segment_id, 
	    ss.version, 
	    ss.encoding_type, 
	    ss.row_count, 
	    ss.has_nulls, 
	    ss.min_data_id, 
	    ss.max_data_id, 
	    ss.on_disk_size 
FROM sys.partitions AS A INNER JOIN sys.column_store_segments AS SS 
                          ON A.partition_id = SS.partition_id
)
SELECT DCSI.*, 
       DPCSI.rows, 
	   DPCSI.data_compression, 
	   DPCSI.data_compression_desc, 
	   DPCSI.version, 
	   DPCSI.encoding_type,
	   DPCSI.min_data_id, 
	   DPCSI.max_data_id, 
	   DPCSI.on_disk_size
FROM DadosColumnStoreIndex AS DCSI LEFT OUTER JOIN DadosPartitionsColumnsStoreIndex AS DPCSI 
                                    ON DCSI.ObjectID = DPCSI.object_id
	                                AND DCSI.IndexID = DPCSI.index_id
	                                AND DCSI.ColumnID = DPCSI.column_id

SELECT * FROM dbo.vw_DadosColumnStoreIndex
