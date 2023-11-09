SET STATISTICS IO ON
--not covered 
SELECT DISTINCT SalesOrderID, CarrierTrackingNumber
	FROM dbo.OrderDetails
	WHERE ProductID = 776
--covered
SELECT DISTINCT SalesOrderID
	FROM dbo.OrderDetails
	WHERE ProductID = 776
SET STATISTICS IO OFF

DROP INDEX dbo.OrderDetails.NCLIX_OrderDetails_ProductID

CREATE INDEX NCLIX_OrderDetails_ProductID
	ON dbo.OrderDetails(ProductID)
	INCLUDE (CarrierTrackingNumber)


SET STATISTICS IO ON
SELECT DISTINCT SalesOrderID, CarrierTrackingNumber
	FROM dbo.OrderDetails
	WHERE ProductID = 776 
SET STATISTICS IO OFF
