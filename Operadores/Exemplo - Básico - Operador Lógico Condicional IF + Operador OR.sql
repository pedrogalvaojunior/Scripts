declare @var char, @c char
set @c = 'I'
set @var = 'E'

if (@c <> 'I') OR (@var <> 'E') 
 begin
   select 'not OK'
 end
else
 select 'OK'