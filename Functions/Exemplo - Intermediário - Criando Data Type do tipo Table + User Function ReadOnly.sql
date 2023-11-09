CREATE TYPE dbo.MyTable AS TABLE
     (CountryCode CHAR(2)
     ,CountryName VARCHAR(250)) 
GO

CREATE FUNCTION dbo.Test (@MyTable MyTable READONLY) 
 RETURNS TABLE 
RETURN SELECT CountryCode, CountryName
        FROM @MyTable 
GO

DECLARE @T MyTable
INSERT INTO @T 
 SELECT 'US', 'UNITED STATES' 
 UNION ALL 
 SELECT 'CA', 'CANADA'

SELECT * FROM dbo.Test(@T) 
GO

DECLARE @T MyTable

INSERT INTO @T 
 SELECT 'US', 'UNITED STATES' 
 UNION ALL 
 SELECT 'CA', 'CANADA'

SELECT *
 FROM dbo.Test((SELECT CountryCode, CountryName FROM @T))
GO

DROP FUNCTION dbo.Test; 
DROP TYPE dbo.MyTable; 
GO