
SET STATISTICS IO ON

--NESTED LOOP
SELECT o.SalesOrderID, o.OrderDate, od.ProductID
	FROM dbo.Orders o INNER JOIN dbo.OrderDetails od
	ON o.SalesOrderID = od.SalesOrderID
	WHERE o.SalesOrderID = 43659

--MERGE JOIN
SELECT o.SalesOrderID, o.OrderDate, od.ProductID
	FROM dbo.Orders o INNER JOIN dbo.OrderDetails od
	ON o.SalesOrderID = od.SalesOrderID
	WHERE o.SalesOrderID BETWEEN 43659 AND 44000

DROP INDEX CLIDX_Orders_SalesOrderID
ON dbo.Orders

DROP INDEX CLIDX_OrderDetails
ON dbo.OrderDetails


SELECT o.SalesOrderID, o.OrderDate, od.ProductID
FROM dbo.Orders o INNER JOIN dbo.OrderDetails od
ON o.SalesOrderID = od.SalesOrderID
WHERE o.SalesOrderID = 43659

SELECT o.SalesOrderID, o.OrderDate, od.ProductID
FROM dbo.Orders o INNER JOIN dbo.OrderDetails od
ON o.SalesOrderID = od.SalesOrderID
WHERE o.SalesOrderID BETWEEN 43659 AND 44000

SET STATISTICS IO OFF

