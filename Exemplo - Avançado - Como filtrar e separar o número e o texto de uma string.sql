-- Criação da base de testes --
IF (OBJECT_ID('tempdb..#Teste') IS NOT NULL) DROP TABLE #Teste
CREATE TABLE #Teste (
    Nr_Documento VARCHAR(50)
)

INSERT INTO #Teste
VALUES 
    ('12345678909'),
    ('123.456.789-09'),
    ('Dirceu12345Resende678909.com'),
    (' 12345678909 '),
    ('"12345678909"'),
    ('d12345678909'),
    ('12345+6789-09'),
    ('123456.789'),
    ('R$ 123456.789'),
    ('$ 123456.789'),
    ('+123456.789'),
    ('-123456.789'),
    ('Dirceu Resende'),
    ('Dirceu[Resende]')

-- Como filtrar a parte numérica e a parte texto de uma string --

-- Código fonte da fncRecupera_Letras --

CREATE FUNCTION [dbo].[fncRecupera_Letras] ( @str VARCHAR(500) )
RETURNS VARCHAR(500)
BEGIN

    DECLARE @startingIndex INT = 0
    
    WHILE (1 = 1)
    BEGIN
        
        SET @startingIndex = PATINDEX('%[^a-Z|^ ]%', @str)
        
        IF @startingIndex <> 0
        BEGIN
            SET @str = REPLACE(@str, SUBSTRING(@str, @startingIndex, 1), '')
        END
        ELSE
            BREAK

    END

    RETURN @str

END
Go

-- Exemplo 1 – Como retornar linhas com apenas números (NOT LIKE) --
SELECT * 
FROM #Teste
WHERE Nr_Documento IS NOT NULL
AND Nr_Documento NOT LIKE '%a%'
AND Nr_Documento NOT LIKE '%b%'
AND Nr_Documento NOT LIKE '%c%'
AND Nr_Documento NOT LIKE '%d%'
AND Nr_Documento NOT LIKE '%e%'
AND Nr_Documento NOT LIKE '%f%'
AND Nr_Documento NOT LIKE '%g%'
AND Nr_Documento NOT LIKE '%h%'
AND Nr_Documento NOT LIKE '%i%'
AND Nr_Documento NOT LIKE '%j%'
AND Nr_Documento NOT LIKE '%k%'
AND Nr_Documento NOT LIKE '%l%'
AND Nr_Documento NOT LIKE '%m%'
AND Nr_Documento NOT LIKE '%n%'
AND Nr_Documento NOT LIKE '%o%'
AND Nr_Documento NOT LIKE '%p%'
AND Nr_Documento NOT LIKE '%q%'
AND Nr_Documento NOT LIKE '%r%'
AND Nr_Documento NOT LIKE '%s%'
AND Nr_Documento NOT LIKE '%t%'
AND Nr_Documento NOT LIKE '%u%'
AND Nr_Documento NOT LIKE '%v%'
AND Nr_Documento NOT LIKE '%x%'
AND Nr_Documento NOT LIKE '%w%'
AND Nr_Documento NOT LIKE '%z%'
AND Nr_Documento NOT LIKE '%y%'
AND Nr_Documento NOT LIKE '%.%'
AND Nr_Documento NOT LIKE '%-%'
AND Nr_Documento NOT LIKE '%"%'
AND Nr_Documento NOT LIKE '%[%'
AND Nr_Documento NOT LIKE '%]%'

-- Exemplo 2 – Como retornar linhas com apenas números (ISNUMERIC) --
SELECT * 
FROM #Teste
WHERE ISNUMERIC(Nr_Documento) = 1

-- Exemplo 3 – Como retornar linhas com apenas números (NOT LIKE e Expressão Regular) --
SELECT * 
FROM #Teste
WHERE Nr_Documento NOT LIKE '%[A-z]%'

-- Exemplo 4 – Como retornar linhas com apenas letras --
SELECT * 
FROM #Teste
WHERE Nr_Documento NOT LIKE '%[^A-z]%'

SELECT * 
FROM #Teste
WHERE Nr_Documento NOT LIKE '%[^A-z ]%' -- Reparem esse espaço no final

-- Exemplo 5 – Como retornar linhas que contém caracteres especiais --
-- Estou permitindo também, os caracteres (+), (.) e (-), além do espaço
SELECT * 
FROM #Teste
WHERE Nr_Documento LIKE '%[^A-z0-9 +.-]%'

-- Como separar a parte numérica e a parte texto de uma string --

