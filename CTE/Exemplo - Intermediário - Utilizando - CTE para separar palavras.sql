DECLARE @s VARCHAR(8000), @d VARCHAR(10)
SET @s = 'separar por espaço em branco'
SET @d = ' ' 

;WITH split(i,j) AS
(
SELECT i = 1, j = CHARINDEX(@d, @s + @d)
UNION ALL
SELECT i = j + 1, j = CHARINDEX(@d, @s + @d, j + 1) FROM split
   WHERE CHARINDEX(@d, @s + @d, j + 1) <> 0
)
SELECT SUBSTRING(@s,i,j-i)
FROM split