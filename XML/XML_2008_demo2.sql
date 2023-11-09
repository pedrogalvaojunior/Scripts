USE WebcastXML2008
GO

--
-- Confirmando que a tabela encontra-se sem dados
--
SELECT * FROM dbo.tbl_XML2008

------------------------------------------------------------
-- INSERT #1 - Erro!!! Não está em conformidade com o Schema
------------------------------------------------------------

INSERT tbl_XML2008(ApplicationName, LogRecord)
VALUES ('SalesApp',
	'<logRecord machine="server1" timestamp="2000-01-12T12:13:14Z">')

------------------------------------------------------------
-- INSERT #2 - Erro!!! Não está em conformidade com o Schema
-------------------------------------------------------------

INSERT tbl_XML2008(ApplicationName, LogRecord)
VALUES ('Inventory',
	'<logRecord machine="server2" timestamp="2000-01-13T12:13:14Z">')

----
-- Tabela continua vazia...
----
SELECT * FROM dbo.tbl_XML2008

--
-- Todos os INSERTs abaixo encontram-se em conformidade com o Schema
--
------------------------------------------------------
-- INSERT #1 - ApplicationName = SalesApp
------------------------------------------------------

INSERT tbl_XML2008(ApplicationName, LogRecord)
VALUES ('SalesApp',
	'<logRecord machine="server1" timestamp="2000-01-12T12:13:14Z">
	<post eventType="appStart">
		<moreInformation>All Services starting</moreInformation>
	</post>
</logRecord>')

------------------------------------------------------
-- INSERT #2 -  - ApplicationName = Inventory
------------------------------------------------------

INSERT tbl_XML2008(ApplicationName, LogRecord)
VALUES ('Inventory',
	'<logRecord machine="server2" timestamp="2000-01-13T12:13:14Z">
	<post eventType="appStart"/>
	<information flag="warning">
		<message>Duplicate IP address</message>
	</information>
</logRecord>')

--------------------------------------------------------
-- INSERT #3 -  - ApplicationName = SHR (HumanResources)
--------------------------------------------------------

INSERT tbl_XML2008(ApplicationName, LogRecord)
VALUES ('HR',
	'<logRecord machine="server1" timestamp="2000-01-14T12:13:14Z">
	<error number="1001">
		<message>The user does not have enough permissions to execute query</message>
		<module>DataAccessLayer</module>
	</error>
</logRecord>')

----------------------------------------------------
-- INSERT #4 -  - ApplicationName = CustomerService
----------------------------------------------------

INSERT tbl_XML2008(ApplicationName, LogRecord)
VALUES ('CustomerService',
	'<logRecord machine="server2" timestamp="2000-01-15T12:13:14Z">
	<post eventType="logOut"/>
	<information flag="custom">
		<message>User must change password on next login</message>
	</information>
</logRecord>')

---------------------------------------------------
-- INSERT #5 -  - ApplicationName = HoursReport
---------------------------------------------------

INSERT tbl_XML2008(ApplicationName, LogRecord)
VALUES ('HoursReport',
	'<logRecord machine="server2" timestamp="2000-01-11T12:13:14Z">
	<information flag="failure">
		<message>Hard Disk with ID #87230283 is not responding</message>
	</information>
	<error number="18763">
		<message>Application can not start</message>
		<module>AppLoader</module>
	</error>
	<post eventType="appStart"/>
</logRecord>')


---------------------------------------------------
-- SELECT - Validando os registros criados
---------------------------------------------------

SELECT * FROM tbl_XML2008
GO