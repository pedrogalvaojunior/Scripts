USE TempDB
GO

-- Consulta atual --
SELECT a.CustomerID,
       a.CountCol,
       CASE a.CountCol
         WHEN 'Count' THEN COUNT(1)
         WHEN 'CountDistinct' THEN COUNT(DISTINCT a.OrderDate)
         WHEN 'CountDistinct_1' THEN COUNT(DISTINCT 1)
         ELSE NULL
       END AS Cnt,
       CASE (SELECT AVG(b.Value)
               FROM OrdersBig b
              WHERE b.CustomerID = a.CustomerID)
            WHEN 1000 THEN 'Média = 1 mil'
            WHEN 2000 THEN 'Média = 2 mil'
            WHEN 3000 THEN 'Média = 3 mil'
            WHEN 4000 THEN 'Média = 4 mil'
            WHEN 5000 THEN 'Média = 5 mil'
            ELSE 'Não é número exato'
       END AS Sts
FROM OrdersBig AS a
GROUP BY a.CustomerID, a.CountCol
ORDER BY a.CustomerID
OPTION (MAXDOP 1)

/*Existem 3 problemas na consulta acima.

1.       A clausula COUNT(DISTINCT 1) não faz nenhum sentido
2.       O CASE com a subquery faz com que o SQL execute a subquery para cada valor analisado no case.
3.       A clausula COUNT(DISTINCT a.OrderDate) é o grande problema de performance da consulta

O plano pode ser dividido em duas partes, primeiro para calcular o COUNT + COUNT(DISTINCT) E
e depois a parte de CASE +SubQuery */

-- Solução 2 - Reescrevendo a Query --
USE TempDB
GO

/*Vamos resolver os problemas por partes, primeiro eliminando um passo do plano trocando o 
“COUNT(DISTINCT 1)” por “1”. Concordam que “COUNT(DISTINCT 1)” é sempre igual a “1”? 
O mais irritante é que o otimizador de consultas não identifica isso sozinho.

Outra alteração que podemos fazer é em relação ao CASE + SubQuery, uma forma muito simples de 
resolver este problema é não usar a subquery como expressão para o CASE, ou seja, trocamos isso:

…
END AS Cnt,
       CASE (SELECT AVG(b.Value)
               FROM OrdersBig b
              WHERE b.CustomerID = a.CustomerID)
            WHEN 1000 THEN ‘Média = 1 mil’
            WHEN 2000 THEN ‘Média = 2 mil’
            WHEN 3000 THEN ‘Média = 3 mil’
            WHEN 4000 THEN ‘Média = 4 mil’
            WHEN 5000 THEN ‘Média = 5 mil’
            ELSE ‘Não é número exato’
       END AS Sts
  FROM OrdersBig AS a
…

Por isso: 

…*/

END AS Cnt,
       (SELECT CASE AVG(b.Value)
            WHEN 1000 THEN 'Média = 1 mil'
            WHEN 2000 THEN 'Média = 2 mil'
            WHEN 3000 THEN 'Média = 3 mil'
            WHEN 4000 THEN 'Média = 4 mil'
            WHEN 5000 THEN 'Média = 5 mil'
            ELSE 'Não é número exato'
               END AS Sts
               FROM OrdersBig b
              WHERE b.CustomerID = a.CustomerID) AS Sts
  FROM OrdersBig AS a


/*Utilizando o AVG(b.Value) como expressão para o CASE evitamos o problema de execução da subquery para 
cada valor na lista do CASE. */

SELECT a.CustomerID,
       a.CountCol,
       CASE a.CountCol
         WHEN ‘Count’ THEN COUNT(1)
         WHEN ‘CountDistinct’ THEN COUNT(DISTINCT a.OrderDate)
         WHEN ‘CountDistinct_1′ THEN 1
         ELSE NULL
       END AS Cnt,
       (SELECT CASE AVG(b.Value)
                      WHEN 1000 THEN 'Média = 1 mil'
                      WHEN 2000 THEN 'Média = 2 mil'
                      WHEN 3000 THEN 'Média = 3 mil'
                      WHEN 4000 THEN 'Média = 4 mil'
                      WHEN 5000 THEN 'Média = 5 mil'
                      ELSE 'Não é número exato'
               END AS Sts
               FROM OrdersBig b
              WHERE b.CustomerID = a.CustomerID) AS Sts
  FROM OrdersBig a
 GROUP BY a.CustomerID, a.CountCol
 ORDER BY a.CustomerID