-- Código fonte da fncRecupera_Numeros --
CREATE FUNCTION [dbo].[fncRecupera_Numeros] ( @str VARCHAR(500) )
RETURNS VARCHAR(500)
BEGIN

    DECLARE @startingIndex INT = 0
    
    WHILE (1 = 1)
    BEGIN
        
        SET @startingIndex = PATINDEX('%[^0-9]%', @str)
        
        IF @startingIndex <> 0
        BEGIN
            SET @str = REPLACE(@str, SUBSTRING(@str, @startingIndex, 1), '')
        END
        ELSE
            BREAK

    END

    RETURN @str

END
Go

SELECT 
    Nr_Documento,
    dbo.fncRecupera_Numeros(Nr_Documento)
FROM
    #Teste
WHERE
    dbo.fncRecupera_Numeros(Nr_Documento) = '12345678909'
Go

SELECT 
    Nr_Documento,
    dbo.fncRecupera_Numeros(Nr_Documento)
FROM
    #Teste
WHERE
    dbo.fncRecupera_Numeros(Nr_Documento) = '12345678909'
Go

-- Analisando todas as linhas dessa tabela, agora utilizando também as 2 funções --
SELECT 
    Nr_Documento,
    dbo.fncRecupera_Numeros(Nr_Documento) AS Parte_Numerica,
    dbo.fncRecupera_Letras(Nr_Documento) AS Parte_Textual
FROM
    #Teste


-- Como melhorar a performance das consultas utilizando essas funções --
-- Uma outra dica legal, é que dá até pra criar uma coluna calculada, indexada, para fazer as buscas bem mais rápido: --
-- Crio a tabela física no mesmo database das funções
IF (OBJECT_ID('dbo.DadosExemplo') IS NOT NULL) DROP TABLE dbo.DadosExemplo
CREATE TABLE dbo.DadosExemplo (
    Nr_Documento VARCHAR(50)
)

INSERT INTO dbo.DadosExemplo
VALUES 
    ('12345678909'),
    ('123.456.789-09'),
    ('Dirceu12345Resende678909.com'),
    (' 12345678909 '),
    ('"12345678909"'),
    ('d12345678909'),
    ('12345+6789-09'),
    ('123456.789'),
    ('R$ 123456.789'),
    ('$ 123456.789'),
    ('+123456.789'),
    ('-123456.789'),
    ('Dirceu Resende'),
    ('Dirceu[Resende]')

ALTER TABLE dbo.DadosExemplo ADD
    Parte_Numerica AS (dbo.fncRecupera_Numeros(Nr_Documento)) PERSISTED,
    Parte_Textual AS (dbo.fncRecupera_Letras(Nr_Documento)) PERSISTED
Go

IF (OBJECT_ID('dbo.fncRecupera_Letras') IS NOT NULL) DROP FUNCTION dbo.fncRecupera_Letras
GO

CREATE FUNCTION [dbo].[fncRecupera_Letras] ( @str VARCHAR(500) )
RETURNS VARCHAR(500)
WITH SCHEMABINDING
BEGIN

    DECLARE @startingIndex INT = 0
    
    WHILE (1 = 1)
    BEGIN
        
        SET @startingIndex = PATINDEX('%[^a-Z|^ ]%', @str)
        
        IF @startingIndex <> 0
        BEGIN
            SET @str = REPLACE(@str, SUBSTRING(@str, @startingIndex, 1), '')
        END
        ELSE
            BREAK

    END

    RETURN @str

END
GO


IF (OBJECT_ID('dbo.fncRecupera_Numeros') IS NOT NULL) DROP FUNCTION dbo.fncRecupera_Numeros
GO

CREATE FUNCTION [dbo].[fncRecupera_Numeros] ( @str VARCHAR(500) )
RETURNS VARCHAR(500)
WITH SCHEMABINDING
BEGIN

    DECLARE @startingIndex INT = 0
    
    WHILE (1 = 1)
    BEGIN
        
        SET @startingIndex = PATINDEX('%[^0-9]%', @str)
        
        IF @startingIndex <> 0
        BEGIN
            SET @str = REPLACE(@str, SUBSTRING(@str, @startingIndex, 1), '')
        END
        ELSE
            BREAK

    END

    RETURN @str

END
GO

ALTER TABLE dbo.DadosExemplo ADD
    Parte_Numerica AS (dbo.fncRecupera_Numeros(Nr_Documento)) PERSISTED,
    Parte_Textual AS (dbo.fncRecupera_Letras(Nr_Documento)) PERSISTED
Go

CREATE NONCLUSTERED INDEX SK01_DadosExemplo ON dbo.DadosExemplo(Parte_Numerica) INCLUDE(Nr_Documento) WITH(DATA_COMPRESSION=PAGE)
CREATE NONCLUSTERED INDEX SK02_DadosExemplo ON dbo.DadosExemplo(Parte_Textual) INCLUDE(Nr_Documento) WITH(DATA_COMPRESSION=PAGE)
Go
