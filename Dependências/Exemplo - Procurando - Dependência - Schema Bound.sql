SELECT OBJECT_NAME(d.referencing_id) AS referencing_name, 
             o.type_desc referencing_object_type,
             d.referencing_minor_id AS referencing_column_id, 
             d.referenced_entity_name, d.referenced_minor_id AS referenced_column_id, 
             cc.name as referenced_column_name
FROM sys.sql_expression_dependencies d JOIN sys.all_columns cc 
                                                                       ON d.referenced_minor_id = cc.column_id AND d.referenced_id = cc.[object_id]
                                                                     JOIN sys.objects o 
                                                                      ON d.referencing_id = o.[object_id]
WHERE  d.is_schema_bound_reference = 1
 -- AND d.referencing_minor_id > 0 