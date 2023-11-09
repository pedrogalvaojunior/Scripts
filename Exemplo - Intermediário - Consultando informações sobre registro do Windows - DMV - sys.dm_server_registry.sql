SELECT MAX(CONVERT(VARCHAR(15),value_data)) FROM sys.dm_server_registry 
WHERE registry_key LIKE '%MSSQLServer\SuperSocketNetLib\Tcp\%' 
AND value_name LIKE N'%TcpPort%' 
AND CONVERT(float,value_data) > 0;

SELECT MAX(CONVERT(VARCHAR(15),value_data)) FROM sys.dm_server_registry
WHERE registry_key LIKE '%MSSQLServer\SuperSocketNetLib\Tcp\%' 
AND value_name LIKE N'%TcpDynamicPort%' 
AND CONVERT(float,value_data) > 0;

-- A. Display the SQL Server services --
SELECT registry_key, value_name, value_data
FROM sys.dm_server_registry
WHERE key_name LIKE N'%ControlSet%';

-- B. Display the SQL Server Agent registry key values --
SELECT registry_key, value_name, value_data
FROM sys.dm_server_registry
WHERE key_name LIKE N'%SQLAgent%';

-- C. Display the current version of the instance of SQL Server --
SELECT registry_key, value_name, value_data
FROM sys.dm_server_registry
WHERE value_name = N'CurrentVersion';

-- D. Display the parameters passed to the instance of SQL Server during startup --
SELECT registry_key, value_name, value_data
FROM sys.dm_server_registry
WHERE registry_key LIKE N'%Parameters';

-- E. Return network configuration information for the instance of SQL Server --
SELECT registry_key, value_name, value_data
FROM sys.dm_server_registry
WHERE keyname LIKE N'%SuperSocketNetLib%';
