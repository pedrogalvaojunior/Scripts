DECLARE @Table TABLE
( iAsInt int,
  iAsString varchar(2));
    
DECLARE @i int, @x int;
SET @i = 1;

WHILE @i <= 10
BEGIN
  INSERT INTO @Table
  VALUES (@i,     CAST(@i AS varchar(2))),
         (@i + 1, CAST(@i AS varchar(2)));
    
  SET @i = @i + 1;
END

SET @x = 3 --set an integer value between 1 and 19

--statement 1
SELECT TOP (@x) WITH TIES iAsInt, iAsString FROM @Table ORDER BY iAsInt;
--statement 2
SELECT TOP (@x) WITH TIES iAsInt, iAsString FROM @Table ORDER BY iAsString;