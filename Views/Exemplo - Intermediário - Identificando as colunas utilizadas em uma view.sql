-- Option 1: Using Information_Schema --
SELECT * 
FROM INFORMATION_SCHEMA.VIEW_COLUMN_USAGE AS UsedColumns 
WHERE UsedColumns.VIEW_NAME='NameofView'
Go

-- Option 2: Using DMVs --
SELECT
     v.name AS ViewName,
     c.name AS ColumnName,
     columnTypes.name AS DataType,
     aliases.name AS Alias
FROM
sys.views v 
INNER JOIN sys.sql_dependencies d 
    ON d.object_id = v.object_id
INNER JOIN .sys.objects t 
    ON t.object_id = d.referenced_major_id
INNER JOIN sys.columns c 
    ON c.object_id = d.referenced_major_id 
INNER JOIN sys.types AS columnTypes 
    ON c.user_type_id=columnTypes.user_type_id
    AND c.column_id = d.referenced_minor_id
INNER JOIN sys.columns AS aliases
    on c.column_id=aliases.column_id
    AND aliases.object_id = object_id('[SchemaName].[ViewName]')
WHERE
   v.name = 'ViewName';
Go