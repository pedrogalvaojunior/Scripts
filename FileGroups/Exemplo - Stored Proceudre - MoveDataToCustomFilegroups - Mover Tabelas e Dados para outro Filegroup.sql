CREATE PROCEDURE dbo.MoveDataToCustomFilegroups
(
    @IndexType int
    , @OldFileGroupName sysname
    , @NewFileGroupName sysname
    , @DebugOnly bit = 0
)
AS
BEGIN
    /*
        Description:    MOVE ALL INDEXES of specified @IndexType from @OldFileGroupName 
                        to @NewFileGroupName
        By:             Max Vernon
        NOTE:           Should not be used on partitioned tables.
    */
    SET NOCOUNT ON;
    DECLARE @OnlineOption bit;
    DECLARE @msg nvarchar(255);
    DECLARE @cmd nvarchar(max);
    /*
    @IndexType can be
        0 = Heap
        1 = Clustered
        2 = Nonclustered
        3 = XML
        4 = Spatial
    */
    IF NOT EXISTS (SELECT 1 FROM (VALUES (0), (1), (2), (3), (4))v(n) WHERE v.n = @IndexType )
    BEGIN
        SET @msg = N'Invalid @IndexType specified.  @IndexType can be
        0 = Heap
        1 = Clustered
        2 = Nonclustered
        3 = XML
        4 = Spatial
