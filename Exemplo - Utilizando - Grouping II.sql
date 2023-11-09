SELECT Production.Product.Name AS Product, 
    AVG(Sales.SalesOrderDetail.UnitPrice) AS [Avg Price]
FROM Sales.SalesOrderDetail 
    INNER JOIN
        Production.Product 
        ON 
        Sales.SalesOrderDetail.ProductID = Production.Product.ProductID
GROUP BY Production.Product.Name
ORDER BY Production.Product.Name
--
SELECT
    CASE GROUPING(Production. Product .Name) 
        WHEN 1 THEN 'Global Average' 
        ELSE 
            Production. Product .Name 
    END AS Product, 
    CASE GROUPING(
        CONVERT(nvarchar(7), Sales.SalesOrderHeader.OrderDate, 111)) 
        WHEN 1 THEN 'Average' 
        ELSE 
            CONVERT(nvarchar(7),Sales.SalesOrderHeader.OrderDate, 111) 
    END AS Period, 
    AVG(Sales.SalesOrderDetail.UnitPrice) AS [Avg Price]
FROM Sales.SalesOrderDetail 
    INNER JOIN Production.Product 
        ON Sales.SalesOrderDetail.ProductID = Production.Product.ProductID 
    INNER JOIN Sales.SalesOrderHeader 
        ON Sales.SalesOrderDetail.SalesOrderID = Sales.SalesOrderHeader.SalesOrderID
GROUP BY 
    Production.Product.Name, 
    CONVERT(nvarchar(7), Sales.SalesOrderHeader.OrderDate, 111) 
        WITH ROLLUP
ORDER BY 
    GROUPING(Production.Product.Name), 
    Production.Product.Name, 
    Period
--
SELECT Production.Product.Name, 
    MIN(Sales.SalesOrderDetail.UnitPrice) AS [Min Price], 
    MAX(Sales.SalesOrderDetail.UnitPrice) AS [Max Price], 
    AVG(Sales.SalesOrderDetail.UnitPrice) AS [Avg Price]
FROM Sales.SalesOrderDetail 
INNER JOIN Production.Product 
    ON Sales.SalesOrderDetail.ProductID = Production.Product.ProductID
GROUP BY Production.Product.Name
ORDER BY Production.Product.Name
--
SELECT Production.Product.Name, 
    MIN(DISTINCT Sales.SalesOrderDetail.UnitPrice) AS [Min Price], 
    MAX(DISTINCT Sales.SalesOrderDetail.UnitPrice) AS [Max Price], 
    AVG(DISTINCT Sales.SalesOrderDetail.UnitPrice) AS [Avg Price]
FROM Sales.SalesOrderDetail 
INNER JOIN Production.Product 
    ON Sales.SalesOrderDetail.ProductID = Production.Product.ProductID
GROUP BY Production.Product.Name
ORDER BY Production.Product.Name
--
