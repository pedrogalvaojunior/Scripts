WITH DepTree 
 AS 
(
    SELECT  o.name, o.[object_id] AS referenced_id , 
   o.name AS referenced_name, 
   o.[object_id] AS referencing_id, 
   o.name AS referencing_name,  
   0 AS NestLevel
  FROM  sys.objects o 
    WHERE o.is_ms_shipped = 0 AND o.type = 'V'
    
    UNION ALL
    
    SELECT  r.name, d1.referenced_id,  
   OBJECT_NAME( d1.referenced_id) , 
   d1.referencing_id, 
   OBJECT_NAME( d1.referencing_id) , 
   NestLevel + 1
     FROM  sys.sql_expression_dependencies d1 
  JOIN DepTree r 
   ON d1.referenced_id =  r.referencing_id
)
 SELECT DISTINCT name as ViewName, MAX(NestLevel) AS MaxNestLevel
  FROM DepTree
 GROUP BY name
 HAVING MAX(NestLevel) > 4
 ORDER BY MAX(NestLevel) DESC; 