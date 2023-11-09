SELECT SDPs.name as role, 
            m.login, 
            m.usuario
FROM [Master].sys.database_principals SDPs JOIN 
 (SELECT p2.name AS role,
               SDPs1.name AS  usuario,
               p2.principal_id,
               SL.name AS login
FROM [Master].sys.database_principals SDPs1 JOIN [Master].sys.syslogins SL 
                                                                               ON SL.sid = SDPs1.sid
                                                                              JOIN [Master].sys.database_role_members SRM 
                                                                               ON SDPs1.principal_id = SRM.member_principal_id
                                                                              JOIN [Master].sys.database_principals p2 
                                                                               ON p2.principal_id = SRM.role_principal_id 
                                                                               AND p2.type IN ('R')
WHERE SDPs1.type IN ('S','U','G') )  m  ON SDPs.principal_id = m.principal_id
WHERE SDPs.type IN ('R')
ORDER BY role, login