DECLARE @T TABLE(i INT NULL)
INSERT @T SELECT -1 AS i
UNION ALL SELECT NULL
UNION ALL SELECT 0
UNION ALL SELECT 1
ORDER BY i DESC

-- what's the order?
SELECT * FROM @T
ORDER BY i