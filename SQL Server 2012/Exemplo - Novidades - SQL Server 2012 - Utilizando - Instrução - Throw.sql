Use TempDB
GO

-- Exemplo 1 --
CREATE TABLE ErrorHistory
(ErrorTime   DATETIME,
 ErrorSeverityLevel  VARCHAR(100),
 ErrorMessage   VARCHAR(1000))
GO

BEGIN TRY
 DECLARE @TryDivision int = 10/0
END TRY
BEGIN CATCH
 
 /* Insert Error Information & Then Re-Throw the error message received */
 INSERT INTO ErrorHistory VALUES(GETDATE(), ERROR_SEVERITY(), ERROR_MESSAGE());

 THROW;

END CATCH
GO

SELECT * FROM ErrorHistory
GO

-- Exemplo 2 --
CREATE TABLE dbo.TestRethrow
(ID INT PRIMARY KEY)

BEGIN TRY
    INSERT dbo.TestRethrow(ID) VALUES(1);
--  Force error 2627, Violation of PRIMARY KEY constraint to be raised.
    INSERT dbo.TestRethrow(ID) VALUES(1);
END TRY
BEGIN CATCH

    PRINT 'In catch block.';
    THROW;
END CATCH;


-- Exemplo 3 --
DECLARE @msg NVARCHAR(2048) = FORMATMESSAGE(60000, 500, N'First string', N'second string'); 

THROW 60000, @msg, 1; 