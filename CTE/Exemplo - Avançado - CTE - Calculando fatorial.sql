WITH fat(f, n) AS
(
    SELECT CAST (1 as bigint) as f, 0  as n -- fat de 0 é 1
    UNION ALL
    SELECT CAST (1 as bigint) as f, 1 as n -- fat de 1 é 1
    UNION ALL
    SELECT f * (n + 1), n +1
    FROM fat 
    WHERE n < 20 AND n <> 0 
    -- 20 é o limite neste caso, pois o fatorial de 21 
    -- não cabe em um tipo bigint. O <> 0 é para cortar a recursão
    -- do primeiro âncora, senão repetiria tudo, faça o teste. 
)
SELECT f
FROM fat
WHERE n = 9