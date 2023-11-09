-- Exemplo 1 --

DECLARE @FileName varchar(50),

@bcpCommand varchar(2000)

SET @FileName = 'C:\Users\test.xml'

 
SET @bcpCommand = 'bcp "SELECT


''CustomerID'' AS ''Parameter/name'',

CustomerID AS ''Parameter/value'',

''ContactName'' AS ''Parameter/name'',

ContactName AS ''Parameter/value'',

''CompanyName'' AS ''Parameter/name'',

CompanyName AS ''Parameter/value''


FROM Sales.Customers

 

FOR XML PATH(''T2Method''), ROOT(''Parking''), TYPE, ELEMENTS" queryout "'
 
SET @bcpCommand = @bcpCommand + @FileName + '" -T -c -x'

print(@bcpCommand)
 

EXEC master..xp_cmdshell @bcpCommand


-- Exemplo 2 --
Declare @Contador Int, 
              @FileName varchar(50),
              @bcpCommand varchar(2000)

Set @Contador = 1

While @Contador <=(Select Count(IDdaSuaTabela) from SuaTabela)
Begin

    SET @bcpCommand = 'bcp "SELECT ''CustomerID'' AS ''Parameter/name'', CustomerID AS ''Parameter/value'',
                                                            ''ContactName'' AS ''Parameter/name'',
                                                              ContactName AS ''Parameter/value'',
                                                              ''CompanyName'' AS ''Parameter/name'',
                                                                CompanyName AS ''Parameter/value''
												FROM Sales.Customers
												Where IDdaSuaTabela = @Contador
												FOR XML PATH(''T2Method''), ROOT(''Parking''), TYPE, ELEMENTS" queryout "'

   SET @FileName = 'C:\Users\test-arquivo-'+Convert(Varchar(10),@Contador)+'.xml'
   SET @bcpCommand = @bcpCommand + @FileName + '" -T -c -x'   
   
   EXEC master..xp_cmdshell @bcpCommand

   Set @Contador += 1
End
