USE AdventureWorks
GO
-- Criando schemas para valida��o de dados.
-- Primeiramente vamos criar um schema para validar os dados que ser�o 
-- inseridos na nossa tabela de produtos.
IF EXISTS(SELECT * 
            FROM sys.xml_schema_collections
           WHERE name = 'xsdProds')
BEGIN
  DROP XML SCHEMA COLLECTION xsdProds
END
GO

CREATE XML SCHEMA COLLECTION xsdProds AS
N'<?xml version="1.0"?>
 <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
   <xs:element name="Raiz">
     <xs:complexType>
       <xs:sequence>
         <xs:element name="Codigo" type="xs:integer" />
         <xs:element name="Nome" type="xs:string" />
       </xs:sequence>
     </xs:complexType>
   </xs:element>
 </xs:schema>'
GO

IF OBJECT_ID('Prods') IS NOT NULL
  DROP TABLE Prods
GO

-- Ao criar a tabela Prods desta vez inserimos uma refer�ncia ao schema criado.
CREATE TABLE Prods (ID Int IDENTITY(1,1) PRIMARY KEY, ColunaXML XML(xsdProds))

-- Ao utilizar um schema podemos dizer se no XML que ser�
-- incluido iremos permitir fragmentos XML ou ent�o apenas Documentos
-- inteiros onde os n�veis dever�o ser sempre iguais, Utiliza-se CONTENT
-- ou DOCUMENT, caso n�o seja especificado assim como no nosso exemplo
-- o padr�o � CONTENT

-- Exemplo de um INSERT simples.
INSERT INTO Prods(ColunaXML) VALUES('<Raiz>
                                       <Codigo>1</Codigo>
                                       <Nome>Nome de Algum Produto</Nome>
                                     </Raiz>')

-- Exemplo de falha no INSERT, ao tentar inserir um valor string para o 
-- elemento C�digo o SQL ir� exibir uma mensagem de erro dizendo que o
-- tipo de dados n�o est� correto
INSERT INTO Prods(ColunaXML) VALUES('<Raiz>
                                       <Codigo>STRING</Codigo>
                                       <Nome>Nome de Algum Produto</Nome>
                                     </Raiz>')

-- Caso o XML esteja com alguma tag incorreta o SQL XSD n�o ir� permitir
-- que o INSERT seja efetuado com sucesso
INSERT INTO Prods(ColunaXML) VALUES('<ROOT>
                                       <Codigo>2</Codigo>
                                       <Nome>Nome de Algum Produto</Nome>
                                     </ROOT>')

-- Caso o XML n�o esteja exatamente no formato do schema que foi 
-- criado ent�o o INSERT n�o sera efetuado com sucesso
INSERT INTO Prods(ColunaXML) VALUES('<Raiz>
                                       <Codigo>3</Codigo>
                                       <Nome>Nome de Algum Produto</Nome>
                                       <Marca>Marca de Algum Produto</Marca>
                                     </Raiz>')


/*
  Existe alguma maneira fac�l de gerar um schema para meu XML?
  Resposta: Sim v�rias.
  Por exemplo com o Visual Studio.
  Para fazer uma demo vamos gerar um arquivo XML com os dados da tabela Prods
*/

SELECT * FROM Prods
-- Salvar um arquivo com o resultado de um XML na pasta desktop\XML

-- Abrir o arquivo no Visual Studio, Clicar em Create Schema e alterar 
-- o type do elemento Codigo para Integer


-- Gerando Schemas para valida��o de dados.

-- Mais Sobre schemas

-- XML Schema Definition Language (XSD) � o padr�o recomendado pela W3C para valida��o de 
-- arquivos XML, antes do XSD os schemas eram gerados no formato XML Data Reduced Schema(XDR)
-- O SQLXML 4.0 possuir uma ferramenta para convers�o de arquivos XDR para o novo formato
-- XSD.
-- Para gerar um schema no formato XDT devemos usar o comando XMLDATA, por exemplo.

SELECT TOP 0 ProdCat.ProductCategoryID, ProdCat.Name Categoria, ProdSubCat.Name SubCategoria
  FROM Production.ProductCategory ProdCat
 INNER JOIN Production.ProductSubcategory ProdSubCat
    ON ProdCat.ProductCategoryID = ProdSubCat.ProductCategoryID
FOR XML RAW, ELEMENTS, XMLDATA
-- Salvar o resultado em um arquivo para analise.

-- Para converter o arquivo podemos abrir o arquivo no Visual Studio e clicar 
-- em Create Schema ou podemos usar o "cvtschema" que vem com o SQLXML 4.0
-- Converter arquivo XDT para XSD a partir do Visual Studio.

SELECT TOP 0 ProdCat.ProductCategoryID, ProdCat.Name Categoria, ProdSubCat.Name SubCategoria
  FROM Production.ProductCategory ProdCat
 INNER JOIN Production.ProductSubcategory ProdSubCat
    ON ProdCat.ProductCategoryID = ProdSubCat.ProductCategoryID
FOR XML RAW, ELEMENTS, XMLSCHEMA
-- Salvar o resultado em um arquivo para analise.

-- Gerando schema a partir de um arquivo XML

-- <XSD.exe> 
  -- Abrir o DOS e Mostrar exemplo de uso do XSD.exe
--</XSD.exe>

-- Criando um SCHEMA a partir de um arquivo XSD
IF OBJECT_ID('ProdsIndex') IS NOT NULL
  DROP TABLE ProdsIndex
GO

IF EXISTS(SELECT * 
            FROM sys.xml_schema_collections
           WHERE name = 'XSDVar')
BEGIN
  DROP XML SCHEMA COLLECTION XSDVar
END
GO

DECLARE @x XML
SET @X = (SELECT * 
            FROM OPENROWSET(BULK 'C:\Documents and Settings\fabiano\Desktop\xml\Produtos.xsd',
                            SINGLE_BLOB) AS A)
-- Exibe o Schema
SELECT @X

-- Criar o schema a Partir da variavel
CREATE XML SCHEMA COLLECTION XSDVar AS @x
GO