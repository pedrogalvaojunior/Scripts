---------------------------------------------------------------------
-- Advanced Querying and Query Tuning in SQL Server 2000 and 2005
-- Itzik Ben-Gan, Solid Quality Learning
---------------------------------------------------------------------
SET NOCOUNT ON;
USE tempdb;
GO

---------------------------------------------------------------------
-- Identify Waits (Bottlenecks) at the Server
---------------------------------------------------------------------
IF DB_ID('Performance') IS NOT NULL
  DROP DATABASE Performance;
GO
CREATE DATABASE Performance;
GO
USE Performance;
GO

-- 2000
DBCC SQLPERF(WAITSTATS);

-- 2005
SELECT * FROM sys.dm_os_wait_stats;

-- Collect wait info

-- Create the table
SELECT GETDATE() AS dt, * INTO WAITSTATS FROM sys.dm_os_wait_stats WHERE 1=2;
ALTER TABLE WAITSTATS ADD PRIMARY KEY(wait_type, dt);
CREATE INDEX idx_dt_type ON WAITSTATS(dt, wait_type);

-- Run in a job
INSERT INTO WAITSTATS SELECT GETDATE(), * FROM sys.dm_os_wait_stats;

-- Calc problematic waits
SELECT *, ROUND(100.* wait_time_ms / SUM(wait_time_ms) OVER(), 2) AS per
FROM (SELECT TOP (1) WITH TIES *
      FROM WAITSTATS
      ORDER BY dt DESC) AS D
ORDER BY wait_time_ms DESC;
GO

-- Calc wait diffs
CREATE VIEW VWaitDiffs
AS

SELECT Prv.dt AS dt, DATEDIFF(ms, Prv.dt, Cur.dt) AS elapsed,
  Cur.wait_type, Cur.wait_time_ms - Prv.wait_time_ms AS diff,
  MAX(Cur.wait_time_ms) OVER(PARTITION BY Cur.wait_type) AS cumulative
FROM WAITSTATS AS Cur
  CROSS APPLY (SELECT TOP (1) *
               FROM WAITSTATS AS P
               WHERE P.wait_type = Cur.wait_type
                 AND P.dt < Cur.dt
               ORDER BY P.dt DESC) AS Prv;
GO

SELECT *
FROM VWaitDiffs
ORDER BY cumulative DESC;

---------------------------------------------------------------------
-- Correlate Waits with Queues
---------------------------------------------------------------------

-- 2000
SELECT * FROM master.dbo.sysperfinfo;

-- 2005
SELECT * FROM sys.dm_os_performance_counters;

---------------------------------------------------------------------
-- Drill Down to the Database/File Level
---------------------------------------------------------------------

SELECT db_name(dbid) AS DbName, * FROM ::fn_virtualfilestats(2, 1)
UNION ALL
SELECT db_name(dbid), * FROM ::fn_virtualfilestats(2, 2)
-- UNION ALL <other db files>;

SELECT db_name(database_id) AS database_name,
  SUM(num_of_bytes_read + num_of_bytes_written) OVER(PARTITION BY database_id) AS dbio,
  CAST(100.*SUM(num_of_bytes_read + num_of_bytes_written) OVER(PARTITION BY database_id)
    / SUM(num_of_bytes_read + num_of_bytes_written) OVER() AS DECIMAL(12, 2)) AS dbioper,
  SUM(num_of_bytes_read + num_of_bytes_written) OVER(PARTITION BY database_id, file_id) AS fileio,
  CAST(100.*SUM(num_of_bytes_read + num_of_bytes_written) OVER(PARTITION BY database_id, file_id)
    / SUM(num_of_bytes_read + num_of_bytes_written) OVER() AS DECIMAL(12,2)) AS fileioper,
  *
FROM sys.dm_io_virtual_file_stats(NULL, NULL)
ORDER BY SUM(num_of_bytes_read + num_of_bytes_written) OVER(PARTITION BY database_id) DESC;

---------------------------------------------------------------------
-- Drill Down to the Process Level
---------------------------------------------------------------------
use tempdb;
go
drop table orders;
go
select row_number() over(order by orderid) as orderid,
  customerid, employeeid, orderdate, cast('a' as char(200)) as filler
into orders
from northwind.dbo.orders, nums
where n <= 1000;
go
create unique nonclustered index idx_orderid on orders(orderid);
go
dbcc freeproccache;
set statistics io off
-- trace
select * from orders where orderid = 3
select * from orders where orderid = 5
select * from orders where orderid = 7

select * from orders where orderdate = '19970101'
select * from orders where orderdate = '19970102'
select * from orders where orderdate = '19970103'

select * from orders where orderdate between '19970103' and '19970104'
select * from orders where orderdate between '19970104' and '19970105'
select * from orders where orderdate between '19970105' and '19970106'
go

-- load trace to table
drop table workload;
go
select * from fn_trace_gettable('c:\traces\workload.trc', null);

select *
into workload
from fn_trace_gettable('c:\traces\workload.trc', null);

select * from workload;

select dbo.SQL_Signature('select * from t1 where col1 = 3 and col2 > 78', 4000);

select textdata, dbo.SQL_Signature(textdata, 4000) as pattern,
  checksum(dbo.SQL_Signature(textdata, 4000)) as cs, duration
from workload
where textdata like '%select%';

select checksum(dbo.SQL_Signature(textdata, 4000)) as cs, sum(duration) as sumduration
from workload
where textdata like '%select%'
group by checksum(dbo.SQL_Signature(textdata, 4000))
order by sumduration desc;

select w.textdata, t.*
from (select top (5) checksum(dbo.SQL_Signature(textdata, 4000)) as cs, sum(duration) as sumduration
      from workload
      where textdata like '%select%'
      group by checksum(dbo.SQL_Signature(textdata, 4000))
      order by sumduration desc) as t
  join workload as w
    on t.cs = checksum(dbo.SQL_Signature(w.textdata, 4000))
order by sumduration desc;

-- Fix performance problems
create clustered index idx_dt on orders(orderdate);
go

---------------------------------------------------------------------
-- Indexes
---------------------------------------------------------------------

-- table scan
select * from orders where customerid = 'vinet';

-- nc non-covering - point
select * from orders where orderid = 5;

-- nc non-covering - range
select * from orders where orderid between 1000 and 2000;
select * from orders where orderid between 100000 and 200000;

-- clustered index
select * from orders where orderdate between '19970103' and '19970104'

-- nc covering
create unique nonclustered index idx_oid_cid on orders(orderid, customerid);

select orderid, customerid from orders where orderid between 1000 and 2000;
select orderid, customerid from orders where orderid between 100000 and 200000;

-- nc covering with included non-key columns
drop index orders.idx_oid_cid;

