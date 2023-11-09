CREATE FUNCTION F_QtdDep
(@Codigo int)
RETURNS @Var TABLE
           (
                 Nome_Func char(100),
                 Sal_Func       decimal(10,2),
                 Qtd_Dep       int
           )
AS
BEGIN
	INSERT @Var
	SELECT Funcionario.Nome_Func,
	                Funcionario.Sal_Func,
	                Count(Dependente.Cod_Dep) 
	FROM Funcionario LEFT JOIN Dependente
	ON Funcionario.Cod_Func = Dependente.Cod_Func
	WHERE Funcionario.Cod_Func = @Codigo
	GROUP BY  Funcionario.Cod_Func,
                                     Funcionario.Nome_Func,
	                      Funcionario.Sal_Func
 
	RETURN
END
/* ******************************************** */
SELECT * FROM F_QtdDep(4)
/* ******************************************** */
ALTER FUNCTION F_CLIENTE(@CODCLIENTE INT)
RETURNS
  @TABELA TABLE
   (
    Nome Char(50),
    NomeConj Char(50),
    Sexo Char(1),
    SexoConj Char(1),
    Renda Decimal(10,2),
    RendaConj Decimal(10,2)
   )
As 
Begin  
 INSERT @TABELA
 SELECT CLIENTE.NOME_CLI,
            CONJUGE.NOME_CONJ,
            CLIENTE.SEXO_CLI,
            CONJUGE.SEXO_CONJ,
            CLIENTE.RENDA_CLI,
            CONJUGE.RENDA_CONJ
 FROM CLIENTE LEFT JOIN CONJUGE
                     ON CLIENTE.COD_CLI = CONJUGE.COD_CLI
 WHERE CLIENTE.COD_CLI=@CODCLIENTE

 Return    
End
/* ******************************************** */
SELECT * FROM F_CLIENTE(6)
/* ******************************************** */

SELECT * FROM  CLIENTE
SELECT * FROM CONJUGE