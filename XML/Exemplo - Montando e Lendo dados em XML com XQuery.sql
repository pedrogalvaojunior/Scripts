declare @dadosxml xml

set @dadosxml = '<?xml version="1.0"?>

<root>

<cliente id="1">

<prod id="321"/>

<prod id="543"/>

<prod id="762"/>

<prod id="325"/>

</cliente>

<cliente id="2">

<prod id="289"/>

<prod id="776"/>

<prod id="335"/>

<prod id="1020"/>

</cliente>

</root>'

--print convert(nvarchar(4000),@dadosxml)

SELECT

t.c.value('../@id[1]','int') as IdCliente,

t.c.value('@id[1]','int') as IdProduto

FROM

@dadosxml.nodes('/root/cliente/prod') as t(c)

dECLARE @x xml 
SET @x='<Root>
    <row id="1"><name>Larry</name><oflw>some text</oflw></row>
    <row id="2"><name>moe</name></row>
    <row id="3" />
</Root>'
SELECT T.c.query('.') AS result
FROM   @x.nodes('/Root/row') T(c)
GO
