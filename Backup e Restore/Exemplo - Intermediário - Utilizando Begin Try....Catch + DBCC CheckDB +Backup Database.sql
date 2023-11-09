DECLARE 
 @ErrorMessage varchar(245),
 @ErrorSeverity int,
 @ErrorState int

BEGIN TRY
 DBCC CHECKDB ('MyDatabase') WITH NO_INFOMSGS
END TRY

BEGIN CATCH
 SELECT 
 @ErrorMessage = ERROR_MESSAGE(),
 @ErrorSeverity = ERROR_SEVERITY(),
 @ErrorState = ERROR_STATE()
 RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState)
 RETURN 
END CATCH

BACKUP DATABASE MyDatabase TO DISK = 'C:\MyDatabase\MyDatabase_Full.BAK'