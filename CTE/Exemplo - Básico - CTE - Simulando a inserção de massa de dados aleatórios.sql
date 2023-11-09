CREATE TABLE dbo.RandomDataTable
        (
         ID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED
        ,CustomerID int NOT NULL
        ,SalesPersonID varchar(10) NOT NULL
        ,Quantity smallint NOT NULL
        ,NumericValue numeric(18,2) NOT NULL
        ,Today date NOT NULL
        )
;
DECLARE @RowCount INT = 100000
;
 WITH
 E1(N)    AS (SELECT 1 FROM (VALUES (1),(1),(1),(1),(1),(1),(1),(1),(1),(1))E0(N))
,E10(N)   AS (SELECT 1 FROM E1 a, E1 b, E1 c, E1 d, E1 e, E1 f, E1 g, E1 h, E1 i, E1 j)
,TallY(N) AS (SELECT TOP(@RowCount) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) FROM E10)
 INSERT INTO dbo.RandomDataTable
        (CustomerID, SalesPersonID, Quantity, NumericValue, Today)
 SELECT  CustomerID     = @RowCount+1-t.N
        ,SalesPersonID  = SUBSTRING(ca.Texto,ABS(CHECKSUM(NEWID())%126)+1,2)
                        + SUBSTRING(ca.Texto,ABS(CHECKSUM(NEWID())%124)+1,4)
                        + SUBSTRING(ca.Texto,ABS(CHECKSUM(NEWID())%124)+1,4)
        ,Quantity       = ABS(CHECKSUM(NEWID())%1000)
        ,NumericValue   = RAND(CHECKSUM(NEWID()))*100+5
        ,Today          = DATEADD(dd,ABS(CHECKSUM(NEWID())%1000),GETDATE())
   FROM TallY t
  CROSS APPLY (SELECT '0123456789@ABCDEFGHIJKLMNOPQRSTUVWXYZ\_abcdefghijklmnopqrstuvwxyzéèùü°¿¡¬√ƒ≈∆«»… ÀÃÕŒœ–—“”‘’÷Ÿ⁄€‹›‡·‚„‰ÂÊÁËÈÍÎÏÌÓÔÒÚÛÙıˆ˘˙˚¸˝ˇ')ca(Texto)
;
 SELECT ID, CustomerID, SalesPersonID, Quantity, NumericValue, Today 
   FROM RandomDataTable
;