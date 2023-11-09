set nocount on
go
sp_configure 'allow updates', '1'
go
reconfigure with override
go

delete sysusers where name = '\rm'
delete sysusers where name = '\sysdba'
delete sysusers where name = 'rm'
delete sysusers where name = 'sysdba'
go
delete master.dbo.syslogins where name = '\rm'
delete master.dbo.syslogins where name = '\sysdba'
delete master.dbo.syslogins where name = 'rm'
delete master.dbo.syslogins where name = 'sysdba'
go

/* criação dos usuários */

if not exists(select * from master.dbo.syslogins where name = 'rm')
   exec sp_addlogin rm,rm
go

sp_addalias rm,dbo
go

if not exists(select * from master.dbo.syslogins where name = 'sysdba')
   exec sp_addlogin sysdba,masterkey
go
 
sp_adduser sysdba,sysdba
go


grant select on gparams to sysdba
go
grant select on gusuario to sysdba
go
grant select on gpermis  to sysdba
go
grant select on gacesso  to sysdba
go
grant select on gsistema  to sysdba
go
grant select on gcoligada  to sysdba
go
grant select on gusrperfil to sysdba
go
sp_configure 'allow updates', '0'
go
reconfigure with override
go

declare @nome varchar(255)
declare @sql varchar(255)
declare @id varchar(10)
declare @usuario varchar(255)
declare tabs cursor for
select name,uid from sysobjects where type in ('u','p','v') and uid != 1 order by 1
open tabs
fetch next from tabs into @nome,@id
set @usuario=(select name from sysusers where uid=@id)
while (@@fetch_status=0)
begin
	set @sql='sp_changeobjectowner '+''''+@usuario+ '.' + @nome + ''',''dbo'''
	print @sql
	exec(@sql)
fetch next from tabs into @nome,@id
end
close tabs
deallocate tabs
go

sp_configure 'allow updates', '0'
go
reconfigure with override
go

declare @base_name varchar(100)
set @base_name = (select distinct table_catalog from information_schema.tables)
exec  ('sp_dboption ' + @base_name  + ',''ansi null default'', ''true''')
exec  ('sp_dboption ' + @base_name  + ',''recursive triggers'', ''false''')
exec  ('sp_dboption ' + @base_name  + ',''auto update statistics'', ''false''')
exec  ('sp_dboption ' + @base_name  + ',''torn page detection'', ''false''')
exec  ('sp_dboption ' + @base_name  + ',''autoshrink'', ''true''')
exec  ('sp_dboption ' + @base_name  + ',''auto create statistics'', ''false''')
exec  ('sp_dboption ' + @base_name  + ',''quoted identifier'', ''false''')
exec  ('sp_dboption ' + @base_name  + ',''autoclose'', ''false''')
exec  ('sp_dboption ' + @base_name  + ',''trunc. log on chkpt'', ''true''')
exec ( 'dbcc shrinkdatabase ('+@base_name +', truncateonly)' )
go

declare @tab_nome varchar(255)
declare @tab_statistic varchar(255)
declare @sql_str varchar(255)
declare @db_nome varchar(255)
select @db_nome=name from master..sysdatabases where dbid=(select dbid from master..sysprocesses where spid=@@spid)
checkpoint
declare cur cursor for select object_name(id),name from sysindexes where name like '_wa_sys%'
set nocount on
open cur 
fetch next from cur into @tab_nome,@tab_statistic
while(@@fetch_status=0)
begin
	set @sql_str='drop statistics ' + @tab_nome + '.' + @tab_statistic
	exec (@sql_str)
fetch next from cur into @tab_nome,@tab_statistic
end
close cur
deallocate cur
set nocount off
go


