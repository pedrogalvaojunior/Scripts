-- Configura o Linked Server para acessar a instância SQL2005
IF EXISTS (SELECT * FROM SYS.SERVERS WHERE NAME ='.\SQL2005')
	EXEC master.dbo.sp_dropserver @server = '.\SQL2005', @droplogins = 'droplogins'

EXEC master.dbo.sp_addlinkedserver @server = '.\SQL2005', @srvproduct='SQL Server'
EXEC master.dbo.sp_serveroption @server='.\SQL2005', @optname='data access', @optvalue='true'
EXEC master.dbo.sp_serveroption @server='.\SQL2005', @optname='rpc', @optvalue='true'
EXEC master.dbo.sp_serveroption @server='.\SQL2005', @optname='rpc out', @optvalue='true'

-- Configura um login para acessar o Linked Server
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = '.\SQL2005',
	@locallogin = NULL , @useself = 'False',
	@rmtuser = 'UsrLoginLK', @rmtpassword = 'PWD123456'
GO

-- Obter informações sobre os bancos existentes no Linked Server
SELECT * FROM OPENQUERY([.\SQL2005],'SELECT * FROM sys.server_principals')

-- Passa um parâmetro o nome de um banco de dados para pesquisa
DECLARE @Banco VARCHAR(20), @Schema VARCHAR(20), @Objeto VARCHAR(20)
SET @Banco = 'Northwind'
SET @Schema = 'dbo'
SET @Objeto = 'Customers'

-- O comando abaixo falha
SELECT * FROM OPENQUERY([.\SQL2005],
	'SELECT * FROM ' + @Banco + '.' + @Schema + '.' + @Objeto)

-- O comando abaixo funciona mas é mais trabalhoso
DECLARE @cmdSQL VARCHAR(1000)
SET @cmdSQL = 
'SELECT * FROM OPENQUERY([.\SQL2005],''SELECT * FROM ' +
@Banco + '.' + @Schema + '.' + @Objeto + ''')'
EXEC(@cmdSQL)

-- Possibilidade no 2005
DECLARE @cmdSQL VARCHAR(1000)
SET @cmdSQL = 'SELECT * FROM ' + @Banco + '.' + @Schema + '.' + @Objeto
EXEC(@cmdSQL) AT [.\SQL2005]

EXEC('SELECT * FROM Northwind.dbo.Orders WHERE OrderID = ?', 10248) AT [.\SQL2005]