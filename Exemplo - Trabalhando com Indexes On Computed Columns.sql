
SELECT SalesOrderID 
FROM OrderDetails
WHERE LineTotal = 27893.619



CREATE NONCLUSTERED INDEX NCL_OrderDetail_LineTotal
ON dbo.OrderDetails(LineTotal)

