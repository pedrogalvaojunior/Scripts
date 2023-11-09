Alter Database [AdventureWorks2014]
Set Compatibility_Level = 100

SET DATEFORMAT dmy; 

DECLARE @t2 date = '12/5/2011' ;

SET LANGUAGE dutch; 
SELECT CONVERT(varchar(11), @t2, 106); 
Go

-- Results when the compatibility level is less than 120. 
12 May 2011 

Alter Database [AdventureWorks2014]
Set Compatibility_Level = 120

SET DATEFORMAT dmy; 

DECLARE @t2 date = '12/5/2011' ;

SET LANGUAGE dutch; 
SELECT CONVERT(varchar(11), @t2, 106); 

-- Results when the compatibility level is set to 120).
12 mei 2011