';
        THROW 50000, @msg, 1;
    END
    IF @DebugOnly = 1
    BEGIN
        SET @msg = N'Running in DEBUG mode.  No statements will be executed.';
        RAISERROR (@msg, 10, 1);
    END
    SET @cmd = N'';
    SET @msg = N'';
    SET @OnlineOption = 0;
    IF EXISTS (SELECT name FROM sys.data_spaces WHERE name = @OldFileGroupName)
    BEGIN
        IF EXISTS (SELECT name FROM sys.data_spaces WHERE name = @NewFileGroupName)
        BEGIN
            IF @IndexType = 0 
            BEGIN
                /*
                    Heaps require building a clustered index on the target filegroup, 
                    then dropping the clustered index.
                */
                SELECT @cmd = @cmd + CASE WHEN @cmd = N'' THEN N'' ELSE CHAR(13) + CHAR(10) END + 
                N'CREATE CLUSTERED INDEX [CX_' + o.name + N'_' + (SELECT TOP(1) col_c.name FROM sys.columns col_c WHERE col_c.object_id = o.object_id ORDER BY col_c.column_id) + N'] ON ' + QUOTENAME(s.name) + N'.' + QUOTENAME(o.name) + N' (' + QUOTENAME((SELECT TOP(1) col_c.name FROM sys.columns col_c WHERE col_c.object_id = o.object_id ORDER BY col_c.column_id)) + N') 
    WITH (FILLFACTOR=100, DATA_COMPRESSION=PAGE) ON ' + QUOTENAME(@NewFileGroupName) + N';
    DROP INDEX [CX_' + o.name + N'_' + (SELECT TOP(1) col_c.name FROM sys.columns col_c WHERE col_c.object_id = o.object_id ORDER BY col_c.column_id) + N'] ON ' + QUOTENAME(s.name) + N'.' + QUOTENAME(o.name) + N';
    '
                FROM sys.indexes i
                    INNER JOIN sys.objects o on i.object_id = o.object_id
                    INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
                    INNER JOIN sys.data_spaces ds ON i.data_space_id = ds.data_space_id
                    INNER JOIN sys.partitions p ON o.object_id = p.object_id AND i.index_id = p.index_id
                WHERE i.type = 0 /* HEAP */
                    AND o.type = 'U' /* USER_TABLE */
                    AND o.is_ms_shipped = 0
                    AND ds.name = @OldFileGroupName;
            END
            ELSE
            BEGIN
                SELECT @cmd = @cmd + CASE WHEN @cmd = N'' THEN N'' ELSE CHAR(13) + CHAR(10) END +
            
                    CASE WHEN i.is_primary_key = 1 AND i.type = 2
                    THEN N'
    BEGIN TRANSACTION
    BEGIN TRY
        ALTER TABLE ' + QUOTENAME(s.name) + N'.'+ QUOTENAME(o.name) + N'
        DROP CONSTRAINT ' + QUOTENAME(i.name) + N';
        ALTER TABLE ' + QUOTENAME(s.name) + N'.'+ QUOTENAME(o.name) + N'
        ADD CONSTRAINT ' + QUOTENAME(i.name) + N' PRIMARY KEY NONCLUSTERED ('
                    ELSE
                        N'CREATE ' + CASE WHEN i.is_unique = 1 THEN N'UNIQUE ' ELSE N'' END + i.type_desc + N' INDEX ' + QUOTENAME(i.name) + N' ON ' + QUOTENAME(s.name) + N'.' + QUOTENAME(o.name) + 
                        N'(' 
                    END + 
                        (
                        SELECT STUFF((
                            SELECT N', ' + QUOTENAME(col_c.name) + CASE WHEN col_ic.is_descending_key = 1 THEN N' DESC' ELSE N'' END
                            FROM sys.indexes col_i
                                INNER JOIN sys.index_columns col_ic ON col_i.object_id = col_ic.object_id AND col_i.index_id = col_ic.index_id
                                INNER JOIN sys.columns col_c ON col_ic.object_id = col_c.object_id AND col_ic.column_id = col_c.column_id
                            WHERE col_ic.is_included_column = 0
                                AND col_i.object_id = i.object_id
                                AND col_i.index_id = i.index_id
                            ORDER BY col_ic.key_ordinal
                            FOR XML PATH('')
                            ),1,2,'')
                        )
                    + N')' + CHAR(13) + CHAR(10) +
                    CASE WHEN (
                            SELECT COUNT(1) 
                            FROM sys.indexes col_i
                                INNER JOIN sys.index_columns col_ic ON col_i.object_id = col_ic.object_id AND col_i.index_id = col_ic.index_id
                                INNER JOIN sys.columns col_c ON col_ic.object_id = col_c.object_id AND col_ic.column_id = col_c.column_id
                            WHERE col_ic.is_included_column = 1
                                AND col_i.object_id = i.object_id
                                AND col_i.index_id = i.index_id
                            ) > 0
                    THEN
                        N' INCLUDE (' + 
                        (SELECT STUFF((
                            SELECT N', ' + QUOTENAME(col_c.name)
                            FROM sys.indexes col_i
                                INNER JOIN sys.index_columns col_ic ON col_i.object_id = col_ic.object_id AND col_i.index_id = col_ic.index_id
                                INNER JOIN sys.columns col_c ON col_ic.object_id = col_c.object_id AND col_ic.column_id = col_c.column_id
                            WHERE col_ic.is_included_column = 1
                                AND col_i.object_id = i.object_id
                                AND col_i.index_id = i.index_id
                            ORDER BY col_ic.key_ordinal
                            FOR XML PATH(N'')
                            ),1,2,N'')
                        ) + N')'
                    ELSE N''
                    END +
                    CASE WHEN i.has_filter = 1 THEN N' WHERE ' + i.filter_definition ELSE N'' END +
                    N'    WITH (' + 
                    CASE WHEN NOT(i.is_primary_key = 1 AND i.type = 2) THEN N'DROP_EXISTING = ON, ' ELSE N'' END + 
                    CASE WHEN i.fill_factor > 0 AND i.fill_factor < 100 THEN N'FILLFACTOR = ' + CONVERT(NVARCHAR(3), i.fill_factor) + N', ' ELSE N'' END +
                    N'PAD_INDEX = ' + CASE WHEN i.is_padded = 1 THEN N'ON' ELSE N'OFF' END + N', ' +
                    N'IGNORE_DUP_KEY = ' + CASE WHEN i.ignore_dup_key = 1 THEN N'ON' ELSE N'OFF' END + N', ' +
                    CASE WHEN NOT(i.is_primary_key = 1 AND i.type = 2) THEN N'ONLINE = ' + CASE WHEN @OnlineOption = 1 THEN N'ON' ELSE N'OFF' END + N', ' ELSE N'' END +
                    N'ALLOW_ROW_LOCKS = ' + CASE WHEN i.allow_row_locks = 1 THEN N'ON' ELSE N'OFF' END + N', ' +
                    N'ALLOW_PAGE_LOCKS = ' + CASE WHEN i.allow_page_locks = 1 THEN N'ON' ELSE N'OFF' END + N', ' +
                    N'DATA_COMPRESSION = ' + p.data_compression_desc +
                    N') ON ' +
                    N'[' + @NewFileGroupName + N'];'
                
                    + CASE WHEN i.is_primary_key = 1 AND i.type = 2
                    THEN N'
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
    END CATCH'
                ELSE
                    N'
    '
                    END
                FROM sys.indexes i
                    INNER JOIN sys.objects o ON i.object_id = o.object_id
                    INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
                    INNER JOIN sys.data_spaces ds ON i.data_space_id = ds.data_space_id
                    INNER JOIN sys.partitions p ON o.object_id = p.object_id AND i.index_id = p.index_id
                WHERE o.type = 'U' /* USER_TABLE */
                    AND i.type = @IndexType
                    AND o.is_ms_shipped = 0
                    AND ds.name = @OldFileGroupName
                    --AND i.name = 'AcisC5ModuleLaunc3'
                ORDER BY o.name, i.name;
            END
            IF @cmd = N''
            BEGIN
                SET @msg = N'Warning: no indexes found on ' + @OldFileGroupName + N'!';
                THROW 50000, @msg, 3;
            END
            ELSE
            BEGIN
                RAISERROR (@cmd, 0, 1) WITH NOWAIT;
                IF @DebugOnly = 0
                BEGIN
                    EXEC sp_executesql @cmd;
                END
            END
        END
        ELSE
        BEGIN
            SET @msg = N'ERROR: ' + @NewFileGroupName + N' does not exist!';
            THROW 50000, @msg, 2;
        END
    END
    ELSE
    BEGIN
        SET @msg = 'ERROR: ' + @OldFileGroupName + N' does not exist!';
        THROW 50000, @msg, 2;
    END
END
GO

-- Executando --

/* move heaps from PRIMARY to fgdata01 */
EXEC dbo.MoveDataToCustomFilegroups @IndexType = 0
         , @OldFileGroupName = 'PRIMARY'
         , @NewFileGroupName = 'fgdata01';

/* move Clustered Indexes from PRIMARY to fgdata01 */
EXEC dbo.MoveDataToCustomFilegroups @IndexType = 1
         , @OldFileGroupName = 'PRIMARY'
         , @NewFileGroupName = 'fgdata01';

/* Non-Clustered Indexes from PRIMARY to fgindex01 */
EXEC dbo.MoveDataToCustomFilegroups @IndexType = 2
         , @OldFileGroupName = 'PRIMARY'
         , @NewFileGroupName = 'fgindex01';

/* Non-Clustered Indexes fgdata01 to fgindex01 */
EXEC dbo.MoveDataToCustomFilegroups @IndexType = 2
         , @OldFileGroupName = 'fgdata01'
         , @NewFileGroupName = 'fgindex01';
GO

/* drop the stored procedure */
DROP PROCEDURE dbo.MoveDataToCustomFilegroups;