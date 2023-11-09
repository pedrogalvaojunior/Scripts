-- SQL Server 2000

declare @t TABLE (CONC int, DATA datetime, N1 int, N2 int, N3 int)

insert into @t VALUES (1,'01/01/98 23:59:59.999',1,9,8)

insert into @t VALUES (2,'01/01/98 23:59:59.999',3,15,12)

-- Despivoteando

SELECT Conc, Data, N FROM (

SELECT Conc, Data, N1 AS N, 1 As Ord FROM @t

UNION ALL

SELECT Conc, Data, N2 AS N, 2 As Ord FROM @t

UNION ALL

SELECT Conc, Data, N3 AS N, 3 As Ord FROM @t) AS Q

ORDER BY Conc, Data, Ord


-- SQL Server 2005

declare @t TABLE (CONC int, DATA datetime, N1 int, N2 int, N3 int)

insert into @t VALUES (1,'01/01/98 23:59:59.999',1,9,8)

insert into @t VALUES (2,'01/01/98 23:59:59.999',3,15,12)

 

-- Despivoteando

SELECT Conc, Data, N

FROM

(SELECT CONC, DATA, N1, N2, N3 FROM @T) P

UNPIVOT

(N FOR X IN (N1,N2,N3)) AS UP
