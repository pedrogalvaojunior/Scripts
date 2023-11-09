SELECT C.Name AS Category, 
    S.Name AS SubCategory, 
    SUM(O.LineTotal) AS Sales
FROM Sales.SalesOrderDetail AS O 
    INNER JOIN Production.Product AS P 
        ON O.ProductID = P.ProductID 
        INNER JOIN Production.ProductSubcategory AS S 
        ON P.ProductSubcategoryID = S.ProductSubcategoryID 
        INNER JOIN Production.ProductCategory AS C 
        ON S.ProductCategoryID = C.ProductCategoryID
GROUP BY C.Name, S.Name WITH ROLLUP
ORDER BY Category, SubCategory
--
SELECT 
    C.Name AS Category, 
    S.Name AS SubCategory, 
    SUM(O.LineTotal) AS Sales, 
    GROUPING(C.Name) AS IsCategoryGroup, 
    GROUPING(S.Name) AS IsSubCategoryGroup
FROM         Sales.SalesOrderDetail AS O 
    INNER JOIN Production.Product AS P 
        ON O.ProductID = P.ProductID 
    INNER JOIN Production.ProductSubcategory AS S 
        ON P.ProductSubcategoryID = S.ProductSubcategoryID 
    INNER JOIN Production.ProductCategory AS C 
        ON S.ProductCategoryID = C.ProductCategoryID
GROUP BY C.Name, S.Name WITH ROLLUP
ORDER BY Category, SubCategory
--
SELECT 
    C.Name AS Category, 
    S.Name AS SubCategory, 
    SUM(O.LineTotal) AS Sales, 
    GROUPING(C.Name) AS IsCategoryGroup, 
    GROUPING(S.Name) AS IsSubCategoryGroup
FROM Sales.SalesOrderDetail AS O 
    INNER JOIN Production.Product AS P 
        ON O.ProductID = P.ProductID 
    INNER JOIN Production.ProductSubcategory AS S 
        ON P.ProductSubcategoryID = S.ProductSubcategoryID 
    INNER JOIN Production.ProductCategory AS C 
        ON S.ProductCategoryID = C.ProductCategoryID
GROUP BY C.Name, S.Name WITH ROLLUP
ORDER BY 
    IsCategoryGroup, 
    Category, 
    IsSubCategoryGroup, 
    SubCategory
--
SELECT 
    CASE GROUPING(C.Name) 
        WHEN 1 THEN 'Category Total'  
        ELSE C.Name 
    END AS Category, 
    CASE GROUPING(S.Name) 
        WHEN 1 THEN 'Sub-category Total'  
        ELSE S.Name 
    END AS SubCategory, 
    SUM(O.LineTotal) AS Sales, 
    GROUPING(C.Name) AS IsCategoryGroup, 
    GROUPING(S.Name) AS IsSubCategoryGroup
FROM Sales.SalesOrderDetail AS O 
    INNER JOIN Production.Product AS P 
        ON O.ProductID = P.ProductID 
    INNER JOIN Production.ProductSubcategory AS S 
        ON P.ProductSubcategoryID = S.ProductSubcategoryID 
    INNER JOIN Production.ProductCategory AS C 
        ON S.ProductCategoryID = C.ProductCategoryID
GROUP BY C.Name, S.Name WITH ROLLUP
ORDER BY 
    IsCategoryGroup, 
    Category, 
    IsSubCategoryGroup, 
    SubCategory
