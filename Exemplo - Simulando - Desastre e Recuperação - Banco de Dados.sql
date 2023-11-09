Primeiro vamos criar um banco de dados para teste, o script abaixo cria o banco TesteDB contendo uma tabela de Clientes:

USE master
go
CREATE DATABASE TesteDB
go

USE TesteDB
go
CREATE TABLE Clientes (
ClientesID int not null,
Nome varchar(40) not null,
Telefone varchar(20) null)
go

INSERT Clientes VALUES (1,'Jose','(21) 2521-2252')
INSERT Clientes VALUES (2,'Maria','(21) 2521-1151')
go

Agora para corromper o banco TesteDB, basta simular uma queda de energia:

1) Na mesma conexão utilizada no script anterior, execute o código abaixo e mantenha a conexão aberta:
-- Abre a transacao e atualiza tabela
BEGIN TRAN
UPDATE Clientes SET Telefone = '(21) 2521-1151'
WHERE ClientesID = 2
go
CHECKPOINT
go

2) Abra uma nova conexão e execute o comando “SHUTDOWN WITH NOWAIT”.

O SQL Server para o serviço com o arquivo de dados atualizado pela transação que ficou em aberto, mantendo no arquivo de log o registro desta transação incompleta. Em uma situação normal, O SQL Server resolveria o problema ao iniciar, executando um ROLLBACK da transação que ficou em aberto, utilizando as informações do arquivo de log.

Para corromper o arquivo de log basta abri-lo no NOTEPAD, apagar alguns caracteres no seu início e salvar. Após corromper o arquivo de log inicie o SQL Server e tente entrar no banco TesteDB, teremos a mensagem de erro abaixo:

USE TesteDB

Resultado:
Msg 945, Level 14, State 2, Line 1
Database 'TesteDB' cannot be opened due to inaccessible files or insufficient memory or disk space. See the SQL Server errorlog for details.

Se você pesquisar no log do serviço (Management Studio – Object Explorer – Management – SQl Server Logs) veremos as mensagens abaixo:

- File activation failure. The physical file name "F:\sql2005\TesteDB_log.LDF" may be incorrect.
- The header for file 'F:\sql2005\TesteDB_log.LDF' is not a valid database file header. The PageAudit property is incorrect.

Para verificar o status do banco TesteDB:
SELECT databasepropertyex ('TesteDB', 'STATUS');
Resultado: SUSPECT

Vamos tentar resolver o problema com Detach e depois Attach:

EXEC sp_detach_db 'TesteDB'

Resultado:
Msg 947, Level 16, State 1, Line 1 Error while closing database 'TesteDB'. Check for previous additional errors and retry the operation.

O Detach ocorreu, apesar do erro alertando o estado inconsistente do banco de dados. Verifique com o comando abaixo:
SELECT * FROM sys.databases WHERE NAME = 'TesteDB'

Se você tentar realizar um Attach utilizando sp_attach_db a operação irá falhar, pois o arquivo de log foi corrompido.

EXEC sp_attach_db @dbname = 'TesteDB',
@filename1 = 'F:\sql2005\TesteDB.mdf',
@filename2 = 'F:\sql2005\TesteDB_log.LDF'

Resultado:
Msg 5172, Level 16, State 15, Line 1 The header for file 'F:\sql2005\TesteDB_log.LDF' is not a valid database file header. The FILE SIZE property is incorrect.

Outra opção, que também não irá funcionar, seria tentar criar um novo arquivo de log utilizando a opção ATTACH_REBUILD_LOG do comando CREATE DATABASE.

CREATE DATABASE TesteDB ON
(NAME = TesteDB, FILENAME = 'F:\sql2005\TesteDB.mdf')
FOR ATTACH_REBUILD_LOG

Resultado:
File activation failure. The physical file name "F:\sql2005\TesteDB_log.LDF" may be incorrect.
The log cannot be rebuilt because the database was not cleanly shut down.

Msg 1813, Level 16, State 2, Line 1 Could not open new database 'TesteDB'. CREATE DATABASE is aborted.

Para resolver o problema, basta seguir os passos abaixo:

1) Mover (copiar para outra pasta e apagar) os arquivos de dados e log do banco TesteDB para outro local.

2) Criar um novo banco com o mesmo nome (TesteDB) e parar o serviço do SQL Server.
CREATE DATABASE TesteDB
SHUTDOWN

3) Apagar o arquivo de log e copiar o arquivo de dados que você salvou no item 1, por cima do arquivo novo criado no item 2 acima.

4) Executar o script abaixo.
ALTER DATABASE TesteDB SET EMERGENCY
ALTER DATABASE TesteDB SET SINGLE_USER
go
DBCC CHECKDB (TesteDB, REPAIR_ALLOW_DATA_LOSS)
WITH NO_INFOMSGS, ALL_ERRORMSGS
go
ALTER DATABASE TesteDB SET read_write
ALTER DATABASE TesteDB SET multi_user
go

Repare que foi gerado um novo arquivo de log e o banco de dados foi recuperado, verifique rodando o script abaixo:
USE TesteDB
go
select * from TesteDB.dbo.Clientes