create unique nonclustered index idx_oid_i_cid
  on orders(orderid) include(customerid);

select orderid, customerid from orders where orderid between 1000 and 2000;
select orderid, customerid from orders where orderid between 100000 and 200000;
go

-- indexed view
create view vemporders with schemabinding
as

select employeeid, count_big(*) as numorders
from dbo.orders
group by employeeid
go

create unique clustered index idx_empid on vemporders(employeeid);
go

select * from vemporders;

select employeeid, count_big(*) as numorders
from dbo.orders
group by employeeid;
go

drop view vemporders;
go

---------------------------------------------------------------------
-- Fragmentation
---------------------------------------------------------------------

-- 2000
DBCC SHOWCONTIG WITH ALL_INDEXES, TABLERESULTS, NO_INFOMSGS;
 
-- 2005
SELECT * FROM sys.dm_db_index_physical_stats(2, null, null, null, null);
GO

-- online index rebuild
ALTER INDEX idx_dt ON orders
  REBUILD WITH (ONLINE = ON);
GO

---------------------------------------------------------------------
-- Dynamic Management Objects
---------------------------------------------------------------------

-- fragmentation
SELECT * FROM sys.dm_db_index_physical_stats(2, null, null, null, null);

-- low-level I/O, locking, latching, and access method activity
SELECT * FROM sys.dm_db_index_operational_stats(2, null, null, null);

-- counts of index operations
SELECT * FROM sys.dm_db_index_usage_stats
GO

---------------------------------------------------------------------
-- Advanced Querying Techniques
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Set-Based Thinking, Example
---------------------------------------------------------------------
USE master;
GO
IF DB_ID('testdb') IS NOT NULL
  DROP DATABASE testdb;
GO
CREATE DATABASE testdb;
GO
USE testdb;
GO

-- Create tables Employees and Orders in tempdb
-- 9 employees, 1,660,000 orders
-- * takes about 5 minutes to run...

IF OBJECT_ID('Employees') IS NOT NULL
  DROP TABLE Employees
IF OBJECT_ID('Orders') IS NOT NULL
  DROP TABLE Orders
IF OBJECT_ID('Nums') IS NOT NULL
  DROP TABLE Nums
GO

CREATE TABLE Nums(n INT NOT NULL PRIMARY KEY)
DECLARE @i AS INT
SET @i = 1
BEGIN TRAN
  WHILE @i <= 2000
  BEGIN
    INSERT INTO Nums VALUES(@i)
    SET @i = @i + 1
  END
COMMIT TRAN
GO

SELECT *
INTO Employees
FROM Northwind.dbo.Employees

ALTER TABLE Employees ADD CONSTRAINT PK_Employees PRIMARY KEY(EmployeeID)

SELECT IDENTITY(INT, 1, 1) AS OrderID, CustomerID, EmployeeID, OrderDate, RequiredDate, ShippedDate, ShipVia, Freight, ShipName, ShipAddress, ShipCity, ShipRegion, ShipPostalCode, ShipCountry
INTO Orders
FROM Northwind.dbo.Orders JOIN Nums
  ON n <= 2000

ALTER TABLE Orders ADD CONSTRAINT PK_Orders PRIMARY KEY(OrderID)
CREATE INDEX idx_nc_EmployeeID_OrderDate ON Orders(EmployeeID, OrderDate)
GO

-- Get the list of active employees that made no orders after April 1998
DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS

-- Cursor based solution - 2 minutes
DECLARE @EmployeeID AS INT, @OrderDate AS DATETIME,
  @PrevEmployeeID AS INT, @PrevOrderDate AS DATETIME

DECLARE EmpOrdersCursor CURSOR FAST_FORWARD
FOR SELECT EmployeeID, OrderDate
    FROM Orders
    ORDER BY EmployeeID, OrderDate

OPEN EmpOrdersCursor

FETCH NEXT FROM EmpOrdersCursor
  INTO @EmployeeID, @OrderDate
SELECT @PrevEmployeeID = @EmployeeID, @PrevOrderDate = @OrderDate

WHILE @@fetch_status = 0
BEGIN
  IF @PrevEmployeeID <> @EmployeeID AND @PrevOrderDate < '19980501'
    PRINT @PrevEmployeeID

  SELECT @PrevEmployeeID = @EmployeeID, @PrevOrderDate = @OrderDate

  FETCH NEXT FROM EmpOrdersCursor
    INTO @EmployeeID, @OrderDate
END

IF @PrevOrderDate < '19980501'
  PRINT @PrevEmployeeID

CLOSE EmpOrdersCursor

DEALLOCATE EmpOrdersCursor

-- Set-based solution (3 seconds)
DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS

SELECT EmployeeID
FROM Orders
GROUP BY EmployeeID
HAVING MAX(OrderDate) < '19980501'
GO

---------------------------------------------------------------------
-- Writing several different solutions
---------------------------------------------------------------------
DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS

SET STATISTICS IO ON

--
SELECT EmployeeID
FROM Orders
GROUP BY EmployeeID
HAVING MAX(OrderDate) < '19980501'

--
SELECT EmployeeID
FROM (SELECT EmployeeID,
        (SELECT MAX(OrderDate)
         FROM Orders AS O
         WHERE O.EmployeeID = E.EmployeeID) AS MaxDT
      FROM Employees AS E) AS MO
WHERE MaxDT < '19980501'

--
SELECT EmployeeID
FROM (SELECT EmployeeID,
        (SELECT MAX(OrderDate)
         FROM Orders AS O
         WHERE O.EmployeeID = E.EmployeeID) AS MaxDT
      FROM Employees AS E) AS MO
WHERE COALESCE(MaxDT, '19980501') < '19980501'

--
SELECT EmployeeID
FROM Employees AS E
WHERE NOT EXISTS
  (SELECT *
   FROM Orders AS O
   WHERE O.EmployeeID = E.EmployeeID
     AND OrderDate >= '19980501')
  AND EXISTS
   (SELECT *
    FROM Orders AS O
    WHERE O.EmployeeID = E.EmployeeID)

---------------------------------------------------------------------
-- Row Numbers
---------------------------------------------------------------------

SET NOCOUNT ON;
USE Northwind;
GO

-- Calculating row numbers

-- SQL Server 2000

-- Oops technique: SELECT INTO … ORDER BY
IF OBJECT_ID('tempdb..#Orders') IS NOT NULL
  DROP TABLE #Orders;
GO

SELECT IDENTITY(int, 1, 1) AS RowNum,
  OrderID + 0 AS OrderID, OrderDate, CustomerID, EmployeeID
INTO #Orders
FROM dbo.Orders
ORDER BY OrderDate, OrderID;
GO

