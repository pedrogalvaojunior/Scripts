SELECT s.name
FROM sys.schemas s
WHERE s.principal_id = USER_ID('ensaios');


ALTER AUTHORIZATION ON SCHEMA::db_securityadmin TO dbo;


ALTER AUTHORIZATION ON SCHEMA::db_ddladmin TO dbo;
ALTER AUTHORIZATION ON SCHEMA::db_backupoperator TO dbo;
ALTER AUTHORIZATION ON SCHEMA::db_datareader TO dbo;
ALTER AUTHORIZATION ON SCHEMA::db_datawriter TO dbo;
ALTER AUTHORIZATION ON SCHEMA::db_denydatareader TO dbo;
ALTER AUTHORIZATION ON SCHEMA::db_denydatawriter TO dbo;

drop user ensaios