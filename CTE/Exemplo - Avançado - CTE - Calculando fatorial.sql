WITH fat(f, n) AS
(
    SELECT CAST (1 as bigint) as f, 0  as n -- fat de 0 � 1
    UNION ALL
    SELECT CAST (1 as bigint) as f, 1 as n -- fat de 1 � 1
    UNION ALL
    SELECT f * (n + 1), n +1
    FROM fat 
    WHERE n < 20 AND n <> 0 
    -- 20 � o limite neste caso, pois o fatorial de 21 
    -- n�o cabe em um tipo bigint. O <> 0 � para cortar a recurs�o
    -- do primeiro �ncora, sen�o repetiria tudo, fa�a o teste. 
)
SELECT f
FROM fat
WHERE n = 9