-- Set based query
SELECT (SELECT COUNT(*)
        FROM dbo.Orders AS I
        WHERE I.OrderDate < O.OrderDate
           OR I.OrderDate = O.OrderDate
              AND I.OrderID <= O.OrderID) AS RowNum,
  OrderID, OrderDate, CustomerID, EmployeeID
FROM dbo.Orders AS O
ORDER BY OrderDate, OrderID;
GO

-- Cursor
DECLARE @OrdersRN TABLE(RowNum INT, OrderID INT, OrderDate DATETIME, CustomerID NCHAR(5), EmployeeID INT);
DECLARE @RowNum AS INT, @OrderID INT, @OrderDate DATETIME, @CustomerID NCHAR(5), @EmployeeID INT;

DECLARE rncursor CURSOR FAST_FORWARD FOR
  SELECT OrderID, OrderDate, CustomerID, EmployeeID
  FROM dbo.Orders ORDER BY OrderDate, OrderID;
OPEN rncursor;

SET @RowNum = 0;

FETCH NEXT FROM rncursor INTO @OrderID, @OrderDate, @CustomerID, @EmployeeID;
WHILE @@fetch_status = 0
BEGIN
  SET @RowNum = @RowNum + 1;
  INSERT INTO @OrdersRN(RowNum, OrderID, OrderDate, CustomerID, EmployeeID)
    VALUES(@RowNum, @OrderID, @OrderDate, @CustomerID, @EmployeeID);
  FETCH NEXT FROM rncursor INTO @OrderID, @OrderDate, @CustomerID, @EmployeeID;
END

CLOSE rncursor;
DEALLOCATE rncursor;

SELECT RowNum, OrderID, OrderDate, CustomerID, EmployeeID FROM @OrdersRN;
GO

-- CREATE TABEL w/IDENTITY, INSERT SELECT … ORDER BY
DECLARE @OrdersRN TABLE(RowNum INT IDENTITY, OrderID INT, OrderDate DATETIME, CustomerID NCHAR(5), EmployeeID INT);
INSERT INTO @OrdersRN(OrderID, OrderDate, CustomerID, EmployeeID)
  SELECT OrderID, OrderDate, CustomerID, EmployeeID
  FROM dbo.Orders
  ORDER BY OrderDate, OrderID;
SELECT * FROM @OrdersRN;
GO

-- SQL Server 2005

-- ROW_NUMBER function
SELECT ROW_NUMBER() OVER(ORDER BY OrderDate, OrderID) AS RowNum,
  OrderID, OrderDate, CustomerID, EmployeeID
FROM dbo.Orders;
GO

-- Selection of Practical Applications

-- Paging
DECLARE @PageNum AS INT, @PageSize AS INT;
SET @PageNum = 2;
SET @PageSize = 10;

WITH OrdersRN AS
(
  SELECT ROW_NUMBER() OVER(ORDER BY OrderDate, OrderID) AS RowNum,
    OrderID, OrderDate, CustomerID, EmployeeID
  FROM dbo.Orders
)
SELECT * FROM OrdersRN
WHERE RowNum BETWEEN (@PageNum - 1) * @PageSize + 1
                 AND @PageNum * @PageSize
ORDER BY OrderDate, OrderID;
GO

-- Top n for each group

-- 2000
SELECT OrderID, OrderDate, CustomerID, EmployeeID
FROM dbo.Orders AS O
WHERE OrderID IN
  (SELECT TOP 3 OrderID
   FROM dbo.Orders AS I
   WHERE I.EmployeeID = O.EmployeeID
   ORDER BY OrderDate DESC, OrderID DESC)
ORDER BY EmployeeID, OrderDate DESC, OrderID DESC;

-- 2005
WITH OrdersRN AS
(
  SELECT ROW_NUMBER() OVER(PARTITION BY EmployeeID
                           ORDER BY OrderDate DESC, OrderID DESC) AS RowNum,
    OrderID, OrderDate, CustomerID, EmployeeID
  FROM dbo.Orders
)
SELECT * FROM OrdersRN
WHERE RowNum <= 3
ORDER BY EmployeeID, OrderDate DESC, OrderID DESC;
GO

-- Matching Current and Adjacent occurences

-- 2000
SELECT D.EmployeeID, D.OrderID, D.OrderDate, D.CustomerID,
  O.OrderID, O.OrderDate, O.CustomerID
FROM (SELECT OrderID, OrderDate, CustomerID, EmployeeID,
        (SELECT TOP 1 OrderID
         FROM dbo.Orders AS O2
         WHERE O2.EmployeeID = O1.EmployeeID
           AND (O2.OrderDate < O1.OrderDate
                OR O2.OrderDate = O1.OrderDate
                   AND O2.OrderID < O1.OrderID)
         ORDER BY OrderDate DESC, OrderID DESC) AS PrvKey
      FROM dbo.Orders AS O1) AS D
  LEFT OUTER JOIN dbo.Orders AS O
    ON D.PrvKey = O.OrderID
ORDER BY D.EmployeeID, D.OrderDate, D.OrderID;

-- 2005
WITH OrdersRN AS
(
  SELECT ROW_NUMBER() OVER(PARTITION BY EmployeeID
                           ORDER BY OrderDate, OrderID) AS RowNum,
    OrderID, OrderDate, CustomerID, EmployeeID
  FROM dbo.Orders
)
SELECT * 
FROM OrdersRN AS Cur
  LEFT OUTER JOIN OrdersRN AS Prv
    ON Cur.EmployeeID = Prv.EmployeeID
    AND Cur.RowNum = Prv.RowNum + 1
ORDER BY Cur.EmployeeID, Cur.OrderDate, Cur.OrderID;
GO

-- Islands

-- 2000
SELECT MIN(OrderDate) AS s, MAX(OrderDate) AS e
FROM (SELECT OrderDate,
        (SELECT MIN(OrderDate)
         FROM dbo.Orders AS O2
         WHERE O2.OrderDate >= O1.OrderDate
           AND NOT EXISTS
             (SELECT *
              FROM dbo.Orders AS O3
              WHERE O3.OrderDate - 1 = O2.OrderDate)) AS Grp
      FROM (SELECT DISTINCT OrderDate
            FROM dbo.Orders) AS O1) AS D
GROUP BY Grp;

-- 2005
WITH Dates AS
(
  SELECT DISTINCT OrderDate
  FROM dbo.Orders
),
GrpFactor AS
(
  SELECT *, OrderDate - ROW_NUMBER() OVER(ORDER BY OrderDate) AS Grp
  FROM Dates
)
SELECT MIN(OrderDate) AS s, MAX(OrderDate) AS e
FROM GrpFactor
GROUP BY Grp;
GO

-- Deleting Dups
USE Northwind;
GO

IF OBJECT_ID('dbo.OrdersDups') IS NOT NULL
  DROP TABLE dbo.OrdersDups;
