-- código 1
CREATE FUNCTION CalcPrest (@C money, @i numeric(9,5), @n int) 
returns money as 
begin
declare @TM float, @a float, @b float;
set @TM= @i / 100;
set @a= Power((1 + @TM), @n) * @TM;
set @b= Power((1 + @TM), @n) -1;
return Cast((@C * (@a / @b)) as money);
end;
go

  
-- A função acima pode ser reescrita na forma de inline table-valued function, que permite melhor performance caso o volume de linhas seja elevado.

-- código 2
CREATE FUNCTION CalcPrest (@C money, @i numeric(9,5), @n int) 
returns table as return
SELECT Cast(@C  *
            (Power((1 + (@i / 100)), @n) * (@i / 100))  /
            (Power((1 + (@i / 100)), @n) -1)
            as money) as Prestação;
go

-- Utilizar Cross Apply na execução

