SELECT
 'CREATE LOGIN ' + QUOTENAME(NAME) +
 CASE
  WHEN TYPE_DESC LIKE 'WINDOWS%' THEN ' FROM WINDOWS'
 ELSE ' WITH PASSWORD = ' + 
  SYS.FN_VarBinToHexStr(CAST(LOGINPROPERTY(NAME,'PasswordHash') As VARBINARY(MAX))) + ' HASHED' +
  ' , SID = ' + SYS.FN_VarBinToHexStr(CAST(SID As VARBINARY(MAX))) + ' , '
 END +
 
 CASE
  WHEN TYPE_DESC LIKE 'WINDOWS%' THEN ' WITH '
 ELSE '' END +
 
 'DEFAULT_DATABASE = ' + default_database_name + ', ' + 
    'DEFAULT_LANGUAGE = ' + default_language_name
FROM SYS.server_principals
WHERE TYPE_DESC IN ('SQL_LOGIN','WINDOWS_LOGIN','WINDOWS_GROUP')
Já utilizei para migrar logins de 2005 para 2008, de 2008 para 2008 e funcionou muito bem. Infelizmente para o 2000 não é tão simples, mas dá pra fazer também.
 
A parte de privilégios pode ser montada programaticamente também com o script abaixo:
 
SELECT state_desc + ' ' + permission_name + ' TO ' +
QUOTENAME(Name) COLLATE Latin1_General_CI_AS_KS_WS,
p.permission_name,
p.state_desc, s.name
FROM sys.server_permissions p
INNER JOIN sys.server_principals s ON
p.grantee_principal_id = s.principal_id
