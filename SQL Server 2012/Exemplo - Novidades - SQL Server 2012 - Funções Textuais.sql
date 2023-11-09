Use MsTechDay
Go

-- CONCAT: Efetua a concatena��o de seus par�metros realizando a convers�o se necess�rio. --
SELECT 'A' + 'B', CONCAT('A','B')
-- Ambos retornam AB

SELECT 2 + '40', CONCAT(2,40)
-- O retorno ser� 42 e 240 respectivamente

SELECT 2 + 'AB', CONCAT(2,'AB')
-- O retorno ser� uma exce��o.

-- FORMAT: Possibilita a formata��o de uma express�o com base em uma m�scara ou idioma. --
DECLARE @Data DATE = '2012-05-18'
SELECT FORMAT(@Data,'d','PT-BR') -- 18/05/2012
SELECT FORMAT(@Data,'M','PT-BR') -- 18 de maio
SELECT FORMAT(@Data,'Y','PT-BR') -- maio de 2012
SELECT FORMAT(@Data,'dd/M/yyyy') -- 18/5/2012
