DECLARE @StringDaAplicacao VARCHAR(1000)

SET @StringDaAplicacao = '"jan", "fev", "mar", "abr", "mai", "jun", "jul", "ago", "set", "out", "nov", "dez"'

 

DECLARE @xml XML, @Var VARCHAR(1000)

 

-- Retirar as aspas duplas e espaços

SET @Var = REPLACE(@StringDaAplicacao,'"','')

SET @Var = REPLACE(@Var,' ','')

 

-- Substituir o separador por uma tag

SET @Var = REPLACE(@Var,',','</i><i>')

 

-- Colocar as tags iniciais

SET @Var = '<e><i>' + @Var + '</i></e>'

 

-- Converte para XML

SET @xml = CAST(@Var AS XML)

 

-- Retorna os valores em formato tabular

SELECT t.c.value('.','char(3)') 

FROM @xml.nodes('/e/i') T(c)
