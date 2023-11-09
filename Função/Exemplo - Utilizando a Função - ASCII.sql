SET TEXTSIZE 0
-- Create variables for the character string and for the current 
-- position in the string.
DECLARE @position int, @string char(8)
-- Initialize the current position and the string variables.
SET @position = 1
SET @string = 'New Moon '
WHILE @position <= DATALENGTH(@string)
   BEGIN
   SELECT ASCII(SUBSTRING(@string, @position, 1)) As 'Código ASCII', 
      CHAR(ASCII(SUBSTRING(@string, @position, 1))) As 'Caracter Correspondente'
   SET @position = @position + 1
   END
GO


DECLARE @a varchar(10)
SELECT @a = 'a'+char(10)+'b'+char(13)+'c'
SELECT @a AS Original, REPLACE(REPLACE(@a, char(10), '*'), char(13), '*') AS New


SELECT @a AS Original, REPLACE(REPLACE(cast(@a as varchar(max)), char(10), '*'), char(13), '*') AS New
