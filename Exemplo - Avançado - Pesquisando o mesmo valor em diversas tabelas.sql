-- Exemplo 1 --
USE DATABASE_NAME
DECLARE @SearchStr nvarchar(100) = 'SEARCH_TEXT'
DECLARE @Results TABLE (ColumnName nvarchar(370), ColumnValue nvarchar(3630))

SET NOCOUNT ON

DECLARE @TableName nvarchar(256), @ColumnName nvarchar(128), @SearchStr2 nvarchar(110)
SET  @TableName = ''
SET @SearchStr2 = QUOTENAME('%' + @SearchStr + '%','''')

WHILE @TableName IS NOT NULL

BEGIN
    SET @ColumnName = ''
    SET @TableName = 
    (
        SELECT MIN(QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME))
        FROM     INFORMATION_SCHEMA.TABLES
        WHERE         TABLE_TYPE = 'BASE TABLE'
            AND    QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) > @TableName
            AND    OBJECTPROPERTY(
                    OBJECT_ID(
                        QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME)
                         ), 'IsMSShipped'
                           ) = 0
    )

    WHILE (@TableName IS NOT NULL) AND (@ColumnName IS NOT NULL)

    BEGIN
        SET @ColumnName =
        (
            SELECT MIN(QUOTENAME(COLUMN_NAME))
            FROM     INFORMATION_SCHEMA.COLUMNS
            WHERE         TABLE_SCHEMA    = PARSENAME(@TableName, 2)
                AND    TABLE_NAME    = PARSENAME(@TableName, 1)
                AND    DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar', 'int', 'decimal')
                AND    QUOTENAME(COLUMN_NAME) > @ColumnName
        )

        IF @ColumnName IS NOT NULL

        BEGIN
            INSERT INTO @Results
            EXEC
            (
                'SELECT ''' + @TableName + '.' + @ColumnName + ''', LEFT(' + @ColumnName + ', 3630) 
                FROM ' + @TableName + ' (NOLOCK) ' +
                ' WHERE ' + @ColumnName + ' LIKE ' + @SearchStr2
            )
        END
    END    
END

SELECT ColumnName, ColumnValue FROM @Results

-- Exemplo 2 --
CREATE PROC SearchAllTables
(
@SearchStr nvarchar(100)
)
AS
BEGIN

    CREATE TABLE #Results (ColumnName nvarchar(370), ColumnValue nvarchar(3630))

    SET NOCOUNT ON

    DECLARE @TableName nvarchar(256), @ColumnName nvarchar(128), @SearchStr2 nvarchar(110)
    SET  @TableName = ''
    SET @SearchStr2 = QUOTENAME('%' + @SearchStr + '%','''')

    WHILE @TableName IS NOT NULL

    BEGIN
        SET @ColumnName = ''
        SET @TableName = 
        (
            SELECT MIN(QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME))
            FROM     INFORMATION_SCHEMA.TABLES
            WHERE         TABLE_TYPE = 'BASE TABLE'
                AND    QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) > @TableName
                AND    OBJECTPROPERTY(
                        OBJECT_ID(
                            QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME)
                             ), 'IsMSShipped'
                               ) = 0
        )

        WHILE (@TableName IS NOT NULL) AND (@ColumnName IS NOT NULL)

        BEGIN
            SET @ColumnName =
            (
                SELECT MIN(QUOTENAME(COLUMN_NAME))
                FROM     INFORMATION_SCHEMA.COLUMNS
                WHERE         TABLE_SCHEMA    = PARSENAME(@TableName, 2)
                    AND    TABLE_NAME    = PARSENAME(@TableName, 1)
                    AND    DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar', 'int', 'decimal')
                    AND    QUOTENAME(COLUMN_NAME) > @ColumnName
            )

            IF @ColumnName IS NOT NULL

            BEGIN
                INSERT INTO #Results
                EXEC
                (
                    'SELECT ''' + @TableName + '.' + @ColumnName + ''', LEFT(' + @ColumnName + ', 3630) 
                    FROM ' + @TableName + 'WITH (NOLOCK) ' +
                    ' WHERE ' + @ColumnName + ' LIKE ' + @SearchStr2
                )
            END
        END    
    END

    SELECT ColumnName, ColumnValue FROM #Results
END

-- Exemplo 3 --
DECLARE
@search_string  VARCHAR(100),
@table_name     SYSNAME,
@table_id       INT,
@column_name    SYSNAME,
@sql_string     VARCHAR(2000)

SET @search_string = 'StringtoSearch'

DECLARE tables_cur CURSOR FOR SELECT ss.name +'.'+ so.name [name], object_id FROM sys.objects so INNER JOIN sys.schemas ss ON so.schema_id = ss.schema_id WHERE  type = 'U'

OPEN tables_cur

FETCH NEXT FROM tables_cur INTO @table_name, @table_id

WHILE (@@FETCH_STATUS = 0)
BEGIN
    DECLARE columns_cur CURSOR FOR SELECT name FROM sys.columns WHERE object_id = @table_id 
        AND system_type_id IN (167, 175, 231, 239)

    OPEN columns_cur

    FETCH NEXT FROM columns_cur INTO @column_name
        WHILE (@@FETCH_STATUS = 0)
        BEGIN
            SET @sql_string = 'IF EXISTS (SELECT * FROM ' + @table_name + ' WHERE [' + @column_name + '] 
            LIKE ''%' + @search_string + '%'') PRINT ''' + @table_name + ', ' + @column_name + ''''

            EXECUTE(@sql_string)

        FETCH NEXT FROM columns_cur INTO @column_name
        END

    CLOSE columns_cur

DEALLOCATE columns_cur

FETCH NEXT FROM tables_cur INTO @table_name, @table_id
END

CLOSE tables_cur
DEALLOCATE tables_cur

-- Exemplo 4 --
IF OBJECT_ID('sp_KeywordSearch', 'P') IS NOT NULL
    DROP PROC sp_KeywordSearch
GO

CREATE PROCEDURE sp_KeywordSearch @KeyWord NVARCHAR(100)
AS
BEGIN
    DECLARE @Result TABLE
        (TableName NVARCHAR(300),
         ColumnName NVARCHAR(MAX))

    DECLARE @Sql NVARCHAR(MAX),
        @TableName NVARCHAR(300),
        @ColumnName NVARCHAR(300),
        @Count INT

    DECLARE @tableCursor CURSOR

    SET @tableCursor = CURSOR LOCAL SCROLL FOR
    SELECT  N'SELECT @Count = COUNT(1) FROM [dbo].[' + T.TABLE_NAME + '] WITH (NOLOCK) WHERE CAST([' + C.COLUMN_NAME +
            '] AS NVARCHAR(MAX)) LIKE ''%' + @KeyWord + N'%''',
            T.TABLE_NAME,
            C.COLUMN_NAME
    FROM    INFORMATION_SCHEMA.TABLES AS T WITH (NOLOCK)
    INNER JOIN INFORMATION_SCHEMA.COLUMNS AS C WITH (NOLOCK)
    ON      T.TABLE_SCHEMA = C.TABLE_SCHEMA AND
            T.TABLE_NAME = C.TABLE_NAME
    WHERE   T.TABLE_TYPE = 'BASE TABLE' AND
            C.TABLE_SCHEMA = 'dbo' AND
            C.DATA_TYPE NOT IN ('image', 'timestamp')

    OPEN @tableCursor
    FETCH NEXT FROM @tableCursor INTO @Sql, @TableName, @ColumnName

    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        SET @Count = 0

        EXEC sys.sp_executesql
            @Sql,
            N'@Count INT OUTPUT',
            @Count OUTPUT

        IF @Count > 0
        BEGIN
            INSERT  INTO @Result
                    (TableName, ColumnName)
            VALUES  (@TableName, @ColumnName)
        END

        FETCH NEXT FROM @tableCursor INTO @Sql, @TableName, @ColumnName
    END

    CLOSE @tableCursor
    DEALLOCATE @tableCursor

    SET @tableCursor = CURSOR LOCAL SCROLL FOR
    SELECT  SUBSTRING(TB.Sql, 1, LEN(TB.Sql) - 3) AS Sql, TB.TableName, SUBSTRING(TB.Columns, 1, LEN(TB.Columns) - 1) AS Columns
    FROM    (SELECT R.TableName, (SELECT R2.ColumnName + ', ' FROM @Result AS R2 WHERE R.TableName = R2.TableName FOR XML PATH('')) AS Columns,
                    'SELECT * FROM ' + R.TableName + ' WITH (NOLOCK) WHERE ' +
                    (SELECT 'CAST(' + R2.ColumnName + ' AS NVARCHAR(MAX)) LIKE ''%' + @KeyWord + '%'' OR '
                     FROM   @Result AS R2
                     WHERE  R.TableName = R2.TableName
                    FOR
                     XML PATH('')) AS Sql
             FROM   @Result AS R
             GROUP BY R.TableName) TB
    ORDER BY TB.Sql

    OPEN @tableCursor
    FETCH NEXT FROM @tableCursor INTO @Sql, @TableName, @ColumnName

    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        PRINT @Sql
        SELECT  @TableName AS [Table],
                @ColumnName AS Columns
        EXEC(@Sql)

        FETCH NEXT FROM @tableCursor INTO @Sql, @TableName, @ColumnName
    END

    CLOSE @tableCursor
    DEALLOCATE @tableCursor

END

-- Exemplo 5 --
CREATE OR REPLACE FUNCTION SearchAllTables(_search text) RETURNS TABLE( txt text ) as $funct$
    DECLARE __COUNT int;
    __SQL text;
BEGIN
    EXECUTE 'SELECT COUNT(0) FROM INFORMATION_SCHEMA.COLUMNS
                    WHERE    DATA_TYPE = ''text'' 
                    AND          table_schema = ''public'' ' INTO __COUNT;

    RETURN QUERY 
        SELECT CASE WHEN ROW_NUMBER() OVER (ORDER BY table_name) < __COUNT THEN 
            'SELECT ''' || table_name ||'.'|| column_name || ''' AS tbl, "'  || column_name || '" AS col FROM "public"."' || "table_name" || '" WHERE "'|| "column_name" || '" ILIKE ''%' || _search  || '%'' UNION ALL' 
            ELSE 
            'SELECT ''' || table_name ||'.'|| column_name || ''' AS tbl, "'  || column_name || '" AS col FROM "public"."' || "table_name" || '" WHERE "'|| "column_name" || '" ILIKE ''%' || _search  || '%'''
        END AS txt

                    FROM     INFORMATION_SCHEMA.COLUMNS
                    WHERE    DATA_TYPE = 'text' 
                    AND          table_schema = 'public';
END