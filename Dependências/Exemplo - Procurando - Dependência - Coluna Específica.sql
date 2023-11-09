SELECT OBJECT_NAME (referencing_id),referenced_database_name, 
             referenced_schema_name, 
             referenced_entity_name
FROM sys.sql_expression_dependencies
WHERE OBJECT_NAME(d.referenced_id) = 'Customers' -- table that has miss-spelled column
AND OBJECT_DEFINITION (referencing_id)  LIKE '%Cstomer%'; -- miss-spelled column