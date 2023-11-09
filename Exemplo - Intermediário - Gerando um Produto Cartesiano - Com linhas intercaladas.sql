--
-- The Lonely and Neglected Cartesian Product (Cross Join)
--
-- create and fill employee table with 5 row sample
--
create table #temp1(PK int IDENTITY Primary Key, column1 varchar(20))
insert into #temp1 values ('employee 1')
insert into #temp1 values ('employee 2')
insert into #temp1 values ('employee 3')
insert into #temp1 values ('employee 4')
insert into #temp1 values ('employee 5')
--
-- create and fill 'tally' table with 3 rows
-- because we want 3 rows per employee
--
create table #temp2(PK int IDENTITY Primary Key, column1 varchar(20))
insert into #temp2 values ('') 
insert into #temp2 values ('')
insert into #temp2 values ('')
--
select * from #temp1
select * from #temp2
--
-- First query attempt 
--
select t1.PK, t1.column1, '' as 'Signature Column' 
from #temp1 t1 cross join #temp1 t2 order by t1.PK
--
-- Second query attempt
--
select t1.PK, t1.column1, '' as 'Signature Column'
from #temp1 t1 cross join #temp2 t2 order by t1.PK
--
-- Third query attempt
--
select t2.PK, 
 case t2.PK 
  WHEN 1 THEN t1.column1 
  ELSE t2.column1 END 'Signature Column'
 from #temp1 t1 
  cross join #temp2 t2 
 order by t1.PK, t1.column1 
--
drop table #temp1
drop table #temp2