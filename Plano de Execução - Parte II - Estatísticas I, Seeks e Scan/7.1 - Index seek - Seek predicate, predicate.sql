/*
  Sr.Nimbus - OnDemand
  http://www.srnimbus.com.br
*/

USE NorthWind
GO

/*
  Index seek - Seek predicate, predicate
*/

-- DROP INDEX ixOrderDate ON OrdersBig 
CREATE INDEX ixOrderDate ON OrdersBig (OrderDate)
GO


-- Seek predicate � utilizado para navegar pela �rvore do �ndice
SELECT * 
  FROM OrdersBig
 WHERE OrderID = 100
GO

-- Predicate � aplicado como filtro depois da navega��o pela �rvore
SELECT * 
  FROM OrdersBig
 WHERE OrderDate BETWEEN '20120101' AND '20120110'
   AND OrderID < 100000

/*
  Pergunta... temos 2 �ndices na tabela OrdersBig, um por OrderID (PK)
  e outro por OrderDate

  Qual � a melhor forma de acesso? Qual �ndice?

  Depende da seletividade dos filtros.

  Se o filtro por OrderID for mais seletivo, usa o �ndice por OrderID
  Se o filtro por OrderDate for mais seletivo, usa o �ndice por OrderDate
*/

-- Exemplo, filtro seletivo por OrderID
-- Faz seek predicate por OrderID e aplica predicate por OrderDate
SELECT * 
  FROM OrdersBig
 WHERE OrderDate BETWEEN '20120101' AND '20120110'
   AND OrderID < 1000
GO

-- Exemplo, filtro seletivo por OrderID
-- Faz seek predicate por OrderDate e aplica predicate por OrderID
SELECT * 
  FROM OrdersBig
 WHERE OrderDate BETWEEN '20120101' AND '20120101'
   AND OrderID < 1000