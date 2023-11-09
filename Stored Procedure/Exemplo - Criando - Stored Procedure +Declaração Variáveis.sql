Use Impacta

CREATE TABLE Funcionario
(
  Codigo   int IDENTITY  not null,
  Nome     char(10)           not null,
  Idade    tinyint                not null,
  Salario  decimal(10,2)          null
)

INSERT Funcionario VALUES('Antonio',34,100)
INSERT Funcionario VALUES('Bras',34,200)
INSERT Funcionario VALUES('Carlos',21,200)
INSERT Funcionario VALUES('Carla',16,200)

/* ******************************************* */
CREATE PROCEDURE P_AumentaSal
@Codigo int
AS
DECLARE @Salario decimal(10,2),
                    @Idade   tinyint

SELECT @Idade = Idade,
                @Salario = Salario
FROM Funcionario
WHERE Codigo = @Codigo

IF @Idade >= 30 
   SET @Salario = @Salario * 1.2
ELSE
   SET @Salario = @Salario * 1.1

UPDATE Funcionario
SET Salario = @Salario
WHERE Codigo = @Codigo
/* ********************************************* */
Exec P_AumentaSal 2
/* ********************************************* */
SELECT * FROM Funcionario