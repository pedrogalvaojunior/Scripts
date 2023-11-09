-- 1
SELECT 
   YEAR(OrderDate) AS OrderYear, SUM(TotalDue) AS Total
 , FORMAT(SUM(TotalDue) / SUM(SUM(TotalDue)) OVER(), 'P') AS PercentOfSales
 FROM Sales.SalesOrderHeader
 GROUP BY YEAR(OrderDate);

-- 2
SELECT 
   YEAR(OrderDate) AS OrderYear, SUM(TotalDue) AS Total
 , FORMAT(SUM(TotalDue) / SUM(TotalDue) OVER(), 'P') AS PercentOfSales
 FROM Sales.SalesOrderHeader
 GROUP BY YEAR(OrderDate);

-- 3
SELECT 
   YEAR(OrderDate) AS OrderYear
 , SUM(TotalDue) AS Total, FORMAT(SUM(TotalDue) / SUM(SUM(TotalDue)) OVER(), 'P') AS PercentOfSales
 FROM Sales.SalesOrderHeader
 GROUP BY OrderDate;