DECLARE @string VARCHAR(8000), @searchString VARCHAR(100);
SET @string = 'abdceada';
SET @searchString = 'a'
SELECT LEN(@string) - LEN(REPLACE(@string, @searchString, ''));