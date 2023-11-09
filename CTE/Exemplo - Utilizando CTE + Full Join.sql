DECLARE  @TABELA_A  TABLE (COLUNA_A CHAR(1))
DECLARE  @TABELA_B  TABLE (COLUNA_B CHAR(1))
DECLARE  @RESULTADO  TABLE (COLUNA_A CHAR(1),COLUNA_B CHAR(1))


INSERT INTO @TABELA_A  (COLUNA_A) VALUES ('A')
INSERT INTO @TABELA_A  (COLUNA_A) VALUES ('B')
INSERT INTO @TABELA_A  (COLUNA_A) VALUES ('C')

INSERT INTO @TABELA_B  (COLUNA_B) VALUES ('Y')
INSERT INTO @TABELA_B  (COLUNA_B) VALUES ('J')
INSERT INTO @TABELA_B  (COLUNA_B) VALUES ('Z')

;with 
    CTE_A as
    (
        select 
            COLUNA_A,         
            ROW_NUMBER() OVER(ORDER BY (SELECT 1)) as RN
        from @TABELA_A
    ),
    
    CTE_B as
    (
        select 
            COLUNA_B,
            ROW_NUMBER() OVER(ORDER BY (select 1)) as RN
        from @TABELA_B
    )
select
    a.COLUNA_A,
    b.COLUNA_B
from CTE_A as a
full join CTE_B as b
    on b.RN = a.RN