GO

SELECT * INTO dbo.OrdersDups FROM dbo.Orders
UNION ALL
SELECT * FROM dbo.Orders
UNION ALL
SELECT * FROM dbo.Orders
GO

WITH Dups AS
(
  SELECT *,
    ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY OrderID) AS RowNum
  FROM dbo.OrdersDups
)
DELETE FROM Dups
WHERE RowNum > 1;
GO

---------------------------------------------------------------------
-- Common Table Expressions (CTE)
---------------------------------------------------------------------

-- DDL & Sample Data for Employees
SET NOCOUNT ON;
USE tempdb;
GO
IF OBJECT_ID('dbo.Employees') IS NOT NULL
  DROP TABLE dbo.Employees;
GO
CREATE TABLE dbo.Employees
(
  empid   INT         NOT NULL PRIMARY KEY,
  mgrid   INT         NULL     REFERENCES dbo.Employees,
  empname VARCHAR(25) NOT NULL,
  salary  MONEY       NOT NULL
);

INSERT INTO dbo.Employees(empid, mgrid, empname, salary)
  VALUES(1, NULL, 'David', $10000.00);
INSERT INTO dbo.Employees(empid, mgrid, empname, salary)
  VALUES(2, 1, 'Eitan', $7000.00);
INSERT INTO dbo.Employees(empid, mgrid, empname, salary)
  VALUES(3, 1, 'Ina', $7500.00);
INSERT INTO dbo.Employees(empid, mgrid, empname, salary)
  VALUES(4, 2, 'Seraph', $5000.00);
INSERT INTO dbo.Employees(empid, mgrid, empname, salary)
  VALUES(5, 2, 'Jiru', $5500.00);
INSERT INTO dbo.Employees(empid, mgrid, empname, salary)
  VALUES(6, 2, 'Steve', $4500.00);
INSERT INTO dbo.Employees(empid, mgrid, empname, salary)
  VALUES(7, 3, 'Aaron', $5000.00);
INSERT INTO dbo.Employees(empid, mgrid, empname, salary)
  VALUES(8, 5, 'Lilach', $3500.00);
INSERT INTO dbo.Employees(empid, mgrid, empname, salary)
  VALUES(9, 7, 'Rita', $3000.00);
INSERT INTO dbo.Employees(empid, mgrid, empname, salary)
  VALUES(10, 5, 'Sean', $3000.00);
INSERT INTO dbo.Employees(empid, mgrid, empname, salary)
  VALUES(11, 7, 'Gabriel', $3000.00);
INSERT INTO dbo.Employees(empid, mgrid, empname, salary)
  VALUES(12, 9, 'Emilia' , $2000.00);
INSERT INTO dbo.Employees(empid, mgrid, empname, salary)
  VALUES(13, 9, 'Michael', $2000.00);
INSERT INTO dbo.Employees(empid, mgrid, empname, salary)
  VALUES(14, 9, 'Didi', $1500.00);

CREATE UNIQUE INDEX idx_unc_mgrid_empid ON dbo.Employees(mgrid, empid);
GO

-- Recursive CTE returning subtree
DECLARE @root AS INT;
SET @root = 1;

WITH SubsCTE
AS
(
  -- Anchor member returns root node
  SELECT empid, mgrid, empname, salary
  FROM dbo.Employees
  WHERE empid = @root

  UNION ALL

  -- Recursive member returns next level of children
  SELECT C.empid, C.mgrid, C.empname, C.salary
  FROM SubsCTE AS P
    JOIN dbo.Employees AS C
      ON C.mgrid = P.empid
)
SELECT * FROM SubsCTE;

-- Sorting

-- Sorting Hierarchy by empname
DECLARE @root AS INT;
SET @root = 1;

WITH SubsCTE
AS
(
  SELECT empid, empname, 0 AS lvl,
    -- Path of root is 1 (binary)
    CAST(1 AS VARBINARY(MAX)) AS sortpath
  FROM dbo.Employees
  WHERE empid = @root

  UNION ALL

  SELECT C.empid, C.empname, P.lvl + 1,
    -- Path of child = parent's path + child row number (binary)
    P.sortpath + CAST(
      ROW_NUMBER() OVER(PARTITION BY C.mgrid
                        ORDER BY C.empname) -- sort col(s)
      AS BINARY(4))
  FROM SubsCTE AS P
    JOIN dbo.Employees AS C
      ON C.mgrid = P.empid
)
SELECT empid, ROW_NUMBER() OVER(ORDER BY sortpath) AS sortval,
  REPLICATE(' | ', lvl) + empname AS empname
FROM SubsCTE
ORDER BY sortval;
GO

-- Cycles

-- Create a cyclic path
UPDATE dbo.Employees SET mgrid = 14 WHERE empid = 1;
GO

-- Detecting Cycles
DECLARE @root AS INT;
SET @root = 1;

WITH SubsCTE
AS
(
  SELECT empid, empname, 0 AS lvl,
    CAST('.' + CAST(empid AS VARCHAR(10)) + '.'
         AS VARCHAR(900)) AS path,
    -- Obviously root has no cycle
    0 AS cycle
  FROM dbo.Employees
  WHERE empid = @root

  UNION ALL

  SELECT C.empid, C.empname, P.lvl + 1,
    CAST(P.path + CAST(C.empid AS VARCHAR(10)) + '.'
         AS VARCHAR(900)) AS path,
    -- Cycle detected if parent's path contains child's id
    CASE WHEN P.path LIKE '%.' + CAST(C.empid AS VARCHAR(10)) + '.%'
      THEN 1 ELSE 0 END
  FROM SubsCTE AS P
    JOIN dbo.Employees AS C
      ON C.mgrid = P.empid
)
SELECT empid, empname, cycle, path
FROM SubsCTE;
GO

-- Not Pursuing Cycles, CTE Solution
DECLARE @root AS INT;
SET @root = 1;

WITH SubsCTE
AS
(
  SELECT empid, empname, 0 AS lvl,
    CAST('.' + CAST(empid AS VARCHAR(10)) + '.'
         AS VARCHAR(900)) AS path,
    -- Obviously root has no cycle
    0 AS cycle
  FROM dbo.Employees
  WHERE empid = @root

  UNION ALL

  SELECT C.empid, C.empname, P.lvl + 1,
    CAST(P.path + CAST(C.empid AS VARCHAR(10)) + '.'
         AS VARCHAR(900)) AS path,
    -- Cycle detected if parent's path contains child's id
    CASE WHEN P.path LIKE '%.' + CAST(C.empid AS VARCHAR(10)) + '.%'
      THEN 1 ELSE 0 END
  FROM SubsCTE AS P
    JOIN dbo.Employees AS C
      ON C.mgrid = P.empid
      AND P.cycle = 0 -- do not pursue branch for parent with cycle
)
SELECT empid, empname, cycle, path
FROM SubsCTE;
GO

