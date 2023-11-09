CREATE FUNCTION SplitID
(
  @IDString VARCHAR(1000)
)
RETURNS @IDs TABLE
(ID INT)
AS
BEGIN
 DECLARE @Position int
 WHILE len(@IDString) > 0
   BEGIN
     SET @Position = charindex(',', @IDString)
     IF @Position > 0
       begiN
         INSERT @IDs
         SELECT CONVERT(INT, LEFT(@IDString, @Position - 1))
         SET @IDString = RIGHT(@IDString, LEN(@IDString) - @Position)
       END
     ELSE
       BEGIN
         INSERT @IDs
         SELECT CONVERT(INT, @IDString)
         SET @IDString = ''
       END
   END
RETURN
END 


 DECLARE @EmpresaIDs VARCHAR(2000)
SET @EmpresaIDs = '1, 2, 3, 4, 5'
SELECT E.*
FROM Empresas E
INNER JOIN SplitIDString(@EmpresaIDs) I
ON E.Empresa = I.ID 