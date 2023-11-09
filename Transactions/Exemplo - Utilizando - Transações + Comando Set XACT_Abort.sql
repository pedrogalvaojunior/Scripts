SELECT * FROM Tocantins.Siscom.dbo.Funcionario

SELECT * FROM Pernambuco.Siscom.dbo.Funcionario
/* ************************************************** */

ALTER PROCEDURE P_AlteraSalario
@Salario decimal(10,2)
AS
SET XACT_ABORT ON

BEGIN DISTRIBUTED TRANSACTION

UPDATE Tocantins.Siscom.dbo.Funcionario
SET Sal_Func = @Salario

UPDATE Pernambuco.Siscom.dbo.Funcionario
SET Sal_Func = @Salario

COMMIT TRANSACTION
/* *********************************************** */
Exec P_AlteraSalario 800.00