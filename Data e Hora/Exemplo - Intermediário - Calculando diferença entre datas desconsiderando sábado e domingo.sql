declare @Data datetime set @Data = '2015/10/01'

 
 
--Calcula a quantidade de dias entre a data inicial e a data atual, excluindo sbados e domingos soma 1 no fim pois no conta o proprio dia

 
 
WITH AllDates AS

 
 
(   SELECT  TOP (DATEDIFF(DAY, @Data, GETDATE()))

 
 
D = DATEADD(DAY, ROW_NUMBER() OVER(ORDER BY a.Object_ID), @Data)

 
 
FROM    sys.all_objects a

 
 
CROSS JOIN sys.all_objects b

 
 
)

 
 
SELECT  WeekDays = COUNT(*) +1 -

 
 
--Clcula a quantidade de feriados entre as datas

 
 
 
(select count(*) from FTAFE(NOLOCK)

 
 
where convert(datetime, convert(varchar, FTAFE.DT_FERIADO), 112) between @Data and GETDATE()

 
 
and FTAFE.CD_CIDADE in(0)

 
 
and DATEPART(weekday, convert(datetime, convert(varchar, FTAFE.DT_FERIADO), 112)  ) not in(6,7))

 
 
FROM    AllDates

 
 
WHERE   DATEPART(WEEKDAY, D) NOT IN(6, 7)

 
 
--Fim da edio SR63613-MA90453
