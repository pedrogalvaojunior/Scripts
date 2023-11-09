--Script para atribuir a Role par ao usuário manutencaobanco
USE [msdb]
GO

--atribuindo a role de SQLAgentOperatorRole
EXEC sp_addrolemember N'SQLAgentOperatorRole', N'manutencaobanco'
GO


USE [msdb]
GO
--atribuindo a role de SQLAgentReaderRole
EXEC sp_addrolemember N'SQLAgentReaderRole', N'manutencaobanco'
GO


USE [msdb]
GO
--atribuindo a role de SQLAgentUserRole
EXEC sp_addrolemember N'SQLAgentUserRole', N'manutencaobanco'
GO


USE [msdb]
GO
--atribuindo a role de db_ssisadmin
EXEC sp_addrolemember N'db_ssisadmin', N'manutencaobanco'
GO


USE [msdb]
GO
--atribuindo a role de dc_admin
EXEC sp_addrolemember N'dc_admin', N'manutencaobanco'
GO

