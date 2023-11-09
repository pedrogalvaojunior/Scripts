SELECT  l.name, 
 CAST(CASE sp.[state] WHEN N'D' THEN 1 ELSE 0 END AS bit) AS DenyWindowsLogin,
 CASE WHEN N'U' = l.type THEN 0 
  WHEN N'G' = l.type THEN 1 
  WHEN N'S' = l.type THEN 2 
  WHEN N'C' = l.type THEN 3 
  WHEN N'K' = l.type THEN 4 END AS LoginType,
 CAST(CASE WHEN (sp.[state] IS NULL) THEN 0 ELSE 1 END AS bit) AS HasAccess,
 CAST(sl.is_policy_checked AS bit) AS PasswordPolicyEnforced,
 CAST(sl.is_expiration_checked AS bit) AS PasswordExpirationEnabled,
 l.create_date AS CreateDate,
 l.modify_date AS DateLastModified,
 LOGINPROPERTY(l.name, N'BadPasswordCount')  AS BadPasswordCount,
 LOGINPROPERTY(l.name, N'BadPasswordTime')  AS BadPasswordTime,
 LOGINPROPERTY(l.name, N'DaysUntilExpiration') AS DaysUntilExpiration,
 LOGINPROPERTY(l.name, N'IsExpired')  AS IsExpired,
 LOGINPROPERTY(l.name, N'IsLocked') AS IsLocked,
 LOGINPROPERTY(l.name, N'IsMustChange') AS IsMustChange,
 LOGINPROPERTY(l.name, N'LockoutTime') AS LockoutTime,
 LOGINPROPERTY(l.name, N'PasswordLastSetTime') AS PasswordLastSetTime,
 l.is_disabled AS IsDisabled
FROM sys.server_principals AS l
  LEFT OUTER JOIN sys.server_permissions AS sp 
  ON sp.grantee_principal_id = l.principal_id 
   AND sp.[type] = N'COSQ' -- Connect permissions
  LEFT OUTER JOIN sys.sql_logins AS sl 
  ON sl.principal_id = l.principal_id
  LEFT OUTER JOIN sys.credentials AS c 
  ON c.credential_id = l.credential_id
WHERE
 l.[type] IN ('U', 'G', 'S', 'C', 'K') 
 AND l.principal_id NOT BETWEEN 101 AND 255 -- ##MS% certificates
 AND 
 ( sp.[state] = N'D'  --  DenyWindowsLogin
  OR sp.[state] IS NULL -- HasAccess
  OR CAST(sl.is_policy_checked AS bit) = 0
  OR CAST(sl.is_expiration_checked AS bit) = 0
  OR l.create_date > GETDATE()-1
  OR l.modify_date  > GETDATE()-1
  OR l.is_disabled > 0
  OR LOGINPROPERTY(l.name, N'DaysUntilExpiration')<= 5
  OR LOGINPROPERTY(l.name, N'IsExpired') > 0 
  OR LOGINPROPERTY(l.name, N'IsLocked') > 0 
  OR LOGINPROPERTY(l.name, N'IsMustChange') > 0 
  OR LOGINPROPERTY(l.name, N'BadPasswordCount')  > 2
 )