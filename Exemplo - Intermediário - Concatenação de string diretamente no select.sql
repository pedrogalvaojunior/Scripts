create table xxx (i int identity, a varchar(3))
go
declare @txt varchar(255)
set @txt = 'Question'
select @txt = isnull (a, '?') from xxx order by i
insert xxx values ('of')
insert xxx values ('the')
insert xxx values ('day')
select @txt = @txt + ' ' + a from xxx order by i
select @txt