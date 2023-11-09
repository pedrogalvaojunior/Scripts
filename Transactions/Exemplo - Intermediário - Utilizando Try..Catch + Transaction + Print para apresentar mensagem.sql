declare @i int, @j int
 set @i = 1

create table #temp (id int)

 while (@i<=5)
 begin

 begin try
 begin transaction
 
 if (@i = 3) 
 set @j = @i/0
 
 insert into #temp values (@i)
 commit transaction
 end try 
 
 begin catch
 rollback transaction
 print 'this is an exception';
 end catch
 
 set @i = @i + 1 
 end

select * from #temp