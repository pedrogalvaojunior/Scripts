-- Exemplo 1 --
CREATE TRIGGER [TG_AUDITORIA]
ON DATABASE
FOR DDL_DATABASE_LEVEL_EVENTS 
AS
SET NOCOUNT ON
DECLARE @data XML
DECLARE @MSG VARCHAR(300);
BEGIN
SELECT @data = EVENTDATA()
SET @MSG = 'REGRA TG_ACESSO - NÃO É PERMITIDO CRIAR A TABELA COM ESTA NOMECLATURA.';
IF (@data.value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(500)') = 'CREATE_TABLE' AND @data.value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(500)') NOT LIKE '%tabela%')
BEGIN
RAISERROR (@MSG, 16, 1);
ROLLBACK;
END
END
GO

-- Exemplo 2 --
USE ExamBook762Ch2;

GO

ALTER TRIGGER tgDMLOnCreateUpdateTable
ON DATABASE
FOR CREATE_TABLE, ALTER_TABLE
AS
BEGIN


    DECLARE @NomesNaoPermitidos AS TABLE (nome VARCHAR(128));
    DECLARE @ObjectName VARCHAR(128);


    INSERT INTO @NomesNaoPermitidos (nome)
    VALUES ('Temp' -- nome - varchar(128)
        );

    SELECT @ObjectName = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'nvarchar(128)');

    IF (EXISTS (   SELECT 1
                     FROM @NomesNaoPermitidos AS NNP
                    WHERE NNP.nome = @ObjectName))
    BEGIN

        RAISERROR('Nome da tabela não permitido',16,1);
		ROLLBACK;
    END;
    ELSE
        SELECT @ObjectName;
END; 