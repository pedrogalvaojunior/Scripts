Use MsTechDay
Go

-- CONCAT: Efetua a concatenação de seus parâmetros realizando a conversão se necessário. --
SELECT 'A' + 'B', CONCAT('A','B')
-- Ambos retornam AB

SELECT 2 + '40', CONCAT(2,40)
-- O retorno será 42 e 240 respectivamente

SELECT 2 + 'AB', CONCAT(2,'AB')
-- O retorno será uma exceção.

-- FORMAT: Possibilita a formatação de uma expressão com base em uma máscara ou idioma. --
DECLARE @Data DATE = '2012-05-18'
SELECT FORMAT(@Data,'d','PT-BR') -- 18/05/2012
SELECT FORMAT(@Data,'M','PT-BR') -- 18 de maio
SELECT FORMAT(@Data,'Y','PT-BR') -- maio de 2012
SELECT FORMAT(@Data,'dd/M/yyyy') -- 18/5/2012
