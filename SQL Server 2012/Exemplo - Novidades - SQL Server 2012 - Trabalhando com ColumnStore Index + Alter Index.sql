/* Como informado anteriormente, quando é criado o ColumnStore Index em uma tabela, essa tabela passa a ser “Read-Only” 
com isso se tentarmos alterar ou adicionar um novo registro a essa tabela, veremos que:*/

BEGIN TRANSACTION
SELECT @@TRANCOUNT

UPDATE dbo.factProductInventory
     SET UnitCost = '332.24' 
WHERE DateKey = 20071021 

ROLLBACK TRANSACTION
GO

--Desabilitando o índice e tentando novamente….
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

/*Na versão RC0 do SQL Server 2012 Codename Denali, não era possível utilizar a opção REBUILD PARTITION, para poder utilizar novamente o 
ColumnStore Index na tabela era necessário realizar a exclusão e criação novamente do índice, agora com a versão RTM é possivel realizar o REBUILD.*/
ALTER INDEX ColumStoreIndex_FactProductInventory
ON dbo.FactInternetSales REBUILD PARTITION = ALL
GO