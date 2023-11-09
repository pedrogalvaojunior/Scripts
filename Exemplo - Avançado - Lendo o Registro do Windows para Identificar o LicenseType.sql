USE master
GO

create table #version
(
	version_desc varchar(2000)
)

insert #version
select @@version

if exists
(
	select 1
	from #version
	where version_desc like '%2005%'
)
Begin
	DECLARE @Registry_Value_2005 VARCHAR(1000)
	EXEC xp_regread 'HKEY_LOCAL_MACHINE','SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL.1\Setup','ProductCode',@Registry_Value_2005 OUTPUT --2005
	SELECT @@version as 'version',@Registry_Value_2005 as 'license_key'
End
else if exists
(
	select 1
	from #version
	where version_desc like '%express%'
)
Begin
	DECLARE @Registry_Value_2008_express VARCHAR(1000)
	EXEC xp_regread 'HKEY_LOCAL_MACHINE','SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL10_50.SQLEXPRESS\Setup','ProductCode',@Registry_Value_2008_express OUTPUT -- 2008 express
	SELECT @@version as 'version',@Registry_Value_2008_express as 'license_key'
End
else if exists
(
	select 1
	from #version
	where version_desc like '%R2%'
)
Begin
	DECLARE @Registry_Value_2008_R2 VARCHAR(1000)
	EXEC xp_regread 'HKEY_LOCAL_MACHINE','SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\Setup','ProductCode',@Registry_Value_2008_R2 OUTPUT -- 2008 R2
	SELECT @@version as 'version',@Registry_Value_2008_R2 as 'license_key'
End
else if exists
(
	select 1
	from #version
	where version_desc like '%2008%'
)
Begin
	DECLARE @Registry_Value_2008 VARCHAR(1000)
	EXEC xp_regread 'HKEY_LOCAL_MACHINE','SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL10.MSSQLSERVER\Setup','ProductCode',@Registry_Value_2008 OUTPUT -- 2008
	SELECT @@version as 'version',@Registry_Value_2008 as 'license_key'
End
else if exists
(
	select 1
	from #version
	where version_desc like '%2012%'
)
Begin
	DECLARE @Registry_Value_2012 VARCHAR(1000)
	EXEC xp_regread 'HKEY_LOCAL_MACHINE','SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL11.MSSQLSERVER\Setup','ProductCode',@Registry_Value_2012 OUTPUT -- 2012
	SELECT @@version as 'version',@Registry_Value_2012 as 'license_key'
End
else
Begin
	select 'version not recognized'
End

drop table #version