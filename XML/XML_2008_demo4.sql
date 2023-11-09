USE WebcastXML2008
GO

-----------------------------------------
--- TRABALHANDO COM VALORES NULL
-----------------------------------------
-- Observe no primeiro exemplo que a coluna 3 possui valor NULL e
-- não será exibida como no exemplo abaixo
--
DECLARE @myXML XML
SET @myXML = 
(SELECT 100 'coluna 1', 
        200 'coluna 2', 
        NULL 'coluna 3', -- <<--- Valor NULL na coluna 3 !!!
        400 'coluna 4'
  FOR XML RAW)
SELECT @myXML

--
-- Usando XISINIL os valores nulos são substituidos
-- por 'true' como apresentado no exemplo abaixo
--
DECLARE @myXML XML
SET @myXML = 
(SELECT 100 'coluna 1', 
		200 'coluna 2', 
		NULL 'coluna 3', -- <<--- Valor NULL na coluna 3 !!!
		400 'coluna 4'
  FOR XML RAW, ELEMENTS XSINIL)
SELECT @myXML


--------------------------------------------------------
-- 5. O exemplo abaixo realiza as seguintes tarefas:
-- Obtem registros usando o metodo query() e XQuery.
-- Retorna uma estrutura XML representando um relatorio
-- com todos os erros.
---------------------------------------------------------
DECLARE @Date nvarchar(50)
DECLARE @UID nvarchar(256)
SET @UID = USER_NAME();
SET @Date = GETDATE();

SELECT TOP(1) LogRecord.query('<errorReport issuedby="{sql:variable("@UID")}" date="{sql:variable("@Date")}"/>'),
	(
		SELECT LogRecord.query('
			for $rec in /logRecord, $err in $rec/error
			order by $rec/@timestamp descending
			return 
			  <error number="{data($err/@number)}" timestamp="{data($rec/@timestamp)}" server="{data($rec/@machine)}">
				<message>{data($err/message)}</message>
				<module>{data($err/module)}</module>
			  </error>')
		FROM tbl_XML2008
		WHERE LogRecord.exist('/logRecord/error') = 1
		FOR XML PATH(''),TYPE
	)
FROM tbl_XML2008
FOR XML PATH(''), ROOT('tbl_XML2008'), TYPE

---------------------------------------------------
-- 6. O exemplo abaixo realiza as seguintes tarefas
-- Obtem valores independentes usando o metodo
-- value() e XPath. E retorna uma estrutura tabular
-- representando um relatorio com todos os erros
---------------------------------------------------

SELECT	LogRecord.value('(/logRecord/error/@number)[1]','int') AS [ErrorNumber],
		LogRecord.value('(/logRecord/@timestamp)[1]','nvarchar(20)') AS [TimeStamp],
		LogRecord.value('(/logRecord/@machine)[1]','nvarchar(10)') AS [ServerName],
		LogRecord.value('(/logRecord/error/message)[1]','nvarchar(100)') AS [Message],
		LogRecord.value('(/logRecord/error/module)[1]','nvarchar(20)') AS [Module] 
FROM tbl_XML2008
WHERE LogRecord.exist('/logRecord/error') = 1