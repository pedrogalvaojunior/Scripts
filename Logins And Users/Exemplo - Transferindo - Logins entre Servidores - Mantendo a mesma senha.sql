SELECT 'ALTER LOGIN ' + NAME + ' WITH PASSWORD = ', LOGINPROPERTY(NAME,'PasswordHash'), ' HASHED' FROM sys.server_principals
 WHERE TYPE = 'S'