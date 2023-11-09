USE [master]
GO

--CONFIGURANDO À INSTÂNCIA SQL PARA ACEITAR OPÇÕES AVANÇADAS
exec sp_configure 'show advanced options', 1
RECONFIGURE
exec sp_configure 'Ad Hoc Distributed Queries', 1
RECONFIGURE

--ADICIONANDO OS DRIVERS NA INSTÂNCIA
EXEC master .dbo. sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0' , N'AllowInProcess' , 1
GO
EXEC master .dbo. sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0' , N'DynamicParameters' , 1
GO

--CONSULTANDO UMA PLANILHA
SELECT * FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0' ,
'Excel 8.0;Database=C:\Planilhas\Teste.xls;' ,
'SELECT * FROM [Plan1$]' );