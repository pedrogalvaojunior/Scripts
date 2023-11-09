CREATE DATABASE [Crack_Me];
GO

USE Crack_Me;
GO

CREATE TABLE [dbo].[Crack_Me_If_You_Can]
(
 [ID] [int] PRIMARY KEY IDENTITY NOT NULL,
 [Insert_Date] [datetime] NOT NULL,
 [Some_Data] [varchar](100) NOT NULL,
 [Optional_Data] [varchar](50)NULL,
 [Life_the_Universe_and_Everything] [int] NOT NULL,
);
GO

INSERT INTO [Crack_Me_If_You_Can] (Insert_Date, Some_Data, Optional_Data, Life_the_Universe_and_Everything)
VALUES (GetDate(), 'Don''t Panic', 'Share and Enjoy', 42);
GO

SELECT * FROM Crack_Me_If_You_Can;

SELECT * FROM fn_dblog(NULL, NULL)

USE Crack_Me;
GO

SELECT allocunits.allocation_unit_id, 
             objects.name, 
             objects.id
FROM sys.allocation_units allocunits INNER JOIN sys.partitions partitions 
                                                                  ON (allocunits.type IN (1, 3) AND partitions.hobt_id = allocunits.container_id)
                                                                  OR (allocunits.type = 2 and partitions.partition_id = allocunits.container_id)
                                                                 INNER JOIN sysobjects objects 
                                                                  ON partitions.object_id = objects.id
																AND objects.type IN ('U', 'u')
WHERE partitions.index_id IN (0, 1)

SELECT * FROM fn_dblog(NULL, NULL)
WHERE AllocUnitId = 72057594039697408
AND Operation = 'LOP_INSERT_ROWS'

DBCC TRACEON(2537)

SELECT [Current LSN], 
			 Operation,
             dblog.[Transaction ID],
             AllocUnitId,
             AllocUnitName,
             [Page ID],
             [Slot ID],
             [Num Elements],
             dblog1.[Begin Time],
             dblog1.[Transaction Name],
             [RowLog Contents 0],
             [Log Record]
FROM ::fn_dblog(NULL, NULL) dblog
 INNER JOIN 
 ( 
 SELECT allocunits.allocation_unit_id, 
              objects.name, 
              objects.id
 FROM sys.allocation_units allocunits INNER JOIN sys.partitions partitions 
                                                                   ON (allocunits.type IN (1, 3) 
                                                                   AND partitions.hobt_id = allocunits.container_id) 
																   OR (allocunits.type = 2 and partitions.partition_id = allocunits.container_id) 
                                                                  INNER JOIN sysobjects objects 
                                                                   ON partitions.object_id = objects.id
                                                                   AND objects.type IN ('U', 'u')
 WHERE partitions.index_id IN (0, 1)) allocunits 
                                                                  ON dblog.AllocUnitID = allocunits.allocation_unit_id 
 INNER JOIN 
 (
 SELECT [Begin Time],
              [Transaction Name],
              [Transaction ID]
 FROM fn_dblog(NULL, NULL) x
 WHERE Operation = 'LOP_BEGIN_XACT' ) dblog1 
                                                                         ON dblog1.[Transaction ID] = dblog.[Transaction ID]
 WHERE [Page ID] IS NOT NULL AND [Slot ID] >= 0
 AND dblog.[Transaction ID] != '0000:00000000' 
 AND Context in ('LCX_HEAP', 'LCX_CLUSTERED')

DBCC TRACEOFF(2537)

-- Exploring the Page --
DECLARE @pageID$ NVARCHAR(23), 
                @pageID NVARCHAR(50), 
                @sqlCmd NVARCHAR(4000);

SET @pageID$ = '0001:00000093'

SELECT @pageID = CONVERT(VARCHAR(4), CONVERT(INT, CONVERT(VARBINARY,SUBSTRING(@pageID$, 0, 5), 2)))
             + ',' + CONVERT(VARCHAR(8), CONVERT(INT, CONVERT(VARBINARY,SUBSTRING(@pageID$, 6, 8), 2)))

SET @sqlCmd = 'DBCC PAGE (''Crack_Me'',' + @pageID + ',3) WITH TABLERESULTS'

EXECUTE(@sqlCmd)

DECLARE @RowLogContents VARBINARY(8000)
SET @RowLogContents = 0x3000140001000000E10CF400EA9D00002A000000050000020028003700446F6E27742050616E6963536861726520616E6420456E6A6F79

