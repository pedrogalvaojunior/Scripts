/* Como informado anteriormente, quando � criado o ColumnStore Index em uma tabela, essa tabela passa a ser �Read-Only� 
com isso se tentarmos alterar ou adicionar um novo registro a essa tabela, veremos que:*/

BEGIN TRANSACTION
SELECT @@TRANCOUNT

UPDATE dbo.factProductInventory
     SET UnitCost = '332.24' 
WHERE DateKey = 20071021 

ROLLBACK TRANSACTION
GO

--Desabilitando o �ndice e tentando novamente�.
ALTER INDEX ColumStoreIndex_FactProductInventory
ON dbo.FactProductInventory DISABLE
GO

BEGIN TRANSACTION
SELECT @@TRANCOUNT

UPDATE dbo.factProductInventory
     SET UnitCost = '332.24' 
WHERE DateKey = 20071021 
GO

SELECT *
FROM dbo.FactProductInventory
WHERE DateKey = 20071021
And UnitCost = '332.24'

COMMIT TRANSACTION

/*Na vers�o RC0 do SQL Server 2012 Codename Denali, n�o era poss�vel utilizar a op��o REBUILD PARTITION, para poder utilizar novamente o 
ColumnStore Index na tabela era necess�rio realizar a exclus�o e cria��o novamente do �ndice, agora com a vers�o RTM � possivel realizar o REBUILD.*/
ALTER INDEX ColumStoreIndex_FactProductInventory
ON dbo.FactInternetSales REBUILD PARTITION = ALL
GO