-- Startup Parameters --
-dS:\MSSQLSystemDatabases\2017\Data\master.mdf

-lS:\MSSQLSystemDatabases\2017\Log\mastlog.ldf

-eS:\MSSQLSystemDatabases\2017\ERRORLOG\ERRORLOG
---------------------------------------------------------------------------------------

SELECT name, physical_name AS CurrentLocation, state_desc  
FROM sys.master_files  
WHERE database_id = DB_ID(N'MASTER');

ALTER DATABASE Master
MODIFY FILE ( NAME = master , FILENAME = 'S:\MSSQLSystemDatabases\2017\Data\master.mdf' )
Go

ALTER DATABASE Master
MODIFY FILE ( NAME = mastlog , FILENAME = 'S:\MSSQLSystemDatabases\2017\Log\mastlog.ldf' )
Go

SELECT name, physical_name AS CurrentLocation, state_desc  
FROM sys.master_files  
WHERE database_id = DB_ID(N'TEMPDB');

ALTER DATABASE TEMPDB
MODIFY FILE ( NAME = tempdev , FILENAME = 'S:\MSSQLSystemDatabases\2017\Data\tempdb.mdf' )
Go

ALTER DATABASE TEMPDB
MODIFY FILE ( NAME = temp2 , FILENAME = 'S:\MSSQLSystemDatabases\2017\Data\tempdb_mssql_2.ndf')
Go

ALTER DATABASE TEMPDB
MODIFY FILE ( NAME = temp3 , FILENAME = 'S:\MSSQLSystemDatabases\2017\Data\tempdb_mssql_3.ndf' )
Go

ALTER DATABASE TEMPDB
MODIFY FILE ( NAME = temp4 , FILENAME = 'S:\MSSQLSystemDatabases\2017\Data\tempdb_mssql_4.ndf' )
Go

ALTER DATABASE TEMPDB
MODIFY FILE ( NAME = templog , FILENAME = 'S:\MSSQLSystemDatabases\2017\Log\tempdblog.ldf' )
Go