DECLARE @lenFixedBytes SMALLINT, 
                @noOfCols SMALLINT, 
                @nullBitMapLength SMALLINT, 
                @nullByteMap VARBINARY(MAX), 
                @nullBitMap VARCHAR(MAX), 
                @noVarCols SMALLINT, 
                @columnOffsetArray VARBINARY(MAX), 
                @varColPointer SMALLINT

SELECT 
 @lenFixedBytes = CONVERT(SMALLINT, CONVERT(BINARY(2), REVERSE(SUBSTRING(@RowLogContents, 2 + 1, 2)))),
 @noOfCols = CONVERT(INT, CONVERT(BINARY(2), REVERSE(SUBSTRING(@RowLogContents, @lenFixedBytes + 1, 2)))),
 @nullBitMapLength = CONVERT(INT, ceiling(@noOfCols/8.0)),
 @nullByteMap = SUBSTRING(@RowLogContents, @lenFixedBytes + 3, @nullBitMapLength),
 @noVarCols = CASE WHEN SUBSTRING(@RowLogContents, 1, 1) = 0x30 THEN
 CONVERT(INT, CONVERT(BINARY(2), REVERSE(SUBSTRING(@RowLogContents, @lenFixedBytes + 3 + @nullBitMapLength, 2))))
 ELSE null
 END, 
 @columnOffsetArray = CASE WHEN SUBSTRING(@RowLogContents, 1, 1) = 0x30 THEN
 SUBSTRING(@RowLogContents, @lenFixedBytes + 3 + @nullBitMapLength + 2, @noVarCols * 2)
 ELSE null
 END,
 @varColPointer = CASE WHEN SUBSTRING(@RowLogContents, 1, 1) = 0x30 THEN 
 (@lenFixedBytes + 2 + @nullBitMapLength + 2 + (@noVarCols * 2))
 ELSE null
 END

DECLARE @byteTable TABLE
(
 byte INT
)

DECLARE @cnt INT 

SET @cnt = 1

WHILE (@cnt < @nullBitMapLength + 1)
BEGIN

 INSERT INTO @byteTable(byte)
 VALUES(@cnt)

 SET @cnt = @cnt +1
END

SELECT 
 @nullBitMap = COALESCE(@nullBitMap, '') + 
 CONVERT(NVARCHAR(1), (SUBSTRING(@nullByteMap, byte, 1) / 128) % 2) + 
 CONVERT(NVARCHAR(1), (SUBSTRING(@nullByteMap, byte, 1) / 64) % 2) +
 CONVERT(NVARCHAR(1), (SUBSTRING(@nullByteMap, byte, 1) / 32) % 2) +
 CONVERT(NVARCHAR(1), (SUBSTRING(@nullByteMap, byte, 1) / 16) % 2) +
 CONVERT(NVARCHAR(1), (SUBSTRING(@nullByteMap, byte, 1) / 8) % 2) +
 CONVERT(NVARCHAR(1), (SUBSTRING(@nullByteMap, byte, 1) / 4) % 2) +
 CONVERT(NVARCHAR(1), (SUBSTRING(@nullByteMap, byte, 1) / 2) % 2) +
 CONVERT(NVARCHAR(1), SUBSTRING(@nullByteMap, byte, 1) % 2) 
FROM @byteTable b 
ORDER BY byte DESC

SELECT 
 SUBSTRING(@RowLogContents, 2 + 1, 2) AS lenFixedBytes,
 SUBSTRING(@RowLogContents, @lenFixedBytes + 1, 2) AS noOfCols,
 SUBSTRING(@RowLogContents, @lenFixedBytes + 3, @nullBitMapLength) AS nullByteMap,
 SUBSTRING(@RowLogContents, @lenFixedBytes + 3 + @nullBitMapLength, 2) AS noVarCols,
 SUBSTRING(@RowLogContents, @lenFixedBytes + 3 + @nullBitMapLength + 2, @noVarCols * 2) AS columnOffsetArray,
 @lenFixedBytes + 2 + @nullBitMapLength + 2 + (@noVarCols * 2) AS varColStart

SELECT 
 @lenFixedBytes AS lenFixedBytes, 
 @noOfCols AS noOfCols, 
 @nullBitMapLength AS nullBitMapLength,
 @nullByteMap AS nullByteMap,
 @nullBitMap AS nullBitMap,
 @noVarCols AS noVarCols,
 @columnOffsetArray AS columnOffsetArray,
 @varColPointer AS varColStart

DECLARE @colOffsetTable TABLE
(
 colNum SMALLINT,
 columnOffset VARBINARY(2),
 columnOffvalue SMALLINT,
 columnLength SMALLINT
)

SET @cnt = 1

