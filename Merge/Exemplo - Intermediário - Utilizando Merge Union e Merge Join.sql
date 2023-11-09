USE AdventureWorks2012;
  GO

-- Exemplo - Merge Union --
SELECT BusinessEntityID, JobTitle, HireDate, VacationHours, SickLeaveHours
FROM HumanResources.Employee AS e1
  
UNION
  
SELECT BusinessEntityID, JobTitle, HireDate, VacationHours, SickLeaveHours
FROM HumanResources.Employee AS e2
OPTION (MERGE UNION);
GO

-- Exemplo - Merge Join --
SELECT * FROM Sales.Customer AS c INNER JOIN Sales.vStoreWithAddresses AS sa 
                                                             ON c.CustomerID = sa.BusinessEntityID
WHERE TerritoryID = 5
OPTION (MERGE JOIN);
GO