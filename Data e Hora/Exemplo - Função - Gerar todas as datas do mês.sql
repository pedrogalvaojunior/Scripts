create function fnDatas(@ano smallint, @mes tinyint)

returns @datas table (data smalldatetime)

as

begin

declare @dia tinyint, @data varchar(10)

set @dia = 1

while @dia <= 31

begin

set @data = cast(@ano as char(4)) + '-' +

cast(@mes as varchar(2)) + '-' +

cast(@dia as varchar(2))

if isdate(@data) = 1

insert into @datas values (@data)

set @dia = @dia + 1

end

return

end

select * from fnDatas(2007,2)
