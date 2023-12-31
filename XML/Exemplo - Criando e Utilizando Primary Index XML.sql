USE AdventureWorks

CREATE TABLE dbo.Products(
	ProductID int NOT NULL,
	Name dbo.Name NOT NULL,
	CatalogDescription xml NULL,
CONSTRAINT PK_ProductModel_ProductID PRIMARY KEY CLUSTERED 
(	ProductID ));

INSERT INTO dbo.Products  (ProductID,Name,CatalogDescription)
SELECT ProductModelID, Name, CatalogDescription
FROM Production.ProductModel;

CREATE PRIMARY XML INDEX PRXML_Products_CatalogDesc
    ON dbo.Products (CatalogDescription);
GO

WITH XMLNAMESPACES ('http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription' AS "PD")

SELECT ProductID, CatalogDescription
FROM dbo.Products
WHERE CatalogDescription.exist ('/PD:ProductDescription/PD:Features') = 1


