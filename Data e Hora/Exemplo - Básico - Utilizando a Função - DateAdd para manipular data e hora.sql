-- Exemplo 1 - Adicionando um quartil --
SELECT DATEADD( qq, 1, '2016')
Go

-- Exemplo 2 - Adicionando Miléssimos de segundos em uma data e hora --
DECLARE @datetime2 datetime2 = '2016-03-01 13:10:10.1111111';
  SELECT '1 millisecond', DATEADD(millisecond,1,@datetime2)
  UNION ALL
  SELECT '2 milliseconds', DATEADD(millisecond,2,@datetime2)
  UNION ALL
  SELECT '1 microsecond', DATEADD(microsecond,1,@datetime2)
  UNION ALL
  SELECT '2 microseconds', DATEADD(microsecond,2,@datetime2)
  UNION ALL
  SELECT '49 nanoseconds', DATEADD(nanosecond,49,@datetime2)
  UNION ALL
  SELECT '50 nanoseconds', DATEADD(nanosecond,50,@datetime2)
  UNION ALL
  SELECT '150 nanoseconds', DATEADD(nanosecond,150,@datetime2);
Go

-- Exemplo 3 - Utilizando diversas opções para adicionar valores a uma data e hora --
DECLARE @datetime2 datetime2 = '2016-02-27 11:25:12.1111111';
  SELECT 'year', DATEADD(year,1,@datetime2)
  UNION ALL
  SELECT 'quarter',DATEADD(quarter,1,@datetime2)
  UNION ALL
  SELECT 'month',DATEADD(month,1,@datetime2)
  UNION ALL
  SELECT 'dayofyear',DATEADD(dayofyear,1,@datetime2)
  UNION ALL
  SELECT 'day',DATEADD(day,1,@datetime2)
  UNION ALL
  SELECT 'week',DATEADD(week,1,@datetime2)
  UNION ALL
  SELECT 'weekday',DATEADD(weekday,1,@datetime2)
  UNION ALL
  SELECT 'hour',DATEADD(hour,1,@datetime2)
  UNION ALL
  SELECT 'minute',DATEADD(minute,1,@datetime2)
  UNION ALL
  SELECT 'second',DATEADD(second,1,@datetime2)
  UNION ALL
  SELECT 'millisecond',DATEADD(millisecond,1,@datetime2)
  UNION ALL
  SELECT 'microsecond',DATEADD(microsecond,1,@datetime2)
  UNION ALL
  SELECT 'nanosecond',DATEADD(nanosecond,1,@datetime2);
Go

-- Exemplo 4 - Utilizando diversas opções para adicionar valores a uma data e hora --
DECLARE @datetime2 datetime2
SET @datetime2 = '2016-02-27 01:01:01.1111111'

SELECT DATEADD(quarter,4,@datetime2);
SELECT DATEADD(month,13,@datetime2);
SELECT DATEADD(dayofyear,365,@datetime2);
SELECT DATEADD(day,365,@datetime2);
SELECT DATEADD(week,5,@datetime2);
SELECT DATEADD(weekday,31,@datetime2);
SELECT DATEADD(hour,23,@datetime2);
SELECT DATEADD(minute,59,@datetime2);
SELECT DATEADD(second,59,@datetime2);
SELECT DATEADD(millisecond,1,@datetime2);
Go

-- Exemplo - 5 - Adicionando uma quantidade de dias específicos em uma data --
DECLARE @days int = 365, 
                @datetime datetime = '2016-02-27'; /* 2000 was a leap year */;
SELECT DATEADD(day, @days, @datetime);
Go