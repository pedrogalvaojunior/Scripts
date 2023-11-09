CREATE FUNCTION fatorial 
(
    @n INT
)
RETURNS INT
AS
BEGIN
    DECLARE @val INT;
    WITH fat(f, n) AS
    (
        SELECT CAST (1 as bigint) as f, 0  as n
        UNION ALL
        SELECT CAST (1 as bigint) as f, 1 as n
        UNION ALL
        SELECT f * (n + 1), n +1
        FROM fat 
        WHERE n < 20 AND n <> 0 
    )
    SELECT @val = f
    FROM fat
    WHERE n = @n
    RETURN @val
END
GO

-- Testando a função
SELECT dbo.fatorial(3);
SELECT dbo.fatorial(4);
SELECT dbo.fatorial(7);