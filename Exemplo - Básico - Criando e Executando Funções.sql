CREATE  FUNCTION  F_RendaFamiliar
(@Codigo int)
RETURNS decimal(10,2)
AS 
BEGIN
    DECLARE @Renda decimal(10,2)
 
    SELECT @Renda =(Renda_Cli + isnull(Renda_Conj,0))
    FROM Cliente LEFT JOIN Conjuge
                      ON Cliente.Cod_Cli = Conjuge.Cod_Cli
    WHERE Cliente.Cod_Cli = @Codigo

    RETURN @Renda
END
/* ********************************************* */
SELECT dbo.F_RendaFamiliar(10)
/* ********************************************* */
