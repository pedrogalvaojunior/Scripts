-- Exemplo 1 --
CREATE TABLE tblPopulation 
(Country VARCHAR(100),
 [State] VARCHAR(100),
 City VARCHAR(100),
 [Population (in Millions)] INT)
GO

INSERT INTO tblPopulation VALUES('India', 'Delhi','East&nbsp;Delhi',9 )
INSERT INTO tblPopulation VALUES('India', 'Delhi','South&nbsp;Delhi',8 )
INSERT INTO tblPopulation VALUES('India', 'Delhi','North&nbsp;Delhi',5.5)
INSERT INTO tblPopulation VALUES('India', 'Delhi','West&nbsp;Delhi',7.5)
INSERT INTO tblPopulation VALUES('India', 'Karnataka','Bangalore',9.5)
INSERT INTO tblPopulation VALUES('India', 'Karnataka','Belur',2.5)
INSERT INTO tblPopulation VALUES('India', 'Karnataka','Manipal',1.5)
INSERT INTO tblPopulation VALUES('India', 'Maharastra','Mumbai',30)
INSERT INTO tblPopulation VALUES('India', 'Maharastra','Pune',20)
INSERT INTO tblPopulation VALUES('India', 'Maharastra','Nagpur',11 )
INSERT INTO tblPopulation VALUES('India', 'Maharastra','Nashik',6.5)
GO

SELECT Country,
       [State],
	   City,
       SUM ([Population (in Millions)]) AS [Population (in Millions)]
FROM tblPopulation
GROUP BY Country,[State],City WITH ROLLUP
Go

-- Exemplo 2 --
CREATE TABLE dbo.GroupingNULLS 
(Store nvarchar(19),
 SaleYear nvarchar(4),
 SaleMonth nvarchar (7))
Go

INSERT INTO dbo.GroupingNULLS 
 VALUES (NULL,NULL,'January'),
        (NULL,'2002',NULL),
		(NULL,NULL,NULL),
		('Active Cycling',NULL ,'January'),
		('Active Cycling','2002',NULL),
		('Active Cycling',NULL ,NULL),
		('Active Cycling',NULL,'January'),
		('Active Cycling','2003','Febuary'),
		('Active Cycling','2003',NULL),
		('Mountain Bike Store','2002','January'),
		('Mountain Bike Store','2002',NULL),
		('Mountain Bike Store',NULL,NULL),
		('Mountain Bike Store','2003','January'),
		('Mountain Bike Store','2003','Febuary'),
		('Mountain Bike Store','2003','March')
Go

SELECT 
 ISNULL(Store, CASE WHEN GROUPING(Store) = 0 THEN 'UNKNOWN' ELSE 'ALL' END) AS Store,
 ISNULL(CAST(SaleYear AS nvarchar(7)), CASE WHEN GROUPING(SaleYear)= 0 THEN 'UNKNOWN' ELSE 'ALL' END) AS SalesYear,  
 ISNULL(SaleMonth, CASE WHEN GROUPING(SaleMonth) = 0 THEN 'UNKNOWN' ELSE 'ALL'END) AS SalesMonth,
 COUNT(*) AS Count
FROM dbo.GroupingNULLS 
GROUP BY ROLLUP(Store, SaleYear, SaleMonth)
Go