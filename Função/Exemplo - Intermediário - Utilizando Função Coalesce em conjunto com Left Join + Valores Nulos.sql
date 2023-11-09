create table #abc
(a int null,
 b int null,
 c int null)

 create table #xyz
(x int null,
 y int null,
 z int null)


Insert Into #abc values(null, null, 3), (1,null,3),(1,null,null),(null,2,null)

Insert Into #xyz values(null,2,3),(null,null,1),(null,null,2)

-- Q1
SELECT
        *
    FROM
        #abc a
        LEFT JOIN #xyz x
        ON a.a = x.x
           AND a.b = x.y;

-- Q2
SELECT
        *
    FROM
        #abc a
        LEFT JOIN #xyz x
        ON COALESCE(a.a, 9) = COALESCE(x.x, 9)
           AND COALESCE(a.b, 9) = COALESCE(x.y, 9);