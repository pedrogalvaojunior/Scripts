Create Table #Usuarios
 (Codigo Int Identity(1,1),
   Nome VarChar(20))


Insert Into #Usuarios Values('Ana')
Insert Into #Usuarios Values('Adriana')
Insert Into #Usuarios Values('Erica')
Insert Into #Usuarios Values('Isabel')
Insert Into #Usuarios Values('Pedro')
Insert Into #Usuarios Values('Junior')
Insert Into #Usuarios Values('Marcio')
Insert Into #Usuarios Values('Nair')
Insert Into #Usuarios Values('Zilda')


Declare @NomeInicial Char(1)
Set @NomeInicial = 'M'

Select * from #Usuarios
Where Nome >=@NomeInicial
Order By Nome

----------------------------------//-----------------------------------
Declare @NomeInicial Char(1),
           @Comando VarChar(100)

Set @NomeInicial = 'M'

--Montando o Select dinâmico
Set @Comando='Select * from #Usuarios'+ 
                      ' Where Nome >='+''''+@NomeInicial+''''+
                      ' Order By Nome'

--Exibindo o conteudo da variável @Comando
Print @comando 

--Executando a variável @comando
Exec(@comando)

----------------------------------//-----------------------------------
Declare @NomeInicial Char(1),
        @Comando NVarChar(100)

Set @NomeInicial = 'M'

--Montando o Select dinâmico
Set @Comando=N'Select * from #Usuarios'+ 
                      ' Where Nome >='+''''+@NomeInicial+''''+
                      ' Order By Nome'

--Exibindo o conteudo da variável @Comando
Print @comando 

--Executando a variável @comando, utilizando o plano de execução
Execute SP_ExecuteSQL @Comando
