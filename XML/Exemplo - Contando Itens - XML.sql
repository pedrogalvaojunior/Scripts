DECLARE @Lista VARCHAR(MAX)

SET @Lista = '1,2,3,15,10,12,16'

 

DECLARE @ListaXML XML

SET @ListaXML = '<c><e>' + REPLACE(@Lista,',','</e><e>') + '</e></c>'

 

DECLARE @TotalItens INT

SET @TotalItens = @ListaXML.value('count(/c/e)','INT')

SELECT @TotalItens
