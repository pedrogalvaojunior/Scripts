create table #Table1 (Col1 varchar(10))
create table #Table2 (Col1 varchar(10))

insert into #table1 values ('1')

insert into #table2 values ('1')
insert into #table2 values ('_1')
insert into #table2 values ('%1')
insert into #table2 values ('[_]1')
insert into #table2 values ('[%]1')

select * from #table1 t1 inner join #table2 t2 
                                         on t1.Col1 like t2.Col1
