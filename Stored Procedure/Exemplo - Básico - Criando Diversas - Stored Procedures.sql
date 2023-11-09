/* ********************************************************************* */
CREATE PROCEDURE P_AumentarSalario
@CODIGO  int,
@PORCENTAGEM decimal(4,2)
AS
DECLARE @Sexo  char(1),
        @Salario decimal(10,2)

SELECT @Sexo = Sexo_Func,@Salario = Sal_Func FROM Funcionario
 WHERE Cod_Func = @codigo

IF @Sexo= 'F' and @Salario < 1000
 Begin
  UPDATE Funcionario
  SET Sal_Func = Sal_Func * @PORCENTAGEM
  WHERE Cod_Func = @codigo
  Print 'Funcionário sofreu aumento'
 End
 Else
  Print 'Funcionário não sofreu aumento'

/* ********************************************************************* */
SELECT * FROM Funcionario

Exec P_AumentarSalario 5,1.2
/* ********************************************************************* */
CREATE PROCEDURE P_AumentarSalario2
@CODIGO  int,
@PORCENTAGEM decimal(4,2)
AS
DECLARE @Sexo  char(1),
        @Salario decimal(10,2)

SELECT @Sexo = Sexo_Func,@Salario = Sal_Func FROM Funcionario
 WHERE Cod_Func = @codigo

IF @Sexo= 'F' and @Salario < 1000
 Begin
  UPDATE Funcionario
  SET Sal_Func = Sal_Func * @PORCENTAGEM
  WHERE Cod_Func = @codigo
  Print 'Funcionário sofreu aumento'
 End
 Else
  Begin
   UPDATE Funcionario
   SET Sal_Func = Sal_Func - 100
   WHERE Cod_Func = @codigo
   Print 'Funcionário teve um desconto no seu salário!!!'  
  End
/* ********************************************************************* */
SELECT * FROM FUNCIONARIO

EXEC P_AumentarSalario2 1,1.1
/* ********************************************************************* */
ALTER PROCEDURE P_VerificarDependenteFuncionario
@CODIGO  int,
@Valor Decimal(10,2)
AS
DECLARE @Dependente int 

SELECT @Dependente = COUNT(*) FROM FUNCIONARIO INNER JOIN DEPENDENTE
 ON FUNCIONARIO.COD_FUNC = DEPENDENTE.COD_FUNC
  WHERE FUNCIONARIO.COD_FUNC= @CODIGO

IF @Dependente > 0 
 SET @Valor= -5.00
Else
 SET @Valor= 500.00

UPDATE FUNCIONARIO
SET SAL_FUNC=@VALOR
WHERE COD_FUNC=@CODIGO
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
       @VALOR=VAL_TOTALPED FROM PEDIDO
        WHERE NUM_PED=@NUMPEDIDO AND VAL_TOTALPED > 200.00

IF @VALOR IS NOT NULL 
 Begin
  SELECT @ESTADOCIVIL= COUNT(*) FROM CONJUGE  JOIN CLIENTE
   ON CONJUGE.COD_CLI = CLIENTE.COD_CLI INNER JOIN PEDIDO 
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

IF EXISTS (SELECT * FROM ITENS WHERE NUM_PED = @NUMPEDIDO AND COD_PROD=1)
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
 