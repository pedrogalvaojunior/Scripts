USE AdventureWorks
GO

/* Vamos preparar uma tabela para testes */

IF OBJECT_ID('Prods') IS NOT NULL
  DROP TABLE Prods
GO

CREATE TABLE Prods (ID Int IDENTITY(1,1) PRIMARY KEY, ColunaXML XML NOT NULL)
GO

INSERT INTO Prods(ColunaXML)
SELECT * 
  FROM OPENROWSET(BULK 'C:\Documents and Settings\fabiano\Desktop\xml\Load\XMLProdutos.xml',
                  SINGLE_BLOB) AS A
GO


SELECT *
  FROM Prods


-- M�todo Query()
-- Retorna um fragmento XML

-- Antes de iniciar podemos observar que o m�todo deve ser chamado em case sensitive, 
-- "Query" n�o � v�lido
SELECT ID, ColunaXML.Query('TabelaProdutos/ProdCat/SubProdCat/Prod')
  FROM Prods

-- Consulta simples que retorna os dados de todos os produtos
SELECT ID, ColunaXML.query('TabelaProdutos/ProdCat/SubProdCat/Prod')
  FROM Prods

-- Retorna todos o XML aplicando um filtro para trazer apenas os produtos da 
-- Categoria "Accessories"
SELECT ID, ColunaXML.query('TabelaProdutos/ProdCat[@Categoria="Accessories"]')
  FROM Prods

-- Retorna todos os produtos aplicando um filtro para trazer apenas os produtos da 
-- Categoria "Clothing"
SELECT ID, ColunaXML.query('TabelaProdutos/ProdCat[@Categoria="Clothing"]/SubProdCat/Prod')
  FROM Prods

