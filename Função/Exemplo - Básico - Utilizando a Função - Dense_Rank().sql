CREATE TABLE #CustomerDemo
( CustomerID INT, Sales INT)
;
INSERT INTO #CustomerDemo
        ( CustomerID
        , Sales
        )
    VALUES
        (  1, 100), ( 2, 50), (3, 50), (4, 120), (5, 25)
;
GO
SELECT 
 CustomerID
,  DENSE_RANK() OVER (ORDER BY sales DESC) AS 'Rank'
  FROM #CustomerDemo AS cd

 SELECT 
 CustomerID
,  RANK() OVER (ORDER BY sales DESC) AS 'Rank'
  FROM #CustomerDemo AS cd
 GO

 DROP TABLE #CustomerDemo;