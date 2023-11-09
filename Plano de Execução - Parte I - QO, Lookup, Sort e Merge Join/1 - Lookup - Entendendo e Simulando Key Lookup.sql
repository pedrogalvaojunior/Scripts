/*
  Sr.Nimbus - OnDemand
  http://www.srnimbus.com.br
*/

USE NorthWind
GO

-- Pegar um CompanyName para usar como exemplo
SELECT CompanyName
  FROM CustomersBig
 WHERE CustomerID = 50000
GO

-- Exemplo de falta de �ndice nonclustered
SET STATISTICS IO ON
SELECT CustomerID, CompanyName, Col1 
  FROM CustomersBig
 WHERE CompanyName = 'QUICK-Stop 763CB129'
SET STATISTICS IO OFF

-- Na aus�ncia da palavra NONCLUSTERED
-- o �ndice � considerado NONCLUSTERED.
-- DROP INDEX ix_CompanyName ON CustomersBig
CREATE NONCLUSTERED INDEX ix_CompanyName ON CustomersBig(CompanyName)
GO

/*
  Agora a consulta pode fazer proveito do �ndice ix_CompanyName
*/
SET STATISTICS IO ON
SELECT CustomerID, CompanyName, Col1 
  FROM CustomersBig
 WHERE CompanyName = 'QUICK-Stop 763CB129'
SET STATISTICS IO OFF

/*
  Novamente, vamos simular os 6 IOs usando o DBCC PAGE
*/
-- Vamos identificar a p�gina Root do �ndice ix_CompanyName
SELECT dbo.fn_HexaToDBCCPAGE(Root) 
  FROM sys.sysindexes
 WHERE name = 'ix_CompanyName'
   AND id = OBJECT_ID ('CustomersBig')

-- Vamos navegar pelo �ndice a partir da p�gina Raiz procurando pelo Value
-- CustomerID = 50000
DBCC TRACEON (3604)
DBCC PAGE (Northwind,1,480962,3) -- 1 Leitura
DBCC PAGE (Northwind,1,480935,3) -- 2 Leitura
DBCC PAGE (Northwind,1,484686,3) -- 3 Leitura Encontramos o CompanyName = 'QUICK-Stop 763CB129'

-- Com o CustomerID 50000, vamos navegar pelo �ndice cluster para 
-- achar o Value da coluna Col1, pois ela n�o pertence ao �ndice

SELECT dbo.fn_HexaToDBCCPAGE(Root)
  FROM sys.sysindexes
 WHERE name = 'xpk_CustomersBig'
   AND id = OBJECT_ID ('CustomersBig')

DBCC PAGE (Northwind,1,23114,3) -- 4 Leitura
DBCC PAGE (Northwind,1,23113,3) -- 5 Leitura
DBCC PAGE (Northwind,1,26564,3) -- 6 Leitura Encontramos o CustomerID = 50000