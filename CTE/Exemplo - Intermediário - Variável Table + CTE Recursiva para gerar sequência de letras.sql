declare @Tabela table
( COL1 INT,  COL2 VARCHAR(1));

insert into @Tabela values
(75, NULL),
(78, 'C'),
(12, 'B'),
(24, 'D')

;with CTE_Rec (COL1, COL2) as
(
    select
        COL1,
        COL2
    from @Tabela
    
    union all
    
    select
        COL1,
        case when ASCII(COL2) > 66 then CAST(CHAR(ASCII(COL2) - 1) AS VARCHAR(1))  end
    from CTE_Rec as c
    where 
        COL2 is not null
)

select
    COL1,
    COL2
from CTE_Rec
order by
    COL1,
    COL2