declare @Tabela table
(
    CRM int, 
    UF char(2), 
    Domingo varchar(20), 
    Segunda varchar(20), 
    Terca varchar(20), 
    Quarta varchar(20), 
    Quinta varchar(20), 
    Sexta varchar(20), 
    Sabado varchar(20),
    Unidade varchar(10)
);

insert into @Tabela values
(10126, 'BA', 'D - 7 as 19 Hs', 'D - 7 as 19 Hs', null, null, 'D - 7 as 19 Hs', null, null, 'HGC'),
(10126, 'BA', 'D - 7 as 19 Hs', null, null, null, 'D  - 7 as 19 Hs', null, null, 'HGE'),
(10432, 'BA', 'N - 19 as 7 Hs', 'DN - 24H', null, null, 'D  - 7 as 19 Hs', null, null, 'HGE');

with 
    CTE_Unpivot as
    (
        select
            CRM,
            UF,
            DiaSemana,
            Escala,
            Unidade
        from @Tabela
        unpivot
        (
            Escala for DiaSemana in (Domingo, Segunda, Terca, Quarta, Quinta, Sexta, Sabado)
        ) as u 
    )
    
select * from CTE_Unpivot