WITH DepTree 
 AS 
(
    SELECT DISTINCT o.name, 
          o.[object_id] AS referenced_id , 
      o.name AS referenced_name, 
      o.[object_id] AS referencing_id, 
      o.name AS referencing_name,  
      0 AS NestLevel
 FROM  sys.objects o JOIN sys.columns c
   ON o.[object_id] = c.[object_id]
    WHERE o.is_ms_shipped = 0 
      AND c.system_type_id IN (34, 99, 35) -- TEXT, NTEXT and IMAGE
    
    UNION ALL
    
    SELECT  r.name, 
         d1.referenced_id,  
     OBJECT_NAME(d1.referenced_id) , 
     d1.referencing_id, 
     OBJECT_NAME( d1.referencing_id) , 
     NestLevel + 1
     FROM  sys.sql_expression_dependencies d1 
  JOIN DepTree r 
   ON d1.referenced_id =  r.referencing_id
)
 SELECT  name AS parent_object_name, 
         referenced_id, 
         referenced_name, 
         referencing_id, 
         referencing_name, 
         NestLevel
  FROM DepTree t1 WHERE NestLevel > 0
 ORDER BY name, NestLevel 