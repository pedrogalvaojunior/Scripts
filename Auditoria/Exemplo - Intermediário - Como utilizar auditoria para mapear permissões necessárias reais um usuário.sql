-- Criando a tabela para armazenar o histórico de acessos --
CREATE TABLE [dbo].[Auditoria_Acesso]
(
    [Id_Auditoria] [bigint] NOT NULL IDENTITY(1, 1),
    [Dt_Auditoria] [datetime] NOT NULL,
    [Cd_Acao] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
    [Ds_Maquina] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
    [Ds_Usuario] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
    [Ds_Database] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
    [Ds_Schema] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
    [Ds_Objeto] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
    [Ds_Query] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
    [Fl_Sucesso] [bit] NOT NULL,
    [Ds_IP] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
    [Ds_Programa] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
    [Qt_Duracao] [bigint] NOT NULL,
    [Qt_Linhas_Retornadas] [bigint] NOT NULL,
    [Qt_Linhas_Alteradas] [bigint] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
)
GO

ALTER TABLE [dbo].[Auditoria_Acesso] ADD CONSTRAINT [PK__Auditori__E9F1DAD4EE3743FE] PRIMARY KEY CLUSTERED ([Id_Auditoria]) WITH (DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO

-- Criando a Server Audit filtrando os usuários --
USE [master]
GO

IF ((SELECT COUNT(*) FROM sys.server_audits WHERE [name] = 'Auditoria_Acessos') > 0)
BEGIN
    ALTER SERVER AUDIT [Auditoria_Acessos] WITH (STATE = OFF);
    DROP SERVER AUDIT [Auditoria_Acessos]
END


CREATE SERVER AUDIT [Auditoria_Acessos]
TO FILE
(	
    FILEPATH = N'C:\Audit\',
    MAXSIZE = 10 MB,
    MAX_ROLLOVER_FILES = 16,
    RESERVE_DISK_SPACE = OFF
)
WITH
(	
    QUEUE_DELAY = 1000,
    ON_FAILURE = CONTINUE,
    AUDIT_GUID = '0b5ad307-ee47-43db-a169-9af67cb661f9'
)
WHERE (([server_principal_name] LIKE '%User' OR [server_principal_name] LIKE 'LS_%') AND [application_name]<>'Microsoft SQL Server Management Studio - Transact-SQL IntelliSense' AND NOT [application_name] LIKE 'Red Gate Software%' AND NOT [server_principal_name] LIKE 'GRUPODADALTO\%' AND NOT [server_principal_name] LIKE 'WWWUser')
GO


ALTER SERVER AUDIT [Auditoria_Acessos] WITH (STATE = ON)
GO


-- Criando a Database Audit capturando os acessos --
DECLARE @Query VARCHAR(MAX)
SET @Query = '

IF (''?'' NOT IN (''master'', ''tempdb'', ''model'', ''msdb''))
BEGIN

    USE [?];

    IF ((SELECT COUNT(*) FROM sys.database_audit_specifications WHERE [name] = ''Auditoria_Acessos'') > 0)
    BEGIN

        ALTER DATABASE AUDIT SPECIFICATION [Auditoria_Acessos] WITH (STATE = OFF);
        DROP DATABASE AUDIT SPECIFICATION [Auditoria_Acessos];

    END

    CREATE DATABASE AUDIT SPECIFICATION [Auditoria_Acessos]
    FOR SERVER AUDIT [Auditoria_Acessos]
    ADD (DELETE ON DATABASE::[?] BY [public]),
    ADD (EXECUTE ON DATABASE::[?] BY [public]),
    ADD (INSERT ON DATABASE::[?] BY [public]),
    ADD (SELECT ON DATABASE::[?] BY [public]),
    ADD (UPDATE ON DATABASE::[?] BY [public])
    WITH (STATE = ON);
    
END'
Go

EXEC sys.sp_MSforeachdb @Query
Go

-- Criando a Stored Procedure para armazenar os dados coletados --
IF (OBJECT_ID('dbo.stpAuditoria_Acessos_Carrega_Dados') IS NULL) EXEC('CREATE PROCEDURE dbo.stpAuditoria_Acessos_Carrega_Dados AS SELECT 1')
GO

ALTER PROCEDURE dbo.stpAuditoria_Acessos_Carrega_Dados
AS
BEGIN

    DECLARE @TimeZone INT = DATEDIFF(HOUR, GETUTCDATE(), GETDATE())
    DECLARE @Dt_Max DATETIME = DATEADD(SECOND, 1, ISNULL((SELECT MAX(Dt_Auditoria) FROM .Auditoria_Acesso), '1900-01-01'))

    INSERT INTO dbo.Auditoria_Acesso
    (
        Dt_Auditoria,
        Cd_Acao,
        Ds_Maquina,
        Ds_Usuario,
        Ds_Database,
        Ds_Schema,
        Ds_Objeto,
        Ds_Query
        Fl_Sucesso,
        Ds_IP,
        Ds_Programa,
        Qt_Duracao,
        Qt_Linhas_Retornadas,
        Qt_Linhas_Alteradas
    )
    SELECT DISTINCT
        DATEADD(HOUR, @TimeZone, event_time) AS event_time,
        action_id,
        server_instance_name,
        server_principal_name,
        [database_name],
        [schema_name],
        [object_name],
        [statement],
        succeeded,
        client_ip,
        application_name,
        duration_milliseconds,
        response_rows,
        affected_rows
    FROM 
        sys.fn_get_audit_file('C:\Audit\*.sqlaudit', DEFAULT, DEFAULT)
    WHERE 
        DATEADD(HOUR, @TimeZone, event_time) >= @Dt_Max

END
Go

-- Consultando os dados coletados --
Select * from Auditoria_Acessos
Go

-- Mapeando as permissões com base na auditoria --
SELECT DISTINCT 
    Ds_Usuario,
    Ds_Database, 
    Cd_Acao, 
    Ds_Objeto,
    'USE [' + Ds_Database + ']; GRANT ' + (CASE Cd_Acao
        WHEN 'UP' THEN 'UPDATE'
        WHEN 'IN' THEN 'INSERT'
        WHEN 'DL' THEN 'DELETE'
        WHEN 'SL' THEN 'SELECT'
        WHEN 'EX' THEN 'EXECUTE'
    END) + ' ON [' + Ds_Schema + '].[' + Ds_Objeto + '] TO [' + Ds_Usuario + '];' AS Comando 
FROM 
    dirceuresende..Auditoria_Acesso 
WHERE 
    Cd_Acao <> 'UNDO'
ORDER BY
    Ds_Usuario,
    Ds_Database,
    Ds_Objeto
Go