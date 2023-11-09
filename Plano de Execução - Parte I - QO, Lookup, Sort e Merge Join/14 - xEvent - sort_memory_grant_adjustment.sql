/*
  Sr.Nimbus - OnDemand
  http://www.srnimbus.com.br
*/

------------------------------------
------------- xEvent ---------------
--- sort_memory_grant_adjustment ---
------------------------------------

USE NorthWind
GO


IF OBJECT_ID('TestOrdersBig_AdditionalMemoryGrant') IS NOT NULL
  DROP TABLE TestOrdersBig_AdditionalMemoryGrant
GO
SELECT TOP 1000000 * 
  INTO TestOrdersBig_AdditionalMemoryGrant
  FROM OrdersBig

/*
  A pergunta que n�o quer calar, se o existe mem�ria dispon�vel 
  no servidor, porque n�o pegar mais mem�ria em tempo de execu��o
  da ordena��o para evitar o SortWarning (acesso a disco)?

  De fato o SQL Server faz isso para ordena��o na cria��o de um �ndice
*/
CHECKPOINT; DBCC DROPCLEANBUFFERS;
GO
-- Sort warning
DECLARE @i Int
SELECT @i = OrderID
  FROM TestOrdersBig_AdditionalMemoryGrant
 ORDER BY CustomerID, OrderID
OPTION (MAXDOP 1, RECOMPILE)


/*
  Plano n�o gera sort Warning porque ele pega mem�ria "on the fly"
  ou seja, durante a execu��o da ordena��o o SQL utiliza mais mem�ria
  do que o inicialmente estimado como necess�rio.
  Podemos visualizar isso acontecendo de 2 formas:
  1 - Consultando a sys.dm_exec_query_memory_grants veremos que granted_memory_kb � 
  maior que requested_memory_kb.
  2 - xEvents additional_memory_grant e sort_memory_grant_adjustment
*/
CHECKPOINT; DBCC DROPCLEANBUFFERS
GO
CREATE INDEX ix1 ON TestOrdersBig_AdditionalMemoryGrant(CustomerID, OrderID) WITH(MAXDOP = 1)
GO
IF EXISTS(SELECT 1 FROM sysindexes WHERE name = 'ix1' and id = OBJECT_ID('TestOrdersBig_AdditionalMemoryGrant'))
  DROP INDEX ix1 ON TestOrdersBig_AdditionalMemoryGrant
GO





/*
  Scripts uteis

-- Set 1GB of memory to the server
EXEC sys.sp_configure N'show advanced options', N'1'  RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'max server memory (MB)', N'1024'
GO
RECONFIGURE WITH OVERRIDE
GO

-- Preparando a tabela para testes
-- 1:10 minuto para rodar
USE NorthWind
GO
IF OBJECT_ID('TestOrdersBig_AdditionalMemoryGrant') IS NOT NULL
BEGIN
  DROP TABLE TestOrdersBig_AdditionalMemoryGrant
END
GO
SELECT TOP 1000000 IDENTITY(Int, 1,1) AS OrderID,
       A.CustomerID,
       CONVERT(Date, GETDATE() - (CheckSUM(NEWID()) / 1000000)) AS OrderDate,
       ISNULL(ABS(CONVERT(Numeric(18,2), (CheckSUM(NEWID()) / 1000000.5))),0) AS Value
  INTO TestOrdersBig_AdditionalMemoryGrant
  FROM Orders A
 CROSS JOIN Orders B
 CROSS JOIN Orders C
 CROSS JOIN Orders D
GO
ALTER TABLE TestOrdersBig_AdditionalMemoryGrant ADD CONSTRAINT xpk_TestOrdersBig_AdditionalMemoryGrant PRIMARY KEY(OrderID)
GO
*/