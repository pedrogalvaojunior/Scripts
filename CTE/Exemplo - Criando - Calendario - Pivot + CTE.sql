DECLARE @Mes INT, @Ano INT

SELECT @Mes = 8, @Ano = 2010

;WITH CTE (Data) AS
(
  SELECT DATEADD(year, @Ano - 1900, DATEADD(month, @Mes - 1, 0))
  UNION ALL
  SELECT Data+1
  FROM CTE
  WHERE MONTH(Data + 1) = @Mes
)

SELECT
  [1] AS [Domingo]
, [2] AS [Segunda-Feira]
, [3] AS [Terça-Feira]
, [4] AS [Quarta-Feira]
, [5] AS [Quinta-Feira]
, [6] AS [Sexta-Feira]
, [7] AS [Sábado]
FROM 
 (
	SELECT DAY(Data) AS Dia, DATEPART(weekday, Data) DiaSemana, DATEPART(week, Data) Semana
	FROM CTE
 ) AS Datas
PIVOT
(
	MAX(Dia) FOR DiaSemana
	IN ([1], [2], [3], [4], [5], [6], [7])
) AS A
