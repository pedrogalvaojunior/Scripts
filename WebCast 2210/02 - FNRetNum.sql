-- Muda o contexto do banco de dados
USE DBQueryPlus;

-- Monta uma tabela com números de 0 a 9
WITH Nums (Num) AS (
SELECT 0 UNION ALL SELECT 1 UNION ALL
SELECT 2 UNION ALL SELECT 3 UNION ALL
SELECT 4 UNION ALL SELECT 5 UNION ALL
SELECT 6 UNION ALL SELECT 7 UNION ALL
SELECT 8 UNION ALL SELECT 9)

--SELECT Num FROM Nums

-- Retorna uma tabela com 100 números
SELECT N1.Num AS Num1, N2.Num AS Num2,
--ROW_NUMBER() OVER (ORDER BY N1.Num),
(N1.Num * 10) + N2.Num + 1
FROM Nums AS N1 CROSS JOIN Nums AS N2


















-- Transforma a consulta em função com limite
CREATE FUNCTION dbo.FNRetNum (@Limite TINYINT)
RETURNS TABLE
AS RETURN (

WITH Nums (Num) AS (
SELECT 0 UNION ALL SELECT 1 UNION ALL
SELECT 2 UNION ALL SELECT 3 UNION ALL
SELECT 4 UNION ALL SELECT 5 UNION ALL
SELECT 6 UNION ALL SELECT 7 UNION ALL
SELECT 8 UNION ALL SELECT 9)

SELECT ROW_NUMBER() OVER (ORDER BY N1.Num) AS Num
FROM Nums AS N1 CROSS JOIN Nums AS N2
WHERE (N1.Num * 10) + N2.Num + 1 <= @Limite)

-- Testa a função
SELECT Num FROM dbo.FNRetNum(3)
SELECT Num FROM dbo.FNRetNum(8)
SELECT Num FROM dbo.FNRetNum(9)