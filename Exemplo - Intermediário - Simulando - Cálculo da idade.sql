-- Exemplo 1 --
declare @Hoje date;
set @Hoje= cast (current_timestamp as date);

SELECT CPF, DATA_NASC, 
       case when month(@Hoje) > month(DATA_NASC) 
                 then datediff (year, DATA_NASC, @Hoje)
            when month(@Hoje) = month(DATA_NASC) and day(@Hoje) >= day(DATA_NASC)
                 then datediff (year, DATA_NASC, @Hoje)
            else datediff (year, DATA_NASC, @Hoje) -1 
       end as Idade
  from tb_idade_dez
Go

-- Exemplo 2 --
SELECT CPF, DATA_NASC, (datediff (month, DATA_NASC, @Hoje) / 12) as Idade from tb_idade_dez
Go

-- Exemplo 3 --
SELECT CPF, DATA_NASC, datediff(day,DATA_NASC,getdate())/365.15 as idade from TB_IDADE_JANEIRO
Go

-- Exemplo 4 --
declare @DATAS table (DataNasc date);
INSERT into @DATAS values 
  ('19880101'), ('19880111'), ('19880112'), ('19880113'), 
  ('19880213'), ('19880313'), ('19880413'), ('19880513'),
  ('19880613'), ('19880713'), ('19880813'), ('19880913'),
  ('19881013'), ('19881113'), ('19881213');

declare @Hoje date;
set @Hoje= '20190112';

SELECT DataNasc, @Hoje as Hoje,
       datediff(day, DataNasc, @Hoje)/365.15 as idade,
       case when month(@Hoje) > month(DataNasc) then datediff (year, DataNasc, @Hoje)
            when month(@Hoje) = month(DataNasc) and day(@Hoje) >= day(DataNasc) then datediff (year, DataNasc, @Hoje)
        else 
         datediff (year, DataNasc, @Hoje) -1 
       end as Anos
  from @DATAS
Go