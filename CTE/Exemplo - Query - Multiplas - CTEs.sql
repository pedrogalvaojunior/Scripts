-- período de emissão do relatório
declare @DataInicial datetime, @DataFinal datetime;
set @DataInicial = convert(date, '1/1/2012', 103);
set @DataFinal = convert(date, '31/12/2013', 103);

-- ajusta data final para usar < na cláusula where
set @DataFinal = DateAdd(day, +1, @DataFinal);

--
;with 
-- calcula a quantidade média para cada produto
X1 as (
SELECT CodProd, 
       (sum (Qtd) / count(distinct convert(char(6), Data, 112))) as QtdMedia
  from CAIXAGERAL
  where Data >= @DataInicial and Data < @DataFinal
  group by CodProd
),
-- somatório dos valores de QtdMedia
X2 as (
SELECT sum(QtdMedia) as TotalQtdMedia
  from X1
),
-- calcula o percentual de cada produto no todo
X3 as (
SELECT CodProd, QtdMedia, (QtdMedia / TotalQtdMedia * 100) as [% prod],
  Seq= row_number() over (order by QtdMedia desc, CodProd)
  from X1 cross join X2
),
-- calcula acumulado de percentual
X4 as (
SELECT CodProd, QtdMedia, [% prod], Seq,
       [% acum]= (SELECT sum([% prod]) from X3 as X3i where X3i.Seq <= X3.Seq)
  from X3
)
-- planilha para montar a curva ABC
SELECT CodProd, 
       Descr_Prod= (SELECT top (1) Descr_Prod from CAIXAGERAL as CX where CX.CodProd=X4.CodProd),
       QtdMedia, [% prod], [% acum],
       Classe= case when [% acum] >= 75 then 'A'
                    when [% acum] >= 50 then 'B'
                    else 'C' end
  from X4
  order by Seq;