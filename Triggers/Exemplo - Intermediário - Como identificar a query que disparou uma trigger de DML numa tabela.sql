-- Criando a Tabela --
IF (OBJECT_ID('dbo.Cliente') IS NOT NULL) DROP TABLE dbo.Cliente
CREATE TABLE dbo.Cliente (
    Id_Cliente INT IDENTITY(1, 1),
    Nome VARCHAR(100),
    Data_Nascimento DATETIME,
    Salario FLOAT
)

INSERT INTO dbo.Cliente
VALUES 
    ('João', '1981-05-14', 4521),
    ('Marcos', '1975-01-07', 1478.58),
    ('André', '1962-11-11', 7151.45),
    ('Simão', '1991-12-18', 2584.97),
    ('Pedro', '1986-11-20', 987.52),
    ('Paulo', '1974-08-04', 6259.14),
    ('José', '1979-09-01', 5272.13)


-- Criando a tabela com a mesma estrutura da original, mas adicionando colunas de controle
IF (OBJECT_ID('dbo.Cliente_Log') IS NOT NULL) DROP TABLE dbo.Cliente_Log
CREATE TABLE dbo.Cliente_Log (
    Id INT IDENTITY(1, 1),
    Dt_Atualizacao DATETIME DEFAULT GETDATE(),
    [Login] VARCHAR(100),
    Hostname VARCHAR(100),
    Operacao VARCHAR(20),

    -- Dados da tabela original
    Id_Cliente INT,
    Nome VARCHAR(100),
    Data_Nascimento DATETIME,
    Salario FLOAT
)
GO

IF ((SELECT COUNT(*) FROM sys.triggers WHERE name = 'trgHistorico_Cliente' AND parent_id = OBJECT_ID('dbo.Cliente')) &gt; 0) DROP TRIGGER trgHistorico_Cliente
GO

-- Criando o Trigger --
CREATE TRIGGER trgHistorico_Cliente ON dbo.Cliente -- Tabela que a trigger será associada
AFTER INSERT, UPDATE, DELETE AS
BEGIN
    
    SET NOCOUNT ON

    DECLARE 
        @Login VARCHAR(100) = SYSTEM_USER, 
        @HostName VARCHAR(100) = HOST_NAME(),
        @Data DATETIME = GETDATE()
        

    IF (EXISTS(SELECT * FROM Inserted) AND EXISTS (SELECT * FROM Deleted))
    BEGIN
        
        INSERT INTO dbo.Cliente_Log
        SELECT @Data, @Login, @HostName, 'UPDATE', *
        FROM Inserted

    END
    ELSE BEGIN

        IF (EXISTS(SELECT * FROM Inserted))
        BEGIN

            INSERT INTO dbo.Cliente_Log
            SELECT @Data, @Login, @HostName, 'INSERT', *
            FROM Inserted

        END
        ELSE BEGIN

            INSERT INTO dbo.Cliente_Log
            SELECT @Data, @Login, @HostName, 'DELETE', *
            FROM Deleted

        END

    END

END
GO

-- Realizando Manipulação de Dados --
INSERT INTO dbo.Cliente
VALUES ('Bartolomeu', '1975-05-28', 6158.74)

UPDATE dbo.Cliente
SET Salario = Salario * 1.5
WHERE Nome = 'Bartolomeu'

DELETE FROM dbo.Cliente
WHERE Nome = 'André'

UPDATE dbo.Cliente
SET Salario = Salario * 1.1
WHERE Id_Cliente = 2

UPDATE dbo.Cliente
SET Salario = 10, Nome = 'Judas Iscariodes', Data_Nascimento = '06/06/2066'
WHERE Id_Cliente = 1
Go

-- Como identificar a query que disparou a trigger --
DECLARE @SqlQuery VARCHAR(MAX)

DECLARE @TableSqlQuery TABLE (
    EventType NVARCHAR(30), 
    [Parameters] INT, 
    EventInfo NVARCHAR(MAX)
) 

INSERT INTO @TableSqlQuery 
EXEC('DBCC INPUTBUFFER(@@SPID)') 

SET @SqlQuery = (SELECT TOP(1) EventInfo FROM @TableSqlQuery)
Go

-- Adicionando o campo para armazenar a Tabela --
ALTER TABLE dbo.Cliente_Log ADD Ds_Query VARCHAR(MAX)
Go

-- Testando o comando --
INSERT INTO dbo.Cliente
VALUES('Dirceu', '1987-05-28', 0)

INSERT INTO dbo.Cliente
SELECT 
    'Resende' AS Nome, 
    '1987-05-28' AS Dt_Nascimento, 
    9999 AS Vl_Salario
Go

-- Realizando o teste de forma separada --
INSERT INTO dbo.Cliente
VALUES('Dirceu - Teste 2', '1987-05-28', 0)
GO

INSERT INTO dbo.Cliente
SELECT 
    'Resende - Teste 2' AS Nome, 
    '1987-05-28' AS Dt_Nascimento, 
    9999 AS Vl_Salario
GO

