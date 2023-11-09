-- c�digo #1
declare @UltimoDiaMes date, @UltimaSegundaFeira date;

-- �ltimo dia do m�s
set @UltimoDiaMes= eomonth(cast(current_timestamp as date));

-- �ltima segunda-feira do m�s
set datefirst 1;  -- considera semana iniciando na segunda-feira
set @UltimaSegundaFeira= dateadd(day,
                                 -datepart(dw, @UltimoDiaMes) +1,
                                 @UltimoDiaMes);

SELECT @UltimoDiaMes, @UltimaSegundaFeira;
       
Se a vers�o do SQL Server for anterior a 2012, utilize o seguinte c�digo:
-- c�digo #2
declare @UltimoDiaMes date, @UltimaSegundaFeira date;

-- �ltimo dia do m�s
set @UltimoDiaMes= dateadd(day, -1, dateadd(month, datediff(month, 0, current_timestamp) +1, 0));

-- �ltima segunda-feira do m�s
set datefirst 1;  -- considera semana iniciando na segunda-feira
set @UltimaSegundaFeira= dateadd(day,
                                 -datepart(dw, @UltimoDiaMes) +1,
                                 @UltimoDiaMes);

SELECT @UltimoDiaMes, @UltimaSegundaFeira;