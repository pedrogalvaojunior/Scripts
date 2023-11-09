SELECT COUNT(*) AS [Count] FROM Production.Product
--
SELECT COUNT(*) AS [Count], 
COUNT(Class) AS [Classes with values]
 FROM Production.Product
--
SELECT COUNT(DISTINCT CardType) AS [Different Credit Cards]  FROM Sales.CreditCard
--
SELECT COUNT(*) AS [In Seattle] FROM Person.Address 
WHERE (City = 'Seattle')
--
SELECT City, COUNT(*) AS [Count of Customers] 
FROM Person.Address GROUP BY City
--
SELECT City, COUNT(*) AS [Count of Customers]
FROM Person.Address
GROUP BY City
ORDER BY City
--
SELECT City, COUNT(*) AS [Count of Customers]
FROM Person.Address
GROUP BY City
HAVING (COUNT(*) > 50)
ORDER BY City


