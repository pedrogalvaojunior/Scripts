declare @DataNascimento date;
declare @Anos int;
declare @Meses int;
declare @Dias int;
set @DataNascimento = '20011231';

declare @DataAux date;
set @Anos = Year(current_timestamp) -
            Year(@DataNascimento) - 
            case when 
                    Month(current_timestamp) * 100 - Day(current_timestamp) <
                    Month(@DataNascimento) * 100 + Day(@DataNascimento)
                then 1
                else 0
            end;
set @DataAux = dateadd(year, @Anos, @DataNascimento);
set @Meses = datediff(month, @DataAux, current_timestamp) -
             case when Day(current_timestamp) < Day(@DataNascimento)
                 then 1
                 else 0
              end;
set @DataAux = dateadd(month, @Meses, @DataAux);
set @Dias = datediff(day, @DataAux, current_timestamp);

select
    @Anos as Anos,
    @Meses as Meses,
    @Dias as Dias
Go