WHILE (@cnt <= @noVarCols)
BEGIN

 INSERT INTO @colOffsetTable(colNum, columnOffset, columnOffValue, columnLength)
 VALUES(@cnt * - 1, SUBSTRING (@columnOffsetArray, (2 * @cnt) - 1, 2), 
                                   CONVERT(SMALLINT, CONVERT(BINARY(2), REVERSE (SUBSTRING (@columnOffsetArray, (2 * @cnt) - 1, 2)))), 
                                   CONVERT(SMALLINT, CONVERT(BINARY(2), REVERSE (SUBSTRING (@columnOffsetArray, (2 * @cnt) - 1, 2))))
                                   - ISNULL(NULLIF(CONVERT(SMALLINT, CONVERT(BINARY(2), REVERSE (SUBSTRING (@columnOffsetArray, (2 * (@cnt - 1)) - 1, 2)))), 0), @varColPointer))
 
 SET @cnt = @cnt + 1
END

SELECT * FROM @colOffsetTable

SELECT cols.leaf_null_bit AS nullbit,
             ISNULL(syscolumns.length, cols.max_length) AS [length],
             CASE WHEN is_uniqueifier = 1 THEN 'UNIQUIFIER' ELSE ISNULL(syscolumns.name, 'DROPPED') END [name],
             cols.system_type_id,
             cols.leaf_bit_position AS bitpos,
             ISNULL(syscolumns.xprec, cols.precision) AS xprec,
             ISNULL(syscolumns.xscale, cols.scale) AS xscale,
             cols.leaf_offset,
             is_uniqueifier
FROM sys.allocation_units allocunits INNER JOIN sys.partitions partitions 
                                                                  ON (allocunits.type IN (1, 3)
                                                                  AND partitions.hobt_id = allocunits.container_id) 
                                                                  OR(allocunits.type = 2 AND partitions.partition_id =allocunits.container_id)
                                                                 INNER JOIN sys.system_internals_partition_columns cols 
                                                                  ON cols.partition_id = partitions.partition_id
                                                                 LEFT OUTER JOIN syscolumns 
                                                                  ON syscolumns.id = partitions.object_id
                                                                  AND syscolumns.colid = cols.partition_column_id
WHERE allocunits.allocation_unit_id = 72057594039697408
ORDER BY nullbit


DECLARE @schema TABLE 
(
 [column] INT,
 [length] INT,
 [name] NVARCHAR(255),
 [system_type_id] INT,
 [bitpos] INT,
 [xprec] INT,
 [xscale] INT,
 [leaf_offset] INT,
 [is_uniqueifier] BIT,
 [is_null] BIT NULL
)

INSERT INTO @schema
SELECT cols.leaf_null_bit AS nullbit,
             ISNULL(syscolumns.length, cols.max_length) AS [length], 
            CASE WHEN is_uniqueifier = 1 THEN 'UNIQUIFIER' ELSE isnull(syscolumns.name, 'DROPPED') END [name], 
            cols.system_type_id,
			cols.leaf_bit_position AS bitpos, 
			ISNULL(syscolumns.xprec, cols.precision) AS xprec, 
			ISNULL(syscolumns.xscale, cols.scale) AS xscale,
			cols.leaf_offset,
			is_uniqueifier,
			SUBSTRING(REVERSE(@nullBitMap), cols.leaf_null_bit, 1) AS is_null
FROM sys.allocation_units allocunits INNER JOIN sys.partitions partitions 
																  ON (allocunits.type IN (1, 3) 
																  AND partitions.hobt_id = allocunits.container_id) 
																  OR (allocunits.type = 2 AND partitions.partition_id = allocunits.container_id)
																 INNER JOIN sys.system_internals_partition_columns cols 
																  ON cols.partition_id = partitions.partition_id
																 LEFT OUTER JOIN syscolumns 
																  ON syscolumns.id = partitions.object_id 
																  AND syscolumns.colid = cols.partition_column_id
WHERE allocunits.allocation_unit_id = 72057594039697408
ORDER BY nullbit

INSERT INTO @schema
SELECT -3, 1, 'StatusBitsA', 0, 0, 0, 0, 2147483647, 0, 0

INSERT INTO @schema
SELECT -2, 1, 'StatusBitsB', 0, 0, 0, 0, 2147483647, 0, 0

INSERT INTO @schema
SELECT -1, 2, 'LenFixedBytes', 52, 0, 10, 0, 2147483647, 0, 0

