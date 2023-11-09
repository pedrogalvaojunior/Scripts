USE AdventureWorks
GO
CREATE PROCEDURE USP_DisableEnableNonClusteredIndexes  (@DB_NAME SYSNAME ,@CHANGERECOVERYMODEL CHAR(1) = 'N' ,@MODEID CHAR(1))
AS
-- ************** Functionality ********************
-- This script Disables or Enables Non-Clustered indexes that are not part of a primary key or unique key.

-- ************** Input Parameters ********************
-- @Db_Name, Name of database for which you want to disable /Rebuild Non-Clustered Indexes
-- @ChangeRecoveryModel, Do you want to change Recovery Model values Y or N , applies to only Enabling Index and for database which are not in Simple Recovery Model.
-- MODEID = 1 SCRIPT DISABLES ALL NON-CLUSTERED INDEXES.
-- MODEID = 2 SCRIPT ENABLES / REBUILD ALL NON-CLUSTERED INDEXES.

--  ******************** Compatiblility  ********************
-- Compatible with Sql Server 2005 and higher versions.

SET NOCOUNT ON
DECLARE @RECOVERYMODEL VARCHAR(20)
DECLARE @SQL1 VARCHAR(1000)
DECLARE @SQL2 VARCHAR(1000)
DECLARE @SQL3 VARCHAR(1000)
DECLARE @SQL4 VARCHAR(1000)

SELECT @RECOVERYMODEL = RECOVERY_MODEL_DESC FROM SYS.DATABASES WHERE NAME=@DB_NAME

IF 'SIMPLE' = @RECOVERYMODEL 
BEGIN
	SET @CHANGERECOVERYMODEL = 'N'
END

SET @SQL3 ='IF ( '''+@CHANGERECOVERYMODEL+''' = ''Y'') AND ('+@MODEID+' = 2)
  BEGIN
	PRINT ''Changing recovery model from '+@RECOVERYMODEL+' to SIMPLE  ''
	ALTER DATABASE '+@DB_NAME+'
		SET RECOVERY SIMPLE
  END'
--	PRINT (@SQL3)
EXEC (@SQL3)

IF (SELECT COUNT(*) FROM TEMPDB..SYSOBJECTS WHERE NAME = '##STOREINDEXINFORMATION') > 0
  BEGIN
	DROP TABLE ##STOREINDEXINFORMATION
  END

SET  @SQL1 = 'USE '+@DB_NAME+ '
SELECT	IDENT = IDENTITY (INT,1,1)
		,SC.[TABLE_SCHEMA]+''.''+SC.[TABLE_NAME] [FULLOBJECTNAME]
		,SI.[NAME] [INDEXNAME]
INTO	##STOREINDEXINFORMATION
FROM	SYS.INDEXES I JOIN SYS.TABLES T ON I.[OBJECT_ID] = T.[OBJECT_ID] JOIN SYSINDEXES SI ON SI.ID = T.[OBJECT_ID] JOIN INFORMATION_SCHEMA.TABLES SC ON SC.TABLE_NAME = OBJECT_NAME (T.[OBJECT_ID])
WHERE	I.[INDEX_ID] > 1 
		AND		I.[TYPE] = 2 
		AND		I.[IS_PRIMARY_KEY] <> 1
		AND		I.[IS_UNIQUE_CONSTRAINT] <> 1
		AND		I.[INDEX_ID] = SI.INDID'

EXEC (@SQL1)

DECLARE @VAR1 INT
DECLARE @TOTALCOUNT INT
DECLARE @COUNT INT
SET  	@TOTALCOUNT = 0
SET		@COUNT  = 0
DECLARE @MODEDESCRIPTION VARCHAR(50)
SELECT @MODEDESCRIPTION  =	CASE	WHEN @MODEID = 1 THEN 'Disabl'
									ELSE 'Enabl'
							END	
PRINT 'Started '+@MODEDESCRIPTION +'ing all Non-clustered indexes...'

SET @VAR1 = 1
WHILE @VAR1 < = ( SELECT COUNT(*) FROM ##STOREINDEXINFORMATION)
BEGIN 
	DECLARE @OBJECTNAME VARCHAR(256)
	DECLARE @INDEXNAME VARCHAR(128)
	DECLARE @SQLCMD VARCHAR(1000)
	

	SELECT	@OBJECTNAME = [FULLOBJECTNAME]
			, @INDEXNAME = [INDEXNAME] 
	FROM	##STOREINDEXINFORMATION 
	WHERE	[IDENT] = @VAR1
	
	IF @MODEID = 1 -- DISABLE
	  BEGIN
		SET @SQLCMD ='USE '+@DB_NAME+' ALTER INDEX '+@INDEXNAME +' ON '+@OBJECTNAME+' DISABLE '
		EXEC (@SQLCMD)
		
	END

	IF @MODEID = 2 -- ENABLE/REBUILD
	  BEGIN
		SET @SQLCMD ='USE '+@DB_NAME+' ALTER INDEX '+@INDEXNAME +' ON '+@OBJECTNAME+' REBUILD'
		EXEC (@SQLCMD)
	END

		SET @TOTALCOUNT = @TOTALCOUNT + @COUNT 

	SET @VAR1 = @VAR1 + 1
	
	IF (SELECT COUNT(*) FROM ##STOREINDEXINFORMATION )= @VAR1 
	 BEGIN
		SET @TOTALCOUNT = @VAR1
	 END
END

IF @TOTALCOUNT = (SELECT COUNT(*) FROM ##STOREINDEXINFORMATION)
  BEGIN
	PRINT 'Successfully finished '+@MODEDESCRIPTION+'ing all Non-clustered indexes for '+DB_NAME()+' database'
  END 
	
IF @TOTALCOUNT <> (SELECT COUNT(*) FROM ##STOREINDEXINFORMATION)
  BEGIN
	PRINT 'Could not '+@MODEDESCRIPTION+'e all Non-clustered index due to some reason for more information check sql server logs'
  END


SET @SQL4 ='IF ( '''+@CHANGERECOVERYMODEL+''' = ''Y'') AND ('+@MODEID+' = 2)
  BEGIN
	PRINT ''Changing back recovery model from SIMPLE to '+@RECOVERYMODEL+'''	
	ALTER DATABASE '+@DB_NAME+'
		SET RECOVERY '+@RECOVERYMODEL+'
  END'
EXEC (@SQL4)
DROP TABLE ##STOREINDEXINFORMATION
SET NOCOUNT OFF
-- End of Stored procedure 
GO

-- sample to Execute 
EXEC USP_DisableEnableNonClusteredIndexes  'ADVENTUREWORKS', 'N',1 -- DISABLE
EXEC USP_DisableEnableNonClusteredIndexes  'ADVENTUREWORKS', 'N',2 -- REBUILD/ENABLE with out Changing Recovery model.
EXEC USP_DisableEnableNonClusteredIndexes  'ADVENTUREWORKS', 'Y',2 -- REBUILD/ENABLE with Change Recovery model.

--or

EXEC USP_DisableEnableNonClusteredIndexes  'ADVENTUREWORKS',null, 1 -- DISABLE
EXEC USP_DisableEnableNonClusteredIndexes  'ADVENTUREWORKS', null ,2 -- REBUILD/ENABLE with out Changing Recovery model.

