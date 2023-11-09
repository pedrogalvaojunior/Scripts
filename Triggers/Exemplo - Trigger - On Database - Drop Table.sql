CREATE TRIGGER T_DROP_TABLE 
ON DATABASE 
FOR DROP_TABLE 
AS 
BEGIN 
       PRINT 'Você não possui permissão para esta operação'
       ROLLBACK TRANSACTION
END
GO