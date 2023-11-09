Use MsTechDay
Go

-- Utilizando - Função para tipos temporais --
SELECT DATEFROMPARTS(2011,09,29)
-- Retorna 2011-09-29

SELECT TIMEFROMPARTS(18,15,20,15,2)
-- Retorna 18:15:20.15

SELECT EOMONTH('20110929')
-- Retorna 2011-09-30 00:00:00.0000000

SELECT EOMONTH('20110929',3)
-- Retorna 2011-12-31 00:00:00.0000000


-- Funções lógicas --
SELECT CHOOSE(3,'Jul','Ago','Set')
-- Retorna "Set"

DECLARE @US SMALLMONEY = 1.65
DECLARE @Limite SMALLMONEY = 1.80

SELECT IIF(@US <= @Limite,'Bom','Ruim')
-- Retorna "Bom"


SELECT CHOOSE(4,'Jul','Ago','Set')
-- Retorna "Set"

DECLARE @US SMALLMONEY = 1.65
DECLARE @Limite SMALLMONEY = 1.80

SELECT IIF(@US = @Limite,'Bom','Ruim')
-- Retorna "Bom"
