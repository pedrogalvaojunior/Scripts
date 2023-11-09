
--Alterando para Recovery Model FULL
ALTER DATABASE TestDB SET RECOVERY FULL;
BACKUP DATABASE TestDB TO DISK = 'D:\TestDB.bak'

-- Encolhendo o TLog
DBCC LOGINFO(TestDB)
BACKUP LOG TestDB TO DISK = 'bkplogTestDB.trn'
USE TestDB
GO
DBCC SHRINKFILE (TestDB_Log,1)
GO
DBCC LOGINFO(TestDB)



--cria tabela pessoa
USE TestDB
GO
IF OBJECT_ID ( N'TestDB.dbo.pessoa', N'U' ) IS NOT NULL 
BEGIN
    DROP TABLE dbo.pessoa;
END
GO


USE TestDB
GO
CREATE TABLE dbo.pessoa
(ID int identity PRIMARY KEY NOT NULL,
Nome varchar(50) NOT NULL,
Sobrenome varchar(50) NOT NULL,
Nascimento date NOT NULL,
Cargo varchar(50))
GO


--em outra sessão, inserindo registros...
USE TestDB
GO

WHILE 1=1
BEGIN
INSERT INTO dbo.pessoa
VALUES ('Luiz', 'Mercante', '19810703', 'Estagiário')
END


--acompanhando o TLog
DBCC LOGINFO(TestDB)
CHECKPOINT
SELECT name, Log_reuse_wait_desc FROM sys.databases WHERE name = 'TestDB'


--Backup do TLog
BACKUP LOG TestDB TO DISK = 'd:\log.trn'



-- LIMPA A SUJEIRA PARA NOVAS DEMOS
USE master
IF EXISTS(SELECT * from sys.databases WHERE name='TestDB')
BEGIN
    ALTER DATABASE TestDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE TestDB;
END
GO

--*******************--
-- PREPARA PRA DEMO 6
-- Preparando a base - 1m10s
ALTER DATABASE AdventureWorks2016 SET RECOVERY FULL
GO
BACKUP DATABASE AdventureWorks2016 TO DISK = 'd:\backup.bak' WITH COMPRESSION
GO