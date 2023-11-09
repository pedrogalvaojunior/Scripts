SELECT sys.tables.name AS [Table Name], 
    sys.identity_columns.name AS [Column Name],sys.types.name  as Type,
    last_value AS [Last Value]      
FROM sys.identity_columns
    INNER JOIN sys.tables
        ON sys.identity_columns.object_id = sys.tables.object_id
		Inner join sys.types   on sys.types.user_type_id = sys.identity_columns.user_type_id
ORDER BY last_value DESC