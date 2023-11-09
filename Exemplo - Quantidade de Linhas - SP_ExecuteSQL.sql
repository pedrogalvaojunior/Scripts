DECLARE @TableName	VARCHAR(100)
DECLARE @varSQL		NVARCHAR(4000)
DECLARE @iCount		INT

SET		@TableName = 'TimeZones'
SET		@varSQL = 'SELECT TOP 1 @iCountOut = rows FROM sys.partitions where object_id = ' + CAST(object_id(@TableName) AS VARCHAR(100))

EXECUTE sp_ExecuteSQL @varSQL, N'@iCountOut INT OUTPUT', @iCountOut = @iCount OUTPUT
SELECT	@iCount