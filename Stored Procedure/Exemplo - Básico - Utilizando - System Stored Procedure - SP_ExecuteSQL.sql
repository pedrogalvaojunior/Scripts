-- Exemplo 1 --
DECLARE @str NVARCHAR(4000) = N'SELECT * FROM sys.objects'

EXECUTE SP_EXECUTESQL @str

-- Exemplo 2 --
DECLARE @IntVariable int;
  DECLARE @SQLString nvarchar(500);
  DECLARE @ParmDefinition nvarchar(500);
  
  /* Build the SQL string one time.*/
  SET @SQLString =
       N'SELECT BusinessEntityID, NationalIDNumber, JobTitle, LoginID
         FROM AdventureWorks2012.HumanResources.Employee 
         WHERE BusinessEntityID = @BusinessEntityID';

  SET @ParmDefinition = N'@BusinessEntityID tinyint';

  /* Execute the string with the first parameter value. */
  SET @IntVariable = 197;
  
  EXECUTE sp_executesql @SQLString, @ParmDefinition,
                        @BusinessEntityID = @IntVariable;
  /* Execute the same string with the second parameter value. */
  
  SET @IntVariable = 109;
  EXECUTE sp_executesql @SQLString, @ParmDefinition,
                        @BusinessEntityID = @IntVariable;
