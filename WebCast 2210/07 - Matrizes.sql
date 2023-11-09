-- Muda o contexto de banco de dados
USE DBQueryPlus

-- Cria uma stored procedure para inserir várias categorias
CREATE PROCEDURE uspInsereCategorias
	@Categorias VARCHAR(1000)
AS
/*
	Essa procedure irá receber vários elementos separados por ;
	O objetivo dessa procedure é separar cada elemento
	Após a separação, ela deve inserí-lo individualmente
*/

-- Utiliza a stored procedure
EXEC uspInsereCategorias @Categorias = 'Alimentos;Eletrônicos;Vestiário'



-- Novamente o poder do XML
DECLARE @Categorias VARCHAR(1000), @CategoriasXML XML
SET @Categorias = 'Alimentos;Eletrônicos;Vestiário'

-- Montando as tags e deixando a lista como um XML bem formado
SET @Categorias = '<cs><c>' + REPLACE(@Categorias,';','</c><c>') + '</c></cs>'
SET @CategoriasXML = CAST(@Categorias AS XML)
SELECT @Categorias AS Categorias, @CategoriasXML AS CategoriasXML


SELECT @CategoriasXML.value('count(/cs/c)','int') AS Qtd





-- Desmembrando o XML com os métodos Nodes e Values
SELECT Cats.cat.value('.','varchar(50)') As Categorias
FROM @CategoriasXML.nodes('/cs/c') Cats(cat)

















-- Criando a SP
CREATE PROCEDURE uspInsereCategorias
	@Categorias VARCHAR(1000)
AS
DECLARE @CategoriasXML XML
SET @CategoriasXML = CAST('<cs><c>' +
	REPLACE(@Categorias,';','</c><c>') +
		'</c></cs>' AS XML)

-- Inserindo os registros
INSERT INTO tblCategorias
SELECT Cats.cat.value('.','varchar(50)') As Categorias
FROM @CategoriasXML.nodes('/cs/c') Cats(cat)

-- Executando a SP
EXEC uspInsereCategorias @Categorias = 'Alimentos;Eletrônicos;Vestiário'

-- Verificando os resultados
SELECT CategoriaID, CategoriaNome
FROM tblCategorias
















-- Consultas baseadas em passagens de parâmetros
DECLARE @Categorias VARCHAR(100)
SET @Categorias = '2,3'

-- O comando abaixo não funciona
SELECT ProdutoID, CategoriaID, ProdutoNome FROM tblProdutos
WHERE CategoriaID IN (@Categorias)















-- Utilizando o XML para desmembramento
DECLARE @Categorias VARCHAR(10), @CategoriasXML XML
SET @Categorias = '2,3'

-- Montando as tags e deixando a lista como um XML bem formado
SET @CategoriasXML =
	CAST('<cs><c>' +
	REPLACE(@Categorias,',','</c><c>') +
	'</c></cs>' AS XML)

-- Desmembrando o XML com os métodos Nodes e Values
;WITH Categorias (CategoriaID) AS (
SELECT Cats.cat.value('.','int') As Categorias
FROM @CategoriasXML.nodes('/cs/c') Cats(cat))

--SELECT Categoria FROM Categorias

SELECT ProdutoID, CategoriaID, ProdutoNome FROM tblProdutos
WHERE CategoriaID IN
(SELECT CategoriaID FROM Categorias)


