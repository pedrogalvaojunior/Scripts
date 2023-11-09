WITH lv0 AS (SELECT 0 g UNION ALL SELECT 0)
    ,lv1 AS (SELECT 0 g FROM lv0 a CROSS JOIN lv0 b) -- 4
    ,lv2 AS (SELECT 0 g FROM lv1 a CROSS JOIN lv1 b) -- 16
    ,lv3 AS (SELECT 0 g FROM lv2 a CROSS JOIN lv2 b) -- 256
    ,Tally (n) AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) FROM lv3)
SELECT *
FROM Tally
ORDER BY n;

-- a
select count(*) from x where n % 2 = 0 and n % 3 = 0 and not n % 5 = 0;

-- b
select count(*) from x where n % 2 = 0 and not n % 5 = 0 and n % 3 = 0;

-- c
select count(*) from (
select * from x where n % 2 = 0 
intersect select * from x where n % 3 = 0 
except select * from x where n % 5 = 0
)z;

-- d
select count(*) from (
select * from x where n % 2 = 0 
except select * from x where n % 5 = 0
intersect select * from x where n % 3 = 0 
)z;