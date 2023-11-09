DECLARE @List TABLE
(Number INT);
DECLARE @number INTEGER = 1234;
DECLARE @strNumber VARCHAR(8);
WHILE NOT EXISTS
              (SELECT * FROM @List WHERE Number = @Number)
BEGIN
    INSERT INTO @List (Number) VALUES (@Number);
    SET @strNumber = @Number * @Number;
    SET @strNumber
        = SUBSTRING(RIGHT('00000000' + @strNumber, 8), 3, 4);
    SET @number = @strNumber;
END;
SELECT * FROM @List
order by 1