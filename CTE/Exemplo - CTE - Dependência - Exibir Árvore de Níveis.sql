WITH DepTree (referenced_id, referenced_name, referencing_id, referencing_name, NestLevel)
 AS 
(
    SELECT  o.[object_id] AS referenced_id , 
     o.name AS referenced_name, 
     o.[object_id] AS referencing_id, 
     o.name AS referencing_name,  
     0 AS NestLevel
 FROM  sys.objects o 
    WHERE o.name = 't_demo_4'
    
    UNION ALL
    
    SELECT  d1.referenced_id,  
     OBJECT_NAME( d1.referenced_id) , 
     d1.referencing_id, 
     OBJECT_NAME( d1.referencing_id) , 
     NestLevel + 1
     FROM  sys.sql_expression_dependencies d1 
  JOIN DepTree r ON d1.referenced_id =  r.referencing_id
)
SELECT DISTINCT referenced_id, referenced_name, referencing_id, referencing_name, NestLevel
 FROM DepTree WHERE NestLevel > 0
ORDER BY NestLevel, referencing_id; 