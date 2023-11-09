USE WebcastXML2008
GO

-----------------------------------------
--- 1. exemplo basico de FOR XML RAW
-----------------------------------------
SELECT * FROM tbl_XML2008 FOR XML RAW
GO

-----------------------------------------
--- 2. exemplo basico de FOR XML AUTO
-----------------------------------------
SELECT * FROM tbl_XML2008 FOR XML AUTO
GO

-----------------------------------------
--- 3. exemplo basico de FOR XML PATH
-----------------------------------------
SELECT	[ID] AS Identificador, 
		LogDateTime AS LogDataHora, 
		ApplicationName AS NomeAplicacao, 
		LogRecord AS RegistroLog
FROM tbl_XML2008 FOR XML PATH
GO

-----------------------------------------------------
--- 4. exemplo basico de FOR XML EXPLICIT - Error !!!
-----------------------------------------------------
SELECT * FROM tbl_XML2008 FOR XML EXPLICIT
GO

-----------------------------------------------------------
--- 5. exemplo basico de FOR XML EXPLICIT - Funcionando !!!
-----------------------------------------------------------
-- As primeiras duas colunas são TAG e PARENT e são colunas 
-- de metadados. Esses valores determinam a hierarquia.
-- 
-- Para gerar o XML dessa tabela universal, os dados nessa 
-- tabela são particionados verticalmente em grupos de colunas.
--
-- Para o valor 1 da coluna Tag na primeira linha, as colunas 
-- cujos nomes incluem o mesmo número de marca, exemplo, Ulog!1!ID 
-- Ulog!1!LogDataHora formam um grupo.
--
SELECT 1 AS Tag, NULL AS Parent, 
       [ID] AS [Ulog!1!ID],
       LogDateTime AS [Ulog!1!LogDataHora],
       ApplicationName AS [Ulog!1!NomeApp],
       LogRecord AS [Ulog!1!LogRegistro]
FROM dbo.tbl_XML2008
FOR XML EXPLICIT
GO