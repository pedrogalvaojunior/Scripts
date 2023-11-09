SELECT SUM(LineTotal) AS [Grand Total]
FROM Sales.SalesOrderDetail
--
SELECT ProductID, SUM(LineTotal) AS [Product Total]
FROM Sales.SalesOrderDetail
GROUP BY ProductID
--
SELECT Production.Product.Name, 
    SUM(Sales.SalesOrderDetail.LineTotal) AS [Product Total]
FROM Sales.SalesOrderDetail 
INNER JOIN Production.Product 
    ON Sales.SalesOrderDetail.ProductID = Production.Product.ProductID
GROUP BY Production.Product.Name
ORDER BY Production.Product.Name
--
SELECT C.Name AS Category, 
    S.Name AS SubCategory, 
    P.Name AS Product, 
SUM(O.LineTotal) AS [Product Total]
FROM Sales.SalesOrderDetail AS O 
    INNER JOIN
        Production.Product AS P 
ON O.ProductID = P.ProductID 
    INNER JOIN
        Production.ProductSubcategory AS S 
ON P.ProductSubcategoryID = S.ProductSubcategoryID 
    INNER JOIN
        Production.ProductCategory AS C 
ON S.ProductCategoryID = C.ProductCategoryID
GROUP BY P.Name, C.Name, S.Name
ORDER BY Category, SubCategory, Product
