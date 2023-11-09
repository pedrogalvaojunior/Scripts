create table #temp_test
 (id int);

insert into #temp_test
 values(1)
insert into #temp_test
 values(2)
insert into #temp_test
 values(3)
insert into #temp_test
 values(5)
go

with ABC_CTE as
 (select * from #temp_test)
delete from ABC_CTE where id = 1;

select * from #temp_test


