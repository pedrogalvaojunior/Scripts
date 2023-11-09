declare @t table (hora char(8))
insert into @t values ('15:22:43')
insert into @t values ('17:22:41')
;with valores (hora) as (
 select CAST(hora as time) from @t),
 totalsegundos (segundos) as (
 
select sum(DATEDIFF(ss,'00:00:00',hora)) from valores),
resultados as (
select
 (segundos / 3600) as horas,
 (segundos % 3600) / 60 as minutos,
 (segundos % 3600) % 60 as segundos
from totalsegundos)
select
 RIGHT('0'+CAST(horas as varchar(2)),2) + ':' +
 RIGHT('0'+CAST(minutos as varchar(2)),2) + ':' +
 RIGHT('0'+CAST(segundos as varchar(2)),2) As Total
from resultados
