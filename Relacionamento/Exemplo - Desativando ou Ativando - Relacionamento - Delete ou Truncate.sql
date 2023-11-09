EXEC sp_MSForEachTable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'
 
EXEC sp_MSForEachTable '
 IF OBJECTPROPERTY(object_id(''?''), ''TableHasForeignRef'') = 1
 DELETE FROM ?
 else
 TRUNCATE TABLE ?
 '
 GO
 
-- reativar a integridade refencial
 EXEC sp_MSForEachTable 'ALTER TABLE ? CHECK CONSTRAINT ALL'
 GO