-- Vamos utilizar as express�es xQuery
SELECT ID, ColunaXML.query('for $TabelaProdutos in /TabelaProdutos
                            return $TabelaProdutos/ProdCat/SubProdCat/Prod')
  FROM Prods
-- Nesta consulta retornamos a mesma coisa que a consulta acima
-- porem desta vez usamos as express�es xQuery "for" e "return"
-- a Microsoft recomenda a utiliza��o de comandos xPath e somente quando o 
-- xPath n�o atender aos seus requisitos ent�o dever� recorer aos recursos do xQuery

-- Outra consulta, desta vez retornando apenas os produtos da categoria "Clothing"
SELECT ID, ColunaXML.query('for $TabelaProdutos in /TabelaProdutos
                            return $TabelaProdutos/ProdCat[@Categoria="Clothing"]/SubProdCat/Prod')
  FROM Prods
GO

-- Retorna o total dos produtos por categoria
SELECT ID, ColunaXML.query('for $TabProd in /TabelaProdutos/ProdCat
	                           return
	                           <Fabricante Nome="{$TabProd/@Categoria}"
	                           Carros="{count($TabProd//SubProdCat/Prod)}"/>')
  FROM Prods


-- Retorna todas as categorias e seus produtos ordenados por Categoria e Produto
-- e renomeia o nome das tags dos elementos
SELECT ColunaXML.query(
'for $Cat in /TabelaProdutos/ProdCat,
     $Produto in $Cat/SubProdCat/Prod/@Produto
	order by $Produto, $Cat/@Nome
	return
    <Cat Prod="{$Cat/@Categoria}">{$Produto}</Cat>
    ')
  FROM Prods


-- M�todo Value()

-- Retorna o nome do produto encontrado no XML, repare o [1] que significa em qual n� ele 
-- dever� ler a informa��o, por ex [1], [2] ...
SELECT	ID,	
       ColunaXML.value('(/TabelaProdutos/ProdCat/SubProdCat/Prod/@Produto)[1]','nvarchar(80)') As Produto
  FROM	Prods

-- Retorna o nome da Categoria, SubCategoria e Produto encontrado no XML
SELECT	ID,	
       ColunaXML.value('(/TabelaProdutos/ProdCat/@Categoria)[1]','nvarchar(80)') As Categoria,
       ColunaXML.value('(/TabelaProdutos/ProdCat/SubProdCat/@SubCategoria)[1]','nvarchar(80)') As SubCategoria,
       ColunaXML.value('(/TabelaProdutos/ProdCat/SubProdCat/Prod/@Produto)[1]','nvarchar(80)') As Produto
  FROM	Prods

-- M�todo Exists()

-- Verifica se existe o produto "Full-Finger Gloves, L"
SELECT ID,
	      ColunaXML.exist('/TabelaProdutos/ProdCat/SubProdCat/Prod[@Produto="Full-Finger Gloves, L"]')
  FROM	Prods

-- Pode ser usado no where como filtro do resultado
-- ir� retornar 1 caso encontre ou 0 caso n�o encontre
SELECT *
  FROM	Prods
 WHERE ColunaXML.exist('/TabelaProdutos/ProdCat/SubProdCat/Prod[@Produto="Full-Finger Gloves, L"]') = 1

-- M�todo Nodes()

-- Retorna 1 linha para cada categoria existente.
SELECT Pro.Cat.query('.')
  FROM	Prods
 CROSS APPLY ColunaXML.nodes('/TabelaProdutos/ProdCat') AS Pro(Cat)

-- Retorna 1 linha para cada SubCategoria existente.
SELECT Pro.Cat.query('.')
  FROM	Prods
 CROSS APPLY ColunaXML.nodes('/TabelaProdutos/ProdCat/SubProdCat') AS Pro(Cat)

-- Retorna todas as Categorias
SELECT Pro.Cat.value('@Categoria', 'nVarChar(80)') AS Categorias
  FROM	Prods
 CROSS APPLY ColunaXML.nodes('/TabelaProdutos/ProdCat') AS Pro(Cat)


-- Vamos ver uma aplica��o interessante para o uso do nodes, 
-- EXEMPLO criado pelo Gustavo Maia Aguiar.
-- http://www.plugmasters.com.br/sys/colunistas/145/Gustavo-Maia-Aguiar

-- Declarando uma vari�vel do tipo de dados XML
-- Teste do m�todo nodes
DECLARE @Pessoa XML
SET @Pessoa =
N'<Pessoa Nome="Paula">
  <Telefone Tipo="Celular" DDD="014" Num="8111-1234"/>
  <Telefone Tipo="Residencial" DDD="014" Num="3214-2222"/>
  <Telefone Tipo="Trabalho" Num="1234-0000"/>
</Pessoa>'

SELECT
	Pessoa.Telefones.value('../@Nome','nvarchar(30)')
		As Nome,
	Pessoa.Telefones.value('@Tipo','nvarchar(20)')
		As Tipo,
	Pessoa.Telefones.value('@DDD','nchar(3)')
		As DDD,
	Pessoa.Telefones.value('@Num','nchar(9)')
		As Numero
FROM
	@Pessoa.nodes('/Pessoa/Telefone') Pessoa(Telefones)


-- Indexando consultas XML


-- Schemas ajudam na performance de suas consultas XML pois fornecem informa��es
-- valiosas para o query processor para poder criar um melhor plano de execu��o.
-- Portanto para vamos criar um schema e associar este schema a tabela Prods

-- Criando um SCHEMA a partir de um arquivo XSD
IF EXISTS(SELECT * 
            FROM sys.xml_schema_collections
           WHERE name = 'XSDVar')
BEGIN
  DROP XML SCHEMA COLLECTION XSDVar
END
GO

DECLARE @x XML
SET @X = (SELECT * 
            FROM OPENROWSET(BULK 'C:\Documents and Settings\fabiano\Desktop\xml\Load\XMLProdutos.xsd',
                            SINGLE_BLOB) AS A)
-- Exibe o Schema
SELECT @X

-- Criar o schema a Partir da variavel
CREATE XML SCHEMA COLLECTION XSDVar AS @x
GO

IF OBJECT_ID('Prods') IS NOT NULL
  DROP TABLE Prods
GO

CREATE TABLE Prods (ID Int IDENTITY(1,1) PRIMARY KEY, ColunaXML XML NOT NULL)
GO

INSERT INTO Prods(ColunaXML)
SELECT * 
  FROM OPENROWSET(BULK 'C:\Documents and Settings\fabiano\Desktop\xml\Load\BigXMLProdutos.xml',
                  SINGLE_BLOB) AS A
GO

-- Criar a tabela com o indice
IF OBJECT_ID('ProdsIndex') IS NOT NULL
  DROP TABLE ProdsIndex
GO

CREATE TABLE ProdsIndex (ID Int IDENTITY(1,1) PRIMARY KEY, ColunaXML XML(XSDVar) NOT NULL)
GO

INSERT INTO ProdsIndex(ColunaXML)
SELECT * 
  FROM OPENROWSET(BULK 'C:\Documents and Settings\fabiano\Desktop\xml\Load\BigXMLProdutos.xml',
                  SINGLE_BLOB) AS A
GO


-- Antes de continuar vamos entender um pouco como os indices v�o ajudar em nossas consultas
-- Podemos criar indices primarios e secundarios
-- Um xml � gravado como um BLOB no banco de dados e quando o SQL tem que ler alguma 
-- informa��o no XML
-- ele vai retornando v�rios fragmentos do XML at� achar sua informa��o, isso pode custar 
-- um certo tempo j� que n�o h� nenhuma indexa��o para agilizar 
-- na pesquisa feita nos fragmentos. Depois de ler o valor XML o SQL tem que fazer um join
-- com a tabela do base(from) para mostrar os dados cada um com o seu respectivo valor.

-- Indice Primario, o indice prim�rio � um indice clustered criado com a instru��o de CREATE 
-- Primary XML Index, assim como o j� conhecido indice cluster o Primary XML Index � um indice 
-- cluster utilizado para otimiza��o das consultas em colunas XML. 
-- O Indice primario contem uma linha de cada n� do XML, esse valor � utilizado para otimizar
-- a consulta.

-- Vamos criar o indice XML na tabela 
CREATE PRIMARY XML INDEX ix_Prods ON ProdsIndex(ColunaXML)
GO

-- A consulta abaixo mostra cada coluna existente no indice ix_Prods

-- Mostra as colunas do indice criado para armazenar os dados do XML
SELECT * FROM sys.columns c
 JOIN sys.indexes i ON i.object_id = c.object_id
 WHERE i.name = 'ix_Prods'
 AND i.type = 1

-- Repare que no indice XML o SQL guarda a informa��o do "pk1" que ser� utilizado para 
-- fazer o join com a tabela que contem a coluna XML.

-- Para processar uma consulta o SQL dever� ler cada linha da tabela que contem a coluna
-- XML e validar a express�o XML segundo o m�todo xQuery utilizado para verificar se ele
-- dever� ou n�o retornar os dados. Existem 2 formas do SQL fazer isso.
/*
  1 - Seleciona as linhas da tabela base(from) e depois processa cada xQuery baseado na 
  coluna XML, este m�todo � conhecido como TOP-Down query processing.
  2 - Processa primeiramente o XML usando o xQuery e depois faz o join com a tabela
  base, este m�tido � conhecido como Bottom-Up query processing.

  A escolha de um ou outro m�todo de acesso � feita pelo Query Processor do SQL Server 
  durante a cria��o do plano de execu��o.
*/

-- Compara os planos de execu��o de uma tabela com um indice XML e outra sem o indice.
SELECT *
  FROM	Prods
 WHERE ColunaXML.exist('/TabelaProdutos/ProdCat/SubProdCat/Prod[@Produto="Full-Finger Gloves, L"]') = 1

GO
SELECT *
  FROM	ProdsIndex
 WHERE ColunaXML.exist('/TabelaProdutos/ProdCat/SubProdCat/Prod[@Produto="Full-Finger Gloves, L"]') = 1

