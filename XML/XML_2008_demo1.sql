---- 
-- Criando o database para as demonstrações do webcast
----
CREATE DATABASE WebcastXML2008;
GO

USE WebcastXML2008
GO

---- 
-- Criar tabela com uma coluna recebendo o data type XML
-- mas sem estar linkada ao schema XML
-- Criar uma coluna VARCHAR(MAX) para receber conteudo XML
----
CREATE TABLE tbl_XML2008
( ID INT IDENTITY(1,1) NOT NULL,
LogDateTime DATETIME NOT NULL CONSTRAINT [DF_LogDateTime]DEFAULT (GetDate()),
ApplicationName NVARCHAR(50) NOT NULL,
LogRecord XML NULL, 
LogRecordTxT varchar(MAX)NULL);

---- 
-- Inserir registros sem criterios de formatação
-- na coluna LogRecord (coluna do tipo XML)
----
INSERT tbl_XML2008(ApplicationName, LogRecord, LogRecordTxT)
VALUES ('Inventory',
	'<logRecord machine="server2" timestamp="2000-01-12T12:13:14Z">
	</logRecord>',
	'<logRecord machine="server2" timestamp="2000-01-12T12:13:14Z">
	</logRecord>')

GO

INSERT tbl_XML2008(ApplicationName, LogRecord, LogRecordTxT)
VALUES ('SalesApp',
	'<post eventType="appStart">
		<moreInformation>All Services starting</moreInformation>
	</post>', '<post eventType="appStart">
		<moreInformation>All Services starting</moreInformation>
	</post>')
GO

----
-- Verificando os registros na tabela ...
----
SELECT * FROM dbo.tbl_XML2008

----
-- Apagar os registos da tabela 
----
TRUNCATE TABLE dbo.tbl_XML2008
GO

-- 
-- carregar o XML schema a partir de um arquivo .xsd e
-- criar o SCHEMA COLLECTION no banco de dados
--
DECLARE @schema XML
SELECT @schema = c FROM OPENROWSET (
 BULK 'c:\dados\logRecordSchema.xsd', SINGLE_BLOB) AS temp(c)

CREATE XML SCHEMA COLLECTION LogRecordSchema AS @schema
GO

--
-- alterar a tabela de exemplos da apresentacao para
-- aceitar o link com o schema XML.
--
ALTER TABLE tbl_XML2008
ALTER COLUMN LogRecord XML(LogRecordSchema) NULL;
GO

--
-- Apagar a coluna LogRecordTxT 
--
ALTER TABLE tbl_XML2008
DROP COLUMN LogRecordTxT;
GO