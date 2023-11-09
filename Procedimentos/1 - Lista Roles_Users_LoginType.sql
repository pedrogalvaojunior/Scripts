SELECT 
          CASE WHEN SSPs2.name IS NULL THEN 'public' 
           ELSE SSPs2.name 
          END AS NomeRole,
           SSPs.name AS NomeLogin,
           SSPs.is_disabled AS LoginDesabilitado,
           SSPs.type_desc AS TipoLogin
FROM sys.server_principals SSPs LEFT JOIN sys.server_role_members SSRM 
                                                       ON SSRM.member_principal_id = SSPs.principal_id
                                                      LEFT JOIN sys.server_principals SSPs2 
                                                       ON SSPs2.principal_id = SSRM.role_principal_id
WHERE SSPs2.name IS NOT NULL
OR (SSPs.type_desc <> 'CERTIFICATE_MAPPED_LOGIN'
AND SSPs.type_desc <> 'SERVER_ROLE'
AND SSPs2.name IS NULL)
ORDER BY SSPs2.name DESC, SSPs.name