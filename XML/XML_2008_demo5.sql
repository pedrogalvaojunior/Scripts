USE WebcastXML2008
GO

-----------------------------------------------
-- Exemplo de uso do metodo Query() 
-----------------------------------------------
DECLARE @xmlvar xml
SET @xmlvar =
'<Motocross>
	<Team Manufacturer="Yamaha">
		<Rider Size="250">
			<RiderName>Tim Ferry</RiderName>
		</Rider>
		<Rider Size="250">
			<RiderName>Chad Reed</RiderName>
		</Rider>
	</Team>
</Motocross>'
SELECT @xmlvar.query('/Motocross/Team/Rider')
GO


-----------------------------------------------
-- Exemplo de uso do metodo Value() 
-- O resultado retorna o varchar Yamaha
-- A expressao XQuery retorna o primeiro
-- atributo em /Motocross/Team
-----------------------------------------------
DECLARE @xmlvar xml
DECLARE @Team varchar(50)
SET @xmlvar =
'<Motocross>
	<Team Manufacturer="Yamaha">
		<Rider Size="250">
			<RiderName>Tim Ferry</RiderName>
		</Rider>
		<Rider Size="250">
			<RiderName>Chad Reed</RiderName>
		</Rider>
	</Team>
</Motocross>'
SET @Team = @xmlvar.value('(/Motocross/Team/@Manufacturer)[1]', 'varchar(50)')
SELECT @Team, @xmlvar
GO

-----------------------------------------------
-- Exemplo de uso do metodo Exist() 
-- Este exemplo procura pela existencia de um
-- fragmento XML especifico. O resultado pode ser
-- 1 se existir e 0 se não existir.
-----------------------------------------------
DECLARE @xmlvar xml
DECLARE @bitvar1 bit
DECLARE @bitvar2 bit
SET @xmlvar = 
'<Motocross>
	<Team Manufacturer="Yamaha">
		<Rider Size="250">
			<RiderName>Tim Ferry</RiderName>
		</Rider>
		<Rider Size="250">
			<RiderName>Chad Reed</RiderName>
		</Rider>
	</Team>
</Motocross>'
SET @bitvar1 = @xmlvar.exist('/Motocross/Team[@Manufacturer eq xs:string("Yamaha")]')
SET @bitvar2 = @xmlvar.exist('/Motocross/Team[@Manufacturer eq xs:string("Dafra")]')
--
-- select para validar verdadeiro ou falso
--
SELECT @bitvar1 AS 'Existe Yamaha', @bitvar2 AS 'Não existe Dafra'


-----------------------------------------------------
-- Exemplo de uso do metodo Nodes() 
-- Nesta pesquisa, o retorno apresenta agrupamento 
-- por equipe e apresenta os seus pilotos
------------------------------------------------------
DECLARE @xmlvar xml
SET @xmlvar=
'<Motocross>
	<Team Manufacturer="Yamaha">
		<Rider>Tim Ferry</Rider>
		<Rider>Chad Reed</Rider>
		<Rider>David Vuillemin</Rider>
	</Team>
	<Team Manufacturer="Honda">
		<Rider>Kevin Windham</Rider>
		<Rider>Mike LaRacco</Rider>
		<Rider>Jeremy McGrath</Rider>
	</Team>
	<Team Manufacturer="Suzuki">
		<Rider>Ricky Carmichael</Rider>
		<Rider>Broc Hepler</Rider>
	</Team>
	<Team Manufacturer="Kawasaki">
		<Rider>James Stewart</Rider>
		<Rider>Michael Byrne</Rider>
	</Team>
</Motocross>'
SELECT Motocross.Team.query('.') AS RESULT
FROM @xmlvar.nodes('/Motocross/Team') Motocross(Team)

-----------------------------------------------
-- Exemplo de uso do metodo Modify() 
-- No exemplo a seguir, uma inclusao é realizada
-- na variavel com tipo de dados XML
-----------------------------------------------
DECLARE @xmldoc xml
SET @xmldoc =
'<Root>
	<Employee EmployeeID="1">
		<EmployeeInformation>
		</EmployeeInformation>
	</Employee>
</Root>'
SELECT @xmldoc
-- Efetuando a inclusao propriamente dita
SET @xmldoc.modify('insert <LastName>Knievel</LastName>
into (/Root/Employee/EmployeeInformation)[1]')
SELECT @xmldoc
GO


------------------------------------------------
-- ATENCAO !!! ATENCAO !!! ATENCAO !!!
--
-- Os exemplos a seguir utilizam o metodo Modify()
-- e alteram registros na tabela tbl_XML2008
------------------------------------------------

-----------------------------------------------
-- Exemplo de uso do metodo Modify() com insert
-----------------------------------------------
UPDATE tbl_XML2008
SET LogRecord.modify('
	insert <information flag="custom"><message>SQL Server service is starting</message></information>
	into logRecord[1]')
WHERE ApplicationName = 'SalesApp'

-- testando...
select * from tbl_XML2008

-----------------------------------------------------------
-- Exemplo de uso do metodo Modify() com "replace value of"
-----------------------------------------------------------
UPDATE tbl_XML2008
SET LogRecord.modify('
	replace value of (logRecord/information/message)[1]
	with "Not enough memory"')
WHERE ApplicationName = 'HoursReport'

-- testando...
select * from tbl_XML2008

-----------------------------------------------
-- Exemplo de uso do metodo Modify() com delete
-----------------------------------------------
UPDATE tbl_XML2008
SET LogRecord.modify('
	delete logRecord/post')
WHERE ApplicationName = 'CustomerService'

-- testando...
select * from tbl_XML2008