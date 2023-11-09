CREATE  FUNCTION  F_RendaFamiliar
(@Codigo int)
RETURNS @Var  TABLE
                    (
                      Nome_Cli  char(100),
                      Renda_Cli decimal(10,2),
                      Nome_Conj char(100),
                      Renda_Conj decimal(10,2),
                      Renda_Familiar decimal(10,2)
                     )  
AS 
BEGIN
 
    INSERT @Var
    SELECT Cliente.Nome_Cli,
                    Cliente.Renda_Cli,
                    Conjuge.Nome_Conj,
                    Conjuge.Renda_Conj,
                    (Renda_Cli + isnull(Renda_Conj,0))
    FROM Cliente LEFT JOIN Conjuge
    ON Cliente.Cod_Cli = Conjuge.Cod_Cli
    WHERE Cliente.Cod_Cli = @Codigo

    RETURN
END
/* ********************************************* */
SELECT * FROM F_RendaFamiliar(10)

SELECT Nome_Cli,Renda_Familiar FROM F_RendaFamiliar(10)

/* ********************************************* */
ALTER FUNCTION F_CONTADEP(@CODFUNC INT) 
RETURNS @Tabela TABLE
             (
              QTD_DEP INT,
              NOME_FUNC CHAR(50),
              SAL_FUNC DECIMAL(10,2)
              )
AS 
BEGIN

 INSERT @Tabela
 SELECT QTD_DEP=COUNT(*),
            FUNCIONARIO.NOME_FUNC,
            FUNCIONARIO.SAL_FUNC
 FROM DEPENDENTE INNER JOIN FUNCIONARIO
                           ON DEPENDENTE.COD_FUNC=FUNCIONARIO.COD_FUNC
 WHERE DEPENDENTE.COD_FUNC=@CODFUNC AND FUNCIONARIO.NOME_FUNC=(SELECT NOME_FUNC 
 									      FROM FUNCIONARIO
                                             					      WHERE COD_FUNC=@CODFUNC)
 AND FUNCIONARIO.SAL_FUNC=(SELECT SAL_FUNC FROM FUNCIONARIO
                                             	             WHERE COD_FUNC=@CODFUNC)
 GROUP BY FUNCIONARIO.NOME_FUNC,FUNCIONARIO.SAL_FUNC

 RETURN
END
/* ********************************************* */
SELECT * FROM F_CONTADEP(1)

