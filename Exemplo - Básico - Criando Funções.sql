/* *****************************************************************/
/*                          FUNCTIONS                              */
/* *****************************************************************/
CREATE FUNCTION F_Triangulo(@Base Smallint, @Altura Smallint) RETURNS  INT
AS
BEGIN
    DECLARE @Area int
    
    SET @Area = (@Base * @Altura)/2
     
    RETURN @Area
END
/* ******************************************** */
SELECT  dbo.F_Triangulo(10,50)

SELECT  dbo.F_Triangulo(10,50) AS [Area do Triangulo]

/* ******************************************** */
ALTER FUNCTION F_Triangulo(@Base Smallint, @Altura Smallint) RETURNS  INT
AS
BEGIN
     RETURN((@Base * @Altura)/2)
END
/* ******************************************** */
SELECT dbo.F_Triangulo(4,25)
/* ******************************************** */
drop table Funcionario

CREATE TABLE Funcionario
(
  Codigo   int IDENTITY  not null,
  Nome     char(10)           not null,
  Idade     tinyint                not null,
  Salario   decimal(10,2)          null
)
/* ******************************************** */
INSERT Funcionario VALUES('Antonio',34,100)
INSERT Funcionario VALUES('Bras',34,200)
INSERT Funcionario VALUES('Carlos',21,200)
INSERT Funcionario VALUES('Carla',16,200)
/* ******************************************** */
CREATE FUNCTION F_Salario
(@CodFunc int)
RETURNS  Decimal(10,2)
AS
BEGIN

DECLARE @Salario decimal(10,2),
                    @Idade   Tinyint

SELECT @Salario = Salario,
                 @Idade = Idade
FROM Funcionario
WHERE Codigo = @CodFunc

IF @Idade <= 30
     SET @Salario = @Salario * 1.1 
ELSE
     SET @Salario = @Salario * 1.2 
   
RETURN @Salario

END
/* ******************************************** */
SELECT * FROM Funcionario
/* ******************************************** */
SELECT dbo.F_Salario(1)
/* ******************************************** */
ALTER FUNCTION F_FUNCPREMIO(@CODFUNC INT) RETURNS INT
AS
BEGIN 
  Declare @CODIGO_ULT_PREMIO INT
    
SELECT @CODIGO_ULT_PREMIO=MAX(COD_PREMIO) 
FROM PREMIO
WHERE COD_FUNC = @CODFUNC AND STATUS_PREMIO='0'

RETURN @CODIGO_ULT_PREMIO
END
/* ******************************************** */
ALTER PROCEDURE P_RODAR
@CODFUNC INT
AS

SELECT DBO.F_FUNCPREMIO(@CODFUNC)

P_RODAR 1
/* ******************************************** */
ALTER FUNCTION F_RENDAFAMILIAR(@CODCLIENTE INT) RETURNS DECIMAL(10,2)
AS
 BEGIN
  DECLARE @RENDA DECIMAL(10,2)

  IF EXISTS(SELECT CLIENTE.COD_CLI 
                 FROM CLIENTE INNER JOIN CONJUGE
                                       ON CLIENTE.COD_CLI = CONJUGE.COD_CLI
                 WHERE CLIENTE.COD_CLI=@CODCLIENTE)
   Begin
    SELECT @RENDA=(SELECT RENDA_CLI=RENDA_CLI+CONJUGE.RENDA_CONJ 
    FROM CLIENTE INNER JOIN CONJUGE
                        ON CLIENTE.COD_CLI = CONJUGE.COD_CLI
    WHERE CLIENTE.COD_CLI=@CODCLIENTE)
   End
   ELSE
    SELECT @RENDA=RENDA_CLI FROM CLIENTE  
    WHERE COD_CLI=@CODCLIENTE

 RETURN @RENDA

END
/* ******************************************** */

SELECT DBO.F_RENDAFAMILIAR(6)

SELECT * FROM CONJUGE
SELECT * FROM CLIENTE
                               
 