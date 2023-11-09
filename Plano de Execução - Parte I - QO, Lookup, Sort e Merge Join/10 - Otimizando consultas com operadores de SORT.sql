/*
  Sr.Nimbus - OnDemand
  http://www.srnimbus.com.br
*/

-------------------------------
------------ Sort -------------
-------------------------------
USE NorthWind
GO

-- Consulta simples para mostrar o Sort por CompanyName
SELECT CustomerID, CompanyName, ContactName
  FROM CustomersBig
 ORDER BY CompanyName
OPTION (RECOMPILE)
GO

-- Basta criar um �ndice simples por CompanyName para remover o sort ?
-- DROP INDEX ixCompanyName ON CustomersBig 
CREATE INDEX ixCompanyName ON CustomersBig (CompanyName)
GO

-- Testando a consulta novamente, sort continua... Porque n�o usou o �ndice? 
SELECT CustomerID, CompanyName, ContactName
  FROM CustomersBig
 ORDER BY CompanyName
OPTION (RECOMPILE)

-- For�ando uso do �ndice para ver se o SQL usa...
SELECT CustomerID, CompanyName, ContactName
  FROM CustomersBig WITH(index=ixCompanyName)
 ORDER BY CompanyName
OPTION (RECOMPILE)
-- Nasty plan, n�o fa�a isso em casa!



-- Incluindo a coluna ContactName no �ndice
CREATE INDEX ixCompanyName ON CustomersBig (CompanyName) INCLUDE(ContactName) WITH(DROP_EXISTING=ON)
GO

-- Testando a consulta novamente 
SELECT CustomerID, CompanyName, ContactName
  FROM CustomersBig
 ORDER BY CompanyName
OPTION (RECOMPILE)


-- Sort sem ORDER BY? 
SELECT *
  FROM ProductsBig 
 INNER MERGE JOIN Order_DetailsBig
    ON Order_DetailsBig.ProductID = ProductsBig.ProductID
 INNER JOIN OrdersBig
    ON OrdersBig.OrderID = Order_DetailsBig.OrderID
GO
-- Merge Join precisa que os dados estejam ordenados por ProductID


-- Criando �ndice para evitar sort
-- DROP INDEX ixProducID ON Order_DetailsBig 
CREATE INDEX ixProducID ON Order_DetailsBig (ProductID) INCLUDE(Shipped_Date, Quantity)

-- Sort sumiu? 
SELECT *
  FROM ProductsBig 
 INNER MERGE JOIN Order_DetailsBig
    ON Order_DetailsBig.ProductID = ProductsBig.ProductID
 INNER JOIN OrdersBig
    ON OrdersBig.OrderID = Order_DetailsBig.OrderID
GO