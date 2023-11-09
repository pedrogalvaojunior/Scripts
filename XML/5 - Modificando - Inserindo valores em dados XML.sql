-- Modificando / Inserindo valores em dados XML

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

-- INSERT

-- inserir um produto no XML da tabela Prods
UPDATE Prods
SET ColunaXML.modify('insert <Prod Produto="Novo Produto"/>
                        into (/TabelaProdutos/ProdCat/SubProdCat)[1]')


-- inserir um produto no XML da tabela Prods
-- desta vez usaremos o comando as firs para dizer que o valor deverá 
-- ser inserido como o primeiro valor.
UPDATE Prods
SET ColunaXML.modify('insert <Prod Produto="Primeiro Novo Produto"/> as first
                        into (/TabelaProdutos/ProdCat/SubProdCat)[1]')

-- Uso do last
UPDATE Prods
SET ColunaXML.modify('insert <Prod Produto="Ultimo Novo Produto"/> as last
                        into (/TabelaProdutos/ProdCat/SubProdCat)[1]')


-- DELETE

-- Vamos excluir o produto "Primeiro Novo Produto"
UPDATE Prods
SET ColunaXML.modify('delete /TabelaProdutos/ProdCat/SubProdCat/Prod[@Produto="Primeiro Novo Produto"]')

-- Excluir todos os produtos que iniciam com "Sport"
UPDATE Prods
SET ColunaXML.modify('delete /TabelaProdutos/ProdCat/SubProdCat/Prod/@Produto[contains(.,"Sport")]')

-- Excluir todos os produtos que iniciam com "Mountain"
UPDATE Prods
SET ColunaXML.modify('delete /TabelaProdutos/ProdCat/SubProdCat/Prod/@Produto[contains(.,"Mountain")]')

-- Exclui o elemento <Prod>
UPDATE Prods
SET ColunaXML.modify('delete /TabelaProdutos/ProdCat/SubProdCat/Prod')

-- REPLACE OF

-- Altera o nome do atributo "Accessories" para "Acessorios"
UPDATE Prods
SET ColunaXML.modify('
  replace value of (/TabelaProdutos/ProdCat[@Categoria="Accessories"]/@Categoria)[1]
  with "Acessorios"')

-- Altera o nome da 1 Categoria para "Nova Categoria"
UPDATE Prods
SET ColunaXML.modify('
  replace value of (/TabelaProdutos/ProdCat/@Categoria)[1]
  with "Nova Categoria"')