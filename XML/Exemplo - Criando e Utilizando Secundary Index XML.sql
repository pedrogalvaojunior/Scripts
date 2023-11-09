USE AdventureWorks;

CREATE XML INDEX IXML_Products_CatalogDesc_Path 
    ON dbo.Products (CatalogDescription)
    USING XML INDEX PRXML_Products_CatalogDesc FOR PATH 


CREATE XML INDEX IXML_Products_CatalogDesc_Value
    ON dbo.Products (CatalogDescription)
    USING XML INDEX PRXML_Products_CatalogDesc FOR VALUE


CREATE XML INDEX IXML_Products_CatalogDesc_Property
    ON dbo.Products (CatalogDescription)
    USING XML INDEX PRXML_Products_CatalogDesc FOR PROPERTY

WITH XMLNAMESPACES ('http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription' AS "PD")
SELECT *
	FROM dbo.Products
	WHERE CatalogDescription.exist 
	('/PD:ProductDescription/@ProductModelID[.="19"]') = 1;


WITH XMLNAMESPACES ('http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription' AS "PD")
SELECT *
	FROM dbo.Products
	WHERE CatalogDescription.exist ('//PD:*/@ProductModelID[.="19"]') = 1;

WITH XMLNAMESPACES ('http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription' AS "PD")
SELECT 
	CatalogDescription.value('(/PD:ProductDescription/@ProductModelID)[1]','int') as PID
FROM dbo.Products
WHERE CatalogDescription.exist ('/PD:ProductDescription/@ProductModelID') = 1;



