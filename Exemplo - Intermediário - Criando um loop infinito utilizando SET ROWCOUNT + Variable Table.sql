DECLARE @i float,
                @rc int

set @i = 0

while @i <> 1
begin 
 declare @a table(a int)

 set @rc = @i + 0.9
 
 set rowcount @rc
 
 insert into @a 
 select id from sysobjects
 
 set @i = @i + 0.1
end

SELECT * FROM @a