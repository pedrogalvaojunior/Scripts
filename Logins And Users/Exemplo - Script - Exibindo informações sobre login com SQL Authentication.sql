-- Exibindo informações sobre logins utilizados em Autenticação SQL --

CREATE TABLE #LoginInfo
(BadPasswordCount SQL_VARIANT
,BadPasswordTime SQL_VARIANT
,DaysUntilExpiration SQL_VARIANT
,DefaultDatabase SQL_VARIANT
,DefaultLanguage SQL_VARIANT
,HistoryLength SQL_VARIANT
,IsExpired SQL_VARIANT
,IsLocked SQL_VARIANT
,IsMustChange SQL_VARIANT
,LockoutTime SQL_VARIANT
,PasswordHash SQL_VARIANT
,PasswordLastSetTime SQL_VARIANT
,username VARCHAR(25))

DECLARE @BadPasswordCount SQL_VARIANT
,@BadPasswordTime SQL_VARIANT
,@DaysUntilExpiration SQL_VARIANT
,@DefaultDatabase SQL_VARIANT
,@DefaultLanguage SQL_VARIANT
,@HistoryLength SQL_VARIANT
,@IsExpired SQL_VARIANT
,@IsLocked SQL_VARIANT
,@IsMustChange SQL_VARIANT
,@LockoutTime SQL_VARIANT
,@PasswordHash SQL_VARIANT
,@PasswordLastSetTime SQL_VARIANT
,@username VARCHAR(25)

DECLARE useracct_cursor CURSOR FOR
SELECT NAME FROM sys.server_principals WHERE (type = 'S' AND NAME NOT LIKE '##%')

OPEN useracct_cursor
FETCH NEXT FROM useracct_cursor INTO @username

WHILE @@FETCH_STATUS = 0
BEGIN

SET @BadPasswordCount = (SELECT loginproperty(@username, 'BadPasswordCount'))
SET @BadPasswordTime = (SELECT loginproperty(@username, 'BadPasswordTime'))
SET @DaysUntilExpiration = (SELECT loginproperty(@username, 'DaysUntilExpiration'))
SET @DefaultDatabase = (SELECT loginproperty(@username, 'DefaultDatabase'))
SET @DefaultLanguage = (SELECT loginproperty(@username, 'DefaultLanguage'))
SET @HistoryLength = (SELECT loginproperty(@username, 'HistoryLength'))
SET @IsExpired = (SELECT loginproperty(@username, 'IsExpired'))
SET @IsLocked = (SELECT loginproperty(@username, 'IsLocked'))
SET @IsMustChange = (SELECT loginproperty(@username, 'IsMustChange'))
SET @LockoutTime = (SELECT loginproperty(@username, 'LockoutTime'))
SET @PasswordHash = (SELECT loginproperty(@username, 'PasswordHash'))
SET @PasswordLastSetTime = (SELECT loginproperty(@username, 'PasswordLastSetTime'))

INSERT INTO #LoginInfo
 ( BadPasswordCount ,
 BadPasswordTime ,
 DaysUntilExpiration ,
 DefaultDatabase ,
 DefaultLanguage ,
 HistoryLength ,
 IsExpired ,
 IsLocked ,
 IsMustChange ,
 LockoutTime ,
 PasswordHash ,
 PasswordLastSetTime ,
 username
 )
VALUES ( @BadPasswordCount 
,@BadPasswordTime 
,@DaysUntilExpiration 
,@DefaultDatabase
,@DefaultLanguage
,@HistoryLength 
,@IsExpired 
,@IsLocked 
,@IsMustChange 
,@LockoutTime 
,@PasswordHash 
,@PasswordLastSetTime 
,@username 
 )

FETCH NEXT FROM useracct_cursor INTO @username
END

CLOSE useracct_cursor
DEALLOCATE useracct_cursor

SELECT username AS 'SQL Login Name'
,BadPasswordCount AS 'Bad Password Count'
,BadPasswordTime AS 'Bad Password Time'
,DaysUntilExpiration AS 'Days Until Expiration'
,DefaultDatabase AS 'Default Database'
,DefaultLanguage AS 'Default Language'
,HistoryLength AS 'History Length'
,IsExpired AS 'Is Expired'
,IsLocked AS 'Is Locked'
,IsMustChange AS 'Is Must Change'
,LockoutTime AS 'Lockout Time'
,PasswordHash AS 'Password Hash'
,PasswordLastSetTime AS 'Password Last Set Time'
FROM #LoginInfo

DROP TABLE #LoginInfo
GO