-- Isolating Cyclic Paths, CTE Solution
DECLARE @root AS INT;
SET @root = 1;

WITH SubsCTE
AS
(
  SELECT empid, empname, 0 AS lvl,
    CAST('.' + CAST(empid AS VARCHAR(10)) + '.'
         AS VARCHAR(900)) AS path,
    -- Obviously root has no cycle
    0 AS cycle
  FROM dbo.Employees
  WHERE empid = @root

  UNION ALL

  SELECT C.empid, C.empname, P.lvl + 1,
    CAST(P.path + CAST(C.empid AS VARCHAR(10)) + '.'
         AS VARCHAR(900)) AS path,
    -- Cycle detected if parent's path contains child's id
    CASE WHEN P.path LIKE '%.' + CAST(C.empid AS VARCHAR(10)) + '.%'
      THEN 1 ELSE 0 END
  FROM SubsCTE AS P
    JOIN dbo.Employees AS C
      ON C.mgrid = P.empid
      AND P.cycle = 0
)
SELECT path FROM SubsCTE WHERE cycle = 1;

-- Fix cyclic path
UPDATE dbo.Employees SET mgrid = NULL WHERE empid = 1;
GO

---------------------------------------------------------------------
-- Pivoting
---------------------------------------------------------------------
USE Northwind;
GO

-- 2000
SELECT OrderYear,
  SUM(CASE WHEN OrderMonth =  1 THEN Freight END) AS [1],
  SUM(CASE WHEN OrderMonth =  2 THEN Freight END) AS [2],
  SUM(CASE WHEN OrderMonth =  3 THEN Freight END) AS [3],
  SUM(CASE WHEN OrderMonth =  4 THEN Freight END) AS [4],
  SUM(CASE WHEN OrderMonth =  5 THEN Freight END) AS [5],
  SUM(CASE WHEN OrderMonth =  6 THEN Freight END) AS [6],
  SUM(CASE WHEN OrderMonth =  7 THEN Freight END) AS [7],
  SUM(CASE WHEN OrderMonth =  8 THEN Freight END) AS [8],
  SUM(CASE WHEN OrderMonth =  9 THEN Freight END) AS [9],
  SUM(CASE WHEN OrderMonth = 10 THEN Freight END) AS [10],
  SUM(CASE WHEN OrderMonth = 11 THEN Freight END) AS [11],
  SUM(CASE WHEN OrderMonth = 12 THEN Freight END) AS [12]
FROM (SELECT
        YEAR(OrderDate) AS OrderYear,
        MONTH(OrderDate) AS OrderMonth,
        Freight
      FROM dbo.Orders) AS D
GROUP BY OrderYear;

-- 2000 Using Matrix
create table matrix
(
  m int not null primary key,
  m01 int,
  m02 int,
  m03 int,
  m04 int,
  m05 int,
  m06 int,
  m07 int,
  m08 int,
  m09 int,
  m10 int,
  m11 int,
  m12 int
);

insert into matrix(m, m01) values(1,  1);
insert into matrix(m, m02) values(2,  1);
insert into matrix(m, m03) values(3,  1);
insert into matrix(m, m04) values(4,  1);
insert into matrix(m, m05) values(5,  1);
insert into matrix(m, m06) values(6,  1);
insert into matrix(m, m07) values(7,  1);
insert into matrix(m, m08) values(8,  1);
insert into matrix(m, m09) values(9,  1);
insert into matrix(m, m10) values(10, 1);
insert into matrix(m, m11) values(11, 1);
insert into matrix(m, m12) values(12, 1);

SELECT OrderYear,
  SUM(m01*Freight) AS [1],
  SUM(m02*Freight) AS [2],
  SUM(m03*Freight) AS [3],
  SUM(m04*Freight) AS [4],
  SUM(m05*Freight) AS [5],
  SUM(m06*Freight) AS [6],
  SUM(m07*Freight) AS [7],
  SUM(m08*Freight) AS [8],
  SUM(m09*Freight) AS [9],
  SUM(m10*Freight) AS [10],
  SUM(m11*Freight) AS [11],
  SUM(m12*Freight) AS [12]
FROM (SELECT
        YEAR(OrderDate) AS OrderYear,
        MONTH(OrderDate) AS OrderMonth,
        Freight
      FROM dbo.Orders) AS D
  JOIN Matrix AS M
    ON D.OrderMonth = M.m
GROUP BY OrderYear;

-- 2005
SELECT *
FROM (SELECT
        YEAR(OrderDate) AS OrderYear,
        MONTH(OrderDate) AS OrderMonth,
        Freight
      FROM dbo.Orders) AS D
  PIVOT(SUM(Freight) FOR OrderMonth IN
    ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])) AS P;

---------------------------------------------------------------------
-- Auxiliary Tables
---------------------------------------------------------------------

-- Creating Nums
SET NOCOUNT ON;
USE AdventureWorks;
GO
IF OBJECT_ID('dbo.Nums') IS NOT NULL
  DROP TABLE dbo.Nums;
GO
CREATE TABLE dbo.Nums(n INT NOT NULL PRIMARY KEY);
DECLARE @max AS INT, @rc AS INT;
SET @max = 1000000;
SET @rc = 1;

INSERT INTO Nums VALUES(1);
WHILE @rc * 2 <= @max
BEGIN
  INSERT INTO dbo.Nums SELECT n + @rc FROM dbo.Nums;
  SET @rc = @rc * 2;
END

INSERT INTO dbo.Nums 
  SELECT n + @rc FROM dbo.Nums WHERE n + @rc <= @max;
GO

-- Separating elements
USE tempdb;
GO
IF OBJECT_ID('dbo.Arrays') IS NOT NULL
  DROP TABLE dbo.Arrays;
GO

CREATE TABLE dbo.Arrays
(
  arrid VARCHAR(10)   NOT NULL PRIMARY KEY,
  array VARCHAR(8000) NOT NULL
)

INSERT INTO Arrays(arrid, array) VALUES('A', '20,22,25,25,14');
INSERT INTO Arrays(arrid, array) VALUES('B', '30,33,28');
INSERT INTO Arrays(arrid, array) VALUES('C', '12,10,8,12,12,13,12,14,10,9');
INSERT INTO Arrays(arrid, array) VALUES('D', '-4,-6,-4,-2');
GO

-- Solution to Separating Elements Problem, Step 4
SELECT arrid,
  n - LEN(REPLACE(LEFT(array, n), ',', '')) + 1 AS pos,
  CAST(SUBSTRING(array, n, CHARINDEX(',', array + ',', n) - n)
       AS INT) AS element
