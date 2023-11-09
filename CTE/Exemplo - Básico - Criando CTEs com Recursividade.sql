-- Exemplo - Criando uma nova CTE Recursiva concatenando dados --
;With ConcatenarNomes(nome)
AS
(
 SELECT Nome = CONVERT(Varchar(4000),'Pedro Antonio')
 UNION ALL
 SELECT CONVERT(Varchar(4000),nome + ' Galvão Junior') FROM ConcatenarNomes
 WHERE LEN(nome) < 30
)
SELECT Nome FROM ConcatenarNomes
Go

-- Exemplo 2 - Criando uma CTE com Union + Recursividade - Simulando uma sequência de números pares --
;With CTENumerosPares(Numero)
As
(
 Select 0 As Numero
 Union All
 Select Numero + 2 As Numero From CTENumerosPares
 Where Numero < 100
)
Select Numero From CTENumerosPares
Go

-- Exemplo 3 - Criando uma CTE com Union + Recursividade - Simulando uma sequência de números --
;With CTENumerosSequenciais(Numero)
AS
(
     SELECT 1 AS Numero 
     UNION ALL 
     SELECT Numero + 1 AS num FROM CTENumerosSequenciais 
     WHERE Numero < 1000 
)
--SELECT * FROM CTENumerosSequenciais -- Vai estourar um erro e agora?
--Go
-- Resolvendo
SELECT * FROM CTENumerosSequenciais
OPTION (MAXRECURSION 0)
Go

