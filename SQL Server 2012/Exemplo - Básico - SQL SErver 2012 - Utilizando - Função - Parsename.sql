-- USING SQL SERVER 2012
DECLARE @t TABLE (A varchar(25)) 

INSERT @t values ('77.88.99.100')  

SELECT 
  PARSENAME(A,1) AS 'First selected'
, PARSENAME(A,2) AS '2nd selected' 
, PARSENAME(A,3) AS '3rd selected'
, PARSENAME(A,4) AS '4th selected'
 from @t 


USE AdventureWorks2012;
SELECT PARSENAME('AdventureWorks2012..Person', 1) AS 'Object Name';
SELECT PARSENAME('AdventureWorks2012..Person', 2) AS 'Schema Name';
SELECT PARSENAME('AdventureWorks2012..Person', 3) AS 'Database Name';
SELECT PARSENAME('AdventureWorks2012..Person', 4) AS 'Server Name';
GO