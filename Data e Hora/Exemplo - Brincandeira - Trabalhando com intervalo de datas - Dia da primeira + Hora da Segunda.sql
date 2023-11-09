DECLARE @d1 DATETIME = '20170101 09:42'
DECLARE @d2 DATETIME = '20170301 22:22'

SELECT DATEADD(DAY, DATEDIFF(DAY, @d2, @d1), @d2)

-- Explicando o resultado --

Select @D1, @d2

Select DateDiff(day,@d2,@d1)

Select DateAdd(day,-59,@d2)