FROM dbo.Arrays
  JOIN dbo.Nums
    ON n <= LEN(array)
    AND SUBSTRING(',' + array, n, 1) = ',';
GO

---------------------------------------------------------------------
-- Custom Aggregates
---------------------------------------------------------------------

-- Specialized string concatenation
USE Northwind;

SELECT CustomerID,
  (SELECT CAST(EmployeeID AS VARCHAR(10)) + ';' AS [text()]
   FROM (SELECT DISTINCT EmployeeID FROM Orders AS O
         WHERE O.CustomerID = C.CustomerID) AS E
   ORDER BY EmployeeID
   FOR XML PATH('')) AS Emps
FROM Customers AS C;

-- Specialized Median
USE pubs;
GO

WITH salesRN AS
(
  SELECT stor_id, qty,
    ROW_NUMBER() OVER(PARTITION BY stor_id ORDER BY qty) AS rownum,
    COUNT(*) OVER(PARTITION BY stor_id) AS cnt
  FROM sales
)
SELECT stor_id, AVG(1.*qty) AS median
FROM salesRN
WHERE ABS(rownum - (cnt - rownum + 1)) <= 1
GROUP BY stor_id;
GO

---------------------------------------------------------------------
-- Cursors
---------------------------------------------------------------------

-- Cursor Overhead

-- Compare simple table scan using set-based query vs. cursor
SET NOCOUNT ON;
USE tempdb;
GO
IF OBJECT_ID('dbo.T1') IS NOT NULL
  DROP TABLE dbo.T1;
GO
SELECT n AS keycol, CAST('a' AS CHAR(200)) AS filler
INTO dbo.T1
FROM dbo.Nums;

CREATE UNIQUE CLUSTERED INDEX idx_keycol ON dbo.T1(keycol);
GO

-- Turn on "Discard results after execution"
-- Clear data cache, run twice, and measure both runs (cold/warm cache)
DBCC DROPCLEANBUFFERS;
GO

-- Set-Based, 4/2 seconds
SELECT keycol, filler FROM dbo.T1;
GO

DBCC DROPCLEANBUFFERS;
GO

-- Cursor-Based, 22/20 seconds
DECLARE @keycol AS INT, @filler AS CHAR(200);
DECLARE C CURSOR FAST_FORWARD FOR SELECT keycol, filler FROM dbo.T1;
OPEN C
FETCH NEXT FROM C INTO @keycol, @filler;
WHILE @@fetch_status = 0
BEGIN
  -- Process data here
  FETCH NEXT FROM C INTO @keycol, @filler;
END
CLOSE C;
DEALLOCATE C;
GO

-- Order Based Access

-- Custom Aggregations

-- Creating and Populating the Groups Table
USE tempdb;
GO
IF OBJECT_ID('dbo.Groups') IS NOT NULL
  DROP TABLE dbo.Groups;
GO

CREATE TABLE dbo.Groups
(
  groupid  VARCHAR(10) NOT NULL,
  memberid INT         NOT NULL,
  string   VARCHAR(10) NOT NULL,
  val      INT         NOT NULL,
  PRIMARY KEY (groupid, memberid)
);
    
INSERT INTO dbo.Groups(groupid, memberid, string, val)
  VALUES('a', 3, 'stra1', 6);
INSERT INTO dbo.Groups(groupid, memberid, string, val)
  VALUES('a', 9, 'stra2', 7);
INSERT INTO dbo.Groups(groupid, memberid, string, val)
  VALUES('b', 2, 'strb1', 3);
INSERT INTO dbo.Groups(groupid, memberid, string, val)
  VALUES('b', 4, 'strb2', 7);
INSERT INTO dbo.Groups(groupid, memberid, string, val)
  VALUES('b', 5, 'strb3', 3);
INSERT INTO dbo.Groups(groupid, memberid, string, val)
  VALUES('b', 9, 'strb4', 11);
INSERT INTO dbo.Groups(groupid, memberid, string, val)
  VALUES('c', 3, 'strc1', 8);
INSERT INTO dbo.Groups(groupid, memberid, string, val)
  VALUES('c', 7, 'strc2', 10);
INSERT INTO dbo.Groups(groupid, memberid, string, val)
  VALUES('c', 9, 'strc3', 12);
GO

-- Cursor Code for Custom Aggregate
DECLARE
  @Result TABLE(groupid VARCHAR(10), product BIGINT);
DECLARE
  @groupid AS VARCHAR(10), @prvgroupid AS VARCHAR(10),
  @val AS INT, @product AS BIGINT;

DECLARE C CURSOR FAST_FORWARD FOR
  SELECT groupid, val FROM dbo.Groups ORDER BY groupid;

OPEN C

FETCH NEXT FROM C INTO @groupid, @val;
SELECT @prvgroupid = @groupid, @product = 1;

WHILE @@fetch_status = 0
BEGIN
  IF @groupid <> @prvgroupid
  BEGIN
    INSERT INTO @Result VALUES(@prvgroupid, @product);
    SELECT @prvgroupid = @groupid, @product = 1;
  END

  SET @product = @product * @val;
  
  FETCH NEXT FROM C INTO @groupid, @val;
END

IF @prvgroupid IS NOT NULL
  INSERT INTO @Result VALUES(@prvgroupid, @product);

CLOSE C;

DEALLOCATE C;

SELECT groupid, product FROM @Result;
GO

-- Running Aggregations

-- Creating and Populating the EmpOrders Table
USE tempdb;
GO

IF OBJECT_ID('dbo.EmpOrders') IS NOT NULL
  DROP TABLE dbo.EmpOrders;
GO

CREATE TABLE dbo.EmpOrders
(
  empid    INT      NOT NULL,
  ordmonth DATETIME NOT NULL,
  qty      INT      NOT NULL,
  PRIMARY KEY(empid, ordmonth)
);

INSERT INTO dbo.EmpOrders(empid, ordmonth, qty)
  SELECT O.EmployeeID, 
    CAST(CONVERT(CHAR(6), O.OrderDate, 112) + '01'
      AS DATETIME) AS ordmonth,
    SUM(Quantity) AS qty
  FROM Northwind.dbo.Orders AS O
    JOIN Northwind.dbo.[Order Details] AS OD
      ON O.OrderID = OD.OrderID
  GROUP BY EmployeeID,
    CAST(CONVERT(CHAR(6), O.OrderDate, 112) + '01'
      AS DATETIME);
GO

-- Set-Based Code for Running Aggregate
SELECT O1.empid, CONVERT(VARCHAR(7), O1.ordmonth, 121) AS ordmonth,
  O1.qty, SUM(O2.qty) AS totalqty, AVG(O2.qty) AS avgqty
