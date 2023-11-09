DECLARE @xmlsample varchar(max),
                   @ArquivoXML Varchar(Max)
 
SET @xmlsample='<?xml version=“1.0” encoding=“UTF-8”?>'

Set @ArquivoXML= (Select CODIGO, Descricao from Produtos for XML Auto)

Select @xmlsample + Char(10) + @ArquivoXML