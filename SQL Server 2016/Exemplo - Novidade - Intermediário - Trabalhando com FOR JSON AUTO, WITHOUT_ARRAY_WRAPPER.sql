CREATE TABLE tst
(
    ProductID INT,
    ProductName VARCHAR(100),
    Quantity INT,
    Price MONEY
);

INSERT INTO tst
VALUES
( 1, 'SQL Server 2014', 20, 1234.55),
( 2, 'SQL Server 2016', 5, 1234.55);

CREATE TABLE tst0
(
    OrderID INT,
    ProductID INT,
    Quantity INT
);

INSERT INTO tst0
VALUES
( 1, 1, 3),
( 2, 1, 1);

SELECT [Product].ProductID,
       [Product].ProductName,
       [Order].OrderID,
       [Order].Quantity
FROM tst [Product]
    LEFT JOIN tst0 [Order]
        ON [Order].ProductID = [Product].ProductID
FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER; 

SELECT [Product].ProductID,
       [Product].ProductName,
       [Order].OrderID,
       [Order].Quantity
FROM tst [Product]
    LEFT JOIN tst0 [Order]
        ON [Order].ProductID = [Product].ProductID
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER; 

SELECT [Product].ProductID,
       [Product].ProductName,
       [Order].OrderID,
       [Order].Quantity
FROM tst [Product]
    LEFT JOIN tst0 [Order]
        ON [Order].ProductID = [Product].ProductID
FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER; 

DROP TABLE tst;