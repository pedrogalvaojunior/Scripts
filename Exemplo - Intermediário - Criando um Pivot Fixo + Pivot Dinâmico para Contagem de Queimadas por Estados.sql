Use ProjetoDWQueimadas
Go

-- Exemplo 1 -- Criando um Pivot para Estados Espec�ficos --
Select P.Para, P.[Mato Grosso] 
From 
 (Select Estado From Queimadas) As A
  Pivot (Count(A.Estado) For A.Estado In ([Para],[Mato Grosso])) As P
Go

-- Exemplo 2 -- Criando um Pivot com Total Parcial e Total Por Estados Espec�ficos --
Select  P.Para,
			P.[Mato Grosso],
            'Total Parcial'=(Select Count(CodigoQueimada) From Queimadas Where Estado In ('Para', 'Mato Grosso'))
From 
 (Select Estado From Queimadas) As A
  Pivot (Count(A.Estado) For A.Estado In ([Para],[Mato Grosso])) As P
Group By Para, [Mato Grosso]
Go


-- Exemplo 3 -- Criando um Pivot Table Din�mico com a soma de Queimadas em todos os Estados --

-- Declarando as Vari�veis de Controle --
Declare @Estados Varchar(400), @ComandoEstados NVarchar(500)

-- Transformando a linhas de Estados atrav�s da fun��o String_Agg() em uma �nica Linha --
;With CTEEstados
As
(Select Distinct Estado From Queimadas1999
 Where Estado <> ''
 )
Select @Estados='['+STRING_AGG(Estado,'], [')+']' From CTEEstados

-- Gerando o Pivot Table com base na Lista de Estados armazenados na vari�vel @Estados --
Set @ComandoEstados= 'Select * From (Select Estado from Queimadas1999) As A Pivot (Count(A.Estado) For A.Estado In ('+@Estados+')) As P'

-- Executando a Query Din�mica utilizando o comando Exec ou SP_ExecuteSQL --
Exec(@ComandoEstados)

Execute SP_ExecuteSQL @ComandoEstados
Go

-- Exemplo 4 -- Criando um Pivot Table Din�mico com a soma de Queimadas ocorridas em 1000 marca��es de Data e Hora --

-- Declarando as Vari�veis de Controle --
Declare @Data Varchar(Max), @ComandoData Varchar(Max)

-- Transformando a linhas de DataHora atrav�s da fun��o Stuff() em uma �nica Linha --
Set @Data= Stuff((SELECT Distinct Top 1000 ',' + QuoteName(Convert(Varchar(20),DataHora,120)) from Queimadas1999 for XML PATH('')),1,1,'')

-- Gerando o Pivot Table com base na Lista de Datas armazenados na vari�vel @Data --
Set @ComandoData= 'Select * From (Select DataHora from Queimadas1999) As A Pivot (Count(A.DataHora) For A.DataHora In ('+@Data+')) As P'

-- Executando a Query Din�mica utilizando o comando Exec --
Exec(@ComandoData)
Go

-- Exemplo 5 -- Criando um Pivot Din�mico com a soma de Queimadas ocorridas em 250 Munic�pio --

-- Declarando as Vari�veis de Controle --
Declare @Municipio NVarchar(4000), @ComandoMunicipio Varchar(5000)

-- Transformando a linhas de Munic�pios atrav�s da fun��o Stuff() em uma �nica Linha --
Set @Municipio= Stuff((SELECT Distinct Top 250 ',' + QuoteName(Municipio)  from Queimadas1999 Order By ',' + QuoteName(Municipio) Asc for XML PATH('')),1,1,'')

-- Gerando o Pivot Table com base na Lista de Munic�pios armazenados na vari�vel @Municipio --
Set @ComandoMunicipio= 'Select * From (Select Municipio from Queimadas1999) As A Pivot (Count(A.Municipio) For A.Municipio In ('+@Municipio+')) As P'

-- Executando a Query Din�mica utilizando o comando Execute --
Execute(@ComandoMunicipio)
Go

-- Exemplo 6 -- Criando um Pivot Din�mico com a Total Geral de Queimadas ocorridas por Bioma e Total por Bioma --

-- Declarando as Vari�veis de Controle --
Declare @Bioma Varchar(75), @ComandoBioma NVarchar(300)

-- Transformando a linhas de Munic�pios atrav�s da fun��o String_Agg() em uma �nica Linha --
;With CTEBioma
As
(Select Distinct Bioma From Queimadas1999)
Select @Bioma='['+STRING_AGG(Bioma,'], [')+']' From CTEBioma

-- Gerando o Pivot Table com base na Lista de Biomas armazenados na vari�vel @Bioma --
Set @ComandoBioma= 'Select *, ''Total Geral''=(Select Count(Bioma) From Queimadas1999)  From (Select Bioma from Queimadas1999) As A Pivot (Count(A.Bioma) For A.Bioma In ('+@Bioma+')) As P'

-- Executando a Query Din�mica utilizando o comando Execute SP_ExecuteSQL --
Execute SP_ExecuteSQL @ComandoBioma
Go