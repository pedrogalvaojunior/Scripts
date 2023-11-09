CREATE PROCEDURE dbo.ShowDecrypted(@ProcName SYSNAME = NULL)
AS
--Jon Gurgul 27/09/2010
--Adapted idea/code from shoeboy/joseph gama
SET NOCOUNT ON
IF EXISTS 
(
SELECT * FROM sys.dm_exec_connections ec JOIN sys.endpoints e 
on (ec.[endpoint_id]=e.[endpoint_id]) 
WHERE e.[name]='Dedicated Admin Connection' 
AND ec.[session_id] = @@SPID
)
	BEGIN

	DECLARE @i BIGINT,@a NVARCHAR(MAX),@b NVARCHAR(MAX),@d NVARCHAR(MAX),@c NVARCHAR(MAX)
	SET @a=(SELECT [imageval] FROM [sys].[sysobjvalues] WHERE [objid] = OBJECT_ID(@ProcName) and [valclass] = 1 and [subobjid] = 1)
	SET @b='ALTER PROCEDURE '+ @ProcName +' WITH ENCRYPTION AS '+REPLICATE('-', 8000)

		BEGIN TRANSACTION
			EXECUTE (@b)
			SET @c=(SELECT [imageval] FROM [sys].[sysobjvalues] WHERE [objid] = OBJECT_ID(@ProcName) and [valclass] = 1 and [subobjid] = 1)	
		ROLLBACK TRANSACTION

	SET @d = REPLICATE(N'A', (DATALENGTH(@a) /2 ))
	SET @i=1
	WHILE @i<=(DATALENGTH(@a)/2)
	BEGIN
	SET @d = STUFF(@d, @i, 1,NCHAR(UNICODE(SUBSTRING(@a, @i, 1)) ^(UNICODE(SUBSTRING('CREATE PROCEDURE '+ @ProcName +' WITH ENCRYPTION AS ' + REPLICATE('-', 8000), @i, 1)) ^UNICODE(SUBSTRING(@c, @i, 1)))))
	SET @i=@i+1
	END

	SELECT @d [StoredProcedure]

	END
	ELSE
	BEGIN
		PRINT 'Use a DAC Connection'
	END

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


Exec ShowDecrypted '[dbo].[PD_D_BU]'

Exec sp_configure 'show advanced options',1
Reconfigure With Override

sp_configure

Exec sp_configure 'Dedicated Admin Connection',1
Reconfigure With Override