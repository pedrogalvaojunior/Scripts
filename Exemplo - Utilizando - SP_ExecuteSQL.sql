Declare @SQL nvarchar(4000)
Declare @VLR float
declare @tabela char(10)

set @tabela='PesoMedio'

SET @SQL = 'SELECT SUM(pesominimo) FROM ' + @TABELA
exec sp_executesql @sql, N'@VLR Float OUTPUT', @VLR OUTPUT

--debug
print @VLR


Declare @SQL nvarchar(4000)
Declare @VLR float

SET @SQL = N'SELECT SUM(pesominimo)+2 FROM ' + @TABELA
EXEC(@SQL)

--exec sp_executesql @sql, N'@VLR Float OUTPUT', @VLR OUTPUT

--debug
print @VLR