declare @foo as table (a char(1))

insert into @foo
select 'A'
union
select 'A'
union
select 'B'
union
select 'C'
union
select 'C'
union
select 'C'
union
select 'B'
union
select 'A'

Select Sum(Case a 
                    When 'A' Then 1
					When 'B' Then 7
					When 'C' Then 10
				   else 0
				   end)
from @foo