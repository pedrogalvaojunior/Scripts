DECLARE @Xml XML = N'
 <products>
 <product id="1" name="Adjustable Race" />
 <product id="879" name="All-Purpose Bike Stand" />
 <product id="712" name="AWC Logo Cap" />
 <product id="19910" name="Cozonac" />
 </products>';

SELECT 
    xt.xc.value('@id', 'INT') AS ProductID,
    xt.xc.value('@name','NVARCHAR(50)') AS Name
FROM 
    @Xml.nodes('/products/product') AS xt(xc);