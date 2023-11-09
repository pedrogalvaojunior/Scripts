SET LANGUAGE Português

 

SELECT DATENAME(weekday, GetDate()) + ‘, ‘   +

       DATENAME(day, GetDate())     + ‘ de ‘ +

       DATENAME(month, GetDate())   + ‘ de ‘ +

       DATENAME(year, GetDate())
Go