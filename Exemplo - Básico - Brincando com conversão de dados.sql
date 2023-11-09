declare @c int,@d int
select @c = 211
select @c = cast(convert(varchar(2),convert(varchar(3),@c)) as float) * 0.5 
select @c