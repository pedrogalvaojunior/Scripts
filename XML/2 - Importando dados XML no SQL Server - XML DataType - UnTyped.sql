USE AdventureWorks
GO
-- <XML DataType>

/* 
  Vamos criar uma tabela para testes com uma coluna XML, inicialmente a 
  tabela n�o usa um Schema para valida��o do XML que ser� inserido na tabela
  portanto chamamos este XML de XML UnTyped, veremos alguns exemplos de XML Typed
  daqui a pouco.
*/

IF OBJECT_ID('Prods') IS NOT NULL
  DROP TABLE Prods
GO

CREATE TABLE Prods (ID Int IDENTITY(1,1) PRIMARY KEY, ColunaXML XML NOT NULL)

-- Exemplo de um INSERT simples.
INSERT INTO Prods(ColunaXML) VALUES('<Raiz>
                                       <Codigo>1</Codigo>
                                       <Nome>Nome de Algum Produto</Nome>
                                     </Raiz>')

-- Aqui podemos reparar que o SQL Server verifica se o documento XML
-- est� bem formatado, no exemplo abaixo eu inicio a tag "Raiz" mas n�o finalizo ela
-- o SQL detecta isso e gera um erro ao tentar efetuar o INSERT.
INSERT INTO Prods(ColunaXML) VALUES('<Raiz>
                                       <Codigo>1</Codigo>
                                       <Nome>Nome de Algum Produto</Nome>
                                     <Raiz>')

-- Outro exemplo de valida��o do XML, o campo R da tag "Raiz" � iniciado com R mai�sculo
-- e finalizado com r min�sculo
INSERT INTO Prods(ColunaXML) VALUES('<Raiz>
                                       <Codigo>1</Codigo>
                                       <Nome>Nome de Algum Produto</Nome>
                                     </raiz>')

-- Vizualiza os dados da tabela
SELECT * FROM Prods
GO

-- Exemplo de uso de uma var��vel XML
DECLARE @vXML XML

SET @vXML = '<Raiz>
               <Codigo>1</Codigo>
               <Nome>Nome de Algum Produto</Nome>
             </Raiz>'

SELECT @vXML
GO

-- Inserindo dados na tabela Prods utilizando uma v�ri�vel XML
DECLARE @vXML XML

SET @vXML = '<Raiz>
               <Codigo>2</Codigo>
               <Nome>2 Nome de Algum Produto</Nome>
             </Raiz>'

INSERT INTO Prods(ColunaXML) VALUES(@vXML)

GO

-- </XML DataType>





-- Importanto um documento XML direto para uma tabela

CREATE TABLE #TMP (ID Int IDENTITY(1,1), ColunaXML XML NOT NULL)

DECLARE @x XML
SET @X = (SELECT * 
            FROM OPENROWSET(BULK 'C:\Documents and Settings\fabiano\Desktop\xml\Produtos.xml',
                            SINGLE_BLOB) AS A)

-- Exibe o XML
SELECT @X

INSERT INTO #TMP(ColunaXML) VALUES(@X)
GO

SELECT * FROM #TMP



-- Ou ent�o poderiamos ter incluido direto na tabela, sem usar a vari�vel.

INSERT INTO #TMP(ColunaXML)
SELECT * 
  FROM OPENROWSET(BULK 'C:\Documents and Settings\fabiano\Desktop\xml\Produtos.xml',
                  SINGLE_BLOB) AS A
GO

SELECT * FROM #TMP
GO