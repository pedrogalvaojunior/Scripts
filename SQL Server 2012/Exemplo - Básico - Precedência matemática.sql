DECLARE @A INT,@B INT, @C INT

SET @A = 2

SET @B = 3

SET @C = 4

SELECT  (@A + @B)-@C AS 'Result #1' 

SELECT @A + (@B-@C) AS 'Result #2' 

SELECT (@A + @B) * @C AS 'Result #3' 

SELECT @A + (@B * @C) AS 'Result #4' 