SELECT s.*,
CASE WHEN s.leaf_offset > 1 AND s.bitpos = 0 THEN 
SUBSTRING(@RowLogContents, ISNULL((SELECT TOP 1 SUM(x.length) FROM @schema x WHERE x.[column] < s.[column] AND x.leaf_offset > 1 AND x.bitpos = 0), 0) + 1,s.length)
ELSE
SUBSTRING(@RowLogContents, (col.columnOffValue - col.columnLength) + 1,col.columnLength)
END AS hex_string
FROM @schema s LEFT OUTER JOIN @colOffsetTable col 
                                  ON col.colNum = (s.leaf_offset)

SELECT
 [name] AS ColumnName, 
 CASE WHEN s.is_null = 1 THEN NULL ELSE 
 CASE WHEN s.system_type_id IN (167, 175, 231, 239) THEN LTRIM(RTRIM(CONVERT(NVARCHAR(MAX), REVERSE(REVERSE(REPLACE(hex_string, 0x00, 0x20))))))
           WHEN s.system_type_id = 48 THEN CONVERT(NVARCHAR(MAX), CONVERT(TINYINT, CONVERT(BINARY(1), REVERSE (hex_string))))
           WHEN s.system_type_id = 52 THEN CONVERT(NVARCHAR(MAX), CONVERT(SMALLINT, CONVERT(BINARY(2), REVERSE (hex_string))))
           WHEN s.system_type_id = 56 THEN CONVERT(NVARCHAR(MAX), CONVERT(INT, CONVERT(BINARY(4), REVERSE(hex_string))))
           WHEN s.system_type_id = 127 THEN CONVERT(NVARCHAR(MAX), CONVERT(BIGINT, CONVERT(BINARY(8), REVERSE(hex_string))))
           WHEN s.system_type_id = 61 THEN CONVERT(VARCHAR(MAX), CONVERT(DATETIME, SUBSTRING(hex_string, 4, 1) + SUBSTRING(hex_string, 3, 1) + SUBSTRING(hex_string, 2, 1) + SUBSTRING(hex_string, 1, 1)) + 
                                                                         CONVERT(DATETIME, DATEADD(dd, CONVERT(INT, SUBSTRING(hex_string, 8, 1) + SUBSTRING(hex_string, 7, 1) + SUBSTRING(hex_string, 6, 1) + SUBSTRING(hex_string, 5, 1)), 0x00000000)), 109)
           WHEN s.system_type_id = 108 AND s.xprec = 5 AND s.xscale = 2 THEN CONVERT(VARCHAR(MAX), CONVERT(NUMERIC(5,2), 0x050200 + hex_string))
           WHEN s.system_type_id = 108 AND s.xprec = 6 AND s.xscale = 2 THEN CONVERT(VARCHAR(MAX), CONVERT(NUMERIC(6,2), 0x060200 + hex_string))
           WHEN s.system_type_id = 108 AND s.xprec = 6 AND s.xscale = 3 THEN CONVERT(VARCHAR(MAX), CONVERT(NUMERIC(6,3), 0x060300 + hex_string))
           WHEN s.system_type_id = 108 AND s.xprec = 7 AND s.xscale = 2 THEN CONVERT(VARCHAR(MAX), CONVERT(NUMERIC(7,2), 0x070200 + hex_string))
           WHEN s.system_type_id = 108 AND s.xprec = 8 AND s.xscale = 2 THEN CONVERT(VARCHAR(MAX), CONVERT(NUMERIC(8,2), 0x080200 + hex_string))
           WHEN s.system_type_id = 108 AND s.xprec = 9 AND s.xscale = 2 THEN CONVERT(VARCHAR(MAX), CONVERT(NUMERIC(9,2), 0x090200 + hex_string))
           WHEN s.system_type_id = 108 AND s.xprec = 10 AND s.xscale = 2 THEN CONVERT(VARCHAR(MAX), CONVERT(NUMERIC(10,2), 0x0A0200 + hex_string))
  END
 END AS ClearText
FROM (SELECT s.*,
                         CASE WHEN s.leaf_offset > 1 AND s.bitpos = 0 THEN SUBSTRING(@RowLogContents, ISNULL((SELECT TOP 1 SUM(x.length) FROM @schema x WHERE x.[column] < s.[column] AND x.leaf_offset > 1 AND x.bitpos = 0), 0) + 1, s.LENGTH)
                         ELSE
                          SUBSTRING(@RowLogContents, (col.columnOffValue - col.columnLength) + 1,col.columnLength)
                         END AS hex_string
 FROM @schema s LEFT OUTER JOIN @colOffsetTable col 
                                  ON col.colNum = (s.leaf_offset)) AS s
WHERE [column] > 0 AND is_uniqueifier = 0
