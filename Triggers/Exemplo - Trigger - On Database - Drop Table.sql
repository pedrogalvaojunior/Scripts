CREATE TRIGGER T_DROP_TABLE 
ON DATABASE 
FOR DROP_TABLE 
AS 
BEGIN 
       PRINT 'Voc� n�o possui permiss�o para esta opera��o'
       ROLLBACK TRANSACTION
END
GO