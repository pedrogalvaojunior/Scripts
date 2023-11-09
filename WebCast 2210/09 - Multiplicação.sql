-- Muda o contexto de banco de dados
USE DBQueryPlus;

-- Verifica os números cadastrados
SELECT Valor FROM tblNumeros

-- Mostra o produto dos registros (pré-fixado)
SELECT 2 * 3 * 6 * 7










-- Utilização de um "BUG" do TSQL
DECLARE @Tot INT
SET @Tot = 1

SELECT @Tot = @Tot * Valor FROM tblNumeros

SELECT @Tot AS Total










-- O uso do logarítmo
-- Elevando 10 ao cubo
SELECT POWER(10,3) AS [Dez Elevado ao Cubo]

-- Calculando o logaritmo de 1000 na base 10
SELECT LOG10(1000)

-- Testando uma das propriedades de logarítmo
SELECT LOG10(100), LOG10(1000), LOG10(100 * 1000)

-- Aplicando o SUM dos logaritmos
SELECT SUM(LOG10(Valor)) FROM tblNumeros

-- Elevando o resultado em uma base 10
SELECT POWER(10,SUM(LOG10(Valor))) FROM tblNumeros