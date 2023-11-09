-- Criando uma nova credencial -- 
create credential [YourCredential]
	with identity = 'YourDomain\YourUserName';
Go

-- Declarando a variável @proxy_id --
declare @proxy_id int;

-- Adicionando a conta proxy e vinculando com a credencial --
exec msdb.dbo.sp_add_proxy
		@proxy_name = 'YourProxy',
		@enabled = 1,
		@description = 'your test proxy' ,
		@credential_name = 'YourCredential' ,
		@credential_id = null ,
		@proxy_id = @proxy_id OUTPUT

select @proxy_id as proxy_id
Go

-- Adicionando permissão para executar pacotes DTS --
exec msdb.dbo.sp_grant_proxy_to_subsystem @proxy_name=N'YourProxy', @subsystem_name = 'Dts'
Go

-- Adiconando permissão de login através da conta proxy --
exec msdb.dbo.sp_grant_login_to_proxy 
		@login_name = 'YourDomain\YourSQLAgent' 
		, @fixed_server_role = null
		, @msdb_role = null
		, @proxy_id = null
		, @proxy_name = 'YourProxy'
Go