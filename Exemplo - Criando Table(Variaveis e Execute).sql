Declare @variaveis varchar(50)
set @variaveis = 'codigo int, nome varchar'

EXECUTE ('Create Table ##tblteste('+@variaveis+')')

Select * FROM  ##tblteste

Drop table ##tblTeste