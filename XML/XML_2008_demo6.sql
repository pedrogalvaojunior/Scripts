USE WebcastXML2008;
GO

------------------------------------------------------------
-- 1º passo: Criar Primary Key na tabela tbl_XML2008
------------------------------------------------------------
ALTER TABLE dbo.tbl_XML2008 WITH NOCHECK
ADD CONSTRAINT PK_Identificador PRIMARY KEY CLUSTERED(ID)
GO


------------------------------------------------------------
-- Agora sim, criando Indice XML Primario
------------------------------------------------------------
SET ARITHABORT ON
CREATE PRIMARY XML INDEX XMLID ON dbo.tbl_XML2008(LogRecord)
GO

------------------------------------------------------------
-- Criando Indice XML Secundario (FOR PATH)
------------------------------------------------------------
CREATE XML INDEX XMLPATH_XMLID ON dbo.tbl_XML2008 (LogRecord) 
USING XML INDEX XMLID FOR PATH WITH (FILLFACTOR = 70, PAD_INDEX =OFF)
GO

------------------------------------------------------------
-- Verificando a criacao dos indices XML na sys.indexes ...
------------------------------------------------------------
SELECT * FROM sys.indexes where type_desc = 'XML'