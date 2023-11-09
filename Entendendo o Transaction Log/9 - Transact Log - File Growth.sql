--limpa database
USE MASTER
GO

IF EXISTS(SELECT * from sys.databases WHERE name='TestDB')
BEGIN
    ALTER DATABASE TestDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE TestDB;
END
GO

-- habilitar traces para mostrar evidências no log
DBCC TRACEON (3004, 3605, -1);


-- limpar log antes de criar pra facilitar visualização
sp_cycle_errorlog

-- cria a base (cerca de 5s) -  quanto tempo demorou pra zerar o TLog?
CREATE DATABASE TestDB
ON PRIMARY
(NAME = 'TestDB_data', FILENAME = 'D:\MSSQLSERVER\DATA\TestDB_data.mdf', SIZE = 10240MB)
LOG ON
(Name = 'TestDB_Log', FILENAME = 'D:\MSSQLSERVER\DATA\TestDB_log.ldf', SIZE = 1024MB, FILEGROWTH = 1024MB)
GO

-- quanto tempo demorou só pro TLog??
xp_readerrorlog

--cleanup the messy

IF EXISTS(SELECT * from sys.databases WHERE name='TestDB')
BEGIN
    ALTER DATABASE TestDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE TestDB;
END
GO

DBCC TRACEOFF (3004, 3605, -1);