FROM dbo.EmpOrders AS O1
  JOIN dbo.EmpOrders AS O2
    ON O2.empid = O1.empid
    AND O2.ordmonth <= O1.ordmonth
GROUP BY O1.empid, O1.ordmonth, O1.qty
ORDER BY O1.empid, O1.ordmonth;
GO

-- Cursor Code for Running Aggregate
DECLARE @Result
  TABLE(empid INT, ordmonth DATETIME, qty INT, runqty INT);
DECLARE
  @empid AS INT,@prvempid AS INT, @ordmonth DATETIME,
  @qty AS INT, @runqty AS INT;

DECLARE C CURSOR FAST_FORWARD FOR
  SELECT empid, ordmonth, qty
  FROM dbo.EmpOrders
  ORDER BY empid, ordmonth;

OPEN C

FETCH NEXT FROM C INTO @empid, @ordmonth, @qty;
SELECT @prvempid = @empid, @runqty = 0;

WHILE @@fetch_status = 0
BEGIN
  IF @empid <> @prvempid
    SELECT @prvempid = @empid, @runqty = 0;

  SET @runqty = @runqty + @qty;

  INSERT INTO @Result VALUES(@empid, @ordmonth, @qty, @runqty);
  
  FETCH NEXT FROM C INTO @empid, @ordmonth, @qty;
END

CLOSE C;

DEALLOCATE C;

SELECT empid, CONVERT(VARCHAR(7), ordmonth, 121) AS ordmonth,
  qty, runqty
FROM @Result
ORDER BY empid, ordmonth;
GO

-- Max Concurrent Sessions

-- Creating and Populating Sessions
USE tempdb;
GO
IF OBJECT_ID('dbo.Sessions') IS NOT NULL
  DROP TABLE dbo.Sessions;
GO

CREATE TABLE dbo.Sessions
(
  keycol    INT         NOT NULL IDENTITY PRIMARY KEY,
  app       VARCHAR(10) NOT NULL,
  usr       VARCHAR(10) NOT NULL,
  host      VARCHAR(10) NOT NULL,
  starttime DATETIME    NOT NULL,
  endtime   DATETIME    NOT NULL,
  CHECK(endtime > starttime)
);

INSERT INTO dbo.Sessions
  VALUES('app1', 'user1', 'host1', '20030212 08:30', '20030212 10:30');
INSERT INTO dbo.Sessions
  VALUES('app1', 'user2', 'host1', '20030212 08:30', '20030212 08:45');
INSERT INTO dbo.Sessions
  VALUES('app1', 'user3', 'host2', '20030212 09:00', '20030212 09:30');
INSERT INTO dbo.Sessions
  VALUES('app1', 'user4', 'host2', '20030212 09:15', '20030212 10:30');
INSERT INTO dbo.Sessions
  VALUES('app1', 'user5', 'host3', '20030212 09:15', '20030212 09:30');
INSERT INTO dbo.Sessions
  VALUES('app1', 'user6', 'host3', '20030212 10:30', '20030212 14:30');
INSERT INTO dbo.Sessions
  VALUES('app1', 'user7', 'host4', '20030212 10:45', '20030212 11:30');
INSERT INTO dbo.Sessions
  VALUES('app1', 'user8', 'host4', '20030212 11:00', '20030212 12:30');
INSERT INTO dbo.Sessions
  VALUES('app2', 'user8', 'host1', '20030212 08:30', '20030212 08:45');
INSERT INTO dbo.Sessions
  VALUES('app2', 'user7', 'host1', '20030212 09:00', '20030212 09:30');
INSERT INTO dbo.Sessions
  VALUES('app2', 'user6', 'host2', '20030212 11:45', '20030212 12:00');
INSERT INTO dbo.Sessions
  VALUES('app2', 'user5', 'host2', '20030212 12:30', '20030212 14:00');
INSERT INTO dbo.Sessions
  VALUES('app2', 'user4', 'host3', '20030212 12:45', '20030212 13:30');
INSERT INTO dbo.Sessions
  VALUES('app2', 'user3', 'host3', '20030212 13:00', '20030212 14:00');
INSERT INTO dbo.Sessions
  VALUES('app2', 'user2', 'host4', '20030212 14:00', '20030212 16:30');
INSERT INTO dbo.Sessions
  VALUES('app2', 'user1', 'host4', '20030212 15:30', '20030212 17:00');

CREATE INDEX idx_app_st_et ON dbo.Sessions(app, starttime, endtime);
GO

-- Set-based solution
SELECT app, MAX(concurrent) AS mx
FROM (SELECT app,
        (SELECT COUNT(*)
         FROM dbo.Sessions AS S2
         WHERE S1.app = S2.app
           AND S1.ts >= S2.starttime
           AND S1.ts < S2.endtime) AS concurrent
      FROM (SELECT DISTINCT app, starttime AS ts
            FROM dbo.Sessions) AS S1) AS C
GROUP BY app;
GO

-- Cursor Code for Max Concurrent Sessions Problem
DECLARE
  @app AS VARCHAR(10), @prevapp AS VARCHAR (10), @ts AS datetime,
  @type AS INT, @concurrent AS INT, @mx AS INT;

DECLARE @Result TABLE(app VARCHAR(10), mx INT);

DECLARE C CURSOR FAST_FORWARD FOR
  SELECT app, starttime AS ts, 1 AS type FROM dbo.Sessions
  UNION ALL
  SELECT app, endtime, -1 FROM dbo.Sessions
  ORDER BY app, ts, type;

OPEN C;

FETCH NEXT FROM C INTO @app, @ts, @type;
SELECT @prevapp = @app, @concurrent = 0, @mx = 0;

WHILE @@fetch_status = 0
BEGIN
  IF @app <> @prevapp
  BEGIN
    INSERT INTO @Result VALUES(@prevapp, @mx);
    SELECT @prevapp = @app, @concurrent = 0, @mx = 0;
  END

  SET @concurrent = @concurrent + @type;
  IF @concurrent > @mx SET @mx = @concurrent;
  
  FETCH NEXT FROM C INTO @app, @ts, @type;
END

IF @prevapp IS NOT NULL
  INSERT INTO @Result VALUES(@prevapp, @mx);

CLOSE C

DEALLOCATE C

SELECT * FROM @Result;
GO

-- Knapsack Problems

-- Code that Creates and Populates the Events and Rooms Tables
USE tempdb;
GO
IF OBJECT_ID('dbo.Events') IS NOT NULL
  DROP TABLE dbo.Events;
GO
IF OBJECT_ID('dbo.Rooms') IS NOT NULL
  DROP TABLE dbo.Rooms;
GO

CREATE TABLE dbo.Rooms
(
  roomid VARCHAR(10) NOT NULL PRIMARY KEY,
  seats INT NOT NULL
);

