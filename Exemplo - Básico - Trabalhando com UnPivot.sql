IF OBJECT_ID('tempdb..#Orders','U') IS NOT NULL
DROP TABLE #Orders

CREATE TABLE #Orders
    (Orderid int identity, GiftCard int, TShirt int, Shipping int)

INSERT INTO #Orders
SELECT 1, NULL, 3 UNION ALL SELECT 2, 5, 4 UNION ALL SELECT 1, 3, 10

-- UNPIVOT Query
SELECT OrderID, convert(varchar(15), ProductName) [ProductName], ProductQty
FROM (
    SELECT OrderID, GiftCard, TShirt, Shipping
    FROM #Orders
    Where Orderid = 1
    ) p
UNPIVOT
    (ProductQty FOR ProductName IN ([GiftCard], [TShirt], [Shipping])) as unpvt


DROP TABLE #Orders