SELECT MAX(CONVERT(VARCHAR(15),value_data)) As 'Default Port' FROM sys.dm_server_registry 
WHERE registry_key LIKE '%MSSQLServer\SuperSocketNetLib\Tcp\%' 
AND value_name LIKE N'%TcpPort%' 
AND CONVERT(float,value_data) > 0
Go

SELECT MAX(CONVERT(VARCHAR(15),value_data)) As 'Dynamic Port ' FROM sys.dm_server_registry 
WHERE registry_key LIKE '%MSSQLServer\SuperSocketNetLib\Tcp\%' 
AND value_name LIKE N'%TcpDynamicPort%' 
AND CONVERT(float,value_data) > 0
Go

select Registry_key, Value_Name, Value_Data FROM sys.dm_server_registry
where registry_key like '%SuperSocketNetLib%'
Go


SELECT port As 'Default Port' FROM sys.dm_tcp_listener_states 
WHERE is_ipv4 = 1 
AND [type] = 0 
AND ip_address <> '127.0.0.1'
Go

Select listener_id, 
            ip_address, 
			is_ipv4, 
			Port, 
			Type, 
			type_desc, 
			state_desc, 
			start_time
from sys.dm_tcp_listener_states