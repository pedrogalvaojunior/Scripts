declare @image as table (
 row_id tinyint
);

insert into @image(row_id)
 values(1),(2),(3),(4),(5),(6),(7),(8),(9)

select 
 case 
  when max(i.row_id) over() - i.row_id > 1 then replicate(' ', max(i.row_id) over() - 2 - i.row_id) + replicate('*',i.row_id) + replicate('*',i.row_id-1)
  else replicate(' ', max(i.row_id) over() - 3) + '|'
 end img
from @image i