OPTION (MAXDOP 1)
 

/*Uau, já ficou MUITO mais simples não é? O problema agora é que estou acessando fazendo um scan na tabela
OrdersBig 3 vezes.

Outro problema que nos resta, é o “COUNT (DISTINCT OrderDate)”, para resolver este problema eu mudei um 
pouco a forma de solicitar esta informação, ou invés de usar o COUNT DISTINCT eu usei a ROW_NUMBER 
particionando a janela por CustomerID e CountCol e depois contei a quantidade de valores igual a 1.  

Vamos criar um cenário mais simples para entender o conceito:*/

IF OBJECT_ID('Tab1') IS NOT NULL
  DROP TABLE Tab1
GO
CREATE TABLE Tab1 (Col1 Int, Col2 Int)
GO
INSERT INTO Tab1 VALUES(1, 1), (1, 1), (1, 1), (2, 1), (2, 1), (3, 1), (3, 1)
GO
SELECT Col1,
       COUNT(Col2) AS "Count", 
       COUNT(DISTINCT Col2) AS CountDistict
  FROM Tab1
 GROUP BY Col1
GO
 

/*Vamos analisar o conceito que mencionei acima passo a passo, primeiro vamos gerar o ROW_NUMBER 
particionando por Col1 com base na ordem de Col2.*/

SELECT *,
       ROW_NUMBER() OVER(PARTITION BY Col1 ORDER BY Col2) AS rn
  FROM Tab1
 
/*Agora se eu contar a quantidade de ocorrências de “1” agrupando por Col1 terei o resultado esperado 
concordam? … Para fazer isso vamos colocar a consulta em uma CTE e fazer um CASE para retornar apenas 
os valores igual a 1. */

WITH CTE_1
AS
(
SELECT *,
       CASE
         WHEN ROW_NUMBER() OVER(PARTITION BY Col1 ORDER BY Col2) = 1 THEN 1
         ELSE NULL
       END AS rn
  FROM Tab1
)
SELECT *
  FROM CTE_1
 

/*Agora podemos simplesmente fazer um COUNT na coluna RN que os valores NULL serão ignorados e teremos  o 
mesmo resultado que o COUNT DISTINCT. Vejamos: */

WITH CTE_1
AS
(
SELECT *,
       CASE
         WHEN ROW_NUMBER() OVER(PARTITION BY Col1 ORDER BY Col2) = 1 THEN 1
         ELSE NULL
       END AS rn
  FROM Tab1
)
SELECT Col1,
       COUNT(Col2) AS "Count", – Palavra reservada
       COUNT(rn) AS CountDistict
  FROM CTE_1
 GROUP BY Col1
 

/*Agora conseguimos resolver a consulta com apenas um scan na tabela, porém agora temos um novo problema, 
o SORT por Col1 (Clausula PARTITION BY) + Col2 (Clausula ORDER BY), mas esse é fácil de resolver certo? … 
Basta criar um índice por Col1 e Col2. Bora fazer isso. */

CREATE INDEX ix1 ON Tab1 (Col1, Col2)
Go 

-- Criando o índice para evitar o Sort e para cobrir a SubQuery --
CREATE INDEX ix1 ON OrdersBig (CustomerID, CountCol, OrderDate) INCLUDE(Value) 
WITH(DATA_COMPRESSION=PAGE)
GO

