CREATE PROCEDURE P_DepFunc
@CodFunc      Codigo,
@QtdDep        Codigo output,
@NomeFunc   Nome  output,
@DifSal            Valor   output
AS
SELECT @NomeFunc = Nome_Func
FROM Funcionario
WHERE Cod_Func = @CodFunc

SELECT @QtdDep = Count(*)
FROM Dependente
WHERE Cod_Func = @CodFunc

IF @QtdDep > 0
   SET @DifSal = -5.00
ELSE
   SET @DifSal = 500.00

UPDATE Funcionario
SET Sal_Func = Sal_Func +@DifSal
WHERE Cod_Func = @CodFunc 
/* ******************************************* */
DECLARE
@QtdDep        Codigo, 
@NomeFunc   Nome,
@DifSal            Valor  

Exec P_DepFunc 1,
                                @QtdDep output,
                                @NomeFunc output,
		   @DifSal  output

Print 'O Funcionario :' + @NomeFunc 
Print  ' recebeu uma diferença salarial de : ' + cast(@DifSal as char(10))  
Print  ' porque ele tem ' + Cast(@QtdDep as char(5)) + ' Dependentes'
