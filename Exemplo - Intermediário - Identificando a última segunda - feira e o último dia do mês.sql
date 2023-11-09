-- código #1
declare @UltimoDiaMes date, @UltimaSegundaFeira date;

-- último dia do mês
set @UltimoDiaMes= eomonth(cast(current_timestamp as date));

-- última segunda-feira do mês
set datefirst 1;  -- considera semana iniciando na segunda-feira
set @UltimaSegundaFeira= dateadd(day,
                                 -datepart(dw, @UltimoDiaMes) +1,
                                 @UltimoDiaMes);

SELECT @UltimoDiaMes, @UltimaSegundaFeira;
       
Se a versão do SQL Server for anterior a 2012, utilize o seguinte código:
-- código #2
declare @UltimoDiaMes date, @UltimaSegundaFeira date;

-- último dia do mês
set @UltimoDiaMes= dateadd(day, -1, dateadd(month, datediff(month, 0, current_timestamp) +1, 0));

-- última segunda-feira do mês
set datefirst 1;  -- considera semana iniciando na segunda-feira
set @UltimaSegundaFeira= dateadd(day,
                                 -datepart(dw, @UltimoDiaMes) +1,
                                 @UltimoDiaMes);

SELECT @UltimoDiaMes, @UltimaSegundaFeira;