CREATE FUNCTION dbo.ConcatenaValores (@C1 int, @C2 int, @C3 int, @C4 int, @C5 int)
returns int as
begin

declare @Concatenado varchar(5);

set @Concatenado= space(0);

SELECT @Concatenado+= Cast(N as char(1))
  from (values (@C1), (@C2), (@C3), (@C4), (@C5)) as Numeros(N)
  order by N desc;

return Cast(@Concatenado as int);
end;
go

Select Valor= dbo.ConcatenaValores(1, 2, 3, 4, 5);

