declare @DataIni date;
declare @DataFim date;

set @DataIni = '20150401';
set @DataFim = '20150430';

with CTE_Datas as
(
    select @DataIni as Data, @DataFim as DataFim
    
    union all
    
    select DATEADD(DAY, 1, Data), DataFim
    from CTE_Datas
    where Data < DataFim
)

select Data from CTE_Datas