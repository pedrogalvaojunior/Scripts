-- MOTIVOS PARA O TLOG ENCHER

--Alterando para Recovery Model FULL
ALTER DATABASE TestDB SET RECOVERY FULL;
BACKUP DATABASE TestDB TO DISK = 'D:\TestDB.bak'

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

--acompanhando o TLog
DBCC LOGINFO(TestDB)
CHECKPOINT
SELECT name, Log_reuse_wait_desc FROM sys.databases WHERE name = 'TestDB'


--mais de um motivo?
--em outra sessão:
BEGIN TRANSACTION
UPDATE dbo.Pessoa SET nome = 'XUXA' where ID=3
--Rollback

--acompanhando o TLog
DBCC LOGINFO(TestDB)
CHECKPOINT
SELECT name, Log_reuse_wait_desc FROM sys.databases WHERE name = 'TestDB'


-- resolve?
DBCC OPENTRAN
KILL XX


--Backup do TLog
BACKUP LOG TestDB TO DISK = 'd:\log.trn'

--acompanhando o TLog
DBCC LOGINFO(TestDB)
CHECKPOINT
SELECT name, Log_reuse_wait_desc FROM sys.databases WHERE name = 'TestDB'



-- LIMPA A SUJEIRA PARA NOVAS DEMOS
USE master
IF EXISTS(SELECT * from sys.databases WHERE name='TestDB')
BEGIN
    ALTER DATABASE TestDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE TestDB;
END
GO