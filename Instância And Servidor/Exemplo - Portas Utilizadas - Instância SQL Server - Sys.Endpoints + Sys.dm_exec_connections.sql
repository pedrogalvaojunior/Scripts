SELECT ep.name, ep.endpoint_id,
            ep.principal_id, ep.protocol,
            ep.protocol_desc, ec.connection_id,
            ec.local_net_address,  ec.local_tcp_port,
            ep.type, ep.type_desc,
            ep.state, ep.state_desc,
            ep.is_admin_endpoint
FROM sys.endpoints ep LEFT OUTER JOIN sys.dm_exec_connections ec
									ON ec.endpoint_id = ep.endpoint_id
GROUP BY ep.name, ep.endpoint_id, ep.principal_id, ep.protocol, ep.protocol_desc, 
                  ec.connection_id, ec.local_net_address, ec.local_tcp_port, ep.type, ep.type_desc, ep.state,
                  ep.state_desc, ep.is_admin_endpoint 