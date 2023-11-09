Use ProjetoDWQueimadas
Go

-- Exemplo 1 -- Criando um Pivot para Estados Específicos --
Select P.Para, P.[Mato Grosso] 
From 
 (Select Estado From Queimadas) As A
  Pivot (Count(A.Estado) For A.Estado In ([Para],[Mato Grosso])) As P
Go

-- Exemplo 2 -- Criando um Pivot com Total Parcial e Total Por Estados Específicos --
Select  P.Para,
			P.[Mato Grosso],
            'Total Parcial'=(Select Count(CodigoQueimada) From Queimadas Where Estado In ('Para', 'Mato Grosso'))
From 
 (Select Estado From Queimadas) As A
  Pivot (Count(A.Estado) For A.Estado In ([Para],[Mato Grosso])) As P
Group By Para, [Mato Grosso]
Go


-- Exemplo 3 -- Criando um Pivot Table Dinâmico com a soma de Queimadas em todos os Estados --

-- Declarando as Variáveis de Controle --
Declare @Estados Varchar(400), @ComandoEstados NVarchar(500)

-- Transformando a linhas de Estados através da função String_Agg() em uma única Linha --
;With CTEEstados
As
(Select Distinct Estado From Queimadas1999
 Where Estado <> ''
 )
Select @Estados='['+STRING_AGG(Estado,'], [')+']' From CTEEstados

-- Gerando o Pivot Table com base na Lista de Estados armazenados na variável @Estados --
Set @ComandoEstados= 'Select * From (Select Estado from Queimadas1999) As A Pivot (Count(A.Estado) For A.Estado In ('+@Estados+')) As P'

-- Executando a Query Dinâmica utilizando o comando Exec ou SP_ExecuteSQL --
Exec(@ComandoEstados)

Execute SP_ExecuteSQL @ComandoEstados
Go

-- Exemplo 4 -- Criando um Pivot Table Dinâmico com a soma de Queimadas ocorridas em 1000 marcações de Data e Hora --

-- Declarando as Variáveis de Controle --
Declare @Data Varchar(Max), @ComandoData Varchar(Max)

-- Transformando a linhas de DataHora através da função Stuff() em uma única Linha --
Set @Data= Stuff((SELECT Distinct Top 1000 ',' + QuoteName(Convert(Varchar(20),DataHora,120)) from Queimadas1999 for XML PATH('')),1,1,'')

-- Gerando o Pivot Table com base na Lista de Datas armazenados na variável @Data --
Set @ComandoData= 'Select * From (Select DataHora from Queimadas1999) As A Pivot (Count(A.DataHora) For A.DataHora In ('+@Data+')) As P'

-- Executando a Query Dinâmica utilizando o comando Exec --
Exec(@ComandoData)
Go

-- Exemplo 5 -- Criando um Pivot Dinâmico com a soma de Queimadas ocorridas em 250 Município --

-- Declarando as Variáveis de Controle --
Declare @Municipio NVarchar(4000), @ComandoMunicipio Varchar(5000)

-- Transformando a linhas de Municípios através da função Stuff() em uma única Linha --
Set @Municipio= Stuff((SELECT Distinct Top 250 ',' + QuoteName(Municipio)  from Queimadas1999 Order By ',' + QuoteName(Municipio) Asc for XML PATH('')),1,1,'')

-- Gerando o Pivot Table com base na Lista de Municípios armazenados na variável @Municipio --
Set @ComandoMunicipio= 'Select * From (Select Municipio from Queimadas1999) As A Pivot (Count(A.Municipio) For A.Municipio In ('+@Municipio+')) As P'

-- Executando a Query Dinâmica utilizando o comando Execute --
Execute(@ComandoMunicipio)
Go

-- Exemplo 6 -- Criando um Pivot Dinâmico com a Total Geral de Queimadas ocorridas por Bioma e Total por Bioma --

-- Declarando as Variáveis de Controle --
Declare @Bioma Varchar(75), @ComandoBioma NVarchar(300)

-- Transformando a linhas de Municípios através da função String_Agg() em uma única Linha --
;With CTEBioma
As
(Select Distinct Bioma From Queimadas1999)
Select @Bioma='['+STRING_AGG(Bioma,'], [')+']' From CTEBioma

-- Gerando o Pivot Table com base na Lista de Biomas armazenados na variável @Bioma --
Set @ComandoBioma= 'Select *, ''Total Geral''=(Select Count(Bioma) From Queimadas1999)  From (Select Bioma from Queimadas1999) As A Pivot (Count(A.Bioma) For A.Bioma In ('+@Bioma+')) As P'

-- Executando a Query Dinâmica utilizando o comando Execute SP_ExecuteSQL --
Execute SP_ExecuteSQL @ComandoBioma
Go