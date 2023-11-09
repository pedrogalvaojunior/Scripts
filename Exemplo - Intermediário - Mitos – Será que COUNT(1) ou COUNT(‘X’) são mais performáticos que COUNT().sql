-- Criando o Banco de Dados --
Create Database Mitos
Go

-- Acessando o Banco de Dados --
Use Mitos
Go

-- Criar a tabela --
CREATE TABLE T (
    ID BIGINT IDENTITY(1,1), VERSAO TIMESTAMP,
    UG UNIQUEIDENTIFIER DEFAULT NEWID(),
    C01 BIGINT, C02 BIGINT, C03 BIGINT, C04 BIGINT, C05 BIGINT, 
    C06 BIGINT, C07 BIGINT, C08 BIGINT, C09 BIGINT, C10 BIGINT, 
    C11 BIGINT, C12 BIGINT, C13 BIGINT, C14 BIGINT, C15 BIGINT, 
    C16 BIGINT, C17 BIGINT, C18 BIGINT, C19 BIGINT, C20 BIGINT, 
    C21 BIGINT, C22 BIGINT, C23 BIGINT, C24 BIGINT, C25 BIGINT, 
    C26 BIGINT, C27 BIGINT, C28 BIGINT, C29 BIGINT, C30 BIGINT)
Go

-- Inserir dez mil registros com valores aleatórios --
DECLARE @i INT
SET @i = 1

WHILE @i <= 10000
BEGIN
    INSERT INTO T (
        C01, C02, C03, C04, C05, C06, C07, C08, C09, C10,
        C11, C12, C13, C14, C15, C16, C17, C18, C19, C20,
        C21, C22, C23, C24, C25, C26, C27, C28, C29, C30)
    VALUES (
        CHECKSUM(NEWID()), CHECKSUM(NEWID()), CHECKSUM(NEWID()),
        CHECKSUM(NEWID()), CHECKSUM(NEWID()), CHECKSUM(NEWID()),
        CHECKSUM(NEWID()), CHECKSUM(NEWID()), CHECKSUM(NEWID()),
        CHECKSUM(NEWID()), CHECKSUM(NEWID()), CHECKSUM(NEWID()),
        CHECKSUM(NEWID()), CHECKSUM(NEWID()), CHECKSUM(NEWID()),
        CHECKSUM(NEWID()), CHECKSUM(NEWID()), CHECKSUM(NEWID()),
        CHECKSUM(NEWID()), CHECKSUM(NEWID()), CHECKSUM(NEWID()),
        CHECKSUM(NEWID()), CHECKSUM(NEWID()), CHECKSUM(NEWID()),
        CHECKSUM(NEWID()), CHECKSUM(NEWID()), CHECKSUM(NEWID()),
        CHECKSUM(NEWID()), CHECKSUM(NEWID()), CHECKSUM(NEWID()))
    SET @i = @i + 1
END

-- Para tornar as coisas realmente interessantes, farei uma consulta com quatro variações (0, 1, ‘X’ e *) para fins comparativos. --

-- Ativa as medições de tempo e IO --
SET STATISTICS TIME ON
SET STATISTICS IO ON
Go

-- Ativar exibição do Plano de Execução --

-- Comparativo 1 -- Retorna todos os registros de 4 formas diferentes --
SELECT COUNT('X') FROM T
SELECT COUNT(1) FROM T
SELECT COUNT(0) FROM T
SELECT COUNT(*) FROM T

/* Após executar o batch duas vezes obtive o seguinte resultado: (é necessário executar duas vezes para que as haja igualdade no 
cachê de dados e no plano de execução). */

-- Comparativo 2 - A influência dos índices em expressões do tipo COUNT --

-- Cria um índice sobre a coluna ID --
CREATE INDEX IX_ID ON T (ID)
Go

-- Retorna todos os registros de 4 formas diferentes --
SELECT COUNT('X') FROM T
SELECT COUNT(1) FROM T
SELECT COUNT(ID) FROM T
SELECT COUNT(*) FROM T
Go

-- Comparativo 3 - Elimina o índice sobre ID --
DROP INDEX T.IX_ID
Go

-- Atualiza 1000 registros tornando nulo C1 --
UPDATE T SET C01 = NULL WHERE ID <= 1000
Go

--  Cria um índice sobre C1 --
CREATE INDEX IX_ID ON T (C01)
Go

-- Retorna todos os registros de 4 formas diferentes --
SELECT COUNT('X') FROM T
SELECT COUNT(1) FROM T
SELECT COUNT(ID) FROM T
SELECT COUNT(*) FROM T
Go
