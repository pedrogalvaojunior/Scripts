USE [master]
GO

--CONFIGURANDO � INST�NCIA SQL PARA ACEITAR OP��ES AVAN�ADAS
exec sp_configure 'show advanced options', 1
RECONFIGURE
exec sp_configure 'Ad Hoc Distributed Queries', 1
RECONFIGURE

--ADICIONANDO OS DRIVERS NA INST�NCIA
EXEC master .dbo. sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0' , N'AllowInProcess' , 1
GO
EXEC master .dbo. sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0' , N'DynamicParameters' , 1
GO