-- Exemplo 1 --
DECLARE @n CHAR(10);
SET @n = N'Abc';
SELECT UNICODE(@n);
Go

-- Exemplo 2 --
DECLARE @n NCHAR(10);
SET @n = N'??????????';
SELECT UNICODE(@n);
Go