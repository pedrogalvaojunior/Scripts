SELECT SDPs.name as Role, 
            m.login, 
            m.[User]
FROM [Master].sys.database_principals SDPs Inner JOIN (SELECT SDPs2.name AS role,
																										   SDPs1.name AS  [User],
																										   p2.principal_id,
																										   SL.name AS login
																							  FROM [Master].sys.database_principals SDPs1 Inner JOIN [Master].sys.syslogins SL 
																																											ON SDPs1.sid = SL.sid
																																										   Inner JOIN [Master].sys.database_role_members SRM 
																																										    ON SRM.member_principal_id = SDPs1.principal_id
																																										   Inner JOIN [Master].sys.database_principals SDPs2 
																																											ON SRM.role_principal_id = SDPs2.principal_id
																																											AND SDPs2.type IN ('R')
																							   WHERE SDPs1.type IN ('S','U','G') 
																							 )  m  ON SDPs.principal_id = m.principal_id
WHERE SDPs.type IN ('R')
ORDER BY role, login
Go

-- CTE --
With Roles (Role, Login, [User])
As
(SELECT SDPs2.name AS role,
    		  SDPs1.name AS  [User],
			  SL.name AS login
FROM [Master].sys.database_principals SDPs1 Inner JOIN [Master].sys.syslogins SL 
																			  ON SDPs1.sid = SL.sid
																			 Inner JOIN [Master].sys.database_role_members SRM 
																			  ON SRM.member_principal_id = SDPs1.principal_id
     																		 Inner JOIN [Master].sys.database_principals SDPs2
																			  On SRM.role_principal_id = SDPs2.principal_id
																			  AND SDPs2.type IN ('R')
WHERE SDPs1.type IN ('S','U','G')) 

Select * from Roles
ORDER BY role, login