;WITH CTE_1
AS
(
  SELECT CustomerID,
         CountCol,
         OrderDate,
         CASE
           WHEN ROW_NUMBER() OVER(PARTITION BY CustomerID, CountCol, OrderDate ORDER BY OrderDate) = 1 THEN 1
           ELSE NULL
         END AS DistinctCnt
    FROM OrdersBig
)
SELECT CustomerID,
       CountCol,
       CASE CountCol
         WHEN 'Count' THEN COUNT(1)
         WHEN 'CountDistinct' THEN COUNT(DistinctCnt)
         WHEN 'CountDistinct_1' THEN 1
         ELSE NULL
       END AS Cnt,
       (SELECT CASE AVG(b.Value)
                      WHEN 1000 THEN ‘Média = 1 mil’
                      WHEN 2000 THEN ‘Média = 2 mil’
                      WHEN 3000 THEN ‘Média = 3 mil’
                      WHEN 4000 THEN ‘Média = 4 mil’
                      WHEN 5000 THEN ‘Média = 5 mil’
                      ELSE ‘Não é número exato’
               END AS Sts
               FROM OrdersBig b
              WHERE b.CustomerID = CTE_1.CustomerID) AS Sts
  FROM CTE_1
 GROUP BY CustomerID, CountCol
 ORDER BY CustomerID
OPTION (MAXDOP 1)
 
/*Olhos atentos devem ter reparado que eu criei o índice utilizando a clausula “DATA_COMPRESSION = PAGE”, 
isso faz muito diferença na leitura do índice, já que terei que varrer a tabela

Outro ponto importantíssimo em relação a performance desta consulta é que o mesmo índice esta sendo 
utilizado duas vezes, primeiro um Index Scan é realizado já que esta é a primeira vez que os dados estão 
sendo lidos essa será uma leitura física, quando o Index Seek for realizado os dados já estarão em Cache 
gerando leituras lógicas. Isso significa que ainda que eu crie outro índice menor (por CustomerID com 
INCLUDE de Value), a performance da consulta será pior, pois o seek neste novo índice geraria leituras 
físicas.

Na minha máquina a consulta acima faz o seguinte uso de recursos:

Pra deixar o desafio mais interessante, lanço uma pergunta. Será que da pra fazer isso tudo, com apenas 
UMA leitura na tabela OrdersBig?

Dá, mas o SQL Server infelizmente ainda não é bem esperto na criação deste plano… Eu poderia evitar a 
SubQuery do AVG e escrever a consulta assim: */

;WITH CTE_1
AS
(
  SELECT CustomerID,
         CountCol,
         OrderDate,
         AVG(Value) OVER(PARTITION BY CustomerID) AS Media,
         CASE
           WHEN ROW_NUMBER() OVER(PARTITION BY CustomerID, CountCol, OrderDate ORDER BY OrderDate) = 1 THEN 1
           ELSE NULL
         END AS DistinctCnt
    FROM OrdersBig
)
SELECT CustomerID,
       CountCol,
       CASE CountCol
         WHEN 'Count' THEN COUNT(1)
         WHEN 'CountDistinct' THEN COUNT(DistinctCnt)
         WHEN 'CountDistinct_1' THEN 1
         ELSE NULL
       END AS Cnt,
       CASE Media
              WHEN 1000 THEN 'Média = 1 mil'
              WHEN 2000 THEN 'Média = 2 mil'
              WHEN 3000 THEN 'Média = 3 mil'
              WHEN 4000 THEN 'Média = 4 mil'
              WHEN 5000 THEN 'Média = 5 mil'
              ELSE 'Não é número exato'
       END AS Sts
  FROM CTE_1
 GROUP BY CustomerID, CountCol, Media
 ORDER BY CustomerID
OPTION (MAXDOP 1)
 

/* Infelizmente a operação de SORT é totalmente desnecessária, mas o SQL Server continua gerando o SORT… 
isso é um BUG que eu já reclamei, e que foi fechado pela Micosoft como “By Design”… anyway, não vou entrar
 no mérito aqui se isso é bug ou não é… o que espero é que em novas versões do produto a MS de mais 
 atenção para esse tipo de funcionalidade. */