/* ********************************************************************* */
ALTER PROCEDURE P_AumentarSalario
@CODIGO  int,
@PORCENTAGEM decimal(4,2)
AS
DECLARE @Sexo  char(1),
             @Salario decimal(10,2)

SELECT @Sexo = Sexo_Func,@Salario = Sal_Func 
FROM    Funcionario
WHERE  Cod_Func = @codigo

IF @Sexo= 'F' and @Salario < 1000
 Begin
  SET @Salario=@Salario*@PORCENTAGEM

  UPDATE Funcionario
  SET Sal_Func = @SALARIO
  WHERE Cod_Func = @codigo

  Print 'Funcionário sofreu aumento'
 End
 Else
  Print 'Funcionário não sofreu aumento'

RETURN @Salario

/* ********************************************************************* */
DECLARE @VALOR_RETORNO DECIMAL(10,2)
Exec @VALOR_RETORNO = P_AumentarSalario 1,1.2
PRINT @VALOR_RETORNO
/* ********************************************************************* */
SELECT * 
FROM Funcionario

Exec P_AumentarSalario 5,1.2
/* ********************************************************************* */
ALTER PROCEDURE P_AumentarSalario2
@CODIGO  int,
@PORCENTAGEM decimal(4,2)
AS
DECLARE @Sexo  char(1),
             @Salario decimal(10,2)

SELECT @Sexo = Sexo_Func,@Salario = Sal_Func 
FROM    Funcionario
WHERE  Cod_Func = @codigo

IF @Sexo= 'F' and @Salario < 1000
 Begin
  SET @Salario=@Salario * @PORCENTAGEM

  UPDATE Funcionario
  SET Sal_Func = @Salario
  WHERE Cod_Func = @codigo

  Print 'Funcionário sofreu aumento'
 End
 Else
  Begin

   SET @Salario=@Salario - 100

   UPDATE Funcionario
   SET Sal_Func = @Salario
   WHERE Cod_Func = @codigo
   Print 'Funcionário teve um desconto no seu salário!!!'  
  End

RETURN @SALARIO

/* ********************************************************************* */
DECLARE @VALOR_RETORNO DECIMAL(10,2)
Exec @VALOR_RETORNO = P_AumentarSalario2 1,1.2
PRINT @VALOR_RETORNO
/* ********************************************************************* */

SELECT * FROM FUNCIONARIO

EXEC P_AumentarSalario2 1,1.1
/* ********************************************************************* */
ALTER PROCEDURE P_VerificarDependenteFuncionario
@Codigo  int,
@NomeFunc Varchar(50) Output,
@NumDep Int Output,
@Valor_Alteracao Decimal(10,2) Output,
@Salario Decimal(10,2) Output
AS

SELECT @NomeFunc=NOME_FUNC,
           @Salario=Sal_Func
FROM FUNCIONARIO
WHERE COD_FUNC=@Codigo

SELECT @NumDep=COUNT(*) FROM FUNCIONARIO 
 INNER JOIN DEPENDENTE
  ON FUNCIONARIO.COD_FUNC=DEPENDENTE.COD_FUNC
WHERE FUNCIONARIO.COD_FUNC= @Codigo

IF @NumDep > 0 
  SET @Valor_Alteracao=-5.00
Else
 SET @Valor_Alteracao=500.00

SET @Salario=@Salario + @Valor_Alteracao

UPDATE FUNCIONARIO
SET SAL_FUNC=@Salario
WHERE COD_FUNC=@Codigo
/* ********************************************************************* */
Create Procedure P_ExecutarDifSal
@Codigo int
As

Declare @NomeFunc Varchar(50),
           @NumDep Int,
           @Valor_Alteracao Decimal(10,2), 
           @Salario Decimal(10,2)

Exec P_VerificarDependenteFuncionario 2,@NomeFunc Output,
                                                        @NumDep Output,
                                                        @Valor_Alteracao Output,
                                                        @Salario Output

Print 'Nome do Funcionário --> '+@NomeFunc
Print 'Número de Dependentes --> '+Cast(@NumDep as char(2))

If @Valor_Alteracao <0 
 Print 'Valor de Alteração do Salário, desconto de  --> '+Cast(@Valor_Alteracao as char(10))
Else
 Print 'Valor de Alteração do Salário, aumento de  --> '+Cast(@Valor_Alteracao as char(10))

Print 'Novo salário do funcionário --> '+Cast(@Salario as char(10))
/* ********************************************************************* */
Exec P_ExecutarDifSal 1
/* ********************************************************************* */
SELECT NOME_FUNC,
           Sal_Func,
           NumDep=(SELECT COUNT(*) 
			    FROM FUNCIONARIO 
			      INNER JOIN DEPENDENTE
			       ON FUNCIONARIO.COD_FUNC=DEPENDENTE.COD_FUNC
			    WHERE FUNCIONARIO.COD_FUNC= 1)
FROM FUNCIONARIO
WHERE COD_FUNC=1
/* ********************************************************************* */
select * from funcionario
select * from dependente

Exec P_VerificarDependenteFuncionario 1

sp_helptext 'P_VerificarDependenteFuncionario'
/* ********************************************************************* */
CREATE PROCEDURE P_NUMEROPEDIDO
@NUMPEDIDO INT
AS
 DECLARE @VALOR DECIMAL(10,2),
              @ESTADOCIVIL INT,
              @CODIGOCLIENTE INT,
              @CODIGOFUNC INT

SELECT @CODIGOFUNC=COD_FUNC,
           @CODIGOCLIENTE=COD_CLI,
           @VALOR=VAL_TOTALPED 
FROM    PEDIDO
WHERE  NUM_PED=@NUMPEDIDO AND VAL_TOTALPED > 200.00

IF @VALOR IS NOT NULL 
 Begin
  SELECT @ESTADOCIVIL= COUNT(*) 
  FROM    CONJUGE  
   INNER JOIN CLIENTE 
    ON CONJUGE.COD_CLI = CLIENTE.COD_CLI
   INNER JOIN PEDIDO 
    ON PEDIDO.COD_CLI = @CODIGOCLIENTE
  
  IF @ESTADOCIVIL IS NOT NULL
   Begin
    SET @VALOR= @VALOR -10.00
   
    UPDATE PEDIDO
    SET VAL_TOTALPED=@VALOR
    WHERE NUM_PED=@NUMPEDIDO

    INSERT PREMIO VALUES(@CODIGOFUNC,GETDATE(),100.00,0)
   End
 End
/* ********************************************************************* */
SELECT * FROM PREMIO
SELECT * FROM CONJUGE
SELECT * FROM CLIENTE
SELECT * FROM PEDIDO

EXEC P_NUMEROPEDIDO 2
/* ********************************************************************* */
ALTER PROCEDURE P_NUMEROPEDIDOVENDIDO
@NUMPEDIDO INT
AS

IF EXISTS (SELECT * 
                FROM ITENS 
                WHERE NUM_PED = @NUMPEDIDO AND COD_PROD=1)
  UPDATE PRODUTO
  SET VAL_UNIT= VAL_UNIT * 0.9
  WHERE COD_PROD=1

  UPDATE PEDIDO
  SET VAL_TOTALPED= VAL_TOTALPED * 0.9
  WHERE NUM_PED=@NUMPEDIDO
/* ********************************************************************* */
SELECT * FROM PRODUTO
SELECT * FROM PEDIDO

EXEC P_NUMEROPEDIDOVENDIDO 1
 