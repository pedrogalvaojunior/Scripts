-- Se você estiver utilizando o SQL Server 2012 ou mais recente pode utilizar a função DateFromParts: --
select datefromparts(AnoComp, MesComp, 5) as DataDia5
Go

-- Se estiver utilizando uma versão anterior a 2012 pode utilizar essa alternativa: --

select dateadd(month, MesComp - 1, dateadd(year, AnoComp - 1900, 4)) as DataDia5
Go