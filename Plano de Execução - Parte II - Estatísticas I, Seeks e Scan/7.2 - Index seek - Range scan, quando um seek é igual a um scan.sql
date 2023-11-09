/*
  Sr.Nimbus - OnDemand
  http://www.srnimbus.com.br
*/

USE NorthWind
GO

/*
  Quando um Index Seek � na verdade um Index Scan
*/


-- Aqui o SQL utiliza o �ndice corretamente
SELECT * 
  FROM ProductsBig
 WHERE ProductName LIKE 'Guaran� Fant�stica 07%'
OPTION (RECOMPILE, MAXDOP 1)
GO

-- J� quando utilizamos o % no come�o da strig o 
-- SQL n�o faz o seek
SELECT * 
  FROM ProductsBig
 WHERE ProductName LIKE '%Guaran� Fant�stica 07%'
OPTION (RECOMPILE, MAXDOP 1)
GO

IF OBJECT_ID('st_RetornaProductsBig', 'P') IS NOT NULL
  DROP PROC st_RetornaProductsBig
GO
CREATE PROC st_RetornaProductsBig @vProductName VarChar(250)
WITH RECOMPILE
AS
BEGIN
  SELECT * 
    FROM ProductsBig
   WHERE ProductName LIKE @vProductName
END
GO

-- Utiliza o �ndice
EXEC dbo.st_RetornaProductsBig '%Guaran� Fant�stica 07%'


-- Continua usando �ndice e fazendo o seek
-- Mas est� fazendo um scan nas p�ginas do �ndice, compare a quantidade de 
-- p�ginas para fazer o scan vs o seek do comando abaixo
SET STATISTICS IO ON
EXEC dbo.st_RetornaProductsBig '%Guaran� Fant�stica 07%'
GO
SELECT * 
  FROM ProductsBig
 WHERE ProductName LIKE '%Guaran� Fant�stica 07%'
OPTION (RECOMPILE, MAXDOP 1)
SET STATISTICS IO OFF