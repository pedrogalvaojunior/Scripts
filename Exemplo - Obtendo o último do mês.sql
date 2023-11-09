DECLARE @Mes Int,
        @Ano Int,
        @DataFinal Date

Set @Mes = Month(GetDate())
Set @Ano = Year(GetDate())

Set @DataFinal = DATEADD(YEAR, @Ano - 1900, DATEADD(MONTH, @Mes, 0)) - 1

SELECT CONVERT(VARCHAR, @DataFinal, 103) AS [�ltimo dia de um determinado m�s]
GO