INSERT INTO dbo.Rooms(roomid, seats) VALUES('C001', 2000);
INSERT INTO dbo.Rooms(roomid, seats) VALUES('B101', 1500);
INSERT INTO dbo.Rooms(roomid, seats) VALUES('B102', 100);
INSERT INTO dbo.Rooms(roomid, seats) VALUES('R103', 40);
INSERT INTO dbo.Rooms(roomid, seats) VALUES('R104', 40);
INSERT INTO dbo.Rooms(roomid, seats) VALUES('B201', 1000);
INSERT INTO dbo.Rooms(roomid, seats) VALUES('R202', 100);
INSERT INTO dbo.Rooms(roomid, seats) VALUES('R203', 50);
INSERT INTO dbo.Rooms(roomid, seats) VALUES('B301', 600);
INSERT INTO dbo.Rooms(roomid, seats) VALUES('R302', 55);
INSERT INTO dbo.Rooms(roomid, seats) VALUES('R303', 55);

CREATE TABLE dbo.Events
(
  eventid INT NOT NULL PRIMARY KEY,
  eventdesc VARCHAR(25) NOT NULL,
  attendees INT NOT NULL
);

INSERT INTO dbo.Events(eventid, eventdesc, attendees)
  VALUES(1, 'Adv T-SQL Seminar', 203);
INSERT INTO dbo.Events(eventid, eventdesc, attendees)
  VALUES(2, 'Logic Seminar',     48);
INSERT INTO dbo.Events(eventid, eventdesc, attendees)
  VALUES(3, 'DBA Seminar',       212);
INSERT INTO dbo.Events(eventid, eventdesc, attendees)
  VALUES(4, 'XML Seminar',       98);
INSERT INTO dbo.Events(eventid, eventdesc, attendees)
  VALUES(5, 'Security Seminar',  892);
INSERT INTO dbo.Events(eventid, eventdesc, attendees)
  VALUES(6, 'Modeling Seminar',  48);
GO

CREATE INDEX idx_att_eid_edesc
  ON dbo.Events(attendees, eventid, eventdesc);
CREATE INDEX idx_seats_rid
  ON dbo.Rooms(seats, roomid);
GO

-- Cursor Code for Knapsack Problem (guaranteed fill)
DECLARE
  @roomid AS VARCHAR(10), @seats AS INT,
  @eventid AS INT, @attendies AS INT;

DECLARE @Result TABLE(roomid  VARCHAR(10), eventid INT);

DECLARE CRooms CURSOR FAST_FORWARD FOR
  SELECT roomid, seats FROM dbo.Rooms
  ORDER BY seats, roomid;
DECLARE CEvents CURSOR FAST_FORWARD FOR
  SELECT eventid, attendees FROM dbo.Events
  ORDER BY attendees, eventid;

OPEN CRooms;
OPEN CEvents;

FETCH NEXT FROM CEvents INTO @eventid, @attendies;
WHILE @@FETCH_STATUS = 0
BEGIN
  FETCH NEXT FROM CRooms INTO @roomid, @seats;

  WHILE @@FETCH_STATUS = 0 AND @seats < @attendies
    FETCH NEXT FROM CRooms INTO @roomid, @seats;

  IF @@FETCH_STATUS = 0
    INSERT INTO @Result(roomid, eventid) VALUES(@roomid, @eventid);
  ELSE
  BEGIN
    RAISERROR('Not enough rooms for events.', 16, 1);
    BREAK;
  END

  FETCH NEXT FROM CEvents INTO @eventid, @attendies;
END

CLOSE CRooms;
CLOSE CEvents;

DEALLOCATE CRooms;
DEALLOCATE CEvents;

SELECT roomid, eventid FROM @Result;
GO

---------------------------------------------------------------------
-- Temporary Tables
---------------------------------------------------------------------

-- Table variables have tempdb representation
SELECT TABLE_NAME FROM tempdb.INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '%#%';
GO
DECLARE @T TABLE(col1 INT);
INSERT INTO @T VALUES(1);
SELECT TABLE_NAME FROM tempdb.INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '%#%';
GO

-- Statistics

-- Table Variable Example
DECLARE @T TABLE
(
  col1 INT NOT NULL PRIMARY KEY,
  col2 INT NOT NULL,
  filler CHAR(200) NOT NULL DEFAULT('a'),
  UNIQUE(col2, col1)
);

INSERT INTO @T(col1, col2)
  SELECT n, (n - 1) % 100000 + 1 FROM dbo.Nums
  WHERE n <= 100000;

SELECT * FROM @T WHERE col1 = 1;
SELECT * FROM @T WHERE col1 <= 50000;

SELECT * FROM @T WHERE col2 = 1;
SELECT * FROM @T WHERE col2 <= 2;
SELECT * FROM @T WHERE col2 <= 5000;
GO

-- Temp Table Example
SELECT n AS col1, (n - 1) % 100000 + 1 AS col2,
  CAST('a' AS CHAR(200)) AS filler
INTO #T
FROM dbo.Nums
WHERE n <= 100000;

ALTER TABLE #T ADD PRIMARY KEY(col1);
CREATE UNIQUE INDEX idx_col2_col1 ON #T(col2, col1);
GO

SELECT * FROM #T WHERE col1 = 1;
SELECT * FROM #T WHERE col1 <= 50000;

SELECT * FROM #T WHERE col2 = 1;
SELECT * FROM #T WHERE col2 <= 2;
SELECT * FROM #T WHERE col2 <= 5000;
GO

-- Cleanup
DROP TABLE #T;
GO

---------------------------------------------------------------------
-- Row Versioning and Concurrency
---------------------------------------------------------------------

-- New Isolation Levels
set nocount on;
use master;
go
drop database testdb;
go
create database testdb;
alter database testdb set read_committed_snapshot on;
alter database testdb set allow_snapshot_isolation on;
go
use testdb;
go

create table t1(col1 int);
insert into t1 values(1);

-- con1
begin tran

update t1 set col1 = col1 + 1;

select * from t1;

-- con2
use testdb;

set transaction isolation level read committed

begin tran

select * from t1;

-- con3
use testdb;

set transaction isolation level snapshot

begin tran

select * from t1;

-- con1
commit

-- rerun select in con2, con3
select * from t1;

-- run update in con2, con3
update t1 set col1 = 10;

-- system catalog
select * from sys.dm_exec_sessions
select * from sys.dm_exec_connections 
select * from sys.dm_exec_requests 
select * from sys.dm_tran_locks
select * from sys.dm_exec_sql_text(...handle...)
select * from sys.dm_tran_database_transactions 
select * from sys.dm_tran_session_transactions
select * from sys.dm_tran_active_transactions
select * from sys.dm_os_tasks
select * from sys.dm_os_waiting_tasks
GO
