-- Exemplo 1 --
DECLARE @INICIAL AS DATETIME

DECLARE @FINAL AS DATETIME

SET @INICIAL = '2008-06-23 11:58:58'

SET @FINAL = '2008-06-25 12:23:12'


SELECT DATEDIFF(HH, CAST('1900-01-01' AS DATETIME), @FINAL - @INICIAL) AS HORAS, DATEPART(MINUTE, @FINAL - @INICIAL) AS MINUTOS,

DATEPART(SECOND, @FINAL - @INICIAL) AS SEGUNDOS

Go

-- Exemplo 2 --
declare @inicial datetime

declare @final datetime

set @inicial = cast('2008-01-01 13:00:00' as datetime)

set @final = cast('2008-01-02 14:30:12' as datetime)

select datediff(hour, @inicial, @final) as Horas, datediff(minute, @inicial, @final) - (datediff(hour, @inicial, @final) * 60) as Minutos, datediff(second, @inicial, @final) - (datediff(minute, @inicial, @final) * 60) as Segundos

Go