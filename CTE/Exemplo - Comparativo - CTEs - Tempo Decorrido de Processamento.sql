IF OBJECT_ID('Tab1') IS NOT NULL
  DROP TABLE Tab1
GO
CREATE TABLE Tab1 (ID Int IDENTITY(1,1) PRIMARY KEY, Col1 Int NOT NULL)
GO
CREATE INDEX ixCol1 ON Tab1(Col1)
GO
INSERT INTO Tab1(Col1) VALUES (1), (2), (3), (4), (5)
GO
IF OBJECT_ID('Tab2') IS NOT NULL
  DROP TABLE Tab2
GO
CREATE TABLE Tab2 (ID Int IDENTITY(1,1) PRIMARY KEY, Col1 Int NOT NULL)
GO
CREATE INDEX ixCol1 ON Tab2(Col1)
GO
INSERT INTO Tab2(Col1) VALUES (6), (7)
GO
IF OBJECT_ID('Tab3') IS NOT NULL
  DROP TABLE Tab3
GO
CREATE TABLE Tab3 (ID Int IDENTITY(1,1) PRIMARY KEY, Col1 Int NOT NULL)
GO
CREATE INDEX ixCol1 ON Tab3(Col1)
GO
INSERT INTO Tab3(Col1) VALUES (8), (9)
GO
 
 
-- Query 1
WITH CTE_1
AS
(
SELECT Col1 FROM Tab1
UNION ALL
SELECT Col1 FROM Tab2
UNION ALL
SELECT Col1 FROM Tab3
)
SELECT MAX(Col1)
  FROM CTE_1
GO
-- Query 2
WITH CTE_1
AS
(
SELECT MAX(Col1) AS Col1 FROM Tab1
UNION ALL
SELECT MAX(Col1) FROM Tab2
UNION ALL
SELECT MAX(Col1) FROM Tab3
)
SELECT MAX(Col1)
  FROM CTE_1
GO