-- Definindo o primeiro dia da semana como segunda-feira --
Set DateFirst 1

-- Definindo o idioma para Português Brasil --
Set Language Brazilian
Go

-- Construíndo a CTERecursiva CTEPrimeiroDeJaneiroSegundaFeira retornando as colunas Ano e Data --
;With CTEPrimeiroDeJaneiroSegundaFeira (Ano, Data)
As
(
 -- Definindo o ano inicial e data inicial --
 Select 1900 As Ano, '01/01/1900' As Data
 
 Union

 -- Estabelecendo o incremento inicial para criar ancoragem dos valores de ano e data --
 Select 1900 + 1 As Ano, Concat('01/01/',1900+1) As Data 

 Union All

 -- Aplicando a recursividade --
 Select Ano+1, Concat('01/01/',Ano+1) From CTEPrimeiroDeJaneiroSegundaFeira
 Where Ano < 2200 -- Filtrando a geração das linhas de anos até 2200 --
)
-- Executando a CTEPrimeiroDeJaneiroSegundaFeira --
Select Distinct 
           Ano, Data, DateDiff(Day,Concat('01/01/',Ano),Concat('31/12/',Ano))+1 As 'Dias no Ano',
           DateName(DW, Data) As '1º dia', -- Identificando o nome do dia da semana --
		   Case
		    When DateDiff(Day,Concat('01/01/',Ano),Concat('31/12/',Ano))+1 = 365 Then 'Não'
			Else
			 'Sim'
			End As 'Ano Bissexto', 
		   Lead(Ano,2) Over (Order By Ano Asc) As 'Próximo Ano',
		   Lead(Ano,2) Over (Order By Ano Asc) - Ano As 'Dif. em Anos' -- Calcuando a diferença em anos para identificara os padrões --
From CTEPrimeiroDeJaneiroSegundaFeira
Where DatePart(WEEKDAY, Data) = 1 -- Filtrando a apresentação do dia da semana = segunda-feira --
Option (MaxRecursion 300) -- Estabelecendo o limite de recursividade para 300 voltas --
Go