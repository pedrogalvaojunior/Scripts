/* A. Add target time zone offset to datetime without offset information 
Use AT TIME ZONE to add offset based on time zone rules when you know that the original datetime values are provided in the same time zone:*/

USE AdventureWorks2016;  
GO  
  
SELECT SalesOrderID, OrderDate,   
    OrderDate AT TIME ZONE 'Pacific Standard Time' AS OrderDate_TimeZonePST  
FROM Sales.SalesOrderHeader;  



/*B. Convert values between different time zones
The following example converts values between different time zones: */

USE AdventureWorks2016;  
GO  
  
SELECT SalesOrderID, OrderDate,   
    OrderDate AT TIME ZONE 'Pacific Standard Time' AS OrderDate_TimeZonePST,  
    OrderDate AT TIME ZONE 'Pacific Standard Time'   
    AT TIME ZONE 'Central European Standard Time' AS OrderDate_TimeZoneCET  
FROM Sales.SalesOrderHeader;  



/*C. Query Temporal Tables using local time zone
The following example example selects data from a temporal table.*/
USE AdventureWorks2016;  
GO  
  
DECLARE @ASOF datetimeoffset;  
SET @ASOF = DATEADD (month, -1, GETDATE()) AT TIME ZONE 'UTC';  
  
-- Query state of the table a month ago projecting period   
-- columns as Pacific Standard Time  
SELECT BusinessEntityID, PersonType, NameStyle, Title,   
    FirstName, MiddleName,  
    ValidFrom AT TIME ZONE 'Pacific Standard Time',  
    ValidTo AT TIME ZONE 'Pacific Standard Time'   
FROM  Person.Person_Temporal  
FOR SYSTEM_TIME AS OF @ASO;  