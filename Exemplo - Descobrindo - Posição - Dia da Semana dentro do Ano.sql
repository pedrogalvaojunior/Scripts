-- Exemplo 1 --
select 
    Data,
    Valor,
    CAST(DATEPART(WEEK, Data) - 
         case when DATEPART(WEEKDAY, Data) < DATEPART(WEEKDAY, DATEADD(YEAR, YEAR(Data) - 1900, '19000101'))
             then 1
             else 0
         end as varchar(2)) + '. ' + LEFT(DATENAME(WEEKDAY, Data), 3) as Data_Ano
from Tabela

-- Exemplo 2 --
select cast(DATEPART(wk,'2011-04-12') as varchar) +'.'+ cast(DATEPART(dw,'2011-04-12') as varchar)

-- Exemplo 3 -- SQL Server 2012 --
select Concat(DATEPART(wk,'2011-04-12'),'.',DATEPART(dw,'2011-04-12'))