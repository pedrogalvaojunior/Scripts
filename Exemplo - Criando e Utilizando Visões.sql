USE AdventureWorks;
GO


CREATE VIEW dbo.vOrderDetails
	WITH SCHEMABINDING 
AS
	SELECT DATEPART(yy,Orderdate) as Year,
				DATEPART(mm,Orderdate) as Month,
				SUM(LineTotal) as OrderTotal,
				COUNT_BIG(*) as LineCount
	FROM dbo.Orders o INNER JOIN dbo.OrderDetails od
		ON o.SalesOrderID = od.SalesOrderID
	GROUP BY DATEPART(yy,Orderdate),
					DATEPART(mm,Orderdate);

SET STATISTICS IO ON

SELECT Year, Month, OrderTotal 
	FROM dbo.vOrderDetails
	ORDER BY YEAR, MONTH

SET STATISTICS IO OFF



CREATE UNIQUE CLUSTERED INDEX CLIDX_vOrderDetails_Year_Month
ON dbo.vOrderDetails(Year,Month)



SET STATISTICS IO ON
SELECT Year, Month, OrderTotal 
	FROM dbo.vOrderDetails
	ORDER BY YEAR, MONTH
SET STATISTICS IO OFF


SELECT DATEPART(yy,Orderdate) as Year,
		SUM(LineTotal) as YearTotal
	FROM dbo.Orders o INNER JOIN dbo.OrderDetails od
		ON o.SalesOrderID = od.SalesOrderID
	GROUP BY DATEPART(yy,Orderdate)

