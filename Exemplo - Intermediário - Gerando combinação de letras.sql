create table #t (string varchar (2))

declare @a1 varchar(1), @a2 varchar(1)
set @a1='A'

while @a1 <= 'Z' 
begin
 set @a2='A'

 while @a2 <= 'Z'
 begin
  insert into #t select @a1 + @a2
  set @a2 = char (ascii(@a2) + 1)
 end
 
 set @a1 = char (ascii(@a1) + 1)
end

select string from #t
where string like '_' /*single underscore*/

drop table #t