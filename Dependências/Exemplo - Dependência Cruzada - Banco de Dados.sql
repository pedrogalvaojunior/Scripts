-- Exemplo 1 --
SELECT  OBJECT_NAME (referencing_id) AS referencing_object, 
              referenced_database_name, 
              referenced_schema_name, 
             referenced_entity_name
FROM sys.sql_expression_dependencies
WHERE referenced_database_name IS NOT NULL
AND is_ambiguous = 0; 

-- Exemplo 2 --
SELECT OBJECT_NAME (referencing_id) AS referencing_object, 
             referenced_server_name, 
             referenced_database_name, 
             referenced_schema_name, 
             referenced_entity_name
FROM sys.sql_expression_dependencies
WHERE referenced_server_name IS NOT NULL
AND is_ambiguous = 0;