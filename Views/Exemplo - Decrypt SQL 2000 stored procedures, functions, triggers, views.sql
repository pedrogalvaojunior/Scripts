/*==================================================================================

NAME:          Decrypt SQL 2000 stored procedures, functions, views, and triggers

DESCRIPTION:            The script below accepts an object (schema name + object name)
                        that were created using the WITH ENCRYPTION option and returns
                        the decrypted script that creates the object. This script
                        is useful to decrypt stored procedures, views, functions,
                        and triggers that were created WITH ENCRYPTION.
                        
                        The algorithm used below is the following:
                        1. Check that the object exists and that it is encrypted.
                        2. In order to decrypt the object, the script ALTER (!!!) it
                        and later restores the object to its original one. This is
                        required as part of the decryption process: The object
                        is altered to contain dummy text (the ALTER uses WITH ENCRYPTION)
                        and then compared to the CREATE statement of the same dummy
                        content. 
                        
                        Note: The object is altered in a transaction, which is rolled
                        back immediately after the object is changed to restore
                        all previous settings.
                        
                        3. A XOR operation between the original binary stream of the
                        enrypted object with the binary representation of the dummy
                        object and the binary version of the object in clear-text
                        is used to decrypt the original object.
					 

USER PARAMETERS:        @ObjectOwnerOrSchema
                        @ObjectName

RESULTSET:              NA

RESULTSET SORT:         NA

USING TABLES/VIEWS:     syscomments

REVISIONS

DATE         DEVELOPER          DESCRIPTION OF REVISION             VERSION
=========    ===============    =================================   ===========
01/01/2007   Omri Bahat         Initial release                     1.00
==================================================================================*/

DECLARE @ObjectOwnerOrSchema NVARCHAR(128)
DECLARE @ObjectName NVARCHAR(128)

SET @ObjectOwnerOrSchema = 'dbo'
SET @ObjectName = 'myproc2'

DECLARE @i INT
DECLARE @j INT
DECLARE @k INT
DECLARE @ObjectDataLength INT
DECLARE @ContentOfEncryptedObject NVARCHAR(4000)
DECLARE @ContentOfDecryptedObject NVARCHAR(4000)
DECLARE @ContentOfFakeObject NVARCHAR(4000)
DECLARE @ContentOfFakeEncryptedObject NVARCHAR(4000)
DECLARE @ObjectType NVARCHAR(128)
DECLARE @CurrColID INT
DECLARE @CurrDataLength INT
DECLARE @CurrPtr BINARY(16)
DECLARE @CurrOffset INT
DECLARE @tmpStrForExec VARCHAR(8000)
DECLARE @ObjectID INT

SET NOCOUNT ON

SET @ObjectID = OBJECT_ID('[' + @ObjectOwnerOrSchema + '].[' + @ObjectName + ']')

-- Check that the provided object exists in the database.
IF @ObjectID IS NULL
BEGIN
	RAISERROR('The object name or schema provided does not exist in the database', 16, 1)
	RETURN
END

-- Check that the provided object is encrypted.
IF NOT EXISTS(SELECT TOP 1 * FROM syscomments WHERE id = @ObjectID AND encrypted = 1)
BEGIN
	RAISERROR('The object provided exists however it is not encrypted. Aborting.', 16, 1)
	RETURN
END

-- Determine the type of the object
IF OBJECT_ID('[' + @ObjectOwnerOrSchema + '].[' + @ObjectName + ']', 'PROCEDURE') IS NOT NULL
	SET @ObjectType = 'PROCEDURE'
ELSE
	IF OBJECT_ID('[' + @ObjectOwnerOrSchema + '].[' + @ObjectName + ']', 'TRIGGER') IS NOT NULL
		SET @ObjectType = 'TRIGGER'
	ELSE
		IF OBJECT_ID('[' + @ObjectOwnerOrSchema + '].[' + @ObjectName + ']', 'VIEW') IS NOT NULL
			SET @ObjectType = 'VIEW'
		ELSE
			SET @ObjectType = 'FUNCTION'


