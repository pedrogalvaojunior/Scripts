USE AdventureWorks2016
GO

SELECT Concat(DB_NAME(database_id), '.' ,  OBJECT_SCHEMA_NAME(OBJECT_ID, database_id), '.',  OBJECT_NAME(OBJECT_ID, database_id)) AS Function_Name,
             QS.last_execution_time ,
             QS.max_worker_time ,
	         QS.max_physical_reads ,
             QS.max_logical_reads ,
             QS.max_logical_writes ,
             T.Text
FROM    sys.dm_exec_function_stats QS
        CROSS APPLY sys.dm_exec_sql_text(sql_handle) T
Where  database_id = DB_ID()
Order by last_execution_time

Select  ProductID, 
             LocationID, 
			 Shelf, 
			 Bin, 
			 Quantity, 
			 ModifiedDate,
			 dbo.ufnGetStock(ProductInventory.ProductID)  As 'Stock',
             dbo.ufnGetProductDealerPrice(ProductInventory.ProductID, GETDATE()) As 'Dealer Price',
             dbo.ufnGetProductStandardCost(ProductInventory.ProductID, GETDATE()-100) As 'Standard Cost'
From Production.ProductInventory


