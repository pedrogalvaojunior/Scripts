Use ProjetoDWQueimadas
Go

-- Exemplo 1 --
Declare @Comando Varchar(Max) = ''

Select @Comando += 'Select ' +Table_Name+ ' As Tabela, CodigoQueimada, DataHora, Municipio From '+Table_Name + Char(13) + ' Union All ' + Char(13) 
                                    From INFORMATION_SCHEMA.TABLES
                                    Where Table_Name Like 'Queimadas%'

Set @Comando=SubString(@Comando,1,Len(@Comando)-11) -- Removendo a última linha

Print @Comando

-- Exemplo 2 --
-- Declarando a variável @Comando --
Declare @Comando NVarchar(Max) = ''

-- Montando a Query Dinâmica --
Select @Comando +=  Concat('Select ',Table_Name, ' As Tabela, CodigoQueimada, DataHora, Municipio From ')+Table_Name + Char(13) + ' Union All ' + Char(13) 
                                     From INFORMATION_SCHEMA.TABLES
                                     Where Table_Name Like 'Queimadas%'

-- Removendo a última linha --
Set @Comando=SubString(@Comando,1,Len(@Comando)-11)

-- Exibindo o conteúdo da variável @Comando --
Print @Comando

-- Executundo --
Exec sp_executeSQL @Comando
Go