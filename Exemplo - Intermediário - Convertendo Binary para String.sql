--vc tem uma chave que era em texto legivel;
DECLARE @chave  VARCHAR(MAX) ='quechavemalfeita'

--vc converteu par binary
DECLARE @dadosBinary VARBINARY(MAX) = CONVERT(VARBINARY(MAX),@chave,0)
SELECT @chave,@dadosBinary

--e nas conversões a baixo o texto legivel e diferente ??
 SELECT CONVERT(VARCHAR(MAX),@dadosBinary,0) --o Tipo 0 tranforma em texto legivel

 SELECT CONVERT(VARCHAR(MAX),@dadosBinary,1) -- transforma o valor BINARY EM VALOR VARCHAR DEIXANDO O MESMO CONTEUDO
 
 SELECT CONVERT(VARCHAR(MAX),@dadosBinary,2)-- transforma o valor BINARY EM VALOR VARCHAR RETIRANDO O 0x NO INICIO