SELECT @ObjectDataLength = SUM(DATALENGTH(ctext)/2)
FROM syscomments
WHERE id = OBJECT_ID('[' + REPLACE(@ObjectOwnerOrSchema, '''', '''''') + '].[' + REPLACE(@ObjectName, '''', '''''') + ']')

IF @ObjectDataLength < 4000
BEGIN
        SELECT TOP 1 @ContentOfEncryptedObject = ctext
        FROM syscomments
        WHERE id = OBJECT_ID('[' + REPLACE(@ObjectOwnerOrSchema, '''', '''''') + '].[' + REPLACE(@ObjectName, '''', '''''') + ']')

        
        -- We need to alter the existing object in order to decrypt its content.
        -- This is done in a transaction (which we later rollback) in order to make sure
        -- that the underlying object is not impacted.
        
        SET @ContentOfFakeObject = N'ALTER ' + @ObjectType + N' [' + @ObjectOwnerOrSchema + N'].[' + @ObjectName + N'] WITH ENCRYPTION AS'
        SET @ContentOfFakeObject = @ContentOfFakeObject + REPLICATE(N'-', @ObjectDataLength - (DATALENGTH(@ContentOfFakeObject)/2))
        
        
        -- Since we need to alter the object in order to decrypt it, this is done
        -- in a transaction
        BEGIN TRAN
        
        EXEC(@ContentOfFakeObject)
        
        -- Get the encrypted content of the new "fake" object.
        SELECT TOP 1 @ContentOfFakeEncryptedObject = ctext
        FROM syscomments
        WHERE id = OBJECT_ID('[' + REPLACE(@ObjectOwnerOrSchema, '''', '''''') + '].[' + REPLACE(@ObjectName, '''', '''''') + ']')
        
        IF @@TRANCOUNT > 0
                ROLLBACK TRAN
        
        SET @ContentOfFakeObject = N'CREATE ' + @ObjectType + N' [' + @ObjectOwnerOrSchema + N'].[' + @ObjectName + N'] WITH ENCRYPTION AS'
        SET @ContentOfFakeObject = @ContentOfFakeObject + REPLICATE(N'-', @ObjectDataLength - (DATALENGTH(@ContentOfFakeObject)/2))
        

        SET @i = 1
        
        --Fill the variable that holds the decrypted data with a filler character
        SET @ContentOfDecryptedObject = N''
        SET @ContentOfDecryptedObject = @ContentOfDecryptedObject + REPLICATE(N'A', @ObjectDataLength - (DATALENGTH(@ContentOfDecryptedObject)/2))        

        -- Decrypt one character at a time
        WHILE @i <= @ObjectDataLength
        BEGIN
                --xor real & fake & fake encrypted
                SET @ContentOfDecryptedObject = STUFF(@ContentOfDecryptedObject, @i, 1,
                        NCHAR(  UNICODE(SUBSTRING(@ContentOfEncryptedObject, @i, 1)) ^
                                (       UNICODE(SUBSTRING(@ContentOfFakeObject, @i, 1)) ^
                                        UNICODE(SUBSTRING(@ContentOfFakeEncryptedObject, @i, 1))
                                )))
        
                SET @i = @i + 1
        END
        
        /* debug */
        SELECT @ContentOfDecryptedObject
END -- IF @ObjectDataLength < 4000
ELSE
BEGIN
        -- create this table to hold the encrypted and decrypted data
        IF OBJECT_ID('tempdb..#tblTemp') IS NOT NULL
                DROP TABLE #tblTemp
        
        CREATE TABLE #tblTemp (
                Idx INT IDENTITY(1, 1) PRIMARY KEY CLUSTERED,
                ContentOfEncryptedObject NTEXT,
                ContentOfDecryptedObject NTEXT,
                ContentOfFakeObject NTEXT,
                ContentOfFakeEncryptedObject NTEXT)

        -- Generate the first line
        INSERT INTO #tblTemp (ContentOfEncryptedObject)
        VALUES(N'')

        -- Get ContentOfEncryptedObject
        SELECT @CurrColID = MIN(colid)
        FROM syscomments
        WHERE id = OBJECT_ID('[' + REPLACE(@ObjectOwnerOrSchema, '''', '''''') + '].[' + REPLACE(@ObjectName, '''', '''''') + ']')

        WHILE @CurrColID IS NOT NULL
        BEGIN
                SET @ContentOfEncryptedObject = NULL

                SELECT @ContentOfEncryptedObject = ctext
                FROM syscomments
                WHERE id = OBJECT_ID('[' + REPLACE(@ObjectOwnerOrSchema, '''', '''''') + '].[' + REPLACE(@ObjectName, '''', '''''') + ']')
                        AND colid = @CurrColID

                SELECT  @CurrPtr = TEXTPTR(ContentOfEncryptedObject),
                        @CurrDataLength = ISNULL(DATALENGTH(ContentOfEncryptedObject), 0)
                FROM #tblTemp
                WHERE Idx = 1
                
                IF @CurrDataLength = 0
                BEGIN
                        UPDATE #tblTemp
                        SET ContentOfEncryptedObject = @ContentOfEncryptedObject
                        WHERE Idx = 1
                END
                ELSE
                BEGIN
                        SET @CurrOffset = NULL
                        UPDATETEXT #tblTemp.ContentOfEncryptedObject @CurrPtr @CurrOffset 0 @ContentOfEncryptedObject
                END
                
                SELECT @CurrColID = MIN(colid)
                FROM syscomments
                WHERE id = OBJECT_ID('[' + REPLACE(@ObjectOwnerOrSchema, '''', '''''') + '].[' + REPLACE(@ObjectName, '''', '''''') + ']')
                        AND colid > @CurrColID
        END
                        
        -- We need to alter the existing object in order to decrypt its content.

        SET @ContentOfFakeObject = N'ALTER ' + @ObjectType + N' [' + @ObjectOwnerOrSchema + N'].[' + @ObjectName + N'] WITH ENCRYPTION AS'
        -- SET @ContentOfFakeObject = N'ALTER ' + @ObjectType + N' ' + @ObjectName + N' WITH ENCRYPTION AS'
        
        UPDATE #tblTemp
        SET ContentOfFakeObject = @ContentOfFakeObject
        WHERE Idx = 1
        
        SELECT  @CurrPtr = TEXTPTR(ContentOfFakeObject),
                @CurrDataLength = ISNULL(DATALENGTH(ContentOfFakeObject)/2, 0)
        FROM #tblTemp WHERE Idx = 1

        WHILE @CurrDataLength < @ObjectDataLength
        BEGIN
                SET @CurrOffset = NULL
                
                IF @CurrDataLength + 4000 < @ObjectDataLength
                        SET @ContentOfFakeObject = REPLICATE(N'-', 4000)
                ELSE
                        SET @ContentOfFakeObject = REPLICATE(N'-', @ObjectDataLength - @CurrDataLength)

                UPDATETEXT #tblTemp.ContentOfFakeObject @CurrPtr @CurrOffset 0 @ContentOfFakeObject

                SELECT  @CurrPtr = TEXTPTR(ContentOfFakeObject),
                        @CurrDataLength = ISNULL(DATALENGTH(ContentOfFakeObject)/2, 0)
                FROM #tblTemp WHERE Idx = 1
        END

        -- Now we need to alter the object in order to decrypt it.
        -- This is done in a transaction.
        
        SET @tmpStrForExec = ''
        
        SELECT @j = CEILING(CAST(DATALENGTH(ContentOfFakeObject) AS DECIMAL(18, 0))/(2*2000))
        FROM #tblTemp
        WHERE Idx = 1

        SET @i = 1
        
        WHILE @i <= @j
        BEGIN
                SET @tmpStrForExec = @tmpStrForExec +
                        'DECLARE @ContentOfDecryptedObject' + CAST(@i-1 AS VARCHAR(32)) + ' NVARCHAR(4000) ' + CHAR(10) + CHAR(13)
                        + 'SELECT @ContentOfDecryptedObject' + CAST(@i-1 AS VARCHAR(32)) + ' = SUBSTRING(ContentOfFakeObject, 1 + (' + CAST(@i-1 AS VARCHAR(32)) + '*2000), 2000) FROM #tblTemp WHERE Idx = 1' + CHAR(10) + CHAR(13)
                        + 'SET @ContentOfDecryptedObject' + CAST(@i-1 AS VARCHAR(32)) + ' = REPLACE(@ContentOfDecryptedObject' + CAST(@i-1 AS VARCHAR(32)) + ', '''''''', '''''''''''') ' + CHAR(10) + CHAR(13)

                SET @i = @i + 1
        END

        SET @tmpStrForExec = @tmpStrForExec + 'EXEC('
        SET @i = 1
        
        WHILE @i <= @j
        BEGIN
                IF @i < @j
                        SET @tmpStrForExec = @tmpStrForExec + '@ContentOfDecryptedObject' + CAST(@i-1 AS VARCHAR(32)) + ' + '
                ELSE
                        SET @tmpStrForExec = @tmpStrForExec + '@ContentOfDecryptedObject' + CAST(@i-1 AS VARCHAR(32)) + ')'

                SET @i = @i + 1
        END
        
        SET XACT_ABORT OFF
        BEGIN TRAN
        
        /* debug */
        -- PRINT(@tmpStrForExec)

        EXEC(@tmpStrForExec)
        
        IF @@ERROR <> 0
                ROLLBACK TRAN

        -- Get ContentOfFakeEncryptedObject
        SELECT @CurrColID = MIN(colid)
        FROM syscomments
        WHERE id = OBJECT_ID('[' + REPLACE(@ObjectOwnerOrSchema, '''', '''''') + '].[' + REPLACE(@ObjectName, '''', '''''') + ']')

        WHILE @CurrColID IS NOT NULL
        BEGIN
                SET @ContentOfFakeEncryptedObject = NULL
                SET @CurrOffset = NULL

                SELECT @ContentOfFakeEncryptedObject = ctext
                FROM syscomments
                WHERE id = OBJECT_ID('[' + REPLACE(@ObjectOwnerOrSchema, '''', '''''') + '].[' + REPLACE(@ObjectName, '''', '''''') + ']')
                        AND colid = @CurrColID

                SELECT  @CurrPtr = TEXTPTR(ContentOfFakeEncryptedObject),
                        @CurrDataLength = ISNULL(DATALENGTH(ContentOfFakeEncryptedObject), 0)
                FROM #tblTemp
                WHERE Idx = 1

                IF @CurrDataLength = 0
                BEGIN
                        UPDATE #tblTemp
                        SET ContentOfFakeEncryptedObject = @ContentOfFakeEncryptedObject
                        WHERE Idx = 1
                END
                ELSE
                BEGIN
                        SET @CurrOffset = NULL
                        UPDATETEXT #tblTemp.ContentOfFakeEncryptedObject @CurrPtr @CurrOffset 0 @ContentOfFakeEncryptedObject
                END
                
                SELECT @CurrColID = MIN(colid)
                FROM syscomments
                WHERE id = OBJECT_ID('[' + REPLACE(@ObjectOwnerOrSchema, '''', '''''') + '].[' + REPLACE(@ObjectName, '''', '''''') + ']')
                        AND colid > @CurrColID
        END
        
               

        -- Get ContentOfFakeObject - the CREATE version
        SET @CurrOffset = 0

        SELECT @CurrPtr = TEXTPTR(ContentOfFakeObject)
        FROM #tblTemp
        WHERE Idx = 1
        
        UPDATETEXT #tblTemp.ContentOfFakeObject @CurrPtr @CurrOffset 6 'CREATE '

        -- Prepopulate @ContentOfDecryptedObject
        SET @ContentOfDecryptedObject = REPLICATE(N'A', 4000)

        -- Decrypt the object
        SET @i = 1
        SET @j = 1

        SELECT  @ContentOfEncryptedObject = SUBSTRING(ContentOfEncryptedObject, (@j - 1)*4000 + 1, 4000),
                @ContentOfFakeObject = SUBSTRING(ContentOfFakeObject, (@j - 1)*4000 + 1, 4000),
                @ContentOfFakeEncryptedObject = SUBSTRING(ContentOfFakeEncryptedObject, (@j - 1)*4000 + 1, 4000)
        FROM #tblTemp
        WHERE Idx = 1

        -- Decrypt one character at a time
        WHILE @i <= @ObjectDataLength
        BEGIN

                -- We need @k since the index in STUFF is between 0 to 4K
                SET @k = @i - ((@j-1)*4000)

                --xor real & fake & fake encrypted
                SET @ContentOfDecryptedObject = STUFF(@ContentOfDecryptedObject, @k, 1,
                        NCHAR(  UNICODE(SUBSTRING(@ContentOfEncryptedObject, @k, 1)) ^
                                (       UNICODE(SUBSTRING(@ContentOfFakeObject, @k, 1)) ^
                                        UNICODE(SUBSTRING(@ContentOfFakeEncryptedObject, @k, 1))
                                )))
                                

                -- Here we write to the temp table. We need to write in one of two cases:
                -- 1. We reached 4K chars in @ContentOfDecryptedObject.
                -- 2. We're about to exit the loop and condition #1 is not met.
                IF (@i = (@j*4000)) OR ( (@i <> (@j*4000)) AND @i = @ObjectDataLength)
                BEGIN
                        SELECT  @CurrPtr = TEXTPTR(ContentOfDecryptedObject),
                                @CurrDataLength = ISNULL((DATALENGTH(ContentOfDecryptedObject)/2), 0)
                        FROM #tblTemp
                        WHERE Idx = 1
                        
                        SET @CurrOffset = NULL
                        
                        IF @CurrDataLength = 0
                                UPDATE #tblTemp
                                SET ContentOfDecryptedObject = @ContentOfDecryptedObject
                                WHERE Idx = 1
                        ELSE
                                UPDATETEXT #tblTemp.ContentOfDecryptedObject @CurrPtr @CurrOffset 0 @ContentOfDecryptedObject

                        -- This is the data length after the last write-operation.
                        SET @CurrDataLength = @CurrDataLength + (DATALENGTH(@ContentOfDecryptedObject)/2)

                        IF @CurrDataLength + 4000 < @ObjectDataLength
                                SET @ContentOfDecryptedObject = REPLICATE(N'-', 4000)
                        ELSE
                                SET @ContentOfDecryptedObject = REPLICATE(N'-', @ObjectDataLength - @CurrDataLength)

                        SET @j = @j + 1

                        SELECT  @ContentOfEncryptedObject = SUBSTRING(ContentOfEncryptedObject, (@j - 1)*4000 + 1, 4000),
                                @ContentOfFakeObject = SUBSTRING(ContentOfFakeObject, (@j - 1)*4000 + 1, 4000),
                                @ContentOfFakeEncryptedObject = SUBSTRING(ContentOfFakeEncryptedObject, (@j - 1)*4000 + 1, 4000)
                        FROM #tblTemp
                        WHERE Idx = 1
                END

                SET @i = @i + 1
        END

        /* debug */
        -- SELECT * FROM #tblTemp

        -- Before rolling back the transaction, we need to store the content of @ContentOfDecryptedObject
        -- in NVARCHAR(4K) variables, then rollback, and then update another temp table with the content
        -- of these variables.

        DECLARE @tblBypassTransaction TABLE (Idx INT IDENTITY(1, 1), ContentOfDecryptedObject NVARCHAR(4000))
        
        SELECT @j = CEILING(CAST(DATALENGTH(ContentOfDecryptedObject) AS DECIMAL(18, 0))/(2*4000))
        FROM #tblTemp
        WHERE Idx = 1

        SET @i = 1
        
        WHILE @i <= @j
        BEGIN
                INSERT INTO @tblBypassTransaction (ContentOfDecryptedObject)
                SELECT SUBSTRING(ContentOfDecryptedObject, 1 + (@i-1)*4000, 4000)
                FROM #tblTemp WHERE Idx = 1

                SET @i = @i + 1
        END

        IF @@TRANCOUNT > 0
                ROLLBACK TRAN

        -- This is the content of the descrypted object.
        -- We use a table variable and not temp table since temp tables
        -- would be rolled back in the last ROLLBACK TRAN statement.
        SELECT * FROM @tblBypassTransaction
END -- IF @ObjectDataLength > 4000


