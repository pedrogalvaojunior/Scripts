-- Create Tables --
  SELECT TOP 25
          CustID = IDENTITY(INT,1,1),
          FirstName = 'George' + CHAR(ABS(CHECKSUM(NEWID())) % 26 + 65) + CHAR(ABS(CHECKSUM(NEWID())) % 26 + 65) ,
          LastName = 'Randcust' + CHAR(ABS(CHECKSUM(NEWID())) % 26 + 65) + CHAR(ABS(CHECKSUM(NEWID())) % 26 + 65) + CHAR(ABS(CHECKSUM(NEWID())) % 26 + 65)
  INTO    dbo.Customer
  FROM    Master.dbo.SysColumns t1, Master.dbo.SysColumns t2
  GO

  SELECT TOP 1000000
          OrderID = IDENTITY(INT,1,1),
          CustID = ABS(CHECKSUM(NEWID())) % 25 + 1 ,
          OrderAmt = CAST(ABS(CHECKSUM(NEWID())) % 10000 / 100.0 AS MONEY) ,
          OrderDate = CAST(RAND(CHECKSUM(NEWID())) * 3653.0 + 36524.0 AS DATETIME)
  INTO dbo.Orders
  FROM Master.dbo.SysColumns t1, Master.dbo.SysColumns t2
  GO    

 CREATE TABLE [dbo].[OrderDetail]
 ([OrderID] [int] NOT NULL ,
   [OrderDetailID] [int] NOT NULL ,
   [PartAmt] [money] NULL ,
   [PartID] [int] NULL);

INSERT  INTO OrderDetail (OrderID, OrderDetailID, PartAmt, PartID)
SELECT  OrderID, 
             OrderDetailID = 1, 
			 PartAmt = OrderAmt / 2, 
			 PartID = ABS(CHECKSUM(NEWID())) % 1000 + 1
FROM Orders;
Go

SELECT O.OrderId,
             OD.OrderDetailID ,
             O.OrderAmt ,
             OD.PartAmt ,
             OD.PartID ,
             O.OrderDate
FROM Orders O INNER JOIN OrderDetail OD 
                           ON O.OrderID = OD.OrderID
Go

-- This is a hash match for Neested Loop example --
Select O.OrderId, OD.OrderDetailID, 
           O.OrderAmt, OD.PartAmt, 
		   OD.PartID, O.OrderDate
From Orders O Inner Join OrderDetail OD
							On O.OrderID = OD.OrderID
Where O.OrderID < 10
Go

-- This is a hash match for this example --
SELECT  O.OrderId,
              OD.OrderDetailID,
              O.OrderAmt,
              OD.PartAmt,
              OD.PartID,
              O.OrderDate
FROM Orders O INNER JOIN OrderDetail OD 
							ON O.OrderID = OD.OrderID
OPTION  ( LOOP JOIN ) --force a loop join
Go

-- This is a hash match for this example --
SELECT  O.OrderId,
              OD.OrderDetailID,
              O.OrderAmt,
              OD.PartAmt,
              OD.PartID,
              O.OrderDate
FROM Orders O INNER JOIN OrderDetail OD 
							ON O.OrderID = OD.OrderID
OPTION  ( MERGE JOIN ) --force a merge join
Go

-- Create indexes --
CREATE CLUSTERED INDEX CX_CustID ON Customer(CustID)

CREATE CLUSTERED INDEX CX_OrderDetailID ON OrderDetail(OrderId,OrderDetailID)

CREATE CLUSTERED INDEX CX_OrderID ON dbo.Orders(OrderID)
Go