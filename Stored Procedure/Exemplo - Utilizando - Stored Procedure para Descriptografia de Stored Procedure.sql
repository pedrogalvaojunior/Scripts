Create Procedure Decryptsp2K (@objName varchar(50))
AS
-- INPUT: object name (stored procedure, view or trigger)
DECLARE @a nvarchar(4000), @b nvarchar(4000), @c nvarchar(4000), @d nvarchar(4000), @i int, @t bigint
--get encrypted data
SET @a=(SELECT ctext FROM syscomments WHERE id = object_id(@objName))
SET @b='ALTER PROCEDURE '+ @objName +' WITH ENCRYPTION AS '+REPLICATE('-', 4000-62)
EXECUTE (@b)
--get encrypted bogus SP
SET @c=(SELECT ctext FROM syscomments WHERE id = object_id(@objName))
SET @b='CREATE PROCEDURE '+ @objName +' WITH ENCRYPTION AS '+REPLICATE('-', 4000-62)
--start counter
SET @i=1
--fill temporary variable
SET @d = replicate(N'A', (datalength(@a) / 2))
--loop
WHILE @i<=datalength(@a)/2
BEGIN
--xor original+bogus+bogus encrypted
SET @d = stuff(@d, @i, 1,
NCHAR(UNICODE(substring(@a, @i, 1)) ^
(UNICODE(substring(@b, @i, 1)) ^
UNICODE(substring(@c, @i, 1)))))
SET @i=@i+1
END
--drop original SP
EXECUTE ('drop PROCEDURE '+ @objName)
--remove encryption
--try to preserve case
SET @d=REPLACE((@d),'WITH ENCRYPTION', '')
SET @d=REPLACE((@d),'With Encryption', '')
SET @d=REPLACE((@d),'with encryption', '')
IF CHARINDEX('WITH ENCRYPTION',UPPER(@d) )>0
SET @d=REPLACE(UPPER(@d),'WITH ENCRYPTION', '')
--replace SP
execute( @d)
GO