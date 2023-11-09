-- create view for function call
CREATE VIEW vRandom
AS
SELECT randval = CRYPT_GEN_RANDOM (8)
GO


CREATE FUNCTION [dbo].[GenPass]()
RETURNS VARCHAR(8)
AS
BEGIN
   -- Declare the variables here
   DECLARE @Result VARCHAR(8)
   DECLARE @BinaryData VARBINARY(8)
   DECLARE @CharacterData VARCHAR(8)
 
   SELECT @BinaryData = randval
   FROM vRandom
 
   Set @CharacterData=cast ('' as xml).value ('xs:base64Binary(sql:variable("@BinaryData"))',
                   'varchar (max)')
   
   SET @Result = @CharacterData
   
   -- Return the result of the function
   RETURN @Result
END
GO

-- Example Use --
DECLARE @newPass VARCHAR(8)
SELECT @newPass = dbo.GenPass()
PRINT @newPass 
Go

-- Generating and Storing Password --
CREATE TABLE dbo.GenPasswords (
   requestID INT IDENTITY,
   TS DATETIME,
   pass VARCHAR(8)
   )
GO

CREATE PROCEDURE dbo.usp_GenPass @pass VARCHAR(8) = NULL OUTPUT,
   @reqID INT = 0 OUTPUT
AS
BEGIN
   SET NOCOUNT ON;
   SET @pass = dbo.GenPass();
   INSERT INTO dbo.GenPasswords
   VALUES (
      getDate(),
      @pass
      );
   SELECT @reqID = IDENT_CURRENT('GenPasswords');
   SET NOCOUNT OFF;
END
GO

-- Example Use --
DECLARE @p VARCHAR (8)
DECLARE @req INT
EXEC dbo.usp_GenPass @p out, @req out
PRINT @p
PRINT @req 
Go

