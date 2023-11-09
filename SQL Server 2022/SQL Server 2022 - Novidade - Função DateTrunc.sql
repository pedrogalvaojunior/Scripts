-- Exemplo 1 - Diferentes opções de DatePart --
DECLARE @d datetime2 = '2021-12-08 11:30:15.1234567'
SELECT 'Year', DATETRUNC(year, @d)
SELECT 'Quarter', DATETRUNC(quarter, @d)
SELECT 'Month', DATETRUNC(month, @d)
SELECT 'Week', DATETRUNC(week, @d) -- Using the default DATEFIRST setting value of 7 (U.S. English)
SELECT 'Iso_week', DATETRUNC(iso_week, @d)
SELECT 'DayOfYear', DATETRUNC(dayofyear, @d)
SELECT 'Day', DATETRUNC(day, @d)
SELECT 'Hour', DATETRUNC(hour, @d)
SELECT 'Minute', DATETRUNC(minute, @d)
SELECT 'Second', DATETRUNC(second, @d)
SELECT 'Millisecond', DATETRUNC(millisecond, @d)
SELECT 'Microsecond', DATETRUNC(microsecond, @d)
Go

-- Exemplo 2 - Configuração @@DateFirst --
DECLARE @d datetime2 = '2021-11-11 11:11:11.1234567'

SELECT 'Week-7', DATETRUNC(week, @d) -- Uses the default DATEFIRST setting value of 7 (U.S. English)

SET DATEFIRST 6
SELECT 'Week-6', DATETRUNC(week, @d)

SET DATEFIRST 3
SELECT 'Week-3', DATETRUNC(week, @d)
Go

-- Exemplo 3 - Literais de Data --
SELECT DATETRUNC(month, '1998-03-04')

SELECT DATETRUNC(millisecond, '1998-03-04 10:10:05.1234567')

DECLARE @d1 char(200) = '1998-03-04'
SELECT DATETRUNC(millisecond, @d1)

DECLARE @d2 nvarchar(max) = '1998-03-04 10:10:05'
SELECT DATETRUNC(minute, @d2)
Go

-- Exemplo 5 - Variáveis como parâmetros date --
DECLARE @d datetime2 = '1998-12-11 02:03:04.1234567'
SELECT DATETRUNC(day, @d)
Go

-- Exemplo 6 - Expressões e parâmetro date --
SELECT DATETRUNC(m, SYSDATETIME())

SELECT DATETRUNC(yyyy, CONVERT(date, '2021-12-1'))

SELECT DATETRUNC(month, DATEADD(month, 4, TransactionDate))
FROM Sales.CustomerTransactions;
Go