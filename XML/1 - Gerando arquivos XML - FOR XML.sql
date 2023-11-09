USE AdventureWorks
GO
-- <Gerando arquivos XML>

-- FOR XML RAW


/*
  Pega o resultado da query e transforma cada linha retornada em um Elemento XML 
  e as colunas em atributos deste elemento.
  Se não especificado, o nome da tag do elemento é "Row"
*/

SELECT ProductCategoryID, Name
  FROM Production.ProductCategory
   FOR XML RAW
GO

-- Um nome pode ser especificado para TAG do elemento que será gerado
SELECT ProductCategoryID, Name
  FROM Production.ProductCategory
   FOR XML RAW('Produtos')
GO





-- FOR XML AUTO


/*
  O XML AUTO aninha os dados por retornados por um select por ex, em um join
  cada tabela do select será representado como um Elemento e suas colunas como 
  atributos destes elementos.
  Por ex: Para cada Elemento "ProdCat" será criado um SubElemento "ProdSubCat"
*/
SELECT ProdCat.ProductCategoryID, ProdCat.Name Categoria, ProdSubCat.Name SubCategoria
  FROM Production.ProductCategory ProdCat
 INNER JOIN Production.ProductSubcategory ProdSubCat
    ON ProdCat.ProductCategoryID = ProdSubCat.ProductCategoryID
   FOR XML AUTO
/*
  Importante: O nome dos atribudos serão iguais ao nome das colunas, portanto 
  não é permitido que os nomes das colunas sejam iguais.
  Caso isso aconteça ao executar o comando o SQL irá 
  gerar um erro dizendo que existem colunas usando o mesmo Nome e que não é possível
  atribuir um valor para o mesmo atributo na mesma TAG mais de uma vez.
  Msg 6810, Level 16, State 1, Line 1
  Column name 'XX' is repeated. The same attribute cannot be generated more than once on the same XML tag.
*/




-- FOR XML PATH


-- Com o FOR XML PATH é possível retornar um XML usando o conceito XPath que
-- muitas vezes acaba sendo mais simples do que usar a opção EXPLICIT que veremos abaixo
SELECT ProductID 'Produtos/@CodProduto',
       Name      'Produtos/Nome/@NomeProduto'
  FROM Production.Product
   FOR XML PATH('Produtos')
-- Repare como é simples dizer qual é o nível de cada elemento, Produtos/ e depois Produtos/Nome/ ou seja, 
-- depois de Produtos/ incluir Nome

-- Você já viu esta mensagem?
-- Subquery returned more than 1 value. This is not permitted when the subquery 
-- follows =, !=, <, <= , >, >= or when the subquery is used as an expression.

SELECT ProductID, Name, (SELECT Name
                           FROM Production.Product)
  FROM Production.Product

-- Já pensou o que aconteceria se o SQL permitisse que você faça isso
SELECT ProductID AS CodProduto, 
       Name AS NomeProduto,
       (SELECT TOP 10 Name
          FROM Production.Product FOR XML PATH ('')) AS TodosProdutos
  FROM Production.Product
   FOR XML PATH('Produtos')


-- FOR XML EXPLICIT
/* 
  Permite maior controle e flexibilidade sobre o XML que será gerado pelo resultado 
  da consulta.
  A formação do nome dos Elementos SubElementos ou Atributos ou são 
  especifidados pela seguinte diretiva
  Devemos construir a consulta seguindo algumas regras
  Usar duas colunas de metadado chamadas Tag e Parent 
  usadas para identificar qual será o nível e hierarquia dos
  dados XML que serão gerados.
*/

-- Vamos a alguns exemplos práticos para entendermos melhor...
SELECT 1                         AS Tag,
       NULL                      AS Parent,
       ProdCat.ProductCategoryID AS [ProdCatCod!1!ID], 
       ProdCat.Name              AS [ProdCatCod!1!Categoria], 
       ProdSubCat.Name           AS [ProdCatCod!1!SubCategoria]
  FROM Production.ProductCategory ProdCat
 INNER JOIN Production.ProductSubcategory ProdSubCat
    ON ProdCat.ProductCategoryID = ProdSubCat.ProductCategoryID
   FOR XML EXPLICIT
GO

-- Digamos que eu queira que a coluna SubCategoria seja um SubElemento da Coluna Categoria
-- basta informar que a coluna SubCategoria é um "Element"
SELECT 1                         AS Tag,
       NULL                      AS Parent,
       ProdCat.ProductCategoryID AS [ProdCatCod!1!ProductCategoryID], 
       ProdCat.Name              AS [ProdCatCod!1!Categoria], 
       ProdSubCat.Name           AS [ProdCatCod!1!SubCategoria!Element]
  FROM Production.ProductCategory ProdCat
 INNER JOIN Production.ProductSubcategory ProdSubCat
    ON ProdCat.ProductCategoryID = ProdSubCat.ProductCategoryID
   FOR XML EXPLICIT


-- Agora vamos imaginar uma consulta que é bem comum de vermos.
-- Quero retornar todos os Pedidos e dentro de cada Pedido os Itens vendidos.
SELECT 1                     AS Tag,
       0                     AS Parent,
       Pedidos.SalesOrderID  AS [Pedidos!1!CodigoPedido],
       Pedidos.OrderDate     AS [Pedidos!1!DataPedido],
       NULL                  AS [Itens!2!CodigoPedido],
       NULL                  AS [Itens!2!CodProduto],
       NULL                  AS [Itens!2!Produto],
       NULL                  AS [Itens!2!Quantidade],
       NULL                  AS [Itens!2!Valor]
  FROM Sales.SalesOrderHeader AS Pedidos
 WHERE Pedidos.SalesOrderID BETWEEN 43659 AND 43668
 UNION ALL 
SELECT 2 AS Tag,
       1 AS Parent,
       Pedidos.SalesOrderID,
       Pedidos.OrderDate,
       Itens.SalesOrderID,
       Itens.ProductID,
       Prod.Name,
       Itens.OrderQty,
       Itens.LineTotal
  FROM Sales.SalesOrderHeader Pedidos
 INNER JOIN Sales.SalesOrderDetail Itens
    ON Pedidos.SalesOrderID = Itens.SalesOrderID
 INNER JOIN Production.Product Prod
    ON Prod.ProductID = Itens.ProductID
 WHERE Pedidos.SalesOrderID BETWEEN 43659 AND 43668
 ORDER BY [Pedidos!1!CodigoPedido], 
          [Itens!2!CodigoPedido]
   FOR XML EXPLICIT, ROOT('XMLPedidos')

-- Outra consulta montando um XML dados dos produtos.
SELECT 1            AS Tag,
       NULL         AS Parent,
       ProdCat.Name AS [ProdCat!1!Categoria],
       NULL         AS [SubProdCat!2!SubCategoria],
       NULL         AS [Prod!3!Produto]
  FROM Production.ProductCategory AS ProdCat
 UNION ALL
 SELECT 2,
        1,
        ProdCat.Name,
        ProdSubCat.Name,
        NULL
   FROM Production.ProductCategory AS ProdCat
  INNER JOIN Production.ProductSubcategory AS ProdSubCat
     ON ProdCat.ProductCategoryID = ProdSubCat.ProductCategoryID
  UNION ALL 
 SELECT 3,
        2,
        ProdCat.Name,
        ProdSubCat.Name,
        Prod.Name
   FROM Production.Product Prod
  INNER JOIN Production.ProductSubcategory AS ProdSubCat
     ON Prod.ProductSubcategoryID = ProdSubCat.ProductSubcategoryID
  INNER JOIN Production.ProductCategory AS ProdCat
     ON ProdCat.ProductCategoryID = ProdSubCat.ProductCategoryID
  ORDER BY [ProdCat!1!Categoria], 
           [SubProdCat!2!SubCategoria], 
           [Prod!3!Produto]
    FOR XML EXPLICIT



-- ELEMENTS
-- Ao expecificar a opção ELEMENTS o SQL irá retornar os dados das colunas como SubElementos 
-- e não como Atributos
SELECT ProductCategoryID, Name
  FROM Production.ProductCategory
   FOR XML RAW('Produtos'), ELEMENTS
GO

-- ROOT

-- Para criar um elemento raiz no XML basta informar o nome da TAG utilizando a
-- clausula ROOT
SELECT ProductCategoryID, Name
  FROM Production.ProductCategory
   FOR XML RAW ('Produtos'), ELEMENTS, ROOT ('XML')

-- TYPE
-- Retorna o XML como um DataType XML

SELECT ProductCategoryID, Name
  FROM Production.ProductCategory
   FOR XML RAW ('Produtos'), ELEMENTS, ROOT ('XML')

-- Compartilhando case
/*
  Reparem que o nome da coluna gerada pelo ResultSet é sempre o mesmo 
  "XML_F52E2B61-18A1-11d1-B105-00805F49916B". Acontece que algumas 
  linguagens não suportam caracteres especiais como o "-" gerando um problema
  para gerar os dados XML, uma maneira simples de renomear o nome da coluna seria
  atribuir o resultset para uma variável XML e depois selecionar a variável 
  atribuindo um alias para ela. Ex:
*/

DECLARE @vXML XML

SET @vXML = (SELECT ProdCat.ProductCategoryID, ProdCat.Name Categoria, ProdSubCat.Name SubCategoria
               FROM Production.ProductCategory ProdCat
              INNER JOIN Production.ProductSubcategory ProdSubCat
                 ON ProdCat.ProductCategoryID = ProdSubCat.ProductCategoryID
                FOR XML AUTO, ROOT('ProdXML'), TYPE)

SELECT @vXML AS NomeDaMinhaColuna



-- Gerando arquivos XML a partir do SQL Server

IF OBJECT_ID('st_GeraXMLProdutos') IS NOT NULL
  DROP PROC dbo.st_GeraXMLProdutos
GO

CREATE PROC dbo.st_GeraXMLProdutos
AS
SELECT ProductCategoryID, Name
  FROM Production.ProductCategory
   FOR XML RAW ('Produtos'), ELEMENTS, ROOT ('XML')
GO

-- Testanto proc
EXEC dbo.st_GeraXMLProdutos

-- Habilitando xp_cmdShell 
EXEC sp_configure 'show advanced options', 1 
GO 
RECONFIGURE
GO 
EXEC sp_configure 'xp_cmdshell', 1 
GO 
RECONFIGURE 
GO

-- Gerando arquivo de produtos
EXEC master.dbo.xp_cmdshell 'bcp "exec AdventureWorks.dbo.st_GeraXMLProdutos" QueryOut "C:\Documents and Settings\fabiano\Desktop\xml\Produtos.xml" -S "DSKCNPM15\SQL2008_RC0" -T -c'

-- </Gerando arquivos XML>