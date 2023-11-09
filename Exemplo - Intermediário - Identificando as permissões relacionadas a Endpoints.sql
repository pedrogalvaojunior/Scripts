SELECT
    sp2.[permission_name],
    e.state_desc,
    e.[name] AS endpoint_name,
    e.principal_id,
    sp.[sid],
    e.is_admin_endpoint,
    sp.is_disabled,
    sp.[name] AS granted_name,
    e.protocol_desc
FROM
    sys.server_permissions AS sp2
    JOIN sys.server_principals AS sp ON sp2.grantee_principal_id = sp.principal_id
    LEFT OUTER JOIN sys.endpoints AS e ON sp2.major_id = e.endpoint_id
WHERE
    sp2.class_desc = 'ENDPOINT'
    AND e.is_admin_endpoint = 0
Go