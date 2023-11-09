select pr.name, dp.permission_name, dp.state_desc
 from msdb.sys.database_permissions dp
 join msdb.sys.objects o on dp.major_id = o.object_id
 join msdb.sys.database_principals pr
 on dp.grantee_principal_id = pr.principal_id
 where o.name = 'sp_start_job'