Declare @NomePlanilha Varchar(20),
              @Comando Varchar(500)

Set @NomePlanilha = 'ABA - '+Convert(VarChar(10),GetDate(),103)

Set @Comando = 'SELECT * INTO PLANILHA 
FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
''Excel 12.0;Database=C:\caminho\planilha.xlsx'', ['+''''+@NomePlanilha+'$'+'''])'

Exec(@Comando)

SELECT * INTO PLANILHA 
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
'Excel 12.0;Database=C:\caminho\planilha.xlsx', ['ABA - 08/02/2013$'])