USE AdventureWorks;


SELECT DISTINCT SalesOrderID, CarrierTrackingNumber
	FROM dbo.OrderDetails
	WHERE ProductID = 776

CREATE INDEX NCLIX_OrderDetails_ProductID
	ON dbo.OrderDetails(ProductID)

DROP INDEX OrderDetails.CLIDX_OrderDetails

SELECT DISTINCT SalesOrderID, CarrierTrackingNumber
	FROM dbo.OrderDetails
	WHERE ProductID = 776

CREATE UNIQUE CLUSTERED INDEX CLIDX_OrderDetails
	ON dbo.OrderDetails(SalesOrderID,SalesOrderDetailID)