create table #teste (valor varchar(5))
go
insert into #teste values ('a1')
insert into #teste values ('a1')
insert into #teste values ('a1')
insert into #teste values ('a1')
insert into #teste values ('a1')
insert into #teste values ('a1')
insert into #teste values ('a2')
insert into #teste values ('a2')
insert into #teste values ('a2')
insert into #teste values ('a2')
insert into #teste values ('a2')
insert into #teste values ('a3')
insert into #teste values ('a3')
insert into #teste values ('a3')
insert into #teste values ('a3')
insert into #teste values ('a5')
insert into #teste values ('a5')
insert into #teste values ('a5')
insert into #teste values ('a5')
insert into #teste values ('a5')
go

select valor
	 , rownumber_total = ROW_NUMBER() over (order by valor)
	 , rownumber_agrupado = ROW_NUMBER() over (partition by valor order by valor)
	 , contator  = (1 + ((ROW_NUMBER() over (partition by valor order by valor) - 1) % 3)) 
  from #teste
  order by 1,2