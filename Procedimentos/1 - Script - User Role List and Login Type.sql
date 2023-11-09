SELECT 
          CASE 
           WHEN SSPs2.name IS NULL THEN 'Public' 
           ELSE SSPs2.name 
          END AS 'Role Name',
          SSPs.name AS 'Login Name',
          Case SSPs.is_disabled 
           When 0 Then '0 - Habilitado'
           When 1 Then '1 - Desabilitado'
          End AS 'Login Status',
          SSPs.type_desc AS 'Login Type'
FROM sys.server_principals SSPs LEFT JOIN sys.server_role_members SSRM 
                                                       ON SSPs.principal_id  = SSRM.member_principal_id 
                                                      LEFT JOIN sys.server_principals SSPs2 
                                                       ON SSRM.role_principal_id = SSPs2.principal_id
WHERE SSPs2.name IS NOT NULL
OR SSPs.type_desc <> 'CERTIFICATE_MAPPED_LOGIN'
AND SSPs.type_desc <> 'SERVER_ROLE'
AND SSPs2.name IS NULL
ORDER BY SSPs2.name DESC, SSPs.name