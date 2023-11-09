DECLARE @TableName AS VARCHAR(250)='Produtos'
;WITH cte AS 
(
	SELECT cast(OBJECT_NAME (fkc.parent_object_id) as VARCHAR(MAX)) AS TableRelation, OBJECT_NAME(fkc.parent_object_id) AS DependentTable, fkc.parent_object_id AS 
	       childID, 1 AS ReLevel
	FROM   sys.foreign_key_columns fkc
	WHERE  fkc.referenced_object_id = OBJECT_ID (@TableName)
	UNION ALL
	SELECT cast(c.TableRelation +'-->'+ OBJECT_NAME (fkc.parent_object_id) AS VARCHAR(MAX)) AS TableRelation, OBJECT_NAME(fkc.parent_object_id) AS DependentTable, fkc.parent_object_id AS 
	       childID, c.ReLevel + 1
	FROM   sys.foreign_key_columns fkc
	       INNER JOIN cte c
	            ON  fkc.referenced_object_id = c.Childid AND fkc.parent_object_id<>c.childid
)
SELECT TableRelation,DependentTable
FROM   cte