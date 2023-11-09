DECLARE @DocHandle int
DECLARE @XmlDocument nvarchar(4000)
SET @XmlDocument = N'<ROOT>
<produtos CODIGO="211" DESCRICAO="LUVA DOM�STICA TOP" MARCA="SANRO TOP" ></produtos>
<produtos CODIGO="213" DESCRICAO="LUVA DOM�STICA  STANDARD" MARCA="SANRO STANDARD" ></produtos>
<produtos CODIGO="217" DESCRICAO="L.DOM.P�O DE A��CAR" MARCA="SANRO TOP" ></produtos>
<produtos CODIGO="218" DESCRICAO="L.DOMESTICA SOFT" MARCA="SANRO SOFT" ></produtos>
</ROOT>'

EXEC sp_xml_preparedocument @DocHandle OUTPUT, @XmlDocument
-- Execute a SELECT statement using OPENXML rowset provider.
SELECT *
FROM OPENXML (@DocHandle, '/ROOT/produtos',1)
      With (CODIGO VarChar(3),
               DESCRICAO VarChar(50),
               MARCA